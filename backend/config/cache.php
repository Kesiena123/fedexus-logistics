<?php

$cacheStore = env('CACHE_STORE', 'array');

if ($cacheStore === 'redis' && ! class_exists(Redis::class)) {
    $cacheStore = 'array';
}

return [
    'default' => $cacheStore,
    'stores' => [
        'array' => ['driver' => 'array'],
        'file' => ['driver' => 'file', 'path' => storage_path('framework/cache/data')],
        'redis' => ['driver' => 'redis', 'connection' => 'cache'],
    ],
];
