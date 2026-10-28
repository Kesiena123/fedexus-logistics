<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Shipment extends Model
{
    protected $fillable = [
        'user_id', 'driver_id', 'warehouse_id', 'tracking_number', 'status', 'service_level',
        'sender_name', 'recipient_name', 'origin_address', 'destination_address', 'weight_kg',
        'declared_value', 'quoted_amount', 'estimated_delivery_at', 'delivered_at', 'metadata',
        'current_latitude', 'current_longitude', 'current_location_name',
        'origin_latitude', 'origin_longitude', 'origin_location_name',
        'destination_latitude', 'destination_longitude', 'destination_location_name',
        'location_updated_at',
    ];

    protected $casts = [
        'origin_address' => 'array',
        'destination_address' => 'array',
        'metadata' => 'array',
        'estimated_delivery_at' => 'datetime',
        'delivered_at' => 'datetime',
        'weight_kg' => 'decimal:2',
        'declared_value' => 'decimal:2',
        'quoted_amount' => 'decimal:2',
        'current_latitude' => 'float',
        'current_longitude' => 'float',
        'origin_latitude' => 'float',
        'origin_longitude' => 'float',
        'destination_latitude' => 'float',
        'destination_longitude' => 'float',
        'location_updated_at' => 'datetime',
    ];

    public function trackingEvents(): HasMany
    {
        return $this->hasMany(TrackingEvent::class)->latest('occurred_at');
    }

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function driver(): BelongsTo
    {
        return $this->belongsTo(User::class, 'driver_id');
    }

    public function warehouse(): BelongsTo
    {
        return $this->belongsTo(Warehouse::class);
    }

    public function payments(): HasMany
    {
        return $this->hasMany(Payment::class)->orderBy('stage');
    }

    public function attachments(): HasMany
    {
        return $this->hasMany(ShipmentAttachment::class)->latest();
    }

    public function routePoints(): HasMany
    {
        return $this->hasMany(ShipmentRoutePoint::class)->orderBy('sort_order');
    }

    public function locationHistory(): HasMany
    {
        return $this->hasMany(ShipmentLocationHistory::class)->orderBy('occurred_at');
    }

    public function paymentRequests(): HasMany
    {
        return $this->hasMany(PaymentRequest::class)->latest();
    }

    public function guestChatConversations(): HasMany
    {
        return $this->hasMany(GuestChatConversation::class);
    }
}
