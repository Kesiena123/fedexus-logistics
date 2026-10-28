@extends('layouts.app')
@section('title', 'Edit Shipment')
@php $hideHeaderFooter = true; @endphp
@section('content')
<x-dashboard-shell title="Edit Shipment">
    @if(session('success'))
        <div class="mb-5 rounded-md border border-emerald-200 bg-emerald-50 px-4 py-3 text-sm font-semibold text-emerald-700">{{ session('success') }}</div>
    @endif
    @if($errors->any())
        <div class="mb-5 rounded-md border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-700">{{ $errors->first() }}</div>
    @endif

    <div class="mb-6 flex flex-wrap items-center justify-between gap-4">
        <div>
            <p class="text-xs font-semibold uppercase tracking-wider text-slate-500">Tracking Number</p>
            <h2 class="text-2xl font-bold text-slate-900">{{ $shipment->tracking_number ?? 'REQ-'.$shipment->id }}</h2>
            <p class="mt-1 text-sm capitalize text-slate-600">{{ str_replace('_', ' ', $shipment->status) }}</p>
        </div>
        <div class="flex flex-wrap gap-2">
            <a href="{{ route('admin.shipments.show', $shipment) }}" class="rounded-md border border-slate-200 px-4 py-2 text-sm font-semibold text-slate-700 hover:bg-slate-50">View Details</a>
            <a href="{{ route('admin.shipments') }}" class="rounded-md bg-[#0d5368] px-4 py-2 text-sm font-semibold text-white hover:bg-[#0b4658]">Back to Shipments</a>
        </div>
    </div>

    <form method="POST" action="{{ route('admin.shipments.edit', $shipment) }}" enctype="multipart/form-data" class="space-y-6">
        @csrf

        <div class="rounded-lg border border-slate-200 bg-white p-6 shadow-sm">
            <h3 class="text-lg font-bold text-slate-900">Sender Information</h3>
            <div class="mt-4 grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
                <div>
                    <label class="block text-sm font-semibold text-slate-700">Full Name *</label>
                    <input type="text" name="sender_name" value="{{ old('sender_name', $shipment->sender_name) }}" required class="mt-1.5 block w-full rounded-md border border-slate-300 px-4 py-2.5 text-sm focus:border-azure-500 focus:outline-none">
                </div>
                <div>
                    <label class="block text-sm font-semibold text-slate-700">Company</label>
                    <input type="text" name="sender_company" value="{{ old('sender_company', $senderMeta['company'] ?? '') }}" class="mt-1.5 block w-full rounded-md border border-slate-300 px-4 py-2.5 text-sm focus:border-azure-500 focus:outline-none">
                </div>
                <div>
                    <label class="block text-sm font-semibold text-slate-700">Phone</label>
                    <input type="text" name="sender_phone" value="{{ old('sender_phone', $senderMeta['phone'] ?? '') }}" class="mt-1.5 block w-full rounded-md border border-slate-300 px-4 py-2.5 text-sm focus:border-azure-500 focus:outline-none">
                </div>
                <div>
                    <label class="block text-sm font-semibold text-slate-700">Email</label>
                    <input type="email" name="sender_email" value="{{ old('sender_email', $senderMeta['email'] ?? '') }}" class="mt-1.5 block w-full rounded-md border border-slate-300 px-4 py-2.5 text-sm focus:border-azure-500 focus:outline-none">
                </div>
                <div>
                    <label class="block text-sm font-semibold text-slate-700">Country</label>
                    <input type="text" name="sender_country" value="{{ old('sender_country', $originAddr['country'] ?? '') }}" class="mt-1.5 block w-full rounded-md border border-slate-300 px-4 py-2.5 text-sm focus:border-azure-500 focus:outline-none">
                </div>
                <div>
                    <label class="block text-sm font-semibold text-slate-700">State/Province</label>
                    <input type="text" name="sender_state" value="{{ old('sender_state', $originAddr['state'] ?? '') }}" class="mt-1.5 block w-full rounded-md border border-slate-300 px-4 py-2.5 text-sm focus:border-azure-500 focus:outline-none">
                </div>
                <div>
                    <label class="block text-sm font-semibold text-slate-700">City</label>
                    <input type="text" name="sender_city" value="{{ old('sender_city', $originAddr['city'] ?? '') }}" class="mt-1.5 block w-full rounded-md border border-slate-300 px-4 py-2.5 text-sm focus:border-azure-500 focus:outline-none">
                </div>
                <div>
                    <label class="block text-sm font-semibold text-slate-700">Address</label>
                    <input type="text" name="sender_address" value="{{ old('sender_address', $originAddr['address'] ?? '') }}" class="mt-1.5 block w-full rounded-md border border-slate-300 px-4 py-2.5 text-sm focus:border-azure-500 focus:outline-none">
                </div>
                <div>
                    <label class="block text-sm font-semibold text-slate-700">Postal Code</label>
                    <input type="text" name="sender_postal" value="{{ old('sender_postal', $originAddr['postal_code'] ?? '') }}" class="mt-1.5 block w-full rounded-md border border-slate-300 px-4 py-2.5 text-sm focus:border-azure-500 focus:outline-none">
                </div>
            </div>
        </div>

        <div class="rounded-lg border border-slate-200 bg-white p-6 shadow-sm">
            <h3 class="text-lg font-bold text-slate-900">Receiver Information</h3>
            <div class="mt-4 grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
                <div>
                    <label class="block text-sm font-semibold text-slate-700">Full Name *</label>
                    <input type="text" name="recipient_name" value="{{ old('recipient_name', $shipment->recipient_name) }}" required class="mt-1.5 block w-full rounded-md border border-slate-300 px-4 py-2.5 text-sm focus:border-azure-500 focus:outline-none">
                </div>
                <div>
                    <label class="block text-sm font-semibold text-slate-700">Company</label>
                    <input type="text" name="recipient_company" value="{{ old('recipient_company', $receiverMeta['company'] ?? '') }}" class="mt-1.5 block w-full rounded-md border border-slate-300 px-4 py-2.5 text-sm focus:border-azure-500 focus:outline-none">
                </div>
                <div>
                    <label class="block text-sm font-semibold text-slate-700">Phone</label>
                    <input type="text" name="recipient_phone" value="{{ old('recipient_phone', $receiverMeta['phone'] ?? '') }}" class="mt-1.5 block w-full rounded-md border border-slate-300 px-4 py-2.5 text-sm focus:border-azure-500 focus:outline-none">
                </div>
                <div>
                    <label class="block text-sm font-semibold text-slate-700">Email</label>
                    <input type="email" name="recipient_email" value="{{ old('recipient_email', $receiverMeta['email'] ?? '') }}" class="mt-1.5 block w-full rounded-md border border-slate-300 px-4 py-2.5 text-sm focus:border-azure-500 focus:outline-none">
                </div>
                <div>
                    <label class="block text-sm font-semibold text-slate-700">Country</label>
                    <input type="text" name="recipient_country" value="{{ old('recipient_country', $destAddr['country'] ?? '') }}" class="mt-1.5 block w-full rounded-md border border-slate-300 px-4 py-2.5 text-sm focus:border-azure-500 focus:outline-none">
                </div>
                <div>
                    <label class="block text-sm font-semibold text-slate-700">State/Province</label>
                    <input type="text" name="recipient_state" value="{{ old('recipient_state', $destAddr['state'] ?? '') }}" class="mt-1.5 block w-full rounded-md border border-slate-300 px-4 py-2.5 text-sm focus:border-azure-500 focus:outline-none">
                </div>
                <div>
                    <label class="block text-sm font-semibold text-slate-700">City</label>
                    <input type="text" name="recipient_city" value="{{ old('recipient_city', $destAddr['city'] ?? '') }}" class="mt-1.5 block w-full rounded-md border border-slate-300 px-4 py-2.5 text-sm focus:border-azure-500 focus:outline-none">
                </div>
                <div>
                    <label class="block text-sm font-semibold text-slate-700">Address</label>
                    <input type="text" name="recipient_address" value="{{ old('recipient_address', $destAddr['address'] ?? '') }}" class="mt-1.5 block w-full rounded-md border border-slate-300 px-4 py-2.5 text-sm focus:border-azure-500 focus:outline-none">
                </div>
                <div>
                    <label class="block text-sm font-semibold text-slate-700">Postal Code</label>
                    <input type="text" name="recipient_postal" value="{{ old('recipient_postal', $destAddr['postal_code'] ?? '') }}" class="mt-1.5 block w-full rounded-md border border-slate-300 px-4 py-2.5 text-sm focus:border-azure-500 focus:outline-none">
                </div>
            </div>
        </div>

        <div class="rounded-lg border border-slate-200 bg-white p-6 shadow-sm">
            <h3 class="text-lg font-bold text-slate-900">Shipment Information</h3>
            <div class="mt-4 grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
                <div>
                    <label class="block text-sm font-semibold text-slate-700">Service Level *</label>
                    <select name="service_level" required class="mt-1.5 block w-full rounded-md border border-slate-300 px-4 py-2.5 text-sm focus:border-azure-500 focus:outline-none">
                        <option value="domestic_express" @selected(old('service_level', $shipment->service_level) === 'domestic_express')>Domestic Express</option>
                        <option value="international_priority" @selected(old('service_level', $shipment->service_level) === 'international_priority')>International Priority</option>
                        <option value="freight" @selected(old('service_level', $shipment->service_level) === 'freight')>Freight</option>
                    </select>
                </div>
                <div>
                    <label class="block text-sm font-semibold text-slate-700">Current Status *</label>
                    <select name="status" required class="mt-1.5 block w-full rounded-md border border-slate-300 px-4 py-2.5 text-sm focus:border-azure-500 focus:outline-none">
                        @foreach($statuses as $status)
                            <option value="{{ $status }}" @selected(old('status', $shipment->status) === $status)>{{ str_replace('_', ' ', ucfirst($status)) }}</option>
                        @endforeach
                    </select>
                </div>
                <div>
                    <label class="block text-sm font-semibold text-slate-700">Priority</label>
                    <select name="priority" class="mt-1.5 block w-full rounded-md border border-slate-300 px-4 py-2.5 text-sm focus:border-azure-500 focus:outline-none">
                        <option value="">Normal</option>
                        <option value="high" @selected(old('priority', $metadata['priority'] ?? '') === 'high')>High</option>
                        <option value="urgent" @selected(old('priority', $metadata['priority'] ?? '') === 'urgent')>Urgent</option>
                        <option value="low" @selected(old('priority', $metadata['priority'] ?? '') === 'low')>Low</option>
                    </select>
                </div>
                <div>
                    <label class="block text-sm font-semibold text-slate-700">Estimated Delivery Date</label>
                    <input type="date" name="estimated_delivery_at" value="{{ old('estimated_delivery_at', $shipment->estimated_delivery_at?->format('Y-m-d')) }}" class="mt-1.5 block w-full rounded-md border border-slate-300 px-4 py-2.5 text-sm focus:border-azure-500 focus:outline-none">
                </div>
                <div class="sm:col-span-2 lg:col-span-3">
                    <label class="block text-sm font-semibold text-slate-700">Description</label>
                    <textarea name="shipment_description" class="mt-1.5 block w-full rounded-md border border-slate-300 px-4 py-2.5 text-sm focus:border-azure-500 focus:outline-none" rows="3">{{ old('shipment_description', $metadata['description'] ?? '') }}</textarea>
                </div>
            </div>
        </div>

        <div class="rounded-lg border border-slate-200 bg-white p-6 shadow-sm">
            <h3 class="text-lg font-bold text-slate-900">Parcel Information</h3>
            <div class="mt-4 grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
                <div>
                    <label class="block text-sm font-semibold text-slate-700">Package Type</label>
                    <input type="text" name="package_type" value="{{ old('package_type', $firstPackage['package_type'] ?? '') }}" class="mt-1.5 block w-full rounded-md border border-slate-300 px-4 py-2.5 text-sm focus:border-azure-500 focus:outline-none">
                </div>
                <div>
                    <label class="block text-sm font-semibold text-slate-700">Weight (kg)</label>
                    <input type="number" name="weight_kg" value="{{ old('weight_kg', $shipment->weight_kg) }}" step="0.01" min="0" class="mt-1.5 block w-full rounded-md border border-slate-300 px-4 py-2.5 text-sm focus:border-azure-500 focus:outline-none">
                </div>
                <div>
                    <label class="block text-sm font-semibold text-slate-700">Quantity</label>
                    <input type="number" name="quantity" value="{{ old('quantity', $firstPackage['quantity'] ?? 1) }}" min="1" class="mt-1.5 block w-full rounded-md border border-slate-300 px-4 py-2.5 text-sm focus:border-azure-500 focus:outline-none">
                </div>
                <div>
                    <label class="block text-sm font-semibold text-slate-700">Length (cm)</label>
                    <input type="number" name="length_cm" value="{{ old('length_cm', $firstPackage['length_cm'] ?? '') }}" step="0.1" min="0" class="mt-1.5 block w-full rounded-md border border-slate-300 px-4 py-2.5 text-sm focus:border-azure-500 focus:outline-none">
                </div>
                <div>
                    <label class="block text-sm font-semibold text-slate-700">Width (cm)</label>
                    <input type="number" name="width_cm" value="{{ old('width_cm', $firstPackage['width_cm'] ?? '') }}" step="0.1" min="0" class="mt-1.5 block w-full rounded-md border border-slate-300 px-4 py-2.5 text-sm focus:border-azure-500 focus:outline-none">
                </div>
                <div>
                    <label class="block text-sm font-semibold text-slate-700">Height (cm)</label>
                    <input type="number" name="height_cm" value="{{ old('height_cm', $firstPackage['height_cm'] ?? '') }}" step="0.1" min="0" class="mt-1.5 block w-full rounded-md border border-slate-300 px-4 py-2.5 text-sm focus:border-azure-500 focus:outline-none">
                </div>
                <div class="sm:col-span-2 lg:col-span-4">
                    <label class="block text-sm font-semibold text-slate-700">Package Description</label>
                    <textarea name="package_description" class="mt-1.5 block w-full rounded-md border border-slate-300 px-4 py-2.5 text-sm focus:border-azure-500 focus:outline-none" rows="2">{{ old('package_description', $firstPackage['description'] ?? '') }}</textarea>
                </div>
            </div>
        </div>

        <div class="rounded-lg border border-slate-200 bg-white p-6 shadow-sm">
            <h3 class="text-lg font-bold text-slate-900">Cost Breakdown</h3>
            <div class="mt-4 grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
                <div>
                    <label class="block text-sm font-semibold text-slate-700">Shipping Cost</label>
                    <input type="number" name="shipping_cost" value="{{ old('shipping_cost', $costMeta['shipping_cost'] ?? $shipment->quoted_amount ?? 0) }}" step="0.01" min="0" class="mt-1.5 block w-full rounded-md border border-slate-300 px-4 py-2.5 text-sm focus:border-azure-500 focus:outline-none">
                </div>
                <div>
                    <label class="block text-sm font-semibold text-slate-700">Handling Fee</label>
                    <input type="number" name="handling_fee" value="{{ old('handling_fee', $costMeta['handling_fee'] ?? 0) }}" step="0.01" min="0" class="mt-1.5 block w-full rounded-md border border-slate-300 px-4 py-2.5 text-sm focus:border-azure-500 focus:outline-none">
                </div>
                <div>
                    <label class="block text-sm font-semibold text-slate-700">Insurance</label>
                    <input type="number" name="insurance" value="{{ old('insurance', $costMeta['insurance'] ?? 0) }}" step="0.01" min="0" class="mt-1.5 block w-full rounded-md border border-slate-300 px-4 py-2.5 text-sm focus:border-azure-500 focus:outline-none">
                </div>
                <div>
                    <label class="block text-sm font-semibold text-slate-700">Customs Fee</label>
                    <input type="number" name="customs_fee" value="{{ old('customs_fee', $costMeta['customs_fee'] ?? 0) }}" step="0.01" min="0" class="mt-1.5 block w-full rounded-md border border-slate-300 px-4 py-2.5 text-sm focus:border-azure-500 focus:outline-none">
                </div>
                <div>
                    <label class="block text-sm font-semibold text-slate-700">Tax</label>
                    <input type="number" name="tax" value="{{ old('tax', $costMeta['tax'] ?? 0) }}" step="0.01" min="0" class="mt-1.5 block w-full rounded-md border border-slate-300 px-4 py-2.5 text-sm focus:border-azure-500 focus:outline-none">
                </div>
                <div>
                    <label class="block text-sm font-semibold text-slate-700">Discount</label>
                    <input type="number" name="discount" value="{{ old('discount', $costMeta['discount'] ?? 0) }}" step="0.01" min="0" class="mt-1.5 block w-full rounded-md border border-slate-300 px-4 py-2.5 text-sm focus:border-azure-500 focus:outline-none">
                </div>
                <div>
                    <label class="block text-sm font-semibold text-slate-700">Additional Charges</label>
                    <input type="number" name="additional_charges" value="{{ old('additional_charges', $costMeta['additional_charges'] ?? 0) }}" step="0.01" min="0" class="mt-1.5 block w-full rounded-md border border-slate-300 px-4 py-2.5 text-sm focus:border-azure-500 focus:outline-none">
                </div>
            </div>
        </div>

        <div class="rounded-lg border border-slate-200 bg-white p-6 shadow-sm">
            <h3 class="text-lg font-bold text-slate-900">Location & Route</h3>
            <p class="mt-1 text-sm text-slate-500">Set origin, destination and current coordinates for the map.</p>
            <div class="mt-4 grid gap-4 sm:grid-cols-2">
                <div class="rounded-md bg-slate-50 p-4">
                    <h4 class="font-semibold text-slate-800">Origin Location</h4>
                    <div class="mt-3 grid gap-3 sm:grid-cols-2">
                        <div>
                            <label class="block text-xs font-semibold text-slate-600">Latitude</label>
                            <input type="number" id="origin_lat" name="origin_latitude" value="{{ old('origin_latitude', $originAddr['latitude'] ?? '') }}" step="any" min="-90" max="90" class="mt-1 block w-full rounded-md border border-slate-300 px-3 py-2 text-sm focus:border-azure-500 focus:outline-none">
                        </div>
                        <div>
                            <label class="block text-xs font-semibold text-slate-600">Longitude</label>
                            <input type="number" id="origin_lng" name="origin_longitude" value="{{ old('origin_longitude', $originAddr['longitude'] ?? '') }}" step="any" min="-180" max="180" class="mt-1 block w-full rounded-md border border-slate-300 px-3 py-2 text-sm focus:border-azure-500 focus:outline-none">
                        </div>
                    </div>
                    <div class="mt-3">
                        <label class="block text-xs font-semibold text-slate-600">Location Name</label>
                        <input type="text" name="origin_location_name" value="{{ old('origin_location_name', $shipment->origin_location_name ?? '') }}" maxlength="255" class="mt-1 block w-full rounded-md border border-slate-300 px-3 py-2 text-sm focus:border-azure-500 focus:outline-none">
                    </div>
                </div>
                <div class="rounded-md bg-slate-50 p-4">
                    <h4 class="font-semibold text-slate-800">Destination Location</h4>
                    <div class="mt-3 grid gap-3 sm:grid-cols-2">
                        <div>
                            <label class="block text-xs font-semibold text-slate-600">Latitude</label>
                            <input type="number" id="dest_lat" name="destination_latitude" value="{{ old('destination_latitude', $destAddr['latitude'] ?? '') }}" step="any" min="-90" max="90" class="mt-1 block w-full rounded-md border border-slate-300 px-3 py-2 text-sm focus:border-azure-500 focus:outline-none">
                        </div>
                        <div>
                            <label class="block text-xs font-semibold text-slate-600">Longitude</label>
                            <input type="number" id="dest_lng" name="destination_longitude" value="{{ old('destination_longitude', $destAddr['longitude'] ?? '') }}" step="any" min="-180" max="180" class="mt-1 block w-full rounded-md border border-slate-300 px-3 py-2 text-sm focus:border-azure-500 focus:outline-none">
                        </div>
                    </div>
                    <div class="mt-3">
                        <label class="block text-xs font-semibold text-slate-600">Location Name</label>
                        <input type="text" name="destination_location_name" value="{{ old('destination_location_name', $shipment->destination_location_name ?? '') }}" maxlength="255" class="mt-1 block w-full rounded-md border border-slate-300 px-3 py-2 text-sm focus:border-azure-500 focus:outline-none">
                    </div>
                </div>
            </div>
            <div class="mt-4 rounded-md bg-slate-50 p-4">
                <h4 class="font-semibold text-slate-800">Current Location</h4>
                <p class="mt-0.5 text-xs text-slate-500">Last known live position. Leave blank to keep the latest tracking event location.</p>
                <div class="mt-3 grid gap-3 sm:grid-cols-2">
                    <div>
                        <label class="block text-xs font-semibold text-slate-600">Latitude</label>
                        <input type="number" id="current_lat" name="current_latitude" value="{{ old('current_latitude', $shipment->current_latitude ?? '') }}" step="any" min="-90" max="90" class="mt-1 block w-full rounded-md border border-slate-300 px-3 py-2 text-sm focus:border-azure-500 focus:outline-none">
                    </div>
                    <div>
                        <label class="block text-xs font-semibold text-slate-600">Longitude</label>
                        <input type="number" id="current_lng" name="current_longitude" value="{{ old('current_longitude', $shipment->current_longitude ?? '') }}" step="any" min="-180" max="180" class="mt-1 block w-full rounded-md border border-slate-300 px-3 py-2 text-sm focus:border-azure-500 focus:outline-none">
                    </div>
                </div>
                <div class="mt-3">
                    <label class="block text-xs font-semibold text-slate-600">Location Name</label>
                    <input type="text" name="current_location_name" value="{{ old('current_location_name', $shipment->current_location_name ?? '') }}" maxlength="255" class="mt-1 block w-full rounded-md border border-slate-300 px-3 py-2 text-sm focus:border-azure-500 focus:outline-none">
                </div>
            </div>
            <div class="mt-4">
                <h4 class="font-semibold text-slate-800">Route Preview</h4>
                <p class="mt-0.5 text-xs text-slate-500">Preview the route as you enter coordinates. Markers update automatically.</p>
                <div class="mt-3 overflow-hidden rounded-md border border-slate-200">
                    <div id="shipment-preview-map" class="h-64 min-h-64 w-full"></div>
                </div>
                <div class="mt-2 flex flex-wrap gap-4 text-xs text-slate-500">
                    <span class="inline-flex items-center gap-1.5"><span class="spm-legend-dot" style="background:#2563eb"></span>Origin</span>
                    <span class="inline-flex items-center gap-1.5"><span class="spm-legend-dot" style="background:#dc2626"></span>Current</span>
                    <span class="inline-flex items-center gap-1.5"><span class="spm-legend-dot" style="background:#059669"></span>Destination</span>
                </div>
            </div>

            @if($shipment->routePoints->count())
                <div class="mt-4">
                    <h4 class="font-semibold text-slate-800">Existing Route Points</h4>
                    <div class="mt-2 space-y-2">
                        @foreach($shipment->routePoints as $point)
                            <div class="flex items-center gap-3 rounded-md bg-slate-50 px-4 py-2 text-sm">
                                <span class="inline-flex items-center rounded-full bg-{{ $point->type === 'destination' ? 'emerald' : ($point->type === 'origin' ? 'azure' : 'gold') }}-100 px-2.5 py-0.5 text-xs font-semibold text-{{ $point->type === 'destination' ? 'emerald' : ($point->type === 'origin' ? 'azure' : 'gold') }}-700">{{ ucfirst($point->type) }}</span>
                                <span class="text-slate-700">{{ $point->location ?: $point->label }}</span>
                                @if($point->latitude && $point->longitude)
                                    <span class="text-xs text-slate-400">({{ $point->latitude }}, {{ $point->longitude }})</span>
                                @endif
                            </div>
                        @endforeach
                    </div>
                </div>
            @endif
        </div>

        <div class="rounded-lg border border-slate-200 bg-white p-6 shadow-sm">
            <h3 class="text-lg font-bold text-slate-900">Shipment Photos</h3>
            <p class="mt-1 text-sm text-slate-500">Manage this shipment's package photos. Add, replace, or delete photos and choose the primary photo.</p>

            @if($shipmentPhotos->count())
                <div class="mt-4 grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
                    @foreach($shipmentPhotos as $attachment)
                        <div class="rounded-md border {{ $attachment->isPrimary() ? 'border-azure-400 ring-2 ring-azure-100' : 'border-slate-200' }} bg-white p-2">
                            <div class="relative">
                                @if(\Illuminate\Support\Facades\Storage::disk($attachment->disk)->exists($attachment->path))
                                    <img src="{{ \Illuminate\Support\Facades\Storage::disk($attachment->disk)->url($attachment->path) }}" alt="{{ $attachment->original_name }}" class="h-32 w-full rounded object-cover">
                                @else
                                    <div class="flex h-32 w-full items-center justify-center rounded bg-slate-100 text-xs text-slate-400">File missing</div>
                                @endif
                                @if($attachment->isPrimary())
                                    <span class="absolute left-2 top-2 rounded bg-azure-600 px-2 py-0.5 text-[10px] font-bold text-white">Primary</span>
                                @endif
                            </div>
                            <p class="mt-1 truncate text-xs text-slate-500" title="{{ $attachment->original_name }}">{{ $attachment->original_name }}</p>
                            <div class="mt-2 space-y-2 text-xs">
                                <label class="flex items-center gap-1.5 text-slate-600">
                                    <input type="radio" name="primary_photo" value="{{ $attachment->id }}" @checked($attachment->isPrimary())>
                                    <span>Set as primary photo</span>
                                </label>
                                <label class="block text-slate-600">
                                    <span>Replace photo</span>
                                    <input type="file" name="replace_photo_{{ $attachment->id }}" accept="image/jpeg,image/png,image/webp" class="mt-1 block w-full rounded-md border border-slate-300 px-3 py-1.5 text-xs file:mr-2 file:rounded-md file:border-0 file:bg-azure-50 file:px-2 file:py-1 file:text-xs file:font-semibold file:text-azure-700">
                                </label>
                                <label class="flex items-center gap-1.5 text-red-600">
                                    <input type="checkbox" name="delete_photos[]" value="{{ $attachment->id }}" class="delete-photo-check">
                                    <span>Delete this photo</span>
                                </label>
                            </div>
                        </div>
                    @endforeach
                </div>
            @else
                <p class="mt-3 text-sm text-slate-500">No photos uploaded yet. Select photos below and save to add them.</p>
            @endif

            <div class="mt-5 border-t border-slate-100 pt-4">
                <label class="block text-sm font-semibold text-slate-700">Add New Photos</label>
                <p class="mt-1 text-sm text-slate-500">Select one or more images below (JPG, PNG, WebP, max 5MB each). Existing photos are kept and the new photos are added to this shipment.</p>
                <input type="file" name="photos[]" multiple accept="image/jpeg,image/png,image/webp" class="mt-2 block w-full rounded-md border border-slate-300 px-4 py-2.5 text-sm focus:border-azure-500 focus:outline-none file:mr-3 file:rounded-md file:border-0 file:bg-azure-50 file:px-3 file:py-1.5 file:text-sm file:font-semibold file:text-azure-700 hover:file:bg-azure-100">
            </div>
        </div>

        <div class="flex gap-4">
            <button type="submit" class="rounded-md bg-[#0d5368] px-8 py-3 text-sm font-bold text-white hover:bg-[#0b4658]">Save Changes</button>
            <a href="{{ route('admin.shipments.show', $shipment) }}" class="rounded-md border border-slate-300 px-8 py-3 text-sm font-semibold text-slate-600 hover:bg-slate-50">Cancel</a>
        </div>
    </form>

    <script>
    (function() {
        function photoReady(fn) {
            if (document.readyState !== 'loading') { fn(); } else { document.addEventListener('DOMContentLoaded', fn); }
        }
        photoReady(function() {
            var form = document.querySelector('form[enctype="multipart/form-data"]');
            if (!form) return;
            form.addEventListener('submit', function(e) {
                var checked = form.querySelectorAll('.delete-photo-check:checked');
                if (checked.length) {
                    var labels = [];
                    checked.forEach(function(cb) {
                        var card = cb.closest('.rounded-md');
                        var img = card ? card.querySelector('img') : null;
                        var name = card ? card.querySelector('p[title]') : null;
                        labels.push(img ? (img.alt || 'photo') : (name ? name.textContent : 'photo'));
                    });
                    if (!window.confirm('Delete the selected photo(s)? This cannot be undone.\n\n' + labels.join(', ') + '\n\nThe shipment and its other photos will remain unchanged.')) {
                        e.preventDefault();
                    }
                }
            });
        });
    })();
    </script>

    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
    <script>
    (function() {
        function previewReady(fn) {
            if (document.readyState !== 'loading') { fn(); } else { document.addEventListener('DOMContentLoaded', fn); }
        }
        previewReady(function() {
            var mapEl = document.getElementById('shipment-preview-map');
            if (!mapEl || !window.L) return;

            function num(id) {
                var v = document.getElementById(id).value;
                if (v === '' || v == null) return null;
                v = Number(v);
                return isNaN(v) ? null : v;
            }

            function pinIcon(type, bg) {
                var letter = type === 'origin' ? 'O' : 'D';
                return L.divIcon({
                    html: '<div class="spm-pin"><div class="spm-pin-bg" style="background:' + bg + '"></div><div class="spm-pin-letter">' + letter + '</div></div>',
                    className: 'spm-pin-wrapper',
                    iconSize: [32, 36],
                    iconAnchor: [16, 34],
                    popupAnchor: [0, -30]
                });
            }

            var map = L.map(mapEl, { zoomControl: true, scrollWheelZoom: true });
            L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png', {
                maxZoom: 19,
                attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
            }).addTo(map);

            var originMarker = null, currentMarker = null, destMarker = null, routeLine = null;

            function redraw() {
                var origin = [num('origin_lat'), num('origin_lng')];
                var current = [num('current_lat'), num('current_lng')];
                var dest = [num('dest_lat'), num('dest_lng')];
                var validOrigin = origin[0] != null && origin[1] != null;
                var validCurrent = current[0] != null && current[1] != null;
                var validDest = dest[0] != null && dest[1] != null;

                if (validOrigin) {
                    if (!originMarker) originMarker = L.marker(origin, { icon: pinIcon('origin', '#2563eb') }).addTo(map);
                    else originMarker.setLatLng(origin);
                } else if (originMarker) { map.removeLayer(originMarker); originMarker = null; }

                if (validCurrent) {
                    if (!currentMarker) {
                        currentMarker = L.marker(current, {
                            icon: L.divIcon({
                                html: '<div class="spm-marker-current"><div class="spm-marker-halo"></div><div class="spm-marker-pulse"></div><div class="spm-marker-dot"></div></div>',
                                className: 'spm-marker-wrapper', iconSize: [42, 42], iconAnchor: [21, 21]
                            })
                        }).addTo(map);
                    } else currentMarker.setLatLng(current);
                } else if (currentMarker) { map.removeLayer(currentMarker); currentMarker = null; }

                if (validDest) {
                    if (!destMarker) destMarker = L.marker(dest, { icon: pinIcon('destination', '#059669') }).addTo(map);
                    else destMarker.setLatLng(dest);
                } else if (destMarker) { map.removeLayer(destMarker); destMarker = null; }

                var latLngs = [];
                if (validOrigin) latLngs.push(origin);
                if (validCurrent) latLngs.push(current);
                if (validDest) latLngs.push(dest);

                if (latLngs.length >= 2) {
                    if (!routeLine) {
                        routeLine = L.polyline(latLngs, { color: '#1e40af', weight: 4, opacity: 0.8, dashArray: '10, 8', lineCap: 'round' }).addTo(map);
                    } else {
                        routeLine.setLatLngs(latLngs).redraw();
                    }
                    map.fitBounds(L.latLngBounds(latLngs), { padding: [40, 40], maxZoom: 13 });
                } else if (latLngs.length === 1) {
                    if (routeLine) { map.removeLayer(routeLine); routeLine = null; }
                    map.setView(latLngs[0], 12);
                } else {
                    if (routeLine) { map.removeLayer(routeLine); routeLine = null; }
                    map.setView([9.081999, 8.675277], 3);
                }
            }

            ['origin_lat', 'origin_lng', 'dest_lat', 'dest_lng', 'current_lat', 'current_lng'].forEach(function(id) {
                document.getElementById(id).addEventListener('input', redraw);
            });

            redraw();
        });
    })();
    </script>
</x-dashboard-shell>
@endsection