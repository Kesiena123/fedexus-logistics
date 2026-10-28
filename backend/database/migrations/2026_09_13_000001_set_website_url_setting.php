<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    public function up(): void
    {
        DB::table('admin_settings')->updateOrInsert(
            ['key' => 'website_url'],
            [
                'value' => 'https://fedexus.com.ng',
                'type' => 'url',
                'group' => 'app',
                'label' => 'Website URL',
                'created_at' => now(),
                'updated_at' => now(),
            ]
        );
    }

    public function down(): void
    {
        // Intentionally left empty: the setting value is business data.
    }
};