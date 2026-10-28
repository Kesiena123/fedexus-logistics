<?php

namespace Tests\Feature;

use App\Models\Shipment;
use App\Models\ShipmentLocationHistory;
use App\Models\User;
use App\Support\AdminSecurity;
use Illuminate\Foundation\Testing\DatabaseTransactions;
use Tests\TestCase;

class ShipmentLocationIsolationTest extends TestCase
{
    use DatabaseTransactions;

    public function test_tracking_location_endpoint_is_isolated_per_shipment(): void
    {
        $customer = User::create([
            'name' => 'Isolation Customer',
            'email' => 'isolation-customer@example.test',
            'password' => 'Password123!',
            'role' => 'customer',
        ]);

        $factories = [
            ['tracking_number' => 'TEST-A-LOC-0001', 'current' => [1.1, 2.2], 'origin' => [1.11, 2.22], 'destination' => [1.12, 2.23], 'current_name' => 'TEST-A Current'],
            ['tracking_number' => 'TEST-B-LOC-0002', 'current' => [3.3, 4.4], 'origin' => [3.31, 4.41], 'destination' => [3.32, 4.42], 'current_name' => 'TEST-B Current'],
            ['tracking_number' => 'TEST-C-LOC-0003', 'current' => [5.5, 6.6], 'origin' => [5.51, 6.61], 'destination' => [5.52, 6.62], 'current_name' => 'TEST-C Current'],
        ];

        foreach ($factories as $f) {
            Shipment::create([
                'user_id' => $customer->id,
                'status' => 'picked_up',
                'service_level' => 'international_priority',
                'sender_name' => 'Sender',
                'recipient_name' => 'Recipient',
                'origin_address' => ['city' => 'Memphis', 'country' => 'US'],
                'destination_address' => ['city' => 'Austin', 'country' => 'US'],
                'weight_kg' => 5,
                'tracking_number' => $f['tracking_number'],
                'current_latitude' => $f['current'][0],
                'current_longitude' => $f['current'][1],
                'current_location_name' => $f['current_name'],
                'origin_latitude' => $f['origin'][0],
                'origin_longitude' => $f['origin'][1],
                'destination_latitude' => $f['destination'][0],
                'destination_longitude' => $f['destination'][1],
            ]);
        }

        $allCoords = array_merge(...array_map(
            fn ($f) => array_merge($f['current'], $f['origin'], $f['destination']),
            $factories
        ));

        foreach ($factories as $f) {
            $ownCoords = array_merge($f['current'], $f['origin'], $f['destination']);
            $foreignCoords = array_values(array_diff($allCoords, $ownCoords));

            $response = $this->getJson('/tracking/'.$f['tracking_number'].'/location');

            $response
                ->assertOk()
                ->assertJsonPath('tracking_number', $f['tracking_number'])
                ->assertJsonPath('current.latitude', $f['current'][0])
                ->assertJsonPath('current.longitude', $f['current'][1])
                ->assertJsonPath('current.location', $f['current_name'])
                ->assertJsonPath('origin.latitude', $f['origin'][0])
                ->assertJsonPath('destination.latitude', $f['destination'][0])
                ->assertJsonPath('destination.longitude', $f['destination'][1]);

            $raw = $response->json();

            foreach ($raw['points'] as $point) {
                $this->assertContains(
                    round($point['latitude'], 2),
                    $ownCoords,
                    sprintf('Shipment %s leaked point %s,%s', $f['tracking_number'], $point['latitude'], $point['longitude'])
                );
            }

            foreach ($foreignCoords as $coord) {
                $this->assertNotContains($coord, array_map(fn ($p) => round($p['latitude'], 2), $raw['points']));
                $this->assertNotContains($coord, array_map(fn ($p) => round($p['longitude'], 2), $raw['points']));
            }
        }

        $this->getJson('/tracking/UNKNOWN-LOCATION/location')->assertNotFound();
    }

