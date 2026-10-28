<?php

$dbUrl = parse_url(env('DATABASE_URL') ?? '');

return [
    'default' => env('DB_CONNECTION', $dbUrl ? 'pgsql' : 'mysql'),
    'connections' => [
        'mysql' => [
            'driver' => 'mysql',
            'host' => env('DB_HOST', '127.0.0.1'),
            'port' => env('DB_PORT', '3306'),
            'database' => env('DB_DATABASE', 'freightflow'),
            'username' => env('DB_USERNAME', 'root'),
            'password' => env('DB_PASSWORD', ''),
            'charset' => 'utf8mb4',
            'collation' => 'utf8mb4_unicode_ci',
            'prefix' => '',
            'strict' => true,
            'options' => extension_loaded('pdo_mysql') && env('MYSQL_ATTR_SSL_CA') ? [
                PDO::MYSQL_ATTR_SSL_CA => base_path(env('MYSQL_ATTR_SSL_CA')),
            ] : [],
        ],
        'pgsql' => [
            'driver' => 'pgsql',
            'host' => $dbUrl['host'] ?? env('DB_HOST', '127.0.0.1'),
            'port' => $dbUrl['port'] ?? env('DB_PORT', '5432'),
            'database' => ltrim($dbUrl['path'] ?? '', '/') ?: env('DB_DATABASE', 'freightflow'),
            'username' => $dbUrl['user'] ?? env('DB_USERNAME', 'root'),
            'password' => $dbUrl['pass'] ?? env('DB_PASSWORD', ''),
            'charset' => 'utf8',
            'prefix' => '',
        ],
    ],
    'redis' => [
        'client' => env('REDIS_CLIENT', 'phpredis'),
        'default' => ['host' => env('REDIS_HOST', '127.0.0.1'), 'password' => env('REDIS_PASSWORD'), 'port' => env('REDIS_PORT', 6379), 'database' => 0],
        'cache' => ['host' => env('REDIS_HOST', '127.0.0.1'), 'password' => env('REDIS_PASSWORD'), 'port' => env('REDIS_PORT', 6379), 'database' => 1],
    ],
];
