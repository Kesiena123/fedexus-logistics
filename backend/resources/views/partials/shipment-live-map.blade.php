@if($shipment)
{{-- ============================================ --}}
{{-- PROFESSIONAL LIVE SHIPMENT TRACKING MAP     --}}
{{-- Shared partial: guest tracking + admin show --}}
{{-- ============================================ --}}
@php
    $mapStatusLabel = \App\Support\ShipmentStatus::toDisplay($shipment->status);
    $mapStatusCode  = $shipment->status;
    $mapEta         = $shipment->estimated_delivery_at ? $shipment->estimated_delivery_at->format('M j, Y') : null;
    $mapPointSet    = ($mapPoints ?? collect())->isNotEmpty();
@endphp

<div class="tracking-fade-in-delay2 shipment-map-wrapper">
    <div class="shipment-map-container" id="spm-container">
        {{-- Header --}}
        <div class="shipment-map-header">
            <div class="shipment-map-header-left">
                <span class="shipment-map-header-icon">
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20 10c0 6-8 12-8 12s-8-6-8-12a8 8 0 0 1 16 0Z"/><circle cx="12" cy="10" r="3"/></svg>
                </span>
                <div>
                    <h3 class="shipment-map-title">Live Tracking Map</h3>
                    {{-- Fresh: "Live location updated X" / Stale: "Last known location: X" --}}
                    <p class="shipment-map-subtitle" id="spm-live-message">
                        @if($mapPointSet)
                            {{ $mapStatusLabel }} &middot; Last updated: {{ ($shipment->trackingEvents->first())?->occurred_at?->diffForHumans() ?? 'N/A' }}
                        @else
                            Tracking information will update when location data is available.
                        @endif
                    </p>
                </div>
            </div>
            <div class="shipment-map-header-right">
                <span class="shipment-map-live-badge" id="spm-live-badge">
                    <span class="shipment-map-live-dot" id="spm-live-dot"></span>
                    <span id="spm-live-badge-text">LIVE</span>
                </span>
                <span class="shipment-map-refresh-text" id="spm-refresh-text">Auto-refreshing</span>
            </div>
        </div>

        {{-- Map + overlays --}}
        <div class="shipment-map-body">
            {{-- Map canvas (map stretches, overlays stay relative to it) --}}
            <div class="spm-map-canvas">
                <div id="shipment-route-map"></div>

                {{-- Map controls --}}
                <div class="spm-controls" id="spm-controls">
                    <button type="button" class="spm-control-btn" id="spm-zoom-in" title="Zoom in" aria-label="Zoom in">
                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
                    </button>
                    <button type="button" class="spm-control-btn" id="spm-zoom-out" title="Zoom out" aria-label="Zoom out">
                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4"><line x1="5" y1="12" x2="19" y2="12"/></svg>
                    </button>
                    <button type="button" class="spm-control-btn" id="spm-center" title="Center on shipment" aria-label="Center on shipment">
                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="3"/><path d="M12 2v4M12 18v4M2 12h4M18 12h4"/></svg>
                    </button>
                    <button type="button" class="spm-control-btn" id="spm-fit" title="Fit route" aria-label="Fit route">
                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 8V5a2 2 0 0 1 2-2h3M16 3h3a2 2 0 0 1 2 2v3M21 16v3a2 2 0 0 1-2 2h-3M8 21H5a2 2 0 0 1-2-2v-3"/></svg>
                    </button>
                    <button type="button" class="spm-control-btn" id="spm-fullscreen" title="Full screen" aria-label="Toggle full screen">
                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M8 3H5a2 2 0 0 0-2 2v3M21 8V5a2 2 0 0 0-2-2h-3M3 16v3a2 2 0 0 0 2 2h3M16 21h3a2 2 0 0 0 2-2v-3"/></svg>
                    </button>
                </div>

                {{-- Legend --}}
                <div class="spm-legend" id="spm-legend">
                    <span class="spm-legend-item"><span class="spm-legend-dot" style="background:#2563eb"></span>Origin</span>
                    <span class="spm-legend-item"><span class="spm-legend-dot" style="background:#dc2626"></span>Current Location</span>
                    <span class="spm-legend-item"><span class="spm-legend-dot" style="background:#059669"></span>Destination</span>
                    <span class="spm-legend-item"><span class="spm-legend-dot" style="background:#7c3aed"></span>Checkpoint</span>
                </div>

                {{-- Unavailable note (does not block the map) --}}
                <div id="map-unavailable" class="shipment-map-unavailable" style="display: none">
                    <span class="shipment-map-unavailable-icon"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><circle cx="12" cy="10" r="3"/><path d="M12 21.7C17.3 17 20 13 20 10a8 8 0 1 0-16 0c0 3 2.7 6.9 8 11.7z"/></svg></span>
                    <span class="shipment-map-unavailable-text">
                        <span class="shipment-map-unavailable-title">Shipment location is currently unavailable</span>
                        <span class="shipment-map-unavailable-desc">The map will update automatically when a new location is reported.</span>
                    </span>
                </div>
            </div>

            {{-- Information panel (sits beside the map, never covers it) --}}
            <div class="spm-info-panel" id="spm-info-panel">
                <div class="spm-info-head">
                    <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20 10c0 6-8 12-8 12s-8-6-8-12a8 8 0 0 1 16 0Z"/><circle cx="12" cy="10" r="3"/></svg>
                    <span>Shipment Position</span>
                </div>
                <div class="spm-info-rows">
                    <div class="spm-info-row"><span class="spm-info-label">Tracking Number</span><span class="spm-info-value" id="spm-info-tracking">{{ $shipment->tracking_number }}</span></div>
                    <div class="spm-info-row"><span class="spm-info-label">Current Location</span><span class="spm-info-value" id="spm-info-location">&mdash;</span></div>
                    <div class="spm-info-row"><span class="spm-info-label">Status</span><span class="spm-info-value" id="spm-info-status"><span class="spm-status-chip" id="spm-status-chip">{{ $mapStatusLabel }}</span></span></div>
                    <div class="spm-info-row"><span class="spm-info-label">Direction</span><span class="spm-info-value" id="spm-info-direction">&mdash;</span></div>
                    <div class="spm-info-row"><span class="spm-info-label">Last Updated</span><span class="spm-info-value" id="spm-info-updated">&mdash;</span></div>
                    @if($mapEta)
                        <div class="spm-info-row"><span class="spm-info-label">Estimated Delivery</span><span class="spm-info-value" id="spm-info-eta">{{ $mapEta }}</span></div>
                    @endif
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
<script>
(function () {
    function ready(fn) {
        if (document.readyState !== 'loading') { fn(); } else { document.addEventListener('DOMContentLoaded', fn); }
    }
    ready(function () {
        if (!window.L) return;

        var trackingNumber = @json($shipment->tracking_number);
        var initialPoints = (@json($mapPoints) || []);
        var mapSettings = @json($mapSettings);
        var statusCode = @json($mapStatusCode);
        var statusLabel = @json($mapStatusLabel);

        var el = document.getElementById('shipment-route-map');
        var controlsEl = document.getElementById('spm-controls');
        var panelEl = document.getElementById('spm-info-panel');
        var legendEl = document.getElementById('spm-legend');
        var unavailableEl = document.getElementById('map-unavailable');
        if (!el || !window.L) return;

        var map = null;
        var keyMarkers = {};            // origin / current / destination (single each)
        var transitMarkers = [];        // checkpoint markers
        var routeLine = null;
        var arrowMarkers = [];
        var isUserInteracting = false;
        var interactionTimeout = null;
        var didInitialFit = false;
        var currentData = null;

        function $id(name) { return document.getElementById(name); }

        function esc(value) {
            return String(value == null ? '' : value)
                .replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;')
                .replace(/"/g, '&quot;').replace(/'/g, '&#039;');
        }

        function showUnavailable(show) {
            if (!unavailableEl) return;
            unavailableEl.style.display = show ? 'flex' : 'none';
        }

        /* ---------- Marker icons ---------- */
        function pinIcon(type) {
            var colors = { origin: '#2563eb', destination: '#059669' };
            var c = colors[type] || '#2563eb';
            var letter = type === 'origin' ? 'O' : 'D';
            return L.divIcon({
                html: '<div class="spm-pin"><div class="spm-pin-bg" style="background:' + c + '"></div><div class="spm-pin-letter">' + letter + '</div></div>',
                className: 'spm-pin-wrapper',
                iconSize: [32, 36],
                iconAnchor: [16, 34],
                popupAnchor: [0, -30]
            });
        }

        function currentIcon() {
            return L.divIcon({
                html: '<div class="spm-marker-current"><div class="spm-marker-halo"></div><div class="spm-marker-pulse"></div><div class="spm-marker-dot"></div></div>',
                className: 'spm-marker-wrapper',
                iconSize: [42, 42],
                iconAnchor: [21, 21],
                popupAnchor: [0, -24]
            });
        }

        function transitIcon() {
            return L.divIcon({
                html: '<div class="spm-marker-transit"></div>',
                className: 'spm-marker-transit-wrapper',
                iconSize: [14, 14],
                iconAnchor: [7, 7],
                popupAnchor: [0, -10]
            });
        }

        /* ---------- Popups ---------- */
        function popupFor(point) {
            var meta = {
                origin:    { badge: 'Shipment Origin', color: '#2563eb' },
                destination:{ badge: 'Shipment Destination', color: '#059669' },
                current:   { badge: 'Current Shipment Location', color: '#dc2626' },
                transit:   { badge: 'Checkpoint', color: '#7c3aed' }
            };
            var m = meta[point.type] || meta.transit;
            var html = '<div class="spm-popup">';
            html += '<div class="spm-popup-badge" style="background:' + m.color + '">' + m.badge + '</div>';
            html += '<div class="spm-popup-title">' + esc(point.location || point.label || 'Checkpoint') + '</div>';
            if (point.type === 'current') {
                html += '<div class="spm-popup-row"><span class="spm-popup-k">Tracking:</span><span>' + esc(trackingNumber) + '</span></div>';
                if (statusLabel) html += '<div class="spm-popup-row"><span class="spm-popup-k">Status:</span><span>' + esc(statusLabel) + '</span></div>';
                if (point.updated_human) html += '<div class="spm-popup-row"><span class="spm-popup-k">Last Updated:</span><span>' + esc(point.updated_human) + '</span></div>';
            }
            if (point.latitude != null && point.longitude != null) {
                html += '<div class="spm-popup-coords">' + Number(point.latitude).toFixed(4) + ', ' + Number(point.longitude).toFixed(4) + '</div>';
            }
            html += '</div>';
            return html;
        }

        function attachPopup(marker, point) {
            marker.bindPopup(popupFor(point), { maxWidth: 260, className: 'spm-popup-wrapper' });
        }

        /* ---------- Route ---------- */
        function buildRouteLatLngs(points) {
            var origin = null, current = null, destination = null, transit = [];
            (points || []).forEach(function (p) {
                if (p.type === 'origin') origin = p;
                else if (p.type === 'destination') destination = p;
                else if (p.type === 'current') current = p;
                else transit.push(p);
            });
            var ordered = [];
            if (origin) ordered.push(origin);
            ordered = ordered.concat(transit);
            if (current) ordered.push(current);
            if (destination) ordered.push(destination);

            var latLngs = [];
            var seen = {};
            ordered.forEach(function (p) {
                if (p.latitude == null || p.longitude == null || isNaN(p.latitude) || isNaN(p.longitude)) return;
                var key = p.latitude.toFixed(5) + '|' + p.longitude.toFixed(5);
                if (seen[key]) return;
                seen[key] = true;
                latLngs.push([p.latitude, p.longitude]);
            });
            return latLngs;
        }

        function drawArrows(latLngs) {
            arrowMarkers.forEach(function (m) { map.removeLayer(m); });
            arrowMarkers = [];
            for (var i = 0; i < latLngs.length - 1; i++) {
                var midLat = (latLngs[i][0] + latLngs[i + 1][0]) / 2;
                var midLng = (latLngs[i][1] + latLngs[i + 1][1]) / 2;
                var angle = Math.atan2(latLngs[i + 1][1] - latLngs[i][1], latLngs[i + 1][0] - latLngs[i][0]) * 180 / Math.PI;
                var icon = L.divIcon({
                    html: '<div class="spm-arrow" style="transform:rotate(' + (-angle + 90) + 'deg)">&#9650;</div>',
                    className: 'spm-arrow-wrapper', iconSize: [16, 16], iconAnchor: [8, 8]
                });
                arrowMarkers.push(L.marker([midLat, midLng], { icon: icon, interactive: false }).addTo(map));
            }
        }

        function drawRoute(points) {
            var latLngs = buildRouteLatLngs(points);
            if (!routeLine) {
                routeLine = L.polyline(latLngs, {
                    color: '#1e40af', weight: 4, opacity: 0.8, dashArray: '10, 8', lineCap: 'round', lineJoin: 'round'
                }).addTo(map);
            } else {
                routeLine.setLatLngs(latLngs);
                routeLine.redraw();
            }
            drawArrows(latLngs);
            return latLngs;
        }

        function boundsOf(latLngs) {
            if (!latLngs.length) return null;
            return L.latLngBounds(latLngs);
        }

        /* ---------- Marker sync (in place, no full redraw) ---------- */
        function syncMarkers(points) {
            (points || []).forEach(function (point) {
                if (point.latitude == null || point.longitude == null || isNaN(point.latitude) || isNaN(point.longitude)) return;
                var latlng = L.latLng(point.latitude, point.longitude);
                if (point.type === 'current' || point.type === 'origin' || point.type === 'destination') {
                    var existing = keyMarkers[point.type];
                    if (existing) {
                        if (!existing.getLatLng().equals(latlng)) {
                            animateMarker(existing, latlng);
                        }
                        attachPopup(existing, point);
                    } else {
                        var icon = point.type === 'current' ? currentIcon() : pinIcon(point.type);
                        var marker = L.marker(latlng, { icon: icon, title: point.location || point.label }).addTo(map);
                        keyMarkers[point.type] = marker;
                        attachPopup(marker, point);
                    }
                }
            });

            // reconcile transit markers (rarely change)
            var tLatLngs = (points || []).filter(function (p) { return p.type === 'transit'; });
            var newMarkers = [];
            tLatLngs.forEach(function (point) {
                var marker = L.marker([point.latitude, point.longitude], { icon: transitIcon(), interactive: true }).addTo(map);
                attachPopup(marker, point);
                newMarkers.push(marker);
            });
            transitMarkers.forEach(function (m) { map.removeLayer(m); });
            transitMarkers = newMarkers;
        }

        function animateMarker(marker, toLatLng) {
            var from = marker.getLatLng();
            var steps = 20, i = 0;
            (function step() {
                i++;
                var t = i / steps;
                marker.setLatLng([from.lat + (toLatLng.lat - from.lat) * t, from.lng + (toLatLng.lng - from.lng) * t]);
                if (i < steps) requestAnimationFrame(step);
            })();
        }

        /* ---------- Direction ---------- */
        function compassDirection(lat1, lng1, lat2, lng2) {
            var toRad = Math.PI / 180;
            var f1 = lat1 * toRad, f2 = lat2 * toRad;
            var dl = (lng2 - lng1) * toRad;
            var y = Math.sin(dl) * Math.cos(f2);
            var x = Math.cos(f1) * Math.sin(f2) - Math.sin(f1) * Math.cos(f2) * Math.cos(dl);
            var brng = (Math.atan2(y, x) * 180 / Math.PI + 360) % 360;
            var names = ['N', 'NNE', 'NE', 'ENE', 'E', 'ESE', 'SE', 'SSE', 'S', 'SSW', 'SW', 'WSW', 'W', 'WNW', 'NW', 'NNW'];
            return names[Math.round(brng / 22.5) % 16];
        }

        function statusChipClass(code) {
            if (!code) return 'azure';
            if (code === 'delivered') return 'emerald';
            if (code === 'cancelled' || code === 'rejected') return 'red';
            if (code === 'paused') return 'amber';
            return 'azure';
        }

        function setStatusChip(label) {
            var chip = $id('spm-status-chip');
            if (!chip) return;
            chip.textContent = label;
            chip.className = 'spm-status-chip spm-chip-' + statusChipClass(currentData && currentData.status_code ? currentData.status_code : statusCode);
        }

        /* ---------- Panel / header updates ---------- */
        function updateInfo(data) {
            currentData = data;
            var loc = $id('spm-info-location');
            if (loc) loc.textContent = (data.current && data.current.location) ? data.current.location : '—';

            if (data.status) setStatusChip(data.status);
            else setStatusChip(statusLabel);

            var dirEl = $id('spm-info-direction');
            if (dirEl) {
                var cur = data.current, dest = data.destination;
                if (cur && dest) {
                    dirEl.textContent = 'Heading ' + compassDirection(cur.latitude, cur.longitude, dest.latitude, dest.longitude);
                } else {
                    dirEl.textContent = '—';
                }
            }

            var upd = $id('spm-info-updated');
            if (upd) upd.textContent = (data.current && data.current.updated_human) ? data.current.updated_human : '—';

            var msg = $id('spm-live-message');
            var badge = $id('spm-live-badge');
            var badgeText = $id('spm-live-badge-text');
            var dot = $id('spm-live-dot');
            var refresh = $id('spm-refresh-text');

            if (data.current) {
                if (data.current.stale) {
                    if (msg) msg.textContent = 'Last known location: ' + (data.current.updated_human || 'N/A') + ' — location may be outdated.';
                    if (badge) { badge.classList.add('spm-stale'); badgeText.textContent = 'STALE'; }
                    if (dot) dot.style.animation = 'none';
                } else {
                    if (msg) msg.textContent = (data.status || statusLabel) + ' · Live location updated ' + (data.current.updated_human || 'just now');
                    if (badge) { badge.classList.remove('spm-stale'); badgeText.textContent = 'LIVE'; }
                    if (dot) dot.style.animation = '';
                }
                if (refresh && data.current.updated_human) refresh.textContent = 'Updated ' + data.current.updated_human;
            } else {
                if (msg && data.status) msg.textContent = data.status + ' · Last updated: ' + (data.last_updated || 'N/A');
            }
        }

        /* ---------- Apply points to map ---------- */
        function renderPoints(points) {
            if (!map) return false;
            if (!points || !points.length) {
                showUnavailable(true);
                return false;
            }
            showUnavailable(false);
            syncMarkers(points);
            var latLngs = drawRoute(points);
            return { bounds: boundsOf(latLngs), count: latLngs.length };
        }

        function fitToRoute(animate) {
            if (!map) return;
            var latLngs = routeLine ? routeLine.getLatLngs() : [];
            if (!latLngs.length) return;
            var bounds = L.latLngBounds(latLngs);
            if (bounds.isValid()) {
                map.fitBounds(bounds, { padding: [44, 44], animate: !!animate, maxZoom: 13 });
            }
        }

        function centerOnShipment(animate) {
            if (!map || !currentData || !currentData.current) return;
            var cur = currentData.current;
            map.flyTo([cur.latitude, cur.longitude], Math.max(map.getZoom(), 11), { animate: !!animate, duration: 0.7 });
        }

        /* ---------- Map init ---------- */
        function initMap(points) {
            if (map || !el) return;
            showUnavailable(false);

            map = L.map(el, {
                center: [mapSettings.defaultLatitude, mapSettings.defaultLongitude],
                zoom: mapSettings.zoom,
                zoomControl: false,
                scrollWheelZoom: true
            });

            L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png', {
                maxZoom: 19,
                attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
            }).addTo(map);

            if (points && points.length) {
                var result = renderPoints(points);
                if (result && result.count) {
                    fitToRoute(false);
                    didInitialFit = true;
                }
            }

            map.on('mousedown', function () { isUserInteracting = true; clearTimeout(interactionTimeout); });
            map.on('mouseup', function () { interactionTimeout = setTimeout(function () { isUserInteracting = false; }, 5000); });
            map.on('zoomstart', function () { isUserInteracting = true; clearTimeout(interactionTimeout); });
            map.on('zoomend', function () { interactionTimeout = setTimeout(function () { isUserInteracting = false; }, 5000); });
            map.on('touchstart', function () { isUserInteracting = true; clearTimeout(interactionTimeout); });
        }

        function setFullscreen(on) {
            var container = el.closest('.shipment-map-container');
            if (!container) return;
            container.classList.toggle('spm-fullscreen', on);
            setTimeout(function () { if (map) map.invalidateSize(); }, 60);
        }

        /* ---------- Controls ---------- */
        function bindControls() {
            var zi = $id('spm-zoom-in'), zo = $id('spm-zoom-out'), cen = $id('spm-center'), fit = $id('spm-fit'), fs = $id('spm-fullscreen');
            if (zi) zi.addEventListener('click', function () { if (map) map.zoomIn(); });
            if (zo) zo.addEventListener('click', function () { if (map) map.zoomOut(); });
            if (cen) cen.addEventListener('click', function () { centerOnShipment(true); });
            if (fit) fit.addEventListener('click', function () { fitToRoute(true); });
            if (fs) fs.addEventListener('click', function () {
                var on = !el.closest('.shipment-map-container').classList.contains('spm-fullscreen');
                setFullscreen(on);
            });
            document.addEventListener('keydown', function (e) {
                if (e.key === 'Escape' && el.closest('.shipment-map-container').classList.contains('spm-fullscreen')) {
                    setFullscreen(false);
                }
            });
        }

        /* ---------- Polling ---------- */
        function pollTrackingData() {
            fetch('/tracking/' + encodeURIComponent(trackingNumber) + '/location')
                .then(function (r) { return r.json(); })
                .then(function (data) {
                    if (!data || data.error) return;
                    if (data.points && data.points.length) {
                        var result = renderPoints(data.points);
                        if (result && result.count && didInitialFit && !isUserInteracting) {
                            // auto-fit only when bounds meaningfully change
                            var latLngs = routeLine ? routeLine.getLatLngs() : [];
                            var bounds = boundsOf(latLngs);
                            if (bounds && !map.getBounds().pad(-0.42).contains(bounds.getCenter())) {
                                fitToRoute(true);
                            }
                        }
                    }
                    updateInfo(data);
                })
                .catch(function () {});
        }

        bindControls();
        initMap(initialPoints);
        updateInfo({ status: statusLabel, status_code: statusCode, current: null });
        if (!initialPoints.length) showUnavailable(true);
        pollTrackingData();
        setInterval(pollTrackingData, 10000);

        var resizeTimer;
        window.addEventListener('resize', function () {
            clearTimeout(resizeTimer);
            resizeTimer = setTimeout(function () { if (map) map.invalidateSize(); }, 200);
        });
    });
})();
</script>
@endif