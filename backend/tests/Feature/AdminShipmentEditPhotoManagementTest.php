<?php

namespace Tests\Feature;

use App\Models\Shipment;
use App\Models\ShipmentAttachment;
use App\Models\User;
use Illuminate\Foundation\Testing\DatabaseTransactions;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Storage;
use Tests\TestCase;

class AdminShipmentEditPhotoManagementTest extends TestCase
{
    use DatabaseTransactions;

    private User $admin;

    private User $customer;

    private Shipment $shipment;

    protected function setUp(): void
    {
        parent::setUp();

        $this->admin = User::create([
            'name' => 'Photo Edit Admin',
            'email' => 'photo-edit-admin@example.test',
            'password' => 'Password123!',
            'role' => 'admin',
        ]);

        $this->customer = User::create([
            'name' => 'Photo Edit Customer',
            'email' => 'photo-edit-customer@example.test',
            'password' => 'Password123!',
            'role' => 'customer',
        ]);

        $this->shipment = Shipment::create([
            'user_id' => $this->customer->id,
            'status' => 'approved',
            'service_level' => 'domestic_express',
            'sender_name' => 'Edit Photo Sender',
            'recipient_name' => 'Edit Photo Recipient',
            'origin_address' => ['city' => 'Memphis', 'country' => 'US', 'state' => 'TN', 'address' => '123 Main St', 'postal_code' => '38116'],
            'destination_address' => ['city' => 'Austin', 'country' => 'US', 'state' => 'TX', 'address' => '456 Elm St', 'postal_code' => '73301'],
            'weight_kg' => 10.5,
            'declared_value' => 500,
            'quoted_amount' => 120.50,
            'tracking_number' => 'FDX-2026-PHOTOEDIT01',
            'metadata' => [
                'sender' => ['company' => 'Sender Co', 'phone' => '+1111111', 'email' => 's@test.com'],
                'receiver' => ['company' => 'Recv Co', 'phone' => '+1222222', 'email' => 'r@test.com'],
                'description' => 'Photos edit test',
            ],
        ]);
    }

    private function createPhoto(string $name, bool $primary = false): ShipmentAttachment
    {
        return ShipmentAttachment::create([
            'shipment_id' => $this->shipment->id,
            'uploaded_by' => $this->admin->id,
            'category' => 'package_image',
            'original_name' => $name,
            'stored_name' => $name,
            'disk' => 'public',
            'path' => 'shipment-attachments/'.$this->shipment->id.'/'.$name,
            'mime_type' => 'image/jpeg',
            'size_bytes' => 10,
            'metadata' => ['visible_to_customer' => true, 'is_primary' => $primary],
        ]);
    }

    private function basePayload(array $overrides = []): array
    {
        return array_merge([
            'sender_name' => 'Edit Photo Sender',
            'recipient_name' => 'Edit Photo Recipient',
            'service_level' => 'domestic_express',
            'status' => 'approved',
            'sender_city' => 'Memphis',
            'sender_country' => 'US',
        ], $overrides);
    }

    public function test_edit_page_shows_photo_management_controls(): void
    {
        $this->createPhoto('pkg1.jpg');
        $this->createPhoto('pkg2.jpg', true);

        $response = $this->actingAs($this->admin)
            ->get(route('admin.shipments.edit', $this->shipment));

        $response->assertOk();
        $response->assertSee('Shipment Photos');
        $response->assertSee('pkg1.jpg');
        $response->assertSee('pkg2.jpg');
        $response->assertSee('primary_photo');
        $response->assertSee('delete_photos[]', false);
        $response->assertSee('replace_photo_', false);
        $response->assertSee('Add New Photos');
        $response->assertSee('name="photos[]"', false);
    }

