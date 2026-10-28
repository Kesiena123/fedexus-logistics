<?php

namespace App\Services;

use App\Models\Shipment;
use App\Models\ShipmentLocationHistory;
use Carbon\CarbonInterface;
use Illuminate\Support\Collection;
use Illuminate\Support\Facades\Cache;

class ShipmentLocationService
{
    private const STALE_THRESHOLD_HOURS = 24;

    private const CACHE_TTL = 60;

    public function __construct(
        private readonly LocationCoordinateResolver $resolver,
    ) {}

    public function pointsFor(Shipment $shipment): Collection
    {
        return Cache::remember(
            $this->cacheKey($shipment),
            self::CACHE_TTL,
            fn () => $this->buildPoints($shipment)
        );
    }

    public function locationPayload(Shipment $shipment): array
    {
        $points = $this->pointsFor($shipment);

        $current = $this->currentPoint($shipment);
        $origin = $this->originPoint($shipment);
        $destination = $this->destinationPoint($shipment);

        return [
            'tracking_number' => $shipment->tracking_number,
            'status' => \App\Support\ShipmentStatus::toDisplay($shipment->status),
            'status_code' => $shipment->status,
            'has_location' => $current !== null || $points->isNotEmpty(),
            'has_points' => $points->isNotEmpty(),
            'points' => $points->values()->all(),
            'current' => $current,
            'origin' => $origin,
            'destination' => $destination,
            'last_updated' => optional($shipment->location_updated_at)->toIso8601String(),
        ];
    }

    public function currentPoint(Shipment $shipment): ?array
    {
        $lat = $this->num($shipment->current_latitude);
        $lng = $this->num($shipment->current_longitude);

        if ($lat === null || $lng === null) {
            $event = $shipment->trackingEvents
                ? $shipment->trackingEvents->first(fn ($e) => $this->eventCoords($e) !== null)
                : null;
            if ($event === null) {
                return null;
            }
            $coords = $this->eventCoords($event);
            $lat = $coords['latitude'];
            $lng = $coords['longitude'];
            $name = $event->location;
            $updated = $event->occurred_at ?: $shipment->location_updated_at;
        } else {
            $name = $shipment->current_location_name;
            $updated = $shipment->location_updated_at;
        }

        return $this->locationPoint(
            label: 'Current Location',
            location: $name,
            latitude: $lat,
            longitude: $lng,
            type: 'current',
            updatedAt: $updated,
        );
    }

    public function originPoint(Shipment $shipment): ?array
    {
        $lat = $this->num($shipment->origin_latitude);
        $lng = $this->num($shipment->origin_longitude);

        if ($lat === null || $lng === null) {
            $point = $shipment->routePoints?->first(fn ($p) => $p->type === 'origin');
            $coords = $point ? $this->routePointCoords($point) : null;
            if ($coords) {
                $lat = $coords['latitude'];
                $lng = $coords['longitude'];
            }
        }

        if ($lat === null || $lng === null) {
            $coords = $this->resolver->resolveAddress((array) $shipment->origin_address);
            $lat = $coords['latitude'] ?? null;
            $lng = $coords['longitude'] ?? null;
        }

        if ($lat === null || $lng === null) {
            return null;
        }

        return $this->locationPoint(
            label: 'Origin',
            location: $shipment->origin_location_name ?? $this->addressName($shipment->origin_address),
            latitude: $lat,
            longitude: $lng,
            type: 'origin',
        );
    }

    public function destinationPoint(Shipment $shipment): ?array
    {
        $lat = $this->num($shipment->destination_latitude);
        $lng = $this->num($shipment->destination_longitude);

        if ($lat === null || $lng === null) {
            $point = $shipment->routePoints?->first(fn ($p) => $p->type === 'destination');
            $coords = $point ? $this->routePointCoords($point) : null;
            if ($coords) {
                $lat = $coords['latitude'];
                $lng = $coords['longitude'];
            }
        }

        if ($lat === null || $lng === null) {
            $coords = $this->resolver->resolveAddress((array) $shipment->destination_address);
            $lat = $coords['latitude'] ?? null;
            $lng = $coords['longitude'] ?? null;
        }

        if ($lat === null || $lng === null) {
            return null;
        }

        return $this->locationPoint(
            label: 'Destination',
            location: $shipment->destination_location_name ?? $this->addressName($shipment->destination_address),
            latitude: $lat,
            longitude: $lng,
            type: 'destination',
        );
    }

    public function updateCurrent(
        Shipment $shipment,
        ?float $latitude,
        ?float $longitude,
        ?string $locationName = null,
        ?CarbonInterface $occurredAt = null,
        string $source = 'admin',
        ?int $createdBy = null,
        ?string $status = null,
    ): void {
        $lat = $this->num($latitude);
        $lng = $this->num($longitude);

        if ($lat === null || $lng === null) {
            return;
        }

        $occurredAt = $occurredAt ?: now();
        $name = $this->text($locationName);

        $shipment->forceFill([
            'current_latitude' => $lat,
            'current_longitude' => $lng,
            'current_location_name' => $name,
            'location_updated_at' => $occurredAt,
        ])->save();

        $this->recordHistory($shipment, [
            'latitude' => $lat,
            'longitude' => $lng,
            'location_name' => $name,
            'point_type' => 'current',
            'source' => $source,
            'status' => $status ?: $shipment->status,
            'occurred_at' => $occurredAt,
            'created_by' => $createdBy,
        ]);

        $this->forgetCache($shipment);
    }

