<?php

$queueConnection = env('QUEUE_CONNECTION', 'sync');

if ($queueConnection === 'redis' && ! class_exists(Redis::class)) {
    $queueConnection = 'sync';
}

return [
    'default' => $queueConnection,
    'connections' => [
        'sync' => ['driver' => 'sync'],
        'redis' => ['driver' => 'redis', 'connection' => 'default', 'queue' => env('REDIS_QUEUE', 'default'), 'retry_after' => 90],
    ],
];
