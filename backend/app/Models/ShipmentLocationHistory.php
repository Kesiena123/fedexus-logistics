<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class ShipmentLocationHistory extends Model
{
    protected $table = 'shipment_location_history';

    protected $fillable = [
        'shipment_id',
        'latitude',
        'longitude',
        'location_name',
        'point_type',
        'source',
        'status',
        'occurred_at',
        'created_by',
    ];

    protected $casts = [
        'latitude' => 'float',
        'longitude' => 'float',
        'occurred_at' => 'datetime',
    ];

    public function shipment(): BelongsTo
    {
        return $this->belongsTo(Shipment::class);
    }
}