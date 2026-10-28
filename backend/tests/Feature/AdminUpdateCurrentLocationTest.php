<?php

namespace Tests\Feature;

use App\Models\Shipment;
use App\Models\User;
use App\Services\ShipmentLocationService;
use Illuminate\Foundation\Testing\DatabaseTransactions;
use Tests\TestCase;

class AdminUpdateCurrentLocationTest extends TestCase
{
    use DatabaseTransactions;

    private User $admin;

    private User $customer;

    private Shipment $shipment;

    protected function setUp(): void
    {
        parent::setUp();

        $this->admin = User::create([
            'name' => 'Location Admin',
            'email' => 'loc-admin@example.test',
            'password' => 'Password123!',
            'role' => 'admin',
        ]);

        $this->customer = User::create([
            'name' => 'Location Customer',
            'email' => 'loc-customer@example.test',
            'password' => 'Password123!',
            'role' => 'customer',
        ]);

        $this->shipment = Shipment::create([
            'user_id' => $this->customer->id,
            'status' => 'approved',
            'service_level' => 'domestic_express',
            'sender_name' => 'Sender',
            'recipient_name' => 'Recipient',
            'origin_address' => [
                'city' => 'Memphis',
                'country' => 'US',
                'state' => 'TN',
                'address' => '123 Main St',
                'postal_code' => '38116',
            ],
            'destination_address' => [
                'city' => 'Austin',
                'country' => 'US',
                'state' => 'TX',
                'address' => '456 Elm St',
                'postal_code' => '73301',
            ],
            'weight_kg' => 10.5,
            'declared_value' => 500,
            'quoted_amount' => 120.50,
            'tracking_number' => 'FDX-2026-LOCTEST01',
            'metadata' => [
                'sender' => ['company' => '', 'phone' => '', 'email' => ''],
                'receiver' => ['company' => '', 'phone' => '', 'email' => ''],
                'description' => '',
            ],
        ]);

        $locationService = app(ShipmentLocationService::class);
        $locationService->syncStatic(
            $this->shipment,
            originCoords: ['latitude' => 35.1495, 'longitude' => -90.0490],
            originName: 'Memphis',
            destinationCoords: ['latitude' => 30.2672, 'longitude' => -97.7431],
            destinationName: 'Austin',
            source: 'admin',
            status: 'approved',
        );
    }

    public function test_edit_page_updates_current_location_on_shipment_and_map(): void
    {
        $response = $this->actingAs($this->admin)
            ->from(route('admin.shipments.edit', $this->shipment))
            ->post(route('admin.shipments.edit', $this->shipment), [
                'sender_name' => 'Sender',
                'recipient_name' => 'Recipient',
                'service_level' => 'domestic_express',
                'status' => 'approved',
                'current_latitude' => 34.0522,
                'current_longitude' => -118.2437,
                'current_location_name' => 'Los Angeles',
            ]);

        $response->assertRedirect(route('admin.shipments.edit', $this->shipment));
        $response->assertSessionHas('success', 'Shipment updated successfully.');

        $this->shipment->refresh();
        $this->assertEquals(34.0522, (float) $this->shipment->current_latitude);
        $this->assertEquals(-118.2437, (float) $this->shipment->current_longitude);
        $this->assertEquals('Los Angeles', $this->shipment->current_location_name);

        $payload = app(ShipmentLocationService::class)->locationPayload($this->shipment);
        $this->assertTrue($payload['has_location']);
        $this->assertSame(34.0522, $payload['current']['latitude']);
        $this->assertSame(-118.2437, $payload['current']['longitude']);
        $this->assertSame('Los Angeles', $payload['current']['location']);

        $this->assertSame(
            ['current'],
            collect($payload['points'])->where('type', 'current')->pluck('type')->take(1)->all()
        );
    }

    public function test_edit_page_blank_current_fields_preserve_existing_location(): void
    {
        $this->actingAs($this->admin)
            ->post(route('admin.shipments.edit', $this->shipment), [
                'sender_name' => 'Sender',
                'recipient_name' => 'Recipient',
                'service_level' => 'domestic_express',
                'status' => 'approved',
                'origin_latitude' => 35.1495,
                'origin_longitude' => -90.0490,
                'destination_latitude' => 30.2672,
                'destination_longitude' => -97.7431,
            ]);

        $this->shipment->refresh();
        $this->assertNull($this->shipment->current_latitude);
        $this->assertNull($this->shipment->current_longitude);

        $payload = app(ShipmentLocationService::class)->locationPayload($this->shipment);
        $this->assertNull($payload['current']);
    }

    public function test_show_page_tracking_update_sets_current_location(): void
    {
        $response = $this->actingAs($this->admin)
            ->from(route('admin.shipments.show', $this->shipment))
            ->post(route('admin.shipments.show', $this->shipment), [
                'status' => 'international_processing',
                'location' => 'Dallas, TX',
                'occurred_at' => now()->format('Y-m-d\TH:i'),
                'latitude' => 32.7767,
                'longitude' => -96.7970,
                'description' => 'Arrived at Dallas hub.',
            ]);

        $response->assertRedirect(route('admin.shipments.show', $this->shipment));
        $response->assertSessionHas('success', 'Tracking update added.');

        $this->shipment->refresh();
        $this->assertEquals(32.7767, (float) $this->shipment->current_latitude);
        $this->assertEquals(-96.7970, (float) $this->shipment->current_longitude);
        $this->assertEquals('Dallas, TX', $this->shipment->current_location_name);

        $payload = app(ShipmentLocationService::class)->locationPayload($this->shipment);
        $this->assertSame(32.7767, $payload['current']['latitude']);
        $this->assertSame(-96.7970, $payload['current']['longitude']);

        $this->assertDatabaseHas('shipment_route_points', [
            'shipment_id' => $this->shipment->id,
            'type' => 'checkpoint',
            'latitude' => 32.7767,
            'longitude' => -96.7970,
        ]);
    }

    public function test_show_page_tracking_update_without_coords_keeps_current_null(): void
    {
        $this->actingAs($this->admin)
            ->post(route('admin.shipments.show', $this->shipment), [
                'status' => 'approved',
                'location' => 'Dallas, TX',
                'occurred_at' => now()->format('Y-m-d\TH:i'),
                'description' => 'Status update only.',
            ]);

        $this->shipment->refresh();
        $this->assertNull($this->shipment->current_latitude);
        $this->assertNull($this->shipment->current_longitude);
    }

    public function test_new_shipment_map_renders_and_accepts_admin_location_update(): void
    {
        $response = $this->actingAs($this->admin)
            ->get(route('admin.shipments.show', $this->shipment));

        $response->assertOk();
        $response->assertSee('shipment-map-container');
        $response->assertSee('spm-info-panel');
        $response->assertSee('spm-info-location');
        $response->assertSee('pollTrackingData');
    }
}