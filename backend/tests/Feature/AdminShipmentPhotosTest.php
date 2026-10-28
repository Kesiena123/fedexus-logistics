<?php

namespace Tests\Feature;

use App\Models\Shipment;
use App\Models\ShipmentAttachment;
use App\Models\User;
use Illuminate\Foundation\Testing\DatabaseTransactions;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Storage;
use Tests\TestCase;

class AdminShipmentPhotosTest extends TestCase
{
    use DatabaseTransactions;

    private Shipment $shipment;

    private User $admin;

    protected function setUp(): void
    {
        parent::setUp();

        $this->admin = User::create([
            'name' => 'Photo Admin',
            'email' => 'photo-admin@example.test',
            'password' => 'Password123!',
            'role' => 'admin',
        ]);

        $customer = User::create([
            'name' => 'Photo Customer',
            'email' => 'photo-customer@example.test',
            'password' => 'Password123!',
            'role' => 'customer',
        ]);

        $this->shipment = Shipment::create([
            'user_id' => $customer->id,
            'status' => 'approved',
            'service_level' => 'domestic_express',
            'sender_name' => 'Photo Sender',
            'recipient_name' => 'Photo Recipient',
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
            'tracking_number' => 'FDX-2026-PHOTO01',
            'metadata' => [
                'sender' => ['company' => 'Sender Co', 'phone' => '+1111111', 'email' => 's@test.com'],
                'receiver' => ['company' => 'Recv Co', 'phone' => '+1222222', 'email' => 'r@test.com'],
                'description' => 'Shipment with photos',
                'packages' => [
                    [
                        'package_type' => 'Box',
                        'weight_kg' => 10.5,
                        'length_cm' => 30,
                        'width_cm' => 20,
                        'height_cm' => 15,
                        'quantity' => 1,
                    ],
                ],
            ],
        ]);
    }

    public function test_visible_package_photo_displays_on_tracking_page(): void
    {
        Storage::fake('public');
        Storage::disk('public')->put('shipments/' . $this->shipment->id . '/pkg.jpg', 'fake-image');

        ShipmentAttachment::create([
            'shipment_id' => $this->shipment->id,
            'uploaded_by' => $this->admin->id,
            'category' => 'package_image',
            'original_name' => 'parcel-photo.jpg',
            'stored_name' => 'pkg.jpg',
            'disk' => 'public',
            'path' => 'shipments/' . $this->shipment->id . '/pkg.jpg',
            'mime_type' => 'image/jpeg',
            'size_bytes' => 10,
            'metadata' => ['visible_to_customer' => true],
        ]);

        $response = $this->get('/tracking/' . $this->shipment->tracking_number);

        $response->assertOk();
        $response->assertSee('Shipment Photos');
        $response->assertSee('parcel-photo.jpg', false);
        $response->assertSee('pkg.jpg');
        $response->assertSee('1 photo');
    }

    public function test_internal_only_photo_is_hidden_on_tracking_page(): void
    {
        Storage::fake('public');
        Storage::disk('public')->put('shipments/' . $this->shipment->id . '/internal.jpg', 'fake-image');

        ShipmentAttachment::create([
            'shipment_id' => $this->shipment->id,
            'uploaded_by' => $this->admin->id,
            'category' => 'package_image',
            'original_name' => 'internal-only.jpg',
            'stored_name' => 'internal.jpg',
            'disk' => 'public',
            'path' => 'shipments/' . $this->shipment->id . '/internal.jpg',
            'mime_type' => 'image/jpeg',
            'size_bytes' => 10,
            'metadata' => ['visible_to_customer' => false],
        ]);

        $response = $this->get('/tracking/' . $this->shipment->tracking_number);

        $response->assertOk();
        $response->assertDontSee('Shipment Photos');
        $response->assertDontSee('internal-only.jpg');
    }