    public function syncStatic(
        Shipment $shipment,
        ?array $originCoords = null,
        ?string $originName = null,
        ?array $destinationCoords = null,
        ?string $destinationName = null,
        string $source = 'admin',
        ?int $createdBy = null,
        ?string $status = null,
    ): void {
        $originLat = $this->num($originCoords['latitude'] ?? $shipment->origin_latitude);
        $originLng = $this->num($originCoords['longitude'] ?? $shipment->origin_longitude);
        $destLat = $this->num($destinationCoords['latitude'] ?? $shipment->destination_latitude);
        $destLng = $this->num($destinationCoords['longitude'] ?? $shipment->destination_longitude);

        $originName = $this->text($originName ?? $shipment->origin_location_name);
        $destName = $this->text($destinationName ?? $shipment->destination_location_name);

        $shipment->forceFill([
            'origin_latitude' => $originLat,
            'origin_longitude' => $originLng,
            'origin_location_name' => $originName,
            'destination_latitude' => $destLat,
            'destination_longitude' => $destLng,
            'destination_location_name' => $destName,
        ])->save();

        $status = $status ?: $shipment->status;
        $now = now();

        if ($originLat !== null && $originLng !== null) {
            $this->recordHistory($shipment, [
                'latitude' => $originLat,
                'longitude' => $originLng,
                'location_name' => $originName,
                'point_type' => 'origin',
                'source' => $source,
                'status' => $status,
                'occurred_at' => $now,
                'created_by' => $createdBy,
            ]);
        }

        if ($destLat !== null && $destLng !== null) {
            $this->recordHistory($shipment, [
                'latitude' => $destLat,
                'longitude' => $destLng,
                'location_name' => $destName,
                'point_type' => 'destination',
                'source' => $source,
                'status' => $status,
                'occurred_at' => $now,
                'created_by' => $createdBy,
            ]);
        }

        $this->forgetCache($shipment);
    }

    public function forgetCache(Shipment $shipment): void
    {
        Cache::forget($this->cacheKey($shipment));
    }

    public function clearShipmentCache(int $shipmentId): void
    {
        Cache::forget('shipment_location_' . $shipmentId);
    }

    private function buildPoints(Shipment $shipment): Collection
    {
        $shipment->loadMissing(['routePoints', 'trackingEvents']);

        $points = collect();

        $current = $this->currentPoint($shipment);

        if ($current !== null) {
            $points->push($current);
        }

        foreach (['origin', 'destination'] as $type) {
            $point = $type === 'origin' ? $this->originPoint($shipment) : $this->destinationPoint($shipment);
            if ($point !== null) {
                $points->push($point);
            }
        }

        foreach (($shipment->routePoints ?? collect()) as $point) {
            $coords = $this->routePointCoords($point) ?? $this->resolver->resolveLocation((string) $point->location, $point->country_code);
            if ($coords) {
                $points->push([
                    'label' => $point->label,
                    'location' => $point->location,
                    'latitude' => $coords['latitude'],
                    'longitude' => $coords['longitude'],
                    'type' => $point->type,
                ]);
            }
        }

        foreach (($shipment->trackingEvents ?? collect()) as $event) {
            $coords = $this->eventCoords($event);
            if ($coords === null) {
                continue;
            }
            if ($current !== null && $coords['latitude'] == $current['latitude'] && $coords['longitude'] == $current['longitude']) {
                continue;
            }
            $points->push([
                'label' => \App\Support\ShipmentStatus::toDisplay($event->status),
                'location' => $event->location,
                'latitude' => $coords['latitude'],
                'longitude' => $coords['longitude'],
                'type' => 'transit',
            ]);
        }

        return $points->unique(fn ($p) => $p['latitude'] . '|' . $p['longitude'] . '|' . $p['label'])->values();
    }

    private function locationPoint(
        string $label,
        ?string $location,
        float $latitude,
        float $longitude,
        string $type,
        ?CarbonInterface $updatedAt = null,
    ): array {
        $updatedAt ??= now();

        return [
            'label' => $label,
            'location' => $this->text($location),
            'latitude' => $latitude,
            'longitude' => $longitude,
            'type' => $type,
            'updated_raw' => $updatedAt->toIso8601String(),
            'updated_human' => $updatedAt->diffForHumans(),
            'updated_at' => $updatedAt->toIso8601String(),
            'stale' => $updatedAt->lt(now()->subHours(self::STALE_THRESHOLD_HOURS)),
        ];
    }

    private function recordHistory(Shipment $shipment, array $data): void
    {
        ShipmentLocationHistory::query()->create(array_merge([
            'shipment_id' => $shipment->id,
        ], $data));
    }

    private function eventCoords($event): ?array
    {
        $lat = $this->num($event->latitude ?? null);
        $lng = $this->num($event->longitude ?? null);

        return $lat !== null && $lng !== null ? ['latitude' => $lat, 'longitude' => $lng] : null;
    }

    private function routePointCoords($point): ?array
    {
        $lat = $this->num($point->latitude ?? null);
        $lng = $this->num($point->longitude ?? null);

        return $lat !== null && $lng !== null ? ['latitude' => $lat, 'longitude' => $lng] : null;
    }

    private function addressName($address): ?string
    {
        $address = (array) $address;

        return $this->text($address['city'] ?? $address['address'] ?? null);
    }

    private function cacheKey(Shipment $shipment): string
    {
        return 'shipment_location_' . $shipment->id;
    }

    private function num($value): ?float
    {
        if ($value === null || $value === '') {
            return null;
        }

        return (float) $value;
    }

    private function text($value): ?string
    {
        if ($value === null) {
            return null;
        }

        $value = trim((string) $value);

        return $value === '' ? null : $value;
    }
}