    public function test_add_photos_appends_without_replacing_existing(): void
    {
        Storage::fake('public');
        Storage::disk('public')->put('shipment-attachments/'.$this->shipment->id.'/pkg1.jpg', 'fake-image');
        Storage::disk('public')->put('shipment-attachments/'.$this->shipment->id.'/pkg2.jpg', 'fake-image');
        $p1 = $this->createPhoto('pkg1.jpg', true);
        $p2 = $this->createPhoto('pkg2.jpg');

        $new1 = UploadedFile::fake()->image('new-a.jpg');
        $new2 = UploadedFile::fake()->image('new-b.jpg');

        $this->actingAs($this->admin)
            ->post(route('admin.shipments.edit', $this->shipment), $this->basePayload([
                'photos' => [$new1, $new2],
            ]));

        $this->assertDatabaseHas('shipment_attachments', ['id' => $p1->id]);
        $this->assertDatabaseHas('shipment_attachments', ['id' => $p2->id]);
        $this->assertSame(4, ShipmentAttachment::where('shipment_id', $this->shipment->id)->where('category', 'package_image')->count());
        $this->assertDatabaseHas('shipment_attachments', ['shipment_id' => $this->shipment->id, 'original_name' => 'new-a.jpg']);
        $this->assertDatabaseHas('shipment_attachments', ['shipment_id' => $this->shipment->id, 'original_name' => 'new-b.jpg']);
    }

    public function test_replace_photo_only_changes_the_targeted_photo(): void
    {
        $p1 = $this->createPhoto('pkg1.jpg', true);
        $p2 = $this->createPhoto('pkg2.jpg');
        $p3 = $this->createPhoto('pkg3.jpg');

        Storage::fake('public');
        $replacement = UploadedFile::fake()->image('replaced.jpg');

        $this->actingAs($this->admin)
            ->post(route('admin.shipments.edit', $this->shipment), $this->basePayload([
                'replace_photo_'.$p2->id => $replacement,
            ]));

        $p1->refresh();
        $p2->refresh();
        $p3->refresh();

        $this->assertSame('pkg1.jpg', $p1->original_name);
        $this->assertSame('pkg3.jpg', $p3->original_name);
        $this->assertSame('replaced.jpg', $p2->original_name);
        $this->assertNotSame('pkg2.jpg', $p2->original_name);
        $this->assertTrue(Storage::disk('public')->exists($p2->path));
        $this->assertFalse(Storage::disk('public')->exists('shipment-attachments/'.$this->shipment->id.'/pkg2.jpg'));
    }

    public function test_delete_photo_only_removes_the_selected_photo(): void
    {
        $p1 = $this->createPhoto('pkg1.jpg', true);
        $p2 = $this->createPhoto('pkg2.jpg');
        $p3 = $this->createPhoto('pkg3.jpg');

        Storage::fake('public');
        Storage::disk('public')->put($p2->path, 'fake-image');

        $this->actingAs($this->admin)
            ->post(route('admin.shipments.edit', $this->shipment), $this->basePayload([
                'delete_photos' => [$p2->id],
            ]));

        $this->assertDatabaseHas('shipment_attachments', ['id' => $p1->id]);
        $this->assertDatabaseHas('shipment_attachments', ['id' => $p3->id]);
        $this->assertDatabaseMissing('shipment_attachments', ['id' => $p2->id]);
        $this->assertFalse(Storage::disk('public')->exists($p2->path));
    }

    public function test_deleting_primary_photo_promotes_another_photo(): void
    {
        $p1 = $this->createPhoto('pkg1.jpg', true);
        $p2 = $this->createPhoto('pkg2.jpg');
        $p3 = $this->createPhoto('pkg3.jpg');

        Storage::fake('public');

        $this->actingAs($this->admin)
            ->post(route('admin.shipments.edit', $this->shipment), $this->basePayload([
                'delete_photos' => [$p1->id],
            ]));

        $remaining = ShipmentAttachment::where('shipment_id', $this->shipment->id)->where('category', 'package_image')->get();
        $this->assertCount(2, $remaining);
        $this->assertSame(1, $remaining->filter(fn ($a) => $a->isPrimary())->count());
    }

