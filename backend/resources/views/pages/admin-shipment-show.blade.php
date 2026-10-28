@extends('layouts.app')
@section('title', 'Shipment Details')
@php
    $hideHeaderFooter = true;
    $money = fn ($value) => '$'.number_format((float) ($value ?? 0), 2);
    $address = fn ($addr) => collect([$addr['address'] ?? null, $addr['city'] ?? null, $addr['state'] ?? null, $addr['country'] ?? null])->filter()->implode(', ') ?: 'Not provided';
    $timelineStatuses = [
        'shipment_requested' => 'Shipment Created',
        'approved' => 'Package Received',
        'warehouse_processing' => 'Processing',
        'international_processing' => 'In Transit',
        'destination_hub' => 'Arrived at Facility',
        'out_for_delivery' => 'Out for Delivery',
        'delivered' => 'Delivered',
    ];
@endphp
@section('content')
    <x-dashboard-shell title="Shipment Details">
        @if(session('success'))
            <div class="mb-5 rounded-md border border-emerald-200 bg-emerald-50 px-4 py-3 text-sm font-semibold text-emerald-700">{{ session('success') }}</div>
        @endif

        <div class="grid gap-6 xl:grid-cols-[1.2fr_0.8fr]">
            <section class="rounded-lg border border-slate-200 bg-white p-5 shadow-sm">
                <div class="flex flex-wrap items-start justify-between gap-4">
                    <div>
                        <p class="text-xs font-semibold uppercase tracking-[0.18em] text-slate-500">Tracking Number</p>
                        <h2 class="mt-2 text-2xl font-bold text-slate-900">{{ $shipment->tracking_number ?? 'REQ-'.$shipment->id }}</h2>
                        <p class="mt-1 text-sm capitalize text-slate-600">{{ str_replace('_', ' ', $shipment->status) }}</p>
                    </div>
                    <div class="flex flex-wrap gap-2">
                        @if($shipment->tracking_number)
                            <a href="{{ route('tracking.number', $shipment->tracking_number) }}" class="rounded-md border border-slate-200 px-4 py-2 text-sm font-semibold text-slate-700 hover:bg-slate-50">Public Tracking</a>
                        @endif
                        <a href="{{ route('admin.shipments.edit', $shipment) }}" class="rounded-md border border-amber-200 px-4 py-2 text-sm font-semibold text-amber-700 hover:bg-amber-50">Edit Shipment</a>
                        @if($shipment->tracking_number)
                            <a href="{{ route('admin.shipments.receipt', $shipment) }}" class="rounded-md border border-green-200 px-4 py-2 text-sm font-semibold text-green-700 hover:bg-green-50">Download Receipt</a>
                        @endif
                        <a href="{{ route('admin.shipments') }}" class="rounded-md bg-[#0d5368] px-4 py-2 text-sm font-semibold text-white hover:bg-[#0b4658]">Back to Shipments</a>
                    </div>
                </div>

                <div class="mt-6 grid gap-4 md:grid-cols-2">
                    <div class="rounded-md bg-slate-50 p-4">
                        <h3 class="font-semibold text-slate-900">Sender Information</h3>
                        <p class="mt-2 text-sm text-slate-600">{{ $shipment->sender_name }}</p>
                        <p class="text-sm text-slate-600">{{ data_get($shipment->metadata, 'sender.email', 'Email unavailable') }}</p>
                        <p class="text-sm text-slate-600">{{ data_get($shipment->metadata, 'sender.phone', 'Phone unavailable') }}</p>
                        <p class="mt-2 text-sm text-slate-600">{{ $address($shipment->origin_address) }}</p>
                    </div>
                    <div class="rounded-md bg-slate-50 p-4">
                        <h3 class="font-semibold text-slate-900">Receiver Information</h3>
                        <p class="mt-2 text-sm text-slate-600">{{ $shipment->recipient_name }}</p>
                        <p class="text-sm text-slate-600">{{ data_get($shipment->metadata, 'receiver.email', 'Email unavailable') }}</p>
                        <p class="text-sm text-slate-600">{{ data_get($shipment->metadata, 'receiver.phone', 'Phone unavailable') }}</p>
                        <p class="mt-2 text-sm text-slate-600">{{ $address($shipment->destination_address) }}</p>
                    </div>
                </div>

                <div class="mt-6 grid gap-4 md:grid-cols-4">
                    <div class="rounded-md border border-slate-200 p-4">
                        <p class="text-xs text-slate-500">Shipment Type</p>
                        <p class="mt-1 font-semibold capitalize">{{ str_replace('_', ' ', $shipment->service_level) }}</p>
                    </div>
                    <div class="rounded-md border border-slate-200 p-4">
                        <p class="text-xs text-slate-500">Weight</p>
                        <p class="mt-1 font-semibold">{{ $shipment->weight_kg }} kg</p>
                    </div>
                    <div class="rounded-md border border-slate-200 p-4">
                        <p class="text-xs text-slate-500">Estimated Delivery</p>
                        <p class="mt-1 font-semibold">{{ $shipment->estimated_delivery_at?->format('M d, Y') ?? '-' }}</p>
                    </div>
                    <div class="rounded-md border border-slate-200 p-4">
                        <p class="text-xs text-slate-500">Amount</p>
                        <p class="mt-1 font-semibold">{{ $money($shipment->quoted_amount) }}</p>
                    </div>
                </div>
            </section>

            <section class="rounded-lg border border-slate-200 bg-white p-5 shadow-sm">
                <h3 class="text-lg font-bold text-slate-900">Add Tracking Update</h3>
                <form method="POST" action="{{ route('admin.shipments.show', $shipment) }}" class="mt-4 grid gap-4">
                    @csrf
                    <select name="status" class="min-h-11 rounded-md border border-slate-200 px-3 text-sm" required>
                        @foreach($statuses as $status)
                            <option value="{{ $status }}" @selected(old('status', $shipment->status) === $status)>{{ str_replace('_', ' ', ucfirst($status)) }}</option>
                        @endforeach
                    </select>
                    <input name="location" value="{{ old('location') }}" class="min-h-11 rounded-md border border-slate-200 px-3 text-sm" placeholder="Location" required>
                    <input name="occurred_at" value="{{ old('occurred_at', now()->format('Y-m-d\TH:i')) }}" type="datetime-local" class="min-h-11 rounded-md border border-slate-200 px-3 text-sm" required>
                    <div class="grid gap-3 sm:grid-cols-2">
                        <input name="latitude" value="{{ old('latitude') }}" type="number" step="any" min="-90" max="90" class="min-h-11 rounded-md border border-slate-200 px-3 text-sm" placeholder="Latitude">
                        <input name="longitude" value="{{ old('longitude') }}" type="number" step="any" min="-180" max="180" class="min-h-11 rounded-md border border-slate-200 px-3 text-sm" placeholder="Longitude">
                    </div>
                    <textarea name="description" class="min-h-28 rounded-md border border-slate-200 px-3 py-2 text-sm" placeholder="Description" required>{{ old('description') }}</textarea>
                    @if($errors->any())
                        <div class="rounded-md border border-red-200 bg-red-50 px-3 py-2 text-sm text-red-700">{{ $errors->first() }}</div>
                    @endif
                    <button class="min-h-11 rounded-md bg-[#0d5368] px-5 text-sm font-bold text-white hover:bg-[#0b4658]">Save Tracking Update</button>
                </form>
            </section>
        </div>

        <div class="mt-6 grid gap-6 xl:grid-cols-[1fr_0.8fr]">
            <section class="rounded-lg border border-slate-200 bg-white p-5 shadow-sm">
                <h3 class="text-lg font-bold text-slate-900">Shipment Timeline</h3>
                <div class="mt-5 space-y-4">
                    @foreach($timelineStatuses as $status => $label)
                        @php($event = $shipment->trackingEvents->firstWhere('status', $status))
                        <div class="flex gap-4">
                            <div class="mt-1 size-3 shrink-0 rounded-full {{ $event ? 'bg-[#0d5368]' : 'bg-slate-300' }}"></div>
                            <div>
                                <p class="font-semibold text-slate-900">{{ $label }}</p>
                                <p class="text-sm text-slate-600">{{ $event?->location ?? 'Waiting for update' }}</p>
                                <p class="text-sm text-slate-500">{{ $event?->description ?? '' }}</p>
                                <p class="text-xs text-slate-400">{{ $event?->occurred_at?->format('M d, Y H:i') ?? '' }}</p>
                            </div>
                        </div>
                    @endforeach
                </div>
            </section>

            <section class="rounded-lg border border-slate-200 bg-white p-5 shadow-sm">
                <h3 class="text-lg font-bold text-slate-900">Deposits & Attachments</h3>
                <div class="mt-4 space-y-3">
                    @forelse($shipment->payments as $payment)
                        <div class="rounded-md bg-slate-50 p-3 text-sm">
                            <p class="font-semibold">Stage {{ $payment->stage }} - {{ $payment->label }}</p>
                            <p class="text-slate-600">{{ $money($payment->amount) }} - {{ str_replace('_', ' ', $payment->status) }}</p>
                        </div>
                    @empty
                        <p class="text-sm text-slate-500">No deposit records have been created for this shipment.</p>
                    @endforelse
                </div>
                <div class="mt-5 space-y-3">
                    @forelse($shipment->attachments as $attachment)
                        <a href="{{ \Illuminate\Support\Facades\Storage::disk($attachment->disk)->url($attachment->path) }}" class="block rounded-md border border-slate-200 p-3 text-sm font-semibold text-[#0d5368] hover:bg-slate-50" target="_blank">{{ $attachment->original_name }}</a>
                    @empty
                        <p class="text-sm text-slate-500">No shipment attachments uploaded yet.</p>
                    @endforelse
                </div>
            </section>
        </div>

        @if($shipment)
        @include('partials.shipment-live-map')
        @endif
    </x-dashboard-shell>
@endsection