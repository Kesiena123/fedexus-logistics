<?php

namespace App\Services;

use App\Models\Shipment;
use Illuminate\Support\Collection;

class MapPointService
{
    public function __construct(
        private readonly ShipmentLocationService $locationService,
    ) {}

    public function buildForShipment(Shipment $shipment): Collection
    {
        return $this->locationService->pointsFor($shipment);
    }

    public function settings(): array
    {
        return [
            'defaultLatitude' => (float) \App\Support\AppSettings::mapDefaultLatitude(),
            'defaultLongitude' => (float) \App\Support\AppSettings::mapDefaultLongitude(),
            'zoom' => (int) \App\Support\AppSettings::mapZoom(),
        ];
    }
}
