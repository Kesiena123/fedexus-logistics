<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    public function up(): void
    {
        DB::table('admin_settings')->updateOrInsert(
            ['key' => 'company_email'],
            [
                'value' => 'admin@fedexus.com',
                'type' => 'email',
                'group' => 'app',
                'label' => 'Company Email',
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