    public function test_missing_file_photo_is_not_shown_as_broken_image(): void
    {
        Storage::fake('public');

        ShipmentAttachment::create([
            'shipment_id' => $this->shipment->id,
            'uploaded_by' => $this->admin->id,
            'category' => 'package_image',
            'original_name' => 'deleted-file.jpg',
            'stored_name' => 'gone.jpg',
            'disk' => 'public',
            'path' => 'shipments/' . $this->shipment->id . '/gone.jpg',
            'mime_type' => 'image/jpeg',
            'size_bytes' => 10,
            'metadata' => ['visible_to_customer' => true],
        ]);

        $response = $this->get('/tracking/' . $this->shipment->tracking_number);

        $response->assertOk();
        $response->assertDontSee('Shipment Photos');
        $response->assertDontSee('deleted-file.jpg');
        $response->assertDontSee('gone.jpg');
    }

    public function test_non_image_attachment_is_not_rendered_as_photo(): void
    {
        Storage::fake('public');
        Storage::disk('public')->put('shipments/' . $this->shipment->id . '/doc.pdf', 'fake-doc');

        ShipmentAttachment::create([
            'shipment_id' => $this->shipment->id,
            'uploaded_by' => $this->admin->id,
            'category' => 'document',
            'original_name' => 'invoice.pdf',
            'stored_name' => 'doc.pdf',
            'disk' => 'public',
            'path' => 'shipments/' . $this->shipment->id . '/doc.pdf',
            'mime_type' => 'application/pdf',
            'size_bytes' => 10,
            'metadata' => null,
        ]);

        $response = $this->get('/tracking/' . $this->shipment->tracking_number);

        $response->assertOk();
        $response->assertDontSee('Shipment Photos');
        $response->assertDontSee('invoice.pdf');
    }

    public function test_create_shipment_photos_become_visible_package_images(): void
    {
        Storage::fake('public');

        $file = UploadedFile::fake()->image('parcel-pic.jpg');

        $response = $this->actingAs($this->admin)->post(route('admin.shipments.store'), [
            'sender_full_name' => 'Sender Name',
            'sender_company' => 'Sender Co',
            'sender_email' => 'sender@test.com',
            'sender_phone' => '+1111111',
            'sender_country' => 'US',
            'sender_state' => 'TN',
            'sender_city' => 'Memphis',
            'sender_address' => '123 Main St',
            'sender_postal_code' => '38116',

            'receiver_full_name' => 'Receiver Name',
            'receiver_company' => 'Recv Co',
            'receiver_email' => 'recv@test.com',
            'receiver_phone' => '+1222222',
            'receiver_country' => 'US',
            'receiver_state' => 'TX',
            'receiver_city' => 'Austin',
            'receiver_address' => '456 Elm St',
            'receiver_postal_code' => '73301',

            'service_level' => 'domestic_express',
            'shipment_type' => 'document',
            'shipping_method' => 'standard',
            'priority' => 'standard',
            'description' => 'Photos regression',
            'package_type' => 'Box',
            'package_weight' => 5,
            'package_length' => 30,
            'package_width' => 20,
            'package_height' => 15,
            'package_quantity' => 1,
            'package_description' => 'Box contents',

            'shipping_cost' => 50,
            'handling_fee' => 5,
            'insurance' => 2,
            'customs_fee' => 0,
            'tax' => 1,
            'discount' => 0,
            'additional_charges' => 0,

            'photos' => [$file],
        ]);

        $response->assertRedirect();

        $shipment = Shipment::where('sender_name', 'Sender Name')->where('recipient_name', 'Receiver Name')->latest('id')->first();
        $this->assertNotNull($shipment);
        $this->assertNotNull($shipment->tracking_number);

        $attachment = $shipment->attachments()->first();
        $this->assertNotNull($attachment);
        $this->assertSame('package_image', $attachment->category);
        $this->assertTrue((bool) $attachment->metadata['visible_to_customer']);

        $tracking = $this->get('/tracking/' . $shipment->tracking_number);
        $tracking->assertOk();
        $tracking->assertSee('Shipment Photos');
        $tracking->assertSee('parcel-pic.jpg', false);
    }
}