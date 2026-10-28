<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('shipments', function (Blueprint $table) {
            $table->decimal('current_latitude', 10, 7)->nullable()->after('quoted_amount');
            $table->decimal('current_longitude', 10, 7)->nullable()->after('current_latitude');
            $table->string('current_location_name', 255)->nullable()->after('current_longitude');
            $table->decimal('origin_latitude', 10, 7)->nullable()->after('current_location_name');
            $table->decimal('origin_longitude', 10, 7)->nullable()->after('origin_latitude');
            $table->string('origin_location_name', 255)->nullable()->after('origin_longitude');
            $table->decimal('destination_latitude', 10, 7)->nullable()->after('origin_location_name');
            $table->decimal('destination_longitude', 10, 7)->nullable()->after('destination_latitude');
            $table->string('destination_location_name', 255)->nullable()->after('destination_longitude');
            $table->timestamp('location_updated_at')->nullable()->after('destination_location_name');
        });

        Schema::create('shipment_location_history', function (Blueprint $table) {
            $table->id();
            $table->foreignId('shipment_id')->constrained()->cascadeOnDelete();
            $table->decimal('latitude', 10, 7);
            $table->decimal('longitude', 10, 7);
            $table->string('location_name', 255)->nullable();
            $table->string('point_type', 20)->default('current')->index();
            $table->string('source', 40)->default('admin')->index();
            $table->string('status', 40)->nullable();
            $table->timestamp('occurred_at')->nullable();
            $table->foreignId('created_by')->nullable()->constrained('users')->nullOnDelete();
            $table->timestamps();

            $table->index(['shipment_id', 'occurred_at']);
            $table->index('created_at');
        });

        $this->backfill();
    }

    public function down(): void
    {
        Schema::dropIfExists('shipment_location_history');

        Schema::table('shipments', function (Blueprint $table) {
            $table->dropColumn([
                'current_latitude',
                'current_longitude',
                'current_location_name',
                'origin_latitude',
                'origin_longitude',
                'origin_location_name',
                'destination_latitude',
                'destination_longitude',
                'destination_location_name',
                'location_updated_at',
            ]);
        });
    }

    private function backfill(): void
    {
        DB::table('shipments')->orderBy('id')->chunkById(200, function ($shipments) {
            foreach ($shipments as $shipment) {
                $origin = $this->decodeJson($shipment->origin_address);
                $destination = $this->decodeJson($shipment->destination_address);

                $originLat = $this->num($origin['latitude'] ?? null);
                $originLng = $this->num($origin['longitude'] ?? null);
                $destLat = $this->num($destination['latitude'] ?? null);
                $destLng = $this->num($destination['longitude'] ?? null);

                $routeOrigin = DB::table('shipment_route_points')
                    ->where('shipment_id', $shipment->id)
                    ->where('type', 'origin')
                    ->orderBy('id')
                    ->first();
                $routeDestination = DB::table('shipment_route_points')
                    ->where('shipment_id', $shipment->id)
                    ->where('type', 'destination')
                    ->orderBy('id')
                    ->first();

                $originLat ??= $this->num($routeOrigin->latitude ?? null);
                $originLng ??= $this->num($routeOrigin->longitude ?? null);
                $destLat ??= $this->num($routeDestination->latitude ?? null);
                $destLng ??= $this->num($routeDestination->longitude ?? null);

                $originName = $this->text($origin['city'] ?? $origin['address'] ?? null);
                $destName = $this->text($destination['city'] ?? $destination['address'] ?? null);

                $latest = DB::table('tracking_events')
                    ->where('shipment_id', $shipment->id)
                    ->whereNotNull('latitude')
                    ->whereNotNull('longitude')
                    ->orderByDesc('occurred_at')
                    ->first();

                $currentLat = $this->num($latest->latitude ?? null);
                $currentLng = $this->num($latest->longitude ?? null);
                $currentName = $this->text($latest->location ?? null);
                $currentAt = $latest->occurred_at ?? null;

                DB::table('shipments')->where('id', $shipment->id)->update([
                    'origin_latitude' => $originLat,
                    'origin_longitude' => $originLng,
                    'origin_location_name' => $originName,
                    'destination_latitude' => $destLat,
                    'destination_longitude' => $destLng,
                    'destination_location_name' => $destName,
                    'current_latitude' => $currentLat,
                    'current_longitude' => $currentLng,
                    'current_location_name' => $currentName,
                    'location_updated_at' => $currentAt,
                ]);

                $now = now();

                if ($originLat !== null && $originLng !== null) {
                    DB::table('shipment_location_history')->insert([
                        'shipment_id' => $shipment->id,
                        'latitude' => $originLat,
                        'longitude' => $originLng,
                        'location_name' => $originName,
                        'point_type' => 'origin',
                        'source' => 'import',
                        'status' => $shipment->status,
                        'occurred_at' => $shipment->created_at,
                        'created_at' => $now,
                        'updated_at' => $now,
                    ]);
                }

                if ($destLat !== null && $destLng !== null) {
                    DB::table('shipment_location_history')->insert([
                        'shipment_id' => $shipment->id,
                        'latitude' => $destLat,
                        'longitude' => $destLng,
                        'location_name' => $destName,
                        'point_type' => 'destination',
                        'source' => 'import',
                        'status' => $shipment->status,
                        'occurred_at' => $shipment->created_at,
                        'created_at' => $now,
                        'updated_at' => $now,
                    ]);
                }

                if ($currentLat !== null && $currentLng !== null) {
                    DB::table('shipment_location_history')->insert([
                        'shipment_id' => $shipment->id,
                        'latitude' => $currentLat,
                        'longitude' => $currentLng,
                        'location_name' => $currentName,
                        'point_type' => 'current',
                        'source' => 'import',
                        'status' => $shipment->status,
                        'occurred_at' => $currentAt,
                        'created_at' => $now,
                        'updated_at' => $now,
                    ]);
                }
            }
        });
    }

    private function decodeJson($value): array
    {
        if (is_array($value)) {
            return $value;
        }
        if (! is_string($value) || $value === '') {
            return [];
        }

        $decoded = json_decode($value, true);

        return is_array($decoded) ? $decoded : [];
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
        $value = is_scalar($value) ? trim((string) $value) : '';

        return $value === '' ? null : $value;
    }
};