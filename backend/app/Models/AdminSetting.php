<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class AdminSetting extends Model
{
    protected $fillable = [
        'key',
        'value',
        'type',
        'group',
        'label',
        'description',
        'options',
        'sort_order',
    ];

    protected $casts = [
        'options' => 'array',
    ];

    public static function grouped(): array
    {
        return self::orderBy('sort_order')->get()->groupBy('group')->toArray();
    }

    protected static array $settingsCache;

    public static function value(string $key, mixed $default = null): mixed
    {
        if (! isset(self::$settingsCache)) {
            self::$settingsCache = self::orderBy('sort_order')->get()->keyBy('key')->all();
        }

        $setting = self::$settingsCache[$key] ?? null;
        if (! $setting) {
            return $default;
        }

        $value = $setting->value;

        return match ($setting->type) {
            'boolean' => filter_var($value, FILTER_VALIDATE_BOOLEAN),
            'integer' => (int) $value,
            'json' => json_decode($value, true),
            default => $value,
        };
    }
}