    public function test_admin_tracking_event_updates_current_location_and_history(): void
    {
        $admin = User::create([
            'name' => 'Location Admin',
            'email' => 'location-admin@example.test',
            'password' => 'Password123!',
            'role' => 'admin',
        ]);

        $shipment = Shipment::create([
            'user_id' => $admin->id,
            'status' => 'warehouse_processing',
            'service_level' => 'domestic_express',
            'sender_name' => 'Sender',
            'recipient_name' => 'Recipient',
            'origin_address' => ['city' => 'Memphis', 'country' => 'US'],
            'destination_address' => ['city' => 'Austin', 'country' => 'US'],
            'weight_kg' => 5,
            'tracking_number' => 'TEST-D-LOC-0004',
            'origin_latitude' => 35.1495,
            'origin_longitude' => -90.049,
            'destination_latitude' => 30.2672,
            'destination_longitude' => -97.7431,
            'current_latitude' => 35.1495,
            'current_longitude' => -90.049,
        ]);

        $token = $admin->createToken('phpunit-location', [AdminSecurity::TOKEN_ABILITY])->plainTextToken;

        $this
            ->withHeader('Authorization', "Bearer {$token}")
            ->postJson("/api/admin/shipments/{$shipment->id}/tracking-events", [
                'status' => 'warehouse_processing',
                'location' => 'TEST-D Checkpoint Houston',
                'description' => 'Shipment reached Houston hub.',
                'latitude' => 29.7604,
                'longitude' => -95.3698,
            ])
            ->assertOk();

        $this->assertDatabaseHas('shipments', [
            'id' => $shipment->id,
            'current_latitude' => 29.7604,
            'current_longitude' => -95.3698,
            'current_location_name' => 'TEST-D Checkpoint Houston',
        ]);

        $this->assertDatabaseHas('shipment_location_history', [
            'shipment_id' => $shipment->id,
            'latitude' => 29.7604,
            'longitude' => -95.3698,
            'point_type' => 'current',
            'source' => 'admin',
            'status' => 'warehouse_processing',
        ]);

        $this->getJson('/tracking/TEST-D-LOC-0004/location')
            ->assertOk()
            ->assertJsonPath('current.latitude', 29.7604)
            ->assertJsonPath('current.longitude', -95.3698)
            ->assertJsonPath('current.type', 'current')
            ->assertJsonPath('current.location', 'TEST-D Checkpoint Houston');
    }

    public function test_delivered_without_coordinates_pins_current_to_destination(): void
    {
        $admin = User::create([
            'name' => 'Delivery Admin',
            'email' => 'delivery-admin@example.test',
            'password' => 'Password123!',
            'role' => 'admin',
        ]);

        $shipment = Shipment::create([
            'user_id' => $admin->id,
            'status' => 'out_for_delivery',
            'service_level' => 'domestic_express',
            'sender_name' => 'Sender',
            'recipient_name' => 'Recipient',
            'origin_address' => ['city' => 'Memphis', 'country' => 'US'],
            'destination_address' => ['city' => 'Austin', 'country' => 'US'],
            'weight_kg' => 5,
            'tracking_number' => 'TEST-E-LOC-0005',
            'origin_latitude' => 35.1495,
            'origin_longitude' => -90.049,
            'destination_latitude' => 30.2672,
            'destination_longitude' => -97.7431,
            'destination_location_name' => 'Austin, TX, US',
        ]);

        $token = $admin->createToken('phpunit-location', [AdminSecurity::TOKEN_ABILITY])->plainTextToken;

        $this
            ->withHeader('Authorization', "Bearer {$token}")
            ->postJson("/api/admin/shipments/{$shipment->id}/tracking-events", [
                'status' => 'delivered',
                'location' => 'Austin Delivery Hub',
                'description' => 'Delivered to recipient.',
            ])
            ->assertOk();

        $this->assertDatabaseHas('shipments', [
            'id' => $shipment->id,
            'current_latitude' => 30.2672,
            'current_longitude' => -97.7431,
            'current_location_name' => 'Austin, TX, US',
        ]);

        $this->assertDatabaseHas('shipment_location_history', [
            'shipment_id' => $shipment->id,
            'latitude' => 30.2672,
            'longitude' => -97.7431,
            'point_type' => 'current',
            'source' => 'system',
            'status' => 'delivered',
        ]);
    }

    public function test_tracking_event_rejects_out_of_range_coordinates(): void
    {
        $admin = User::create([
            'name' => 'Validation Admin',
            'email' => 'validation-admin@example.test',
            'password' => 'Password123!',
            'role' => 'admin',
        ]);

        $shipment = Shipment::create([
            'user_id' => $admin->id,
            'status' => 'picked_up',
            'service_level' => 'domestic_express',
            'sender_name' => 'Sender',
            'recipient_name' => 'Recipient',
            'origin_address' => ['city' => 'Memphis', 'country' => 'US'],
            'destination_address' => ['city' => 'Austin', 'country' => 'US'],
            'weight_kg' => 5,
            'tracking_number' => 'TEST-F-LOC-0006',
        ]);

        $token = $admin->createToken('phpunit-location', [AdminSecurity::TOKEN_ABILITY])->plainTextToken;

        $this
            ->withHeader('Authorization', "Bearer {$token}")
            ->postJson("/api/admin/shipments/{$shipment->id}/tracking-events", [
                'status' => 'warehouse_processing',
                'location' => 'Nowhere',
                'description' => 'Bad coordinates.',
                'latitude' => 95,
                'longitude' => 200,
            ])
            ->assertStatus(422);

        $this->assertDatabaseMissing('shipment_location_history', ['shipment_id' => $shipment->id]);
    }
}