    public function test_set_primary_photo_changes_primary_flag(): void
    {
        $p1 = $this->createPhoto('pkg1.jpg', true);
        $p2 = $this->createPhoto('pkg2.jpg');

        $this->actingAs($this->admin)
            ->post(route('admin.shipments.edit', $this->shipment), $this->basePayload([
                'primary_photo' => $p2->id,
            ]));

        $p1->refresh();
        $p2->refresh();

        $this->assertFalse($p1->isPrimary());
        $this->assertTrue($p2->isPrimary());
        $this->assertSame(
            1,
            ShipmentAttachment::where('shipment_id', $this->shipment->id)
                ->where('category', 'package_image')
                ->get()
                ->filter(fn ($a) => $a->isPrimary())
                ->count()
        );
    }

    public function test_no_photo_action_preserves_existing_photos(): void
    {
        $p1 = $this->createPhoto('pkg1.jpg', true);
        $p2 = $this->createPhoto('pkg2.jpg');

        $this->actingAs($this->admin)
            ->post(route('admin.shipments.edit', $this->shipment), $this->basePayload());

        $this->assertDatabaseHas('shipment_attachments', ['id' => $p1->id, 'original_name' => 'pkg1.jpg']);
        $this->assertDatabaseHas('shipment_attachments', ['id' => $p2->id, 'original_name' => 'pkg2.jpg']);
        $this->assertSame(2, ShipmentAttachment::where('shipment_id', $this->shipment->id)->count());
    }

    public function test_photo_operations_never_affect_other_shipments(): void
    {
        $this->createPhoto('a1.jpg', true);

        $other = Shipment::create([
            'user_id' => $this->customer->id,
            'status' => 'approved',
            'service_level' => 'domestic_express',
            'sender_name' => 'Other Sender',
            'recipient_name' => 'Other Recipient',
            'origin_address' => ['city' => 'Dallas', 'country' => 'US', 'state' => 'TX', 'address' => '1 A St', 'postal_code' => '75201'],
            'destination_address' => ['city' => 'Denver', 'country' => 'US', 'state' => 'CO', 'address' => '2 B St', 'postal_code' => '80202'],
            'weight_kg' => 8.5,
            'tracking_number' => 'FDX-2026-PHOTOEDIT02',
            'metadata' => ['sender' => [], 'receiver' => []],
        ]);

        Storage::fake('public');
        Storage::disk('public')->put('shipment-attachments/'.$other->id.'/b1.jpg', 'fake-image');
        Storage::disk('public')->put('shipment-attachments/'.$other->id.'/b2.jpg', 'fake-image');

        $b1 = ShipmentAttachment::create([
            'shipment_id' => $other->id,
            'uploaded_by' => $this->admin->id,
            'category' => 'package_image',
            'original_name' => 'b1.jpg',
            'stored_name' => 'b1.jpg',
            'disk' => 'public',
            'path' => 'shipment-attachments/'.$other->id.'/b1.jpg',
            'mime_type' => 'image/jpeg',
            'size_bytes' => 10,
            'metadata' => ['visible_to_customer' => true],
        ]);
        $b2 = ShipmentAttachment::create([
            'shipment_id' => $other->id,
            'uploaded_by' => $this->admin->id,
            'category' => 'package_image',
            'original_name' => 'b2.jpg',
            'stored_name' => 'b2.jpg',
            'disk' => 'public',
            'path' => 'shipment-attachments/'.$other->id.'/b2.jpg',
            'mime_type' => 'image/jpeg',
            'size_bytes' => 10,
            'metadata' => ['visible_to_customer' => true],
        ]);

        $added = UploadedFile::fake()->image('after-edit.jpg');
        $this->actingAs($this->admin)->post(route('admin.shipments.edit', $this->shipment), $this->basePayload([
            'photos' => [$added],
            'delete_photos' => [$b1->id],
            'primary_photo' => $b2->id,
        ]));

        $this->assertDatabaseHas('shipment_attachments', ['id' => $b1->id]);
        $this->assertDatabaseHas('shipment_attachments', ['id' => $b2->id]);
        $b2->refresh();
        $this->assertFalse($b2->isPrimary());

        $otherPhotos = ShipmentAttachment::where('shipment_id', $other->id)->count();
        $this->assertSame(2, $otherPhotos);

        $this->assertSame(2, ShipmentAttachment::where('shipment_id', $this->shipment->id)->count());
        $this->assertDatabaseHas('shipment_attachments', ['shipment_id' => $this->shipment->id, 'original_name' => 'after-edit.jpg']);
    }

