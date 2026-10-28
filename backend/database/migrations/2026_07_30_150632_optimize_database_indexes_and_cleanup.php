<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;

return new class extends Migration
{
    public function up(): void
    {
        $this->addIndexIfMissing('email_logs', 'email_logs_sender_id_idx', ['sender_id']);
        $this->addIndexIfMissing('email_logs', 'email_logs_recipient_user_id_idx', ['recipient_user_id']);
        $this->addIndexIfMissing('notification_preferences', 'notification_preferences_user_id_idx', ['user_id']);
        $this->addIndexIfMissing('payment_audit_logs', 'payment_audit_logs_admin_user_id_idx', ['admin_user_id']);
        $this->addIndexIfMissing('payment_proofs', 'payment_proofs_payment_request_id_idx', ['payment_request_id']);
        $this->addIndexIfMissing('payment_proofs', 'payment_proofs_payment_transaction_id_idx', ['payment_transaction_id']);
        $this->addIndexIfMissing('payment_proofs', 'payment_proofs_verified_by_idx', ['verified_by']);
        $this->addIndexIfMissing('payment_requests', 'payment_requests_shipment_id_idx', ['shipment_id']);
        $this->addIndexIfMissing('payment_requests', 'payment_requests_created_by_idx', ['created_by']);
        $this->addIndexIfMissing('payment_requests', 'payment_requests_verified_by_idx', ['verified_by']);
        $this->addIndexIfMissing('payment_transactions', 'payment_transactions_payment_request_id_idx', ['payment_request_id']);
        $this->addIndexIfMissing('payments', 'payments_verified_by_idx', ['verified_by']);
        $this->addIndexIfMissing('payments', 'payments_shipment_id_stage_idx', ['shipment_id', 'stage']);
        $this->addIndexIfMissing('shipment_attachments', 'shipment_attachments_uploaded_by_idx', ['uploaded_by']);
        $this->addIndexIfMissing('shipments', 'shipments_driver_id_idx', ['driver_id']);
        $this->addIndexIfMissing('shipments', 'shipments_warehouse_id_idx', ['warehouse_id']);
        $this->addIndexIfMissing('tracking_events', 'tracking_events_shipment_id_idx', ['shipment_id']);
        $this->addIndexIfMissing('tracking_events', 'tracking_events_created_by_idx', ['created_by']);
    }

    public function down(): void
    {
        $tables = [
            'email_logs', 'notification_preferences', 'payment_audit_logs',
            'payment_proofs', 'payment_requests', 'payment_transactions',
            'payments', 'shipment_attachments', 'shipments', 'tracking_events',
        ];
        foreach ($tables as $table) {
            if (! Schema::hasTable($table)) continue;
            Schema::table($table, function (Blueprint $table) {
                $indexes = [
                    'email_logs_sender_id_idx', 'email_logs_recipient_user_id_idx',
                    'notification_preferences_user_id_idx',
                    'payment_audit_logs_admin_user_id_idx',
                    'payment_proofs_payment_request_id_idx',
                    'payment_proofs_payment_transaction_id_idx',
                    'payment_proofs_verified_by_idx',
                    'payment_requests_shipment_id_idx', 'payment_requests_created_by_idx',
                    'payment_requests_verified_by_idx',
                    'payment_transactions_payment_request_id_idx',
                    'payments_verified_by_idx', 'payments_shipment_id_stage_idx',
                    'shipment_attachments_uploaded_by_idx',
                    'shipments_driver_id_idx', 'shipments_warehouse_id_idx',
                    'tracking_events_shipment_id_idx', 'tracking_events_created_by_idx',
                ];
                foreach ($indexes as $name) {
                    try { $table->dropIndex($name); } catch (\Exception $e) {}
                }
            });
        }
    }

    private function addIndexIfMissing(string $table, string $name, array $columns): void
    {
        if (! Schema::hasTable($table)) return;
        try {
            Schema::table($table, function (Blueprint $table) use ($columns, $name) {
                $table->index($columns, $name);
            });
        } catch (\Exception $e) {}
    }
};
