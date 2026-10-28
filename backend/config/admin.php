<?php

return [
    'session_timeout_minutes' => (int) env('ADMIN_SESSION_TIMEOUT_MINUTES', 30),
    'login_max_attempts' => (int) env('ADMIN_LOGIN_MAX_ATTEMPTS', 5),
    'login_decay_seconds' => (int) env('ADMIN_LOGIN_DECAY_SECONDS', 900),
    'captcha_ttl_seconds' => (int) env('ADMIN_CAPTCHA_TTL_SECONDS', 300),
    'ip_allowlist' => array_values(array_filter(array_map('trim', explode(',', (string) env('ADMIN_IP_ALLOWLIST', ''))))),
    'ip_blocklist' => array_values(array_filter(array_map('trim', explode(',', (string) env('ADMIN_IP_BLOCKLIST', ''))))),
    'trusted_device_window_days' => (int) env('ADMIN_TRUSTED_DEVICE_WINDOW_DAYS', 30),
];