    public function test_invalid_photo_upload_is_rejected(): void
    {
        Storage::fake('public');

        $invalid = UploadedFile::fake()->create('malware.exe', 100);

        $response = $this->actingAs($this->admin)
            ->from(route('admin.shipments.edit', $this->shipment))
            ->post(route('admin.shipments.edit', $this->shipment), $this->basePayload([
                'photos' => [$invalid],
            ]));

        $response->assertSessionHasErrors('photos.0');
        $this->assertSame(0, ShipmentAttachment::where('shipment_id', $this->shipment->id)->count());
    }

    public function test_invalid_replace_file_is_rejected_without_mutating_shipment(): void
    {
        $p1 = $this->createPhoto('pkg1.jpg', true);

        Storage::fake('public');
        $invalid = UploadedFile::fake()->create('evil.gif', 100);

        $response = $this->actingAs($this->admin)
            ->from(route('admin.shipments.edit', $this->shipment))
            ->post(route('admin.shipments.edit', $this->shipment), $this->basePayload([
                'replace_photo_'.$p1->id => $invalid,
            ]));

        $response->assertRedirect(route('admin.shipments.edit', $this->shipment));
        $p1->refresh();
        $this->assertSame('pkg1.jpg', $p1->original_name);
        $this->assertSame('Edit Photo Sender', $this->shipment->fresh()->sender_name);
    }

    public function test_tracking_page_shows_updated_photo_collection(): void
    {
        $p1 = $this->createPhoto('current-1.jpg', true);
        $p2 = $this->createPhoto('current-2.jpg');

        Storage::fake('public');
        Storage::disk('public')->put($p1->path, 'fake-image');
        Storage::disk('public')->put($p2->path, 'fake-image');

        $added = UploadedFile::fake()->image('visible-new.jpg');
        $this->actingAs($this->admin)->post(route('admin.shipments.edit', $this->shipment), $this->basePayload([
            'photos' => [$added],
        ]));

        $tracking = $this->get('/tracking/'.$this->shipment->tracking_number);
        $tracking->assertOk();
        $tracking->assertSee('Shipment Photos');
        $tracking->assertSee('current-1.jpg', false);
        $tracking->assertSee('current-2.jpg', false);
        $tracking->assertSee('visible-new.jpg', false);
    }

    public function test_create_shipment_photo_upload_still_works(): void
    {
        Storage::fake('public');

        $file = UploadedFile::fake()->image('create-parcel.jpg');

        $response = $this->actingAs($this->admin)->post(route('admin.shipments.store'), [
            'sender_full_name' => 'Create Sender',
            'sender_email' => 'create-sender@test.com',
            'sender_phone' => '+1111111',
            'sender_country' => 'US',
            'sender_city' => 'Memphis',
            'sender_address' => '123 Main St',

            'receiver_full_name' => 'Create Receiver',
            'receiver_email' => 'create-receiver@test.com',
            'receiver_phone' => '+1222222',
            'receiver_country' => 'US',
            'receiver_city' => 'Austin',
            'receiver_address' => '456 Elm St',

            'service_level' => 'domestic_express',
            'description' => 'Create flow',

            'package_type' => 'Box',
            'package_weight' => 5,
            'package_length' => 30,
            'package_width' => 20,
            'package_height' => 15,
            'package_quantity' => 1,

            'shipping_cost' => 50,

            'photos' => [$file],
        ]);

        $response->assertRedirect();

        $created = Shipment::where('sender_name', 'Create Sender')->latest('id')->first();
        $this->assertNotNull($created);
        $this->assertSame(1, ShipmentAttachment::where('shipment_id', $created->id)->where('category', 'package_image')->count());
        $this->assertTrue((bool) $created->attachments()->first()->metadata['visible_to_customer']);
    }
}