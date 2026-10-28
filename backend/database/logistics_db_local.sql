
/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
DROP TABLE IF EXISTS `admin_audit_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `admin_audit_logs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `admin_user_id` bigint(20) unsigned NOT NULL,
  `action` varchar(255) NOT NULL,
  `target_type` varchar(255) DEFAULT NULL,
  `target_id` varchar(255) DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `device_name` varchar(255) DEFAULT NULL,
  `device_fingerprint` varchar(128) DEFAULT NULL,
  `reason` text DEFAULT NULL,
  `previous_values` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`previous_values`)),
  `new_values` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`new_values`)),
  `metadata` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`metadata`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `admin_audit_logs_admin_user_id_foreign` (`admin_user_id`),
  KEY `admin_audit_logs_action_index` (`action`),
  KEY `admin_audit_logs_target_type_index` (`target_type`),
  KEY `admin_audit_logs_target_id_index` (`target_id`),
  KEY `admin_audit_logs_ip_address_index` (`ip_address`),
  KEY `admin_audit_logs_device_fingerprint_index` (`device_fingerprint`),
  CONSTRAINT `admin_audit_logs_admin_user_id_foreign` FOREIGN KEY (`admin_user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=202 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `admin_audit_logs` WRITE;
/*!40000 ALTER TABLE `admin_audit_logs` DISABLE KEYS */;
INSERT INTO `admin_audit_logs` VALUES (1,1,'admin.login','user','1','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-30 10:37:55','2026-07-30 10:37:55'),(2,1,'payment_request.created','payment_request','4','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,'{\"shipment_id\":\"1\",\"title\":\"rtt\",\"amount\":\"1000.00\",\"currency\":\"USD\",\"requested_method\":\"bank_transfer\"}',NULL,'2026-07-30 10:40:10','2026-07-30 10:40:10'),(3,1,'shipment.deleted','shipment','1','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36',NULL,NULL,NULL,'{\"id\":1,\"user_id\":3,\"driver_id\":null,\"warehouse_id\":null,\"tracking_number\":\"FDX-2026-8K3P91QZ\",\"status\":\"international_processing\",\"service_level\":\"international_priority\",\"sender_name\":\"Maya Carter\",\"recipient_name\":\"Lena Morgan\",\"origin_address\":{\"city\":\"Nashville\",\"country\":\"US\",\"postal_code\":\"37201\"},\"destination_address\":{\"city\":\"London\",\"country\":\"GB\",\"postal_code\":\"SW1A 1AA\"},\"weight_kg\":\"8.50\",\"declared_value\":\"450.00\",\"quoted_amount\":\"142.75\",\"estimated_delivery_at\":\"2026-08-02T22:13:26.000000Z\",\"delivered_at\":null,\"metadata\":null,\"created_at\":\"2026-07-29T22:13:26.000000Z\",\"updated_at\":\"2026-07-29T22:13:26.000000Z\"}',NULL,NULL,'2026-07-30 10:47:39','2026-07-30 10:47:39'),(4,1,'shipment.updated','shipment','2','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36',NULL,NULL,NULL,'{\"id\":2,\"user_id\":1,\"driver_id\":null,\"warehouse_id\":null,\"tracking_number\":\"GEX-2026-4Z2AMEVJ\",\"status\":\"booked\",\"service_level\":\"domestic_express\",\"sender_name\":\"Olga Rodriguez\",\"recipient_name\":\"Liam Moore\",\"origin_address\":{\"street\":\"147 Birch Way\",\"city\":\"Manchester\",\"state\":\"England\",\"postal_code\":\"M1 1AE\",\"country\":\"United Kingdom (GB)\",\"email\":\"olga.rodriguez@yahoo.com\",\"phone\":\"+1-641-442-4272\",\"company\":\"Horizon Supply\"},\"destination_address\":{\"street\":\"123 Main St\",\"city\":\"Nairobi\",\"state\":\"Nairobi\",\"postal_code\":\"00100\",\"country\":\"Kenya (KE)\",\"email\":\"liam.moore@outlook.com\",\"phone\":\"+1-393-362-5478\",\"company\":\"Evergreen Corp\",\"latitude\":-1.3015643,\"longitude\":36.8128437},\"weight_kg\":\"35.60\",\"declared_value\":\"274.07\",\"quoted_amount\":\"274.07\",\"estimated_delivery_at\":\"2026-08-16T00:00:00.000000Z\",\"delivered_at\":null,\"metadata\":{\"workflow\":{\"service_level\":\"domestic_express\",\"shipment_type\":\"express\",\"shipping_method\":\"ground\",\"priority\":\"high\"},\"costs\":{\"shipping_cost\":245.08,\"handling_fee\":8.01,\"insurance_fee\":9.05,\"customs_fee\":6.98,\"tax\":4.95,\"discount\":0,\"additional_charges\":0,\"total_cost\":274.07,\"currency\":\"USD\"},\"package\":{\"type\":\"Parcel\",\"weight_kg\":8.9,\"length_cm\":16,\"width_cm\":58,\"height_cm\":19,\"quantity\":4,\"description\":\"Test parcel contents - auto-generated for testing\"},\"payment\":{\"method\":\"invoice\",\"status\":\"pending\"}},\"created_at\":\"2026-07-30T06:48:21.000000Z\",\"updated_at\":\"2026-07-30T06:48:21.000000Z\"}','{\"id\":2,\"user_id\":1,\"driver_id\":null,\"warehouse_id\":null,\"tracking_number\":\"GEX-2026-4Z2AMEVJ\",\"status\":\"booked\",\"service_level\":\"domestic_express\",\"sender_name\":\"Olga Rodriguez\",\"recipient_name\":\"Liam Moore\",\"origin_address\":{\"address\":\"\",\"city\":\"Manchester\",\"state\":\"England\",\"country\":\"United Kingdom (GB)\",\"postal_code\":\"M1 1AE\"},\"destination_address\":{\"address\":\"\",\"city\":\"Nairobi\",\"state\":\"Nairobi\",\"country\":\"Kenya (KE)\",\"postal_code\":\"00100\",\"latitude\":\"-1.3015643\",\"longitude\":\"36.8128437\"},\"weight_kg\":\"35.60\",\"declared_value\":\"274.07\",\"quoted_amount\":\"274.07\",\"estimated_delivery_at\":\"2026-08-16T00:00:00.000000Z\",\"delivered_at\":null,\"metadata\":{\"workflow\":{\"service_level\":\"domestic_express\",\"shipment_type\":\"express\",\"shipping_method\":\"ground\",\"priority\":\"high\"},\"costs\":{\"shipping_cost\":245.08,\"handling_fee\":8.01,\"insurance_fee\":9.05,\"customs_fee\":6.98,\"tax\":4.95,\"discount\":0,\"additional_charges\":0,\"total_cost\":274.07,\"currency\":\"USD\"},\"package\":{\"type\":\"Parcel\",\"weight_kg\":8.9,\"length_cm\":16,\"width_cm\":58,\"height_cm\":19,\"quantity\":4,\"description\":\"Test parcel contents - auto-generated for testing\"},\"payment\":{\"method\":\"invoice\",\"status\":\"pending\"},\"sender\":{\"company\":\"FedExUS\",\"phone\":\"09034556432\",\"email\":\"rodriguez@gmail.com\"},\"receiver\":{\"company\":\"\",\"phone\":\"08775044232\",\"email\":\"liam@gmail.com\"},\"description\":\"\",\"priority\":\"\",\"cost\":{\"shipping_cost\":274.07,\"handling_fee\":0,\"insurance\":0,\"customs_fee\":0,\"tax\":0,\"discount\":0,\"additional_charges\":0},\"packages\":[{\"package_type\":\"flower\",\"weight_kg\":\"35.60\",\"length_cm\":0,\"width_cm\":0,\"height_cm\":0,\"quantity\":1,\"description\":\"\"}]},\"created_at\":\"2026-07-30T06:48:21.000000Z\",\"updated_at\":\"2026-07-30T06:50:33.000000Z\"}',NULL,'2026-07-30 10:50:33','2026-07-30 10:50:33'),(5,1,'payment.status.updated','payment','7','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36',NULL,NULL,NULL,'{\"status\":\"locked\",\"verified_at\":null,\"verified_by\":null}','{\"status\":\"verified\",\"verified_at\":\"2026-07-30T06:51:55.000000Z\",\"verified_by\":1}',NULL,'2026-07-30 10:51:55','2026-07-30 10:51:55'),(6,1,'admin.login','user','1','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-30 11:02:15','2026-07-30 11:02:15'),(7,1,'payment_request.created','payment_request','7','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,'{\"id\":7,\"shipment_id\":2,\"title\":\"Customs fees clearance\",\"category\":\"Custom\",\"priority\":\"normal\",\"reason\":\"Customs fees clearance need to be paid\",\"description\":null,\"amount\":\"2000.00\",\"currency\":\"USD\",\"requested_method\":\"bank_transfer\",\"status\":\"draft\",\"is_active\":true,\"is_archived\":false,\"secure_token\":\"TdRDmf60RXgDASOkBoJrpRjd0IN2N7QQyhIuSHEs7lLxmMY8S8CuzSQbTNgMdwUm\",\"due_at\":null,\"paid_at\":null,\"verified_at\":null,\"created_by\":1,\"verified_by\":null,\"metadata\":{\"allowed_methods\":[\"bank_transfer\"]},\"internal_notes\":null,\"payment_instructions\":null,\"payment_reference\":null,\"duplicated_from_id\":null,\"created_at\":\"2026-07-30T07:11:26.000000Z\",\"updated_at\":\"2026-07-30T07:11:26.000000Z\"}',NULL,'2026-07-30 11:11:27','2026-07-30 11:11:27'),(8,1,'payment_request.updated','payment_request','7','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36',NULL,NULL,NULL,'{\"id\":7,\"shipment_id\":2,\"title\":\"Customs fees clearance\",\"category\":\"Custom\",\"priority\":\"normal\",\"reason\":\"Customs fees clearance need to be paid\",\"description\":null,\"amount\":\"2000.00\",\"currency\":\"USD\",\"requested_method\":\"bank_transfer\",\"status\":\"draft\",\"is_active\":true,\"is_archived\":false,\"secure_token\":\"TdRDmf60RXgDASOkBoJrpRjd0IN2N7QQyhIuSHEs7lLxmMY8S8CuzSQbTNgMdwUm\",\"due_at\":null,\"paid_at\":null,\"verified_at\":null,\"created_by\":1,\"verified_by\":null,\"metadata\":{\"allowed_methods\":[\"bank_transfer\"]},\"internal_notes\":null,\"payment_instructions\":null,\"payment_reference\":null,\"duplicated_from_id\":null,\"created_at\":\"2026-07-30T07:11:26.000000Z\",\"updated_at\":\"2026-07-30T07:11:26.000000Z\"}','{\"id\":7,\"shipment_id\":2,\"title\":\"Customs fees clearance\",\"category\":\"Custom\",\"priority\":\"normal\",\"reason\":\"Customs fees clearance need to be paid\",\"description\":null,\"amount\":\"2000.00\",\"currency\":\"USD\",\"requested_method\":\"bank_transfer\",\"status\":\"draft\",\"is_active\":true,\"is_archived\":false,\"secure_token\":\"TdRDmf60RXgDASOkBoJrpRjd0IN2N7QQyhIuSHEs7lLxmMY8S8CuzSQbTNgMdwUm\",\"due_at\":null,\"paid_at\":null,\"verified_at\":null,\"created_by\":1,\"verified_by\":null,\"metadata\":{\"allowed_methods\":[\"bank_transfer\"]},\"internal_notes\":null,\"payment_instructions\":null,\"payment_reference\":null,\"duplicated_from_id\":null,\"created_at\":\"2026-07-30T07:11:26.000000Z\",\"updated_at\":\"2026-07-30T07:11:26.000000Z\"}',NULL,'2026-07-30 11:14:42','2026-07-30 11:14:42'),(9,1,'payment_request.created','payment_request','9','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,'{\"id\":9,\"shipment_id\":2,\"title\":\"shimpment fees\",\"category\":\"shipment\",\"priority\":\"normal\",\"reason\":\"shipment fees need to be paid\",\"description\":null,\"amount\":\"1500.00\",\"currency\":\"USD\",\"requested_method\":\"bank_transfer\",\"status\":\"draft\",\"is_active\":true,\"is_archived\":false,\"secure_token\":\"1zalRo3Hx5HUKNiAtvwLh7C7CCq1wxoKgw0N2B5krPgd17jSbBge6zifa0LJcSd1\",\"due_at\":null,\"paid_at\":null,\"verified_at\":null,\"created_by\":1,\"verified_by\":null,\"metadata\":{\"allowed_methods\":[\"bank_transfer\"]},\"internal_notes\":null,\"payment_instructions\":null,\"payment_reference\":null,\"duplicated_from_id\":null,\"created_at\":\"2026-07-30T07:18:57.000000Z\",\"updated_at\":\"2026-07-30T07:18:57.000000Z\"}',NULL,'2026-07-30 11:18:57','2026-07-30 11:18:57'),(10,1,'payment_request.updated','payment_request','9','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36',NULL,NULL,NULL,'{\"id\":9,\"shipment_id\":2,\"title\":\"shimpment fees\",\"category\":\"shipment\",\"priority\":\"normal\",\"reason\":\"shipment fees need to be paid\",\"description\":null,\"amount\":\"1500.00\",\"currency\":\"USD\",\"requested_method\":\"bank_transfer\",\"status\":\"draft\",\"is_active\":true,\"is_archived\":false,\"secure_token\":\"1zalRo3Hx5HUKNiAtvwLh7C7CCq1wxoKgw0N2B5krPgd17jSbBge6zifa0LJcSd1\",\"due_at\":null,\"paid_at\":null,\"verified_at\":null,\"created_by\":1,\"verified_by\":null,\"metadata\":{\"allowed_methods\":[\"bank_transfer\"]},\"internal_notes\":null,\"payment_instructions\":null,\"payment_reference\":null,\"duplicated_from_id\":null,\"created_at\":\"2026-07-30T07:18:57.000000Z\",\"updated_at\":\"2026-07-30T07:18:57.000000Z\"}','{\"id\":9,\"shipment_id\":2,\"title\":\"shimpment fees\",\"category\":\"shipment\",\"priority\":\"normal\",\"reason\":\"shipment fees need to be paid\",\"description\":null,\"amount\":\"1500.00\",\"currency\":\"USD\",\"requested_method\":\"bank_transfer\",\"status\":\"payment_required\",\"is_active\":true,\"is_archived\":false,\"secure_token\":\"1zalRo3Hx5HUKNiAtvwLh7C7CCq1wxoKgw0N2B5krPgd17jSbBge6zifa0LJcSd1\",\"due_at\":null,\"paid_at\":null,\"verified_at\":null,\"created_by\":1,\"verified_by\":null,\"metadata\":{\"allowed_methods\":[\"bank_transfer\"]},\"internal_notes\":null,\"payment_instructions\":null,\"payment_reference\":null,\"duplicated_from_id\":null,\"created_at\":\"2026-07-30T07:18:57.000000Z\",\"updated_at\":\"2026-07-30T07:26:46.000000Z\"}',NULL,'2026-07-30 11:26:46','2026-07-30 11:26:46'),(11,1,'payment_request.updated','payment_request','9','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36',NULL,NULL,NULL,'{\"id\":9,\"shipment_id\":2,\"title\":\"shimpment fees\",\"category\":\"shipment\",\"priority\":\"normal\",\"reason\":\"shipment fees need to be paid\",\"description\":null,\"amount\":\"1500.00\",\"currency\":\"USD\",\"requested_method\":\"bank_transfer\",\"status\":\"payment_required\",\"is_active\":true,\"is_archived\":false,\"secure_token\":\"1zalRo3Hx5HUKNiAtvwLh7C7CCq1wxoKgw0N2B5krPgd17jSbBge6zifa0LJcSd1\",\"due_at\":null,\"paid_at\":null,\"verified_at\":null,\"created_by\":1,\"verified_by\":null,\"metadata\":{\"allowed_methods\":[\"bank_transfer\"]},\"internal_notes\":null,\"payment_instructions\":null,\"payment_reference\":null,\"duplicated_from_id\":null,\"created_at\":\"2026-07-30T07:18:57.000000Z\",\"updated_at\":\"2026-07-30T07:26:46.000000Z\"}','{\"id\":9,\"shipment_id\":2,\"title\":\"shimpment fees\",\"category\":\"shipment\",\"priority\":\"normal\",\"reason\":\"shipment fees need to be paid\",\"description\":null,\"amount\":\"1500.00\",\"currency\":\"USD\",\"requested_method\":\"bank_transfer\",\"status\":\"payment_required\",\"is_active\":true,\"is_archived\":false,\"secure_token\":\"1zalRo3Hx5HUKNiAtvwLh7C7CCq1wxoKgw0N2B5krPgd17jSbBge6zifa0LJcSd1\",\"due_at\":null,\"paid_at\":null,\"verified_at\":null,\"created_by\":1,\"verified_by\":null,\"metadata\":{\"allowed_methods\":[\"bank_transfer\"]},\"internal_notes\":null,\"payment_instructions\":null,\"payment_reference\":null,\"duplicated_from_id\":null,\"created_at\":\"2026-07-30T07:18:57.000000Z\",\"updated_at\":\"2026-07-30T07:26:46.000000Z\"}',NULL,'2026-07-30 11:26:47','2026-07-30 11:26:47'),(12,1,'admin.login','user','1','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-30 11:28:47','2026-07-30 11:28:47'),(13,1,'payment_request.created','payment_request','10','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,'{\"id\":10,\"shipment_id\":2,\"title\":\"rty\",\"category\":\"ert\",\"priority\":\"normal\",\"reason\":\"ert\",\"description\":null,\"amount\":\"2500.00\",\"currency\":\"USD\",\"requested_method\":null,\"status\":\"draft\",\"is_active\":true,\"is_archived\":false,\"secure_token\":\"rDzUdrDEtsuIIp7QuMXwhKkGQx0YhteQBaZrEq698ZKNFf5JcKltbBwOrhzOJZEu\",\"due_at\":null,\"paid_at\":null,\"verified_at\":null,\"created_by\":1,\"verified_by\":null,\"metadata\":[],\"internal_notes\":null,\"payment_instructions\":null,\"payment_reference\":null,\"duplicated_from_id\":null,\"created_at\":\"2026-07-30T07:38:14.000000Z\",\"updated_at\":\"2026-07-30T07:38:14.000000Z\"}',NULL,'2026-07-30 11:38:14','2026-07-30 11:38:14'),(14,1,'payment_request.updated','payment_request','7','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36',NULL,NULL,NULL,'{\"id\":7,\"shipment_id\":2,\"title\":\"Customs fees clearance\",\"category\":\"Custom\",\"priority\":\"normal\",\"reason\":\"Customs fees clearance need to be paid\",\"description\":null,\"amount\":\"2000.00\",\"currency\":\"USD\",\"requested_method\":\"bank_transfer\",\"status\":\"draft\",\"is_active\":true,\"is_archived\":false,\"secure_token\":\"TdRDmf60RXgDASOkBoJrpRjd0IN2N7QQyhIuSHEs7lLxmMY8S8CuzSQbTNgMdwUm\",\"due_at\":null,\"paid_at\":null,\"verified_at\":null,\"created_by\":1,\"verified_by\":null,\"metadata\":{\"allowed_methods\":[\"bank_transfer\"]},\"internal_notes\":null,\"payment_instructions\":null,\"payment_reference\":null,\"duplicated_from_id\":null,\"created_at\":\"2026-07-30T07:11:26.000000Z\",\"updated_at\":\"2026-07-30T07:11:26.000000Z\"}','{\"id\":7,\"shipment_id\":2,\"title\":\"Customs fees clearance\",\"category\":\"Custom\",\"priority\":\"normal\",\"reason\":\"Customs fees clearance need to be paid\",\"description\":null,\"amount\":\"2000.00\",\"currency\":\"USD\",\"requested_method\":\"bank_transfer\",\"status\":\"payment_required\",\"is_active\":true,\"is_archived\":false,\"secure_token\":\"TdRDmf60RXgDASOkBoJrpRjd0IN2N7QQyhIuSHEs7lLxmMY8S8CuzSQbTNgMdwUm\",\"due_at\":null,\"paid_at\":null,\"verified_at\":null,\"created_by\":1,\"verified_by\":null,\"metadata\":{\"allowed_methods\":[\"bank_transfer\"]},\"internal_notes\":null,\"payment_instructions\":null,\"payment_reference\":null,\"duplicated_from_id\":null,\"created_at\":\"2026-07-30T07:11:26.000000Z\",\"updated_at\":\"2026-07-30T07:38:41.000000Z\"}',NULL,'2026-07-30 11:38:41','2026-07-30 11:38:41'),(15,1,'payment_request.updated','payment_request','10','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36',NULL,NULL,NULL,'{\"id\":10,\"shipment_id\":2,\"title\":\"rty\",\"category\":\"ert\",\"priority\":\"normal\",\"reason\":\"ert\",\"description\":null,\"amount\":\"2500.00\",\"currency\":\"USD\",\"requested_method\":null,\"status\":\"draft\",\"is_active\":true,\"is_archived\":false,\"secure_token\":\"rDzUdrDEtsuIIp7QuMXwhKkGQx0YhteQBaZrEq698ZKNFf5JcKltbBwOrhzOJZEu\",\"due_at\":null,\"paid_at\":null,\"verified_at\":null,\"created_by\":1,\"verified_by\":null,\"metadata\":[],\"internal_notes\":null,\"payment_instructions\":null,\"payment_reference\":null,\"duplicated_from_id\":null,\"created_at\":\"2026-07-30T07:38:14.000000Z\",\"updated_at\":\"2026-07-30T07:38:14.000000Z\"}','{\"id\":10,\"shipment_id\":2,\"title\":\"rty\",\"category\":\"ert\",\"priority\":\"normal\",\"reason\":\"ert\",\"description\":null,\"amount\":\"2500.00\",\"currency\":\"USD\",\"requested_method\":null,\"status\":\"payment_required\",\"is_active\":true,\"is_archived\":false,\"secure_token\":\"rDzUdrDEtsuIIp7QuMXwhKkGQx0YhteQBaZrEq698ZKNFf5JcKltbBwOrhzOJZEu\",\"due_at\":null,\"paid_at\":null,\"verified_at\":null,\"created_by\":1,\"verified_by\":null,\"metadata\":[],\"internal_notes\":null,\"payment_instructions\":null,\"payment_reference\":null,\"duplicated_from_id\":null,\"created_at\":\"2026-07-30T07:38:14.000000Z\",\"updated_at\":\"2026-07-30T07:39:10.000000Z\"}',NULL,'2026-07-30 11:39:10','2026-07-30 11:39:10'),(16,1,'payment_request.updated','payment_request','10','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36',NULL,NULL,NULL,'{\"id\":10,\"shipment_id\":2,\"title\":\"rty\",\"category\":\"ert\",\"priority\":\"normal\",\"reason\":\"ert\",\"description\":null,\"amount\":\"2500.00\",\"currency\":\"USD\",\"requested_method\":null,\"status\":\"awaiting_verification\",\"is_active\":true,\"is_archived\":false,\"secure_token\":\"rDzUdrDEtsuIIp7QuMXwhKkGQx0YhteQBaZrEq698ZKNFf5JcKltbBwOrhzOJZEu\",\"due_at\":null,\"paid_at\":null,\"verified_at\":null,\"created_by\":1,\"verified_by\":null,\"metadata\":[],\"internal_notes\":null,\"payment_instructions\":null,\"payment_reference\":\"PAY-2AMEVJ-MOVJ\",\"duplicated_from_id\":null,\"created_at\":\"2026-07-30T07:38:14.000000Z\",\"updated_at\":\"2026-07-30T07:41:54.000000Z\"}','{\"id\":10,\"shipment_id\":2,\"title\":\"rty\",\"category\":\"ert\",\"priority\":\"normal\",\"reason\":\"ert\",\"description\":null,\"amount\":\"2500.00\",\"currency\":\"USD\",\"requested_method\":null,\"status\":\"processing\",\"is_active\":true,\"is_archived\":false,\"secure_token\":\"rDzUdrDEtsuIIp7QuMXwhKkGQx0YhteQBaZrEq698ZKNFf5JcKltbBwOrhzOJZEu\",\"due_at\":null,\"paid_at\":null,\"verified_at\":null,\"created_by\":1,\"verified_by\":null,\"metadata\":[],\"internal_notes\":null,\"payment_instructions\":null,\"payment_reference\":\"PAY-2AMEVJ-MOVJ\",\"duplicated_from_id\":null,\"created_at\":\"2026-07-30T07:38:14.000000Z\",\"updated_at\":\"2026-07-30T07:44:01.000000Z\"}',NULL,'2026-07-30 11:44:01','2026-07-30 11:44:01'),(17,1,'admin.login','user','1','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-30 16:19:59','2026-07-30 16:19:59'),(18,1,'admin.login','user','1','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0',NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-30 16:21:07','2026-07-30 16:21:07'),(19,1,'admin.login','user','1','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-30 16:23:44','2026-07-30 16:23:44'),(20,1,'live_chat.replied','guest_chat_message','5','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-30 16:41:53','2026-07-30 16:41:53'),(21,1,'live_chat.replied','guest_chat_message','6','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-30 16:42:00','2026-07-30 16:42:00'),(22,1,'live_chat.replied','guest_chat_message','7','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-30 16:42:05','2026-07-30 16:42:05'),(23,1,'live_chat.replied','guest_chat_message','8','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-30 16:42:11','2026-07-30 16:42:11'),(24,1,'live_chat.replied','guest_chat_message','9','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-30 16:47:28','2026-07-30 16:47:28'),(25,1,'settings.live_chat.updated','admin_settings',NULL,'127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,'{\"live_chat_enabled\":\"1\",\"live_chat_welcome_message\":\"Welcome. Share your tracking number and our support team will help.\",\"live_chat_guest_email_required\":\"0\",\"live_chat_poll_seconds\":\"8\"}',NULL,'2026-07-30 17:07:16','2026-07-30 17:07:16'),(26,1,'shipment.updated','shipment','3','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36',NULL,NULL,NULL,'{\"id\":3,\"user_id\":1,\"driver_id\":null,\"warehouse_id\":null,\"tracking_number\":\"GEX-2026-9INXWJA2\",\"status\":\"booked\",\"service_level\":\"domestic_express\",\"sender_name\":\"Emma Williams\",\"recipient_name\":\"Lucia Johnson\",\"origin_address\":{\"street\":\"369 Spruce Pl\",\"city\":\"New York\",\"state\":\"New York\",\"postal_code\":\"10001\",\"country\":\"United States (US)\",\"email\":\"emma.williams@yahoo.com\",\"phone\":\"+1-712-452-5986\",\"company\":\"Orion Enterprises\",\"latitude\":41.9410874,\"longitude\":-74.0477648},\"destination_address\":{\"street\":\"741 Ash Ter\",\"city\":\"Mumbai\",\"state\":\"Maharashtra\",\"postal_code\":\"400001\",\"country\":\"India (IN)\",\"email\":\"lucia.johnson@outlook.com\",\"phone\":\"+1-947-652-4286\",\"company\":\"Atlas Logistics\",\"latitude\":19.076,\"longitude\":72.8777},\"weight_kg\":\"164.40\",\"declared_value\":\"407.89\",\"quoted_amount\":\"407.89\",\"estimated_delivery_at\":\"2026-08-08T00:00:00.000000Z\",\"delivered_at\":null,\"metadata\":{\"workflow\":{\"service_level\":\"domestic_express\",\"shipment_type\":\"international\",\"shipping_method\":\"air\",\"priority\":\"urgent\"},\"costs\":{\"shipping_cost\":370.96,\"handling_fee\":10.82,\"insurance_fee\":14.2,\"customs_fee\":8.53,\"tax\":3.38,\"discount\":0,\"additional_charges\":0,\"total_cost\":407.88999999999993,\"currency\":\"USD\"},\"package\":{\"type\":\"Pallet\",\"weight_kg\":41.1,\"length_cm\":35,\"width_cm\":52,\"height_cm\":29,\"quantity\":4,\"description\":\"Test parcel contents - auto-generated for testing\"},\"payment\":{\"method\":\"bank_transfer\",\"status\":\"pending\"}},\"created_at\":\"2026-07-30T13:19:10.000000Z\",\"updated_at\":\"2026-07-30T13:19:10.000000Z\"}','{\"id\":3,\"user_id\":1,\"driver_id\":null,\"warehouse_id\":null,\"tracking_number\":\"GEX-2026-9INXWJA2\",\"status\":\"booked\",\"service_level\":\"domestic_express\",\"sender_name\":\"Emma Williams\",\"recipient_name\":\"Lucia Johnson\",\"origin_address\":{\"address\":\"\",\"city\":\"New York\",\"state\":\"New York\",\"country\":\"United States (US)\",\"postal_code\":\"10001\",\"latitude\":\"41.9410874\",\"longitude\":\"-74.0477648\"},\"destination_address\":{\"address\":\"\",\"city\":\"Mumbai\",\"state\":\"Maharashtra\",\"country\":\"India (IN)\",\"postal_code\":\"400001\",\"latitude\":\"19.076\",\"longitude\":\"72.8777\"},\"weight_kg\":\"164.40\",\"declared_value\":\"407.89\",\"quoted_amount\":\"407.89\",\"estimated_delivery_at\":\"2026-08-08T00:00:00.000000Z\",\"delivered_at\":null,\"metadata\":{\"workflow\":{\"service_level\":\"domestic_express\",\"shipment_type\":\"international\",\"shipping_method\":\"air\",\"priority\":\"urgent\"},\"costs\":{\"shipping_cost\":370.96,\"handling_fee\":10.82,\"insurance_fee\":14.2,\"customs_fee\":8.53,\"tax\":3.38,\"discount\":0,\"additional_charges\":0,\"total_cost\":407.88999999999993,\"currency\":\"USD\"},\"package\":{\"type\":\"Pallet\",\"weight_kg\":41.1,\"length_cm\":35,\"width_cm\":52,\"height_cm\":29,\"quantity\":4,\"description\":\"Test parcel contents - auto-generated for testing\"},\"payment\":{\"method\":\"bank_transfer\",\"status\":\"pending\"},\"sender\":{\"company\":\"\",\"phone\":\"08078564545\",\"email\":\"emmal@gmail.com\"},\"receiver\":{\"company\":\"\",\"phone\":\"0807823454\",\"email\":\"johnson@gmail.com\"},\"description\":\"\",\"priority\":\"\",\"cost\":{\"shipping_cost\":407.89,\"handling_fee\":0,\"insurance\":0,\"customs_fee\":0,\"tax\":0,\"discount\":0,\"additional_charges\":0},\"packages\":[{\"package_type\":\"Document\",\"weight_kg\":\"164.40\",\"length_cm\":0,\"width_cm\":0,\"height_cm\":0,\"quantity\":1,\"description\":\"\"}]},\"created_at\":\"2026-07-30T13:19:10.000000Z\",\"updated_at\":\"2026-07-30T13:21:17.000000Z\"}',NULL,'2026-07-30 17:21:17','2026-07-30 17:21:17'),(27,1,'shipment.updated','shipment','3','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36',NULL,NULL,NULL,'{\"id\":3,\"user_id\":1,\"driver_id\":null,\"warehouse_id\":null,\"tracking_number\":\"GEX-2026-9INXWJA2\",\"status\":\"booked\",\"service_level\":\"domestic_express\",\"sender_name\":\"Emma Williams\",\"recipient_name\":\"Lucia Johnson\",\"origin_address\":{\"address\":\"\",\"city\":\"New York\",\"state\":\"New York\",\"country\":\"United States (US)\",\"postal_code\":\"10001\",\"latitude\":\"41.9410874\",\"longitude\":\"-74.0477648\"},\"destination_address\":{\"address\":\"\",\"city\":\"Mumbai\",\"state\":\"Maharashtra\",\"country\":\"India (IN)\",\"postal_code\":\"400001\",\"latitude\":\"19.076\",\"longitude\":\"72.8777\"},\"weight_kg\":\"164.40\",\"declared_value\":\"407.89\",\"quoted_amount\":\"407.89\",\"estimated_delivery_at\":\"2026-08-08T00:00:00.000000Z\",\"delivered_at\":null,\"metadata\":{\"workflow\":{\"service_level\":\"domestic_express\",\"shipment_type\":\"international\",\"shipping_method\":\"air\",\"priority\":\"urgent\"},\"costs\":{\"shipping_cost\":370.96,\"handling_fee\":10.82,\"insurance_fee\":14.2,\"customs_fee\":8.53,\"tax\":3.38,\"discount\":0,\"additional_charges\":0,\"total_cost\":407.88999999999993,\"currency\":\"USD\"},\"package\":{\"type\":\"Pallet\",\"weight_kg\":41.1,\"length_cm\":35,\"width_cm\":52,\"height_cm\":29,\"quantity\":4,\"description\":\"Test parcel contents - auto-generated for testing\"},\"payment\":{\"method\":\"bank_transfer\",\"status\":\"pending\"},\"sender\":{\"company\":\"\",\"phone\":\"08078564545\",\"email\":\"emmal@gmail.com\"},\"receiver\":{\"company\":\"\",\"phone\":\"0807823454\",\"email\":\"johnson@gmail.com\"},\"description\":\"\",\"priority\":\"\",\"cost\":{\"shipping_cost\":407.89,\"handling_fee\":0,\"insurance\":0,\"customs_fee\":0,\"tax\":0,\"discount\":0,\"additional_charges\":0},\"packages\":[{\"package_type\":\"Document\",\"weight_kg\":\"164.40\",\"length_cm\":0,\"width_cm\":0,\"height_cm\":0,\"quantity\":1,\"description\":\"\"}]},\"created_at\":\"2026-07-30T13:19:10.000000Z\",\"updated_at\":\"2026-07-30T13:21:17.000000Z\"}','{\"id\":3,\"user_id\":1,\"driver_id\":null,\"warehouse_id\":null,\"tracking_number\":\"GEX-2026-9INXWJA2\",\"status\":\"booked\",\"service_level\":\"domestic_express\",\"sender_name\":\"Emma Williams\",\"recipient_name\":\"Lucia Johnson\",\"origin_address\":{\"address\":\"\",\"city\":\"New York\",\"state\":\"New York\",\"country\":\"United States (US)\",\"postal_code\":\"10001\",\"latitude\":\"41.9410874\",\"longitude\":\"-74.0477648\"},\"destination_address\":{\"address\":\"\",\"city\":\"Mumbai\",\"state\":\"Maharashtra\",\"country\":\"India (IN)\",\"postal_code\":\"400001\",\"latitude\":\"19.076\",\"longitude\":\"72.8777\"},\"weight_kg\":\"164.40\",\"declared_value\":\"407.89\",\"quoted_amount\":\"407.89\",\"estimated_delivery_at\":\"2026-08-08T00:00:00.000000Z\",\"delivered_at\":null,\"metadata\":{\"workflow\":{\"service_level\":\"domestic_express\",\"shipment_type\":\"international\",\"shipping_method\":\"air\",\"priority\":\"urgent\"},\"costs\":{\"shipping_cost\":370.96,\"handling_fee\":10.82,\"insurance_fee\":14.2,\"customs_fee\":8.53,\"tax\":3.38,\"discount\":0,\"additional_charges\":0,\"total_cost\":407.88999999999993,\"currency\":\"USD\"},\"package\":{\"type\":\"Pallet\",\"weight_kg\":41.1,\"length_cm\":35,\"width_cm\":52,\"height_cm\":29,\"quantity\":4,\"description\":\"Test parcel contents - auto-generated for testing\"},\"payment\":{\"method\":\"bank_transfer\",\"status\":\"pending\"},\"sender\":{\"company\":\"\",\"phone\":\"08078564545\",\"email\":\"emmal@gmail.com\"},\"receiver\":{\"company\":\"\",\"phone\":\"0807823454\",\"email\":\"johnson@gmail.com\"},\"description\":\"\",\"priority\":\"\",\"cost\":{\"shipping_cost\":407.89,\"handling_fee\":0,\"insurance\":0,\"customs_fee\":0,\"tax\":0,\"discount\":0,\"additional_charges\":0},\"packages\":[{\"package_type\":\"Document\",\"weight_kg\":\"164.40\",\"length_cm\":\"0\",\"width_cm\":\"0\",\"height_cm\":\"0\",\"quantity\":1,\"description\":\"\"}]},\"created_at\":\"2026-07-30T13:19:10.000000Z\",\"updated_at\":\"2026-07-30T13:21:29.000000Z\"}',NULL,'2026-07-30 17:21:30','2026-07-30 17:21:30'),(28,1,'admin.login','user','1','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-30 19:53:02','2026-07-30 19:53:02'),(29,1,'admin.login','user','1','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-30 19:53:39','2026-07-30 19:53:39'),(30,1,'shipment.updated','shipment','3','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36',NULL,NULL,NULL,'{\"id\":3,\"user_id\":1,\"driver_id\":null,\"warehouse_id\":null,\"tracking_number\":\"GEX-2026-9INXWJA2\",\"status\":\"booked\",\"service_level\":\"domestic_express\",\"sender_name\":\"Emma Williams\",\"recipient_name\":\"Lucia Johnson\",\"origin_address\":{\"address\":\"\",\"city\":\"New York\",\"state\":\"New York\",\"country\":\"United States (US)\",\"postal_code\":\"10001\",\"latitude\":\"41.9410874\",\"longitude\":\"-74.0477648\"},\"destination_address\":{\"address\":\"\",\"city\":\"Mumbai\",\"state\":\"Maharashtra\",\"country\":\"India (IN)\",\"postal_code\":\"400001\",\"latitude\":\"19.076\",\"longitude\":\"72.8777\"},\"weight_kg\":\"164.40\",\"declared_value\":\"407.89\",\"quoted_amount\":\"407.89\",\"estimated_delivery_at\":\"2026-08-08T00:00:00.000000Z\",\"delivered_at\":null,\"metadata\":{\"workflow\":{\"service_level\":\"domestic_express\",\"shipment_type\":\"international\",\"shipping_method\":\"air\",\"priority\":\"urgent\"},\"costs\":{\"shipping_cost\":370.96,\"handling_fee\":10.82,\"insurance_fee\":14.2,\"customs_fee\":8.53,\"tax\":3.38,\"discount\":0,\"additional_charges\":0,\"total_cost\":407.88999999999993,\"currency\":\"USD\"},\"package\":{\"type\":\"Pallet\",\"weight_kg\":41.1,\"length_cm\":35,\"width_cm\":52,\"height_cm\":29,\"quantity\":4,\"description\":\"Test parcel contents - auto-generated for testing\"},\"payment\":{\"method\":\"bank_transfer\",\"status\":\"pending\"},\"sender\":{\"company\":\"\",\"phone\":\"08078564545\",\"email\":\"emmal@gmail.com\"},\"receiver\":{\"company\":\"\",\"phone\":\"0807823454\",\"email\":\"johnson@gmail.com\"},\"description\":\"\",\"priority\":\"\",\"cost\":{\"shipping_cost\":407.89,\"handling_fee\":0,\"insurance\":0,\"customs_fee\":0,\"tax\":0,\"discount\":0,\"additional_charges\":0},\"packages\":[{\"package_type\":\"Document\",\"weight_kg\":\"164.40\",\"length_cm\":\"0\",\"width_cm\":\"0\",\"height_cm\":\"0\",\"quantity\":1,\"description\":\"\"}]},\"created_at\":\"2026-07-30T13:19:10.000000Z\",\"updated_at\":\"2026-07-30T13:21:29.000000Z\"}','{\"id\":3,\"user_id\":1,\"driver_id\":null,\"warehouse_id\":null,\"tracking_number\":\"GEX-2026-9INXWJA2\",\"status\":\"booked\",\"service_level\":\"domestic_express\",\"sender_name\":\"Emma Williams\",\"recipient_name\":\"Lucia Johnson\",\"origin_address\":{\"address\":\"\",\"city\":\"New York\",\"state\":\"New York\",\"country\":\"United States (US)\",\"postal_code\":\"10001\",\"latitude\":\"41.9410874\",\"longitude\":\"-74.0477648\"},\"destination_address\":{\"address\":\"\",\"city\":\"Mumbai\",\"state\":\"Maharashtra\",\"country\":\"India (IN)\",\"postal_code\":\"400001\",\"latitude\":\"19.076\",\"longitude\":\"72.8777\"},\"weight_kg\":\"164.40\",\"declared_value\":\"407.89\",\"quoted_amount\":\"407.89\",\"estimated_delivery_at\":\"2026-08-08T00:00:00.000000Z\",\"delivered_at\":null,\"metadata\":{\"workflow\":{\"service_level\":\"domestic_express\",\"shipment_type\":\"international\",\"shipping_method\":\"air\",\"priority\":\"urgent\"},\"costs\":{\"shipping_cost\":370.96,\"handling_fee\":10.82,\"insurance_fee\":14.2,\"customs_fee\":8.53,\"tax\":3.38,\"discount\":0,\"additional_charges\":0,\"total_cost\":407.88999999999993,\"currency\":\"USD\"},\"package\":{\"type\":\"Pallet\",\"weight_kg\":41.1,\"length_cm\":35,\"width_cm\":52,\"height_cm\":29,\"quantity\":4,\"description\":\"Test parcel contents - auto-generated for testing\"},\"payment\":{\"method\":\"bank_transfer\",\"status\":\"pending\"},\"sender\":{\"company\":\"\",\"phone\":\"08078564546\",\"email\":\"emmal@gmail.com\"},\"receiver\":{\"company\":\"\",\"phone\":\"0807823456\",\"email\":\"johnson@gmail.com\"},\"description\":\"\",\"priority\":\"\",\"cost\":{\"shipping_cost\":407.89,\"handling_fee\":0,\"insurance\":0,\"customs_fee\":0,\"tax\":0,\"discount\":0,\"additional_charges\":0},\"packages\":[{\"package_type\":\"Document\",\"weight_kg\":\"164.40\",\"length_cm\":\"0\",\"width_cm\":\"0\",\"height_cm\":\"0\",\"quantity\":1,\"description\":\"\"}]},\"created_at\":\"2026-07-30T13:19:10.000000Z\",\"updated_at\":\"2026-07-30T16:07:14.000000Z\"}',NULL,'2026-07-30 20:07:14','2026-07-30 20:07:14'),(31,1,'shipment.updated','shipment','4','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36',NULL,NULL,NULL,'{\"id\":4,\"user_id\":1,\"driver_id\":null,\"warehouse_id\":null,\"tracking_number\":\"GEX-2026-6BDLZFR1\",\"status\":\"booked\",\"service_level\":\"freight\",\"sender_name\":\"Aisha Gonzalez\",\"recipient_name\":\"Carlos Garcia\",\"origin_address\":{\"street\":\"789 Pine Rd\",\"city\":\"New York\",\"state\":\"New York\",\"postal_code\":\"10001\",\"country\":\"United States (US)\",\"email\":\"aisha.gonzalez@outlook.com\",\"phone\":\"+1-825-408-8031\",\"company\":\"Evergreen Corp\",\"latitude\":41.9410874,\"longitude\":-74.0477648},\"destination_address\":{\"street\":\"369 Spruce Pl\",\"city\":\"Los Angeles\",\"state\":\"California\",\"postal_code\":\"90001\",\"country\":\"United States (US)\",\"email\":\"carlos.garcia@company.com\",\"phone\":\"+1-357-199-8009\",\"company\":\"GlobalTech Solutions\",\"latitude\":34.146085,\"longitude\":-118.130152},\"weight_kg\":\"147.20\",\"declared_value\":\"431.13\",\"quoted_amount\":\"431.13\",\"estimated_delivery_at\":\"2026-08-09T00:00:00.000000Z\",\"delivered_at\":null,\"metadata\":{\"workflow\":{\"service_level\":\"freight\",\"shipment_type\":\"domestic\",\"shipping_method\":\"sea\",\"priority\":\"standard\"},\"costs\":{\"shipping_cost\":385.69,\"handling_fee\":18.31,\"insurance_fee\":4.73,\"customs_fee\":17.76,\"tax\":4.64,\"discount\":0,\"additional_charges\":0,\"total_cost\":431.13,\"currency\":\"USD\"},\"package\":{\"type\":\"Parcel\",\"weight_kg\":18.4,\"length_cm\":19,\"width_cm\":51,\"height_cm\":57,\"quantity\":8,\"description\":\"Test parcel contents - auto-generated for testing\"},\"payment\":{\"method\":\"prepaid\",\"status\":\"pending\"}},\"created_at\":\"2026-07-30T16:29:57.000000Z\",\"updated_at\":\"2026-07-30T16:29:57.000000Z\"}','{\"id\":4,\"user_id\":1,\"driver_id\":null,\"warehouse_id\":null,\"tracking_number\":\"GEX-2026-6BDLZFR1\",\"status\":\"booked\",\"service_level\":\"freight\",\"sender_name\":\"Aisha Gonzalez\",\"recipient_name\":\"Carlos Garcia\",\"origin_address\":{\"address\":\"\",\"city\":\"New York\",\"state\":\"New York\",\"country\":\"United States (US)\",\"postal_code\":\"10001\",\"latitude\":\"41.9410874\",\"longitude\":\"-74.0477648\"},\"destination_address\":{\"address\":\"\",\"city\":\"Los Angeles\",\"state\":\"California\",\"country\":\"United States (US)\",\"postal_code\":\"90001\",\"latitude\":\"34.146085\",\"longitude\":\"-118.130152\"},\"weight_kg\":\"147.20\",\"declared_value\":\"431.13\",\"quoted_amount\":\"431.13\",\"estimated_delivery_at\":\"2026-08-09T00:00:00.000000Z\",\"delivered_at\":null,\"metadata\":{\"workflow\":{\"service_level\":\"freight\",\"shipment_type\":\"domestic\",\"shipping_method\":\"sea\",\"priority\":\"standard\"},\"costs\":{\"shipping_cost\":385.69,\"handling_fee\":18.31,\"insurance_fee\":4.73,\"customs_fee\":17.76,\"tax\":4.64,\"discount\":0,\"additional_charges\":0,\"total_cost\":431.13,\"currency\":\"USD\"},\"package\":{\"type\":\"Parcel\",\"weight_kg\":18.4,\"length_cm\":19,\"width_cm\":51,\"height_cm\":57,\"quantity\":8,\"description\":\"Test parcel contents - auto-generated for testing\"},\"payment\":{\"method\":\"prepaid\",\"status\":\"pending\"},\"sender\":{\"company\":\"FedExUS\",\"phone\":\"0904567857\",\"email\":\"aisha@gmail.com\"},\"receiver\":{\"company\":\"\",\"phone\":\"090334556\",\"email\":\"carlos@gmail.com\"},\"description\":\"\",\"priority\":\"\",\"cost\":{\"shipping_cost\":431.13,\"handling_fee\":0,\"insurance\":0,\"customs_fee\":0,\"tax\":0,\"discount\":0,\"additional_charges\":0},\"packages\":[{\"package_type\":\"\",\"weight_kg\":\"147.20\",\"length_cm\":0,\"width_cm\":0,\"height_cm\":0,\"quantity\":1,\"description\":\"\"}]},\"created_at\":\"2026-07-30T16:29:57.000000Z\",\"updated_at\":\"2026-07-30T16:31:10.000000Z\"}',NULL,'2026-07-30 20:31:10','2026-07-30 20:31:10'),(32,1,'payment_request.created','payment_request','11','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,'{\"id\":11,\"shipment_id\":4,\"title\":\"Clearance\",\"category\":\"Clearance\",\"priority\":\"normal\",\"reason\":\"Clearance need to be paid\",\"description\":null,\"amount\":\"1500.00\",\"currency\":\"USD\",\"requested_method\":null,\"status\":\"draft\",\"is_active\":true,\"is_archived\":false,\"secure_token\":\"U9Se9ZavlMVKGODH5TJLJCRJmF4RCwlVJF8D970hBxUXur66qZV2yGn4PexDFXfJ\",\"due_at\":null,\"paid_at\":null,\"verified_at\":null,\"created_by\":1,\"verified_by\":null,\"metadata\":[],\"internal_notes\":null,\"payment_instructions\":null,\"payment_reference\":null,\"duplicated_from_id\":null,\"created_at\":\"2026-07-30T16:33:28.000000Z\",\"updated_at\":\"2026-07-30T16:33:28.000000Z\"}',NULL,'2026-07-30 20:33:28','2026-07-30 20:33:28'),(33,1,'payment_request.updated','payment_request','11','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36',NULL,NULL,NULL,'{\"id\":11,\"shipment_id\":4,\"title\":\"Clearance\",\"category\":\"Clearance\",\"priority\":\"normal\",\"reason\":\"Clearance need to be paid\",\"description\":null,\"amount\":\"1500.00\",\"currency\":\"USD\",\"requested_method\":null,\"status\":\"draft\",\"is_active\":true,\"is_archived\":false,\"secure_token\":\"U9Se9ZavlMVKGODH5TJLJCRJmF4RCwlVJF8D970hBxUXur66qZV2yGn4PexDFXfJ\",\"due_at\":null,\"paid_at\":null,\"verified_at\":null,\"created_by\":1,\"verified_by\":null,\"metadata\":[],\"internal_notes\":null,\"payment_instructions\":null,\"payment_reference\":null,\"duplicated_from_id\":null,\"created_at\":\"2026-07-30T16:33:28.000000Z\",\"updated_at\":\"2026-07-30T16:33:28.000000Z\"}','{\"id\":11,\"shipment_id\":4,\"title\":\"Clearance\",\"category\":\"Clearance\",\"priority\":\"normal\",\"reason\":\"Clearance need to be paid\",\"description\":null,\"amount\":\"1500.00\",\"currency\":\"USD\",\"requested_method\":null,\"status\":\"payment_required\",\"is_active\":true,\"is_archived\":false,\"secure_token\":\"U9Se9ZavlMVKGODH5TJLJCRJmF4RCwlVJF8D970hBxUXur66qZV2yGn4PexDFXfJ\",\"due_at\":null,\"paid_at\":null,\"verified_at\":null,\"created_by\":1,\"verified_by\":null,\"metadata\":[],\"internal_notes\":null,\"payment_instructions\":null,\"payment_reference\":null,\"duplicated_from_id\":null,\"created_at\":\"2026-07-30T16:33:28.000000Z\",\"updated_at\":\"2026-07-30T16:34:05.000000Z\"}',NULL,'2026-07-30 20:34:05','2026-07-30 20:34:05'),(34,1,'payment_request.updated','payment_request','7','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36',NULL,NULL,NULL,'{\"id\":7,\"shipment_id\":2,\"title\":\"Customs fees clearance\",\"category\":\"Custom\",\"priority\":\"normal\",\"reason\":\"Customs fees clearance need to be paid\",\"description\":null,\"amount\":\"2000.00\",\"currency\":\"USD\",\"requested_method\":\"bank_transfer\",\"status\":\"payment_required\",\"is_active\":true,\"is_archived\":false,\"secure_token\":\"TdRDmf60RXgDASOkBoJrpRjd0IN2N7QQyhIuSHEs7lLxmMY8S8CuzSQbTNgMdwUm\",\"due_at\":null,\"paid_at\":null,\"verified_at\":null,\"created_by\":1,\"verified_by\":null,\"metadata\":{\"allowed_methods\":[\"bank_transfer\"]},\"internal_notes\":null,\"payment_instructions\":null,\"payment_reference\":null,\"duplicated_from_id\":null,\"created_at\":\"2026-07-30T07:11:26.000000Z\",\"updated_at\":\"2026-07-30T07:38:41.000000Z\"}','{\"id\":7,\"shipment_id\":2,\"title\":\"Customs fees clearance\",\"category\":\"Custom\",\"priority\":\"normal\",\"reason\":\"Customs fees clearance need to be paid\",\"description\":null,\"amount\":\"2000.00\",\"currency\":\"USD\",\"requested_method\":\"bank_transfer\",\"status\":\"payment_required\",\"is_active\":true,\"is_archived\":false,\"secure_token\":\"TdRDmf60RXgDASOkBoJrpRjd0IN2N7QQyhIuSHEs7lLxmMY8S8CuzSQbTNgMdwUm\",\"due_at\":null,\"paid_at\":null,\"verified_at\":null,\"created_by\":1,\"verified_by\":null,\"metadata\":{\"allowed_methods\":[\"bank_transfer\"]},\"internal_notes\":null,\"payment_instructions\":null,\"payment_reference\":null,\"duplicated_from_id\":null,\"created_at\":\"2026-07-30T07:11:26.000000Z\",\"updated_at\":\"2026-07-30T07:38:41.000000Z\"}',NULL,'2026-07-30 20:34:54','2026-07-30 20:34:54'),(35,1,'payment_request.updated','payment_request','10','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36',NULL,NULL,NULL,'{\"id\":10,\"shipment_id\":2,\"title\":\"rty\",\"category\":\"ert\",\"priority\":\"normal\",\"reason\":\"ert\",\"description\":null,\"amount\":\"2500.00\",\"currency\":\"USD\",\"requested_method\":null,\"status\":\"processing\",\"is_active\":true,\"is_archived\":false,\"secure_token\":\"rDzUdrDEtsuIIp7QuMXwhKkGQx0YhteQBaZrEq698ZKNFf5JcKltbBwOrhzOJZEu\",\"due_at\":null,\"paid_at\":null,\"verified_at\":null,\"created_by\":1,\"verified_by\":null,\"metadata\":[],\"internal_notes\":null,\"payment_instructions\":null,\"payment_reference\":\"PAY-2AMEVJ-MOVJ\",\"duplicated_from_id\":null,\"created_at\":\"2026-07-30T07:38:14.000000Z\",\"updated_at\":\"2026-07-30T07:44:01.000000Z\"}','{\"id\":10,\"shipment_id\":2,\"title\":\"rty\",\"category\":\"ert\",\"priority\":\"normal\",\"reason\":\"ert\",\"description\":null,\"amount\":\"2500.00\",\"currency\":\"USD\",\"requested_method\":null,\"status\":\"processing\",\"is_active\":true,\"is_archived\":false,\"secure_token\":\"rDzUdrDEtsuIIp7QuMXwhKkGQx0YhteQBaZrEq698ZKNFf5JcKltbBwOrhzOJZEu\",\"due_at\":null,\"paid_at\":null,\"verified_at\":null,\"created_by\":1,\"verified_by\":null,\"metadata\":[],\"internal_notes\":null,\"payment_instructions\":null,\"payment_reference\":\"PAY-2AMEVJ-MOVJ\",\"duplicated_from_id\":null,\"created_at\":\"2026-07-30T07:38:14.000000Z\",\"updated_at\":\"2026-07-30T07:44:01.000000Z\"}',NULL,'2026-07-30 20:35:32','2026-07-30 20:35:32'),(36,1,'payment_request.updated','payment_request','10','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36',NULL,NULL,NULL,'{\"id\":10,\"shipment_id\":2,\"title\":\"rty\",\"category\":\"ert\",\"priority\":\"normal\",\"reason\":\"ert\",\"description\":null,\"amount\":\"2500.00\",\"currency\":\"USD\",\"requested_method\":null,\"status\":\"processing\",\"is_active\":true,\"is_archived\":false,\"secure_token\":\"rDzUdrDEtsuIIp7QuMXwhKkGQx0YhteQBaZrEq698ZKNFf5JcKltbBwOrhzOJZEu\",\"due_at\":null,\"paid_at\":null,\"verified_at\":null,\"created_by\":1,\"verified_by\":null,\"metadata\":[],\"internal_notes\":null,\"payment_instructions\":null,\"payment_reference\":\"PAY-2AMEVJ-MOVJ\",\"duplicated_from_id\":null,\"created_at\":\"2026-07-30T07:38:14.000000Z\",\"updated_at\":\"2026-07-30T07:44:01.000000Z\"}','{\"id\":10,\"shipment_id\":2,\"title\":\"rty\",\"category\":\"ert\",\"priority\":\"normal\",\"reason\":\"ert\",\"description\":null,\"amount\":\"2500.00\",\"currency\":\"USD\",\"requested_method\":null,\"status\":\"processing\",\"is_active\":true,\"is_archived\":false,\"secure_token\":\"rDzUdrDEtsuIIp7QuMXwhKkGQx0YhteQBaZrEq698ZKNFf5JcKltbBwOrhzOJZEu\",\"due_at\":null,\"paid_at\":null,\"verified_at\":null,\"created_by\":1,\"verified_by\":null,\"metadata\":[],\"internal_notes\":null,\"payment_instructions\":null,\"payment_reference\":\"PAY-2AMEVJ-MOVJ\",\"duplicated_from_id\":null,\"created_at\":\"2026-07-30T07:38:14.000000Z\",\"updated_at\":\"2026-07-30T07:44:01.000000Z\"}',NULL,'2026-07-30 20:35:46','2026-07-30 20:35:46'),(37,1,'payment_request.deleted','payment_request','10','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36',NULL,NULL,NULL,'{\"id\":10,\"shipment_id\":2,\"title\":\"rty\",\"category\":\"ert\",\"priority\":\"normal\",\"reason\":\"ert\",\"description\":null,\"amount\":\"2500.00\",\"currency\":\"USD\",\"requested_method\":null,\"status\":\"processing\",\"is_active\":true,\"is_archived\":false,\"secure_token\":\"rDzUdrDEtsuIIp7QuMXwhKkGQx0YhteQBaZrEq698ZKNFf5JcKltbBwOrhzOJZEu\",\"due_at\":null,\"paid_at\":null,\"verified_at\":null,\"created_by\":1,\"verified_by\":null,\"metadata\":[],\"internal_notes\":null,\"payment_instructions\":null,\"payment_reference\":\"PAY-2AMEVJ-MOVJ\",\"duplicated_from_id\":null,\"created_at\":\"2026-07-30T07:38:14.000000Z\",\"updated_at\":\"2026-07-30T07:44:01.000000Z\"}',NULL,NULL,'2026-07-30 20:36:15','2026-07-30 20:36:15'),(38,1,'live_chat.replied','guest_chat_message','11','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-30 20:39:33','2026-07-30 20:39:33'),(39,1,'settings.app.updated','admin_settings',NULL,'127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,'{\"company_name\":\"FedExUS\",\"company_email\":\"admin@example.com\",\"company_phone\":null,\"business_address\":null,\"logo\":null,\"favicon\":\"http://127.0.0.1:8000/favicon.ico\",\"website_url\":\"http://localhost:8000\",\"currency\":\"USD\",\"timezone\":\"UTC\",\"date_format\":\"M d, Y\",\"default_shipment_status\":\"shipment_requested\",\"email_notifications_enabled\":\"1\"}',NULL,'2026-07-30 20:41:57','2026-07-30 20:41:57'),(40,1,'settings.app.updated','admin_settings',NULL,'127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,'{\"company_name\":\"FedExUS\",\"company_email\":\"admin@example.com\",\"company_phone\":null,\"business_address\":null,\"logo\":null,\"favicon\":\"http://127.0.0.1:8000/favicon.ico\",\"website_url\":\"http://localhost:8000\",\"currency\":\"USD\",\"timezone\":\"UTC\",\"date_format\":\"M d, Y\",\"default_shipment_status\":\"shipment_requested\",\"email_notifications_enabled\":\"1\"}',NULL,'2026-07-30 20:42:05','2026-07-30 20:42:05'),(41,1,'settings.live_chat.updated','admin_settings',NULL,'127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,'{\"live_chat_enabled\":\"1\",\"live_chat_welcome_message\":\"Welcome. Share your tracking number and our support team will help.\",\"live_chat_guest_email_required\":\"1\",\"live_chat_poll_seconds\":\"8\"}',NULL,'2026-07-30 20:45:03','2026-07-30 20:45:03'),(42,1,'settings.notifications.updated','admin_settings',NULL,'127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,'{\"notifications_enabled\":\"1\",\"notify_admin_new_chat\":\"1\",\"notify_admin_new_payment\":\"1\",\"notify_guest_tracking_updates\":\"1\",\"notification_footer\":\"Thank you for using our logistics service.\"}',NULL,'2026-07-30 20:45:48','2026-07-30 20:45:48'),(77,1,'admin.login','user','1','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-30 21:29:23','2026-07-30 21:29:23'),(95,1,'admin.login','user','1','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0',NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-30 21:32:42','2026-07-30 21:32:42'),(96,1,'shipment.updated','shipment','155','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0',NULL,NULL,NULL,'{\"id\":155,\"user_id\":1,\"driver_id\":null,\"warehouse_id\":null,\"tracking_number\":\"GEX-2026-PNKGYKIL\",\"status\":\"booked\",\"service_level\":\"standard\",\"sender_name\":\"Ahmed Johnson\",\"recipient_name\":\"Diego Anderson\",\"origin_address\":{\"street\":\"123 Main St\",\"city\":\"Dubai\",\"state\":\"Dubai\",\"postal_code\":\"00000\",\"country\":\"United Arab Emirates (AE)\",\"email\":\"ahmed.johnson@company.com\",\"phone\":\"+1-601-780-6721\",\"company\":\"Horizon Supply\"},\"destination_address\":{\"street\":\"987 Cedar Ln\",\"city\":\"Toronto\",\"state\":\"Ontario\",\"postal_code\":\"M5H 2N2\",\"country\":\"Canada (CA)\",\"email\":\"diego.anderson@yahoo.com\",\"phone\":\"+1-267-626-8582\",\"company\":\"Pinnacle Goods\",\"latitude\":43.6532,\"longitude\":-79.3832},\"weight_kg\":\"382.40\",\"declared_value\":\"168.94\",\"quoted_amount\":\"168.94\",\"estimated_delivery_at\":\"2026-08-17T00:00:00.000000Z\",\"delivered_at\":null,\"metadata\":{\"workflow\":{\"service_level\":\"standard\",\"shipment_type\":\"domestic\",\"shipping_method\":\"air\",\"priority\":\"urgent\"},\"costs\":{\"shipping_cost\":152.21,\"handling_fee\":6.85,\"insurance_fee\":5.37,\"customs_fee\":0.31,\"tax\":4.2,\"discount\":0,\"additional_charges\":0,\"total_cost\":168.94,\"currency\":\"USD\"},\"package\":{\"type\":\"Tube\",\"weight_kg\":47.8,\"length_cm\":85,\"width_cm\":44,\"height_cm\":20,\"quantity\":8,\"description\":\"Test parcel contents - auto-generated for testing\"},\"payment\":{\"method\":\"prepaid\",\"status\":\"pending\"}},\"created_at\":\"2026-07-30T17:34:30.000000Z\",\"updated_at\":\"2026-07-30T17:34:30.000000Z\"}','{\"id\":155,\"user_id\":1,\"driver_id\":null,\"warehouse_id\":null,\"tracking_number\":\"GEX-2026-PNKGYKIL\",\"status\":\"booked\",\"service_level\":\"domestic_express\",\"sender_name\":\"Ahmed Johnson\",\"recipient_name\":\"Diego Anderson\",\"origin_address\":{\"address\":\"\",\"city\":\"Dubai\",\"state\":\"Dubai\",\"country\":\"United Arab Emirates (AE)\",\"postal_code\":\"00000\"},\"destination_address\":{\"address\":\"\",\"city\":\"Toronto\",\"state\":\"Ontario\",\"country\":\"Canada (CA)\",\"postal_code\":\"M5H 2N2\",\"latitude\":\"43.6532\",\"longitude\":\"-79.3832\"},\"weight_kg\":\"382.40\",\"declared_value\":\"168.94\",\"quoted_amount\":\"168.94\",\"estimated_delivery_at\":\"2026-08-17T00:00:00.000000Z\",\"delivered_at\":null,\"metadata\":{\"workflow\":{\"service_level\":\"standard\",\"shipment_type\":\"domestic\",\"shipping_method\":\"air\",\"priority\":\"urgent\"},\"costs\":{\"shipping_cost\":152.21,\"handling_fee\":6.85,\"insurance_fee\":5.37,\"customs_fee\":0.31,\"tax\":4.2,\"discount\":0,\"additional_charges\":0,\"total_cost\":168.94,\"currency\":\"USD\"},\"package\":{\"type\":\"Tube\",\"weight_kg\":47.8,\"length_cm\":85,\"width_cm\":44,\"height_cm\":20,\"quantity\":8,\"description\":\"Test parcel contents - auto-generated for testing\"},\"payment\":{\"method\":\"prepaid\",\"status\":\"pending\"},\"sender\":{\"company\":\"Fedfxus\",\"phone\":\"0947333335\",\"email\":\"ahmed.johnson@company.com\"},\"receiver\":{\"company\":\"\",\"phone\":\"09948333445\",\"email\":\"diego@gmail.com\"},\"description\":\"\",\"priority\":\"\",\"cost\":{\"shipping_cost\":168.94,\"handling_fee\":0,\"insurance\":0,\"customs_fee\":0,\"tax\":0,\"discount\":0,\"additional_charges\":0},\"packages\":[{\"package_type\":\"\",\"weight_kg\":\"382.40\",\"length_cm\":0,\"width_cm\":0,\"height_cm\":0,\"quantity\":1,\"description\":\"\"}]},\"created_at\":\"2026-07-30T17:34:30.000000Z\",\"updated_at\":\"2026-07-30T17:36:29.000000Z\"}',NULL,'2026-07-30 21:36:29','2026-07-30 21:36:29'),(97,1,'payment_request.created','payment_request','12','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0',NULL,NULL,NULL,NULL,'{\"id\":12,\"shipment_id\":155,\"title\":\"Customs\",\"category\":\"Customer\",\"priority\":\"normal\",\"reason\":\"the custom fee needs to be paid\",\"description\":null,\"amount\":\"1600.00\",\"currency\":\"USD\",\"requested_method\":null,\"status\":\"payment_required\",\"is_active\":true,\"is_archived\":false,\"secure_token\":\"wxZ6gX67rPCsoRUOAgvPl95GkqtOGmcqM3d1kI2Kb4JE3Enh2K7aOH9xddtahD3M\",\"due_at\":null,\"paid_at\":null,\"verified_at\":null,\"created_by\":1,\"verified_by\":null,\"metadata\":[],\"internal_notes\":null,\"payment_instructions\":null,\"payment_reference\":null,\"duplicated_from_id\":null,\"created_at\":\"2026-07-30T17:39:03.000000Z\",\"updated_at\":\"2026-07-30T17:39:03.000000Z\"}',NULL,'2026-07-30 21:39:03','2026-07-30 21:39:03'),(132,1,'live_chat.replied','guest_chat_message','53','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0',NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-30 21:52:51','2026-07-30 21:52:51'),(133,1,'live_chat.replied','guest_chat_message','54','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0',NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-30 21:52:57','2026-07-30 21:52:57'),(134,1,'live_chat.replied','guest_chat_message','55','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0',NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-30 21:53:02','2026-07-30 21:53:02'),(186,1,'admin.login','user','1','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-31 06:38:56','2026-07-31 06:38:56'),(187,1,'admin.login','user','1','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-31 06:58:24','2026-07-31 06:58:24'),(188,1,'admin.login','user','1','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-31 13:09:09','2026-07-31 13:09:09'),(189,1,'admin.login','user','1','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-31 13:30:26','2026-07-31 13:30:26'),(190,1,'settings.app.updated','admin_settings',NULL,'127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,'{\"company_name\":\"Max-Fx\",\"company_email\":\"admin@example.com\",\"company_phone\":null,\"business_address\":null,\"logo\":null,\"favicon\":\"http:\\/\\/127.0.0.1:8000\\/favicon.ico\",\"website_url\":\"http:\\/\\/localhost:8000\",\"currency\":\"USD\",\"timezone\":\"UTC\",\"date_format\":\"M d, Y\",\"default_shipment_status\":\"shipment_requested\",\"email_notifications_enabled\":\"1\"}',NULL,'2026-07-31 13:31:56','2026-07-31 13:31:56'),(191,1,'settings.app.updated','admin_settings',NULL,'127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,'{\"company_name\":\"Max-Fx\",\"company_email\":\"admin@example.com\",\"company_phone\":null,\"business_address\":null,\"logo\":null,\"favicon\":\"http:\\/\\/127.0.0.1:8000\\/favicon.ico\",\"website_url\":\"http:\\/\\/localhost:8000\",\"currency\":\"USD\",\"timezone\":\"UTC\",\"date_format\":\"M d, Y\",\"default_shipment_status\":\"shipment_requested\",\"email_notifications_enabled\":\"1\"}',NULL,'2026-07-31 13:31:57','2026-07-31 13:31:57'),(192,1,'shipment.updated','shipment','406','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36',NULL,NULL,NULL,'{\"id\":406,\"user_id\":1,\"driver_id\":null,\"warehouse_id\":null,\"tracking_number\":\"GEX-2026-XA0JGLSU\",\"status\":\"booked\",\"service_level\":\"international_priority\",\"sender_name\":\"Ahmed Gonzalez\",\"recipient_name\":\"Olga Davis\",\"origin_address\":{\"street\":\"258 Walnut Ct\",\"city\":\"Chicago\",\"state\":\"Illinois\",\"postal_code\":\"60601\",\"country\":\"United States (US)\",\"email\":\"ahmed.gonzalez@gmail.com\",\"phone\":\"+1-711-767-4470\",\"company\":\"Evergreen Corp\"},\"destination_address\":{\"street\":\"123 Main St\",\"city\":\"Sydney\",\"state\":\"New South Wales\",\"postal_code\":\"2000\",\"country\":\"Australia (AU)\",\"email\":\"olga.davis@outlook.com\",\"phone\":\"+1-655-554-7210\",\"company\":\"Vertex Manufacturing\",\"latitude\":-33.8927157,\"longitude\":151.2277942},\"weight_kg\":\"168.80\",\"declared_value\":\"124.74\",\"quoted_amount\":\"124.74\",\"estimated_delivery_at\":\"2026-08-11T00:00:00.000000Z\",\"delivered_at\":null,\"metadata\":{\"workflow\":{\"service_level\":\"international_priority\",\"shipment_type\":\"domestic\",\"shipping_method\":\"air\",\"priority\":\"standard\"},\"costs\":{\"shipping_cost\":68.01,\"handling_fee\":26.87,\"insurance_fee\":5.13,\"customs_fee\":19.94,\"tax\":4.79,\"discount\":0,\"additional_charges\":0,\"total_cost\":124.74000000000001,\"currency\":\"USD\"},\"package\":{\"type\":\"Parcel\",\"weight_kg\":84.4,\"length_cm\":114,\"width_cm\":59,\"height_cm\":28,\"quantity\":2,\"description\":\"Test parcel contents - auto-generated for testing\"},\"payment\":{\"method\":\"prepaid\",\"status\":\"pending\"}},\"created_at\":\"2026-07-31T09:34:33.000000Z\",\"updated_at\":\"2026-07-31T09:34:33.000000Z\"}','{\"id\":406,\"user_id\":1,\"driver_id\":null,\"warehouse_id\":null,\"tracking_number\":\"GEX-2026-XA0JGLSU\",\"status\":\"booked\",\"service_level\":\"international_priority\",\"sender_name\":\"Ahmed Gonzalez\",\"recipient_name\":\"Olga Davis\",\"origin_address\":{\"address\":\"\",\"city\":\"Chicago\",\"state\":\"Illinois\",\"country\":\"United States (US)\",\"postal_code\":\"60601\"},\"destination_address\":{\"address\":\"\",\"city\":\"Sydney\",\"state\":\"New South Wales\",\"country\":\"Australia (AU)\",\"postal_code\":\"2000\",\"latitude\":\"-33.8927157\",\"longitude\":\"151.2277942\"},\"weight_kg\":\"168.80\",\"declared_value\":\"124.74\",\"quoted_amount\":\"124.74\",\"estimated_delivery_at\":\"2026-08-11T00:00:00.000000Z\",\"delivered_at\":null,\"metadata\":{\"workflow\":{\"service_level\":\"international_priority\",\"shipment_type\":\"domestic\",\"shipping_method\":\"air\",\"priority\":\"standard\"},\"costs\":{\"shipping_cost\":68.01,\"handling_fee\":26.87,\"insurance_fee\":5.13,\"customs_fee\":19.94,\"tax\":4.79,\"discount\":0,\"additional_charges\":0,\"total_cost\":124.74000000000001,\"currency\":\"USD\"},\"package\":{\"type\":\"Parcel\",\"weight_kg\":84.4,\"length_cm\":114,\"width_cm\":59,\"height_cm\":28,\"quantity\":2,\"description\":\"Test parcel contents - auto-generated for testing\"},\"payment\":{\"method\":\"prepaid\",\"status\":\"pending\"},\"sender\":{\"company\":\"FedExUS\",\"phone\":\"0904567895\",\"email\":\"ahemed@gmail.com\"},\"receiver\":{\"company\":\"\",\"phone\":\"09786655678\",\"email\":\"olga@gmail.com\"},\"description\":\"\",\"priority\":\"\",\"cost\":{\"shipping_cost\":124.74,\"handling_fee\":0,\"insurance\":0,\"customs_fee\":0,\"tax\":0,\"discount\":0,\"additional_charges\":0},\"packages\":[{\"package_type\":\"Document\",\"weight_kg\":\"168.80\",\"length_cm\":0,\"width_cm\":0,\"height_cm\":0,\"quantity\":1,\"description\":\"\"}]},\"created_at\":\"2026-07-31T09:34:33.000000Z\",\"updated_at\":\"2026-07-31T09:38:10.000000Z\"}',NULL,'2026-07-31 13:38:10','2026-07-31 13:38:10'),(193,1,'shipment.updated','shipment','406','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36',NULL,NULL,NULL,'{\"id\":406,\"user_id\":1,\"driver_id\":null,\"warehouse_id\":null,\"tracking_number\":\"GEX-2026-XA0JGLSU\",\"status\":\"booked\",\"service_level\":\"international_priority\",\"sender_name\":\"Ahmed Gonzalez\",\"recipient_name\":\"Olga Davis\",\"origin_address\":{\"address\":\"\",\"city\":\"Chicago\",\"state\":\"Illinois\",\"country\":\"United States (US)\",\"postal_code\":\"60601\"},\"destination_address\":{\"address\":\"\",\"city\":\"Sydney\",\"state\":\"New South Wales\",\"country\":\"Australia (AU)\",\"postal_code\":\"2000\",\"latitude\":\"-33.8927157\",\"longitude\":\"151.2277942\"},\"weight_kg\":\"168.80\",\"declared_value\":\"124.74\",\"quoted_amount\":\"124.74\",\"estimated_delivery_at\":\"2026-08-11T00:00:00.000000Z\",\"delivered_at\":null,\"metadata\":{\"workflow\":{\"service_level\":\"international_priority\",\"shipment_type\":\"domestic\",\"shipping_method\":\"air\",\"priority\":\"standard\"},\"costs\":{\"shipping_cost\":68.01,\"handling_fee\":26.87,\"insurance_fee\":5.13,\"customs_fee\":19.94,\"tax\":4.79,\"discount\":0,\"additional_charges\":0,\"total_cost\":124.74000000000001,\"currency\":\"USD\"},\"package\":{\"type\":\"Parcel\",\"weight_kg\":84.4,\"length_cm\":114,\"width_cm\":59,\"height_cm\":28,\"quantity\":2,\"description\":\"Test parcel contents - auto-generated for testing\"},\"payment\":{\"method\":\"prepaid\",\"status\":\"pending\"},\"sender\":{\"company\":\"FedExUS\",\"phone\":\"0904567895\",\"email\":\"ahemed@gmail.com\"},\"receiver\":{\"company\":\"\",\"phone\":\"09786655678\",\"email\":\"olga@gmail.com\"},\"description\":\"\",\"priority\":\"\",\"cost\":{\"shipping_cost\":124.74,\"handling_fee\":0,\"insurance\":0,\"customs_fee\":0,\"tax\":0,\"discount\":0,\"additional_charges\":0},\"packages\":[{\"package_type\":\"Document\",\"weight_kg\":\"168.80\",\"length_cm\":0,\"width_cm\":0,\"height_cm\":0,\"quantity\":1,\"description\":\"\"}]},\"created_at\":\"2026-07-31T09:34:33.000000Z\",\"updated_at\":\"2026-07-31T09:38:10.000000Z\"}','{\"id\":406,\"user_id\":1,\"driver_id\":null,\"warehouse_id\":null,\"tracking_number\":\"GEX-2026-XA0JGLSU\",\"status\":\"booked\",\"service_level\":\"international_priority\",\"sender_name\":\"Ahmed Gonzalez\",\"recipient_name\":\"Olga Davis\",\"origin_address\":{\"address\":\"\",\"city\":\"Chicago\",\"state\":\"Illinois\",\"country\":\"United States (US)\",\"postal_code\":\"60601\"},\"destination_address\":{\"address\":\"\",\"city\":\"Sydney\",\"state\":\"New South Wales\",\"country\":\"Australia (AU)\",\"postal_code\":\"2000\",\"latitude\":\"-33.8927157\",\"longitude\":\"151.2277942\"},\"weight_kg\":\"168.80\",\"declared_value\":\"124.74\",\"quoted_amount\":\"124.74\",\"estimated_delivery_at\":\"2026-08-11T00:00:00.000000Z\",\"delivered_at\":null,\"metadata\":{\"workflow\":{\"service_level\":\"international_priority\",\"shipment_type\":\"domestic\",\"shipping_method\":\"air\",\"priority\":\"standard\"},\"costs\":{\"shipping_cost\":68.01,\"handling_fee\":26.87,\"insurance_fee\":5.13,\"customs_fee\":19.94,\"tax\":4.79,\"discount\":0,\"additional_charges\":0,\"total_cost\":124.74000000000001,\"currency\":\"USD\"},\"package\":{\"type\":\"Parcel\",\"weight_kg\":84.4,\"length_cm\":114,\"width_cm\":59,\"height_cm\":28,\"quantity\":2,\"description\":\"Test parcel contents - auto-generated for testing\"},\"payment\":{\"method\":\"prepaid\",\"status\":\"pending\"},\"sender\":{\"company\":\"FedExUS\",\"phone\":\"0904567895\",\"email\":\"ahemed@gmail.com\"},\"receiver\":{\"company\":\"\",\"phone\":\"09786655678\",\"email\":\"olga@gmail.com\"},\"description\":\"\",\"priority\":\"\",\"cost\":{\"shipping_cost\":124.74,\"handling_fee\":0,\"insurance\":0,\"customs_fee\":0,\"tax\":0,\"discount\":0,\"additional_charges\":0},\"packages\":[{\"package_type\":\"Document\",\"weight_kg\":\"168.80\",\"length_cm\":0,\"width_cm\":0,\"height_cm\":0,\"quantity\":1,\"description\":\"\"}]},\"created_at\":\"2026-07-31T09:34:33.000000Z\",\"updated_at\":\"2026-07-31T09:38:10.000000Z\"}',NULL,'2026-07-31 13:38:13','2026-07-31 13:38:13'),(194,1,'shipment.updated','shipment','406','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36',NULL,NULL,NULL,'{\"id\":406,\"user_id\":1,\"driver_id\":null,\"warehouse_id\":null,\"tracking_number\":\"GEX-2026-XA0JGLSU\",\"status\":\"booked\",\"service_level\":\"international_priority\",\"sender_name\":\"Ahmed Gonzalez\",\"recipient_name\":\"Olga Davis\",\"origin_address\":{\"address\":\"\",\"city\":\"Chicago\",\"state\":\"Illinois\",\"country\":\"United States (US)\",\"postal_code\":\"60601\"},\"destination_address\":{\"address\":\"\",\"city\":\"Sydney\",\"state\":\"New South Wales\",\"country\":\"Australia (AU)\",\"postal_code\":\"2000\",\"latitude\":\"-33.8927157\",\"longitude\":\"151.2277942\"},\"weight_kg\":\"168.80\",\"declared_value\":\"124.74\",\"quoted_amount\":\"124.74\",\"estimated_delivery_at\":\"2026-08-11T00:00:00.000000Z\",\"delivered_at\":null,\"metadata\":{\"workflow\":{\"service_level\":\"international_priority\",\"shipment_type\":\"domestic\",\"shipping_method\":\"air\",\"priority\":\"standard\"},\"costs\":{\"shipping_cost\":68.01,\"handling_fee\":26.87,\"insurance_fee\":5.13,\"customs_fee\":19.94,\"tax\":4.79,\"discount\":0,\"additional_charges\":0,\"total_cost\":124.74000000000001,\"currency\":\"USD\"},\"package\":{\"type\":\"Parcel\",\"weight_kg\":84.4,\"length_cm\":114,\"width_cm\":59,\"height_cm\":28,\"quantity\":2,\"description\":\"Test parcel contents - auto-generated for testing\"},\"payment\":{\"method\":\"prepaid\",\"status\":\"pending\"},\"sender\":{\"company\":\"FedExUS\",\"phone\":\"0904567895\",\"email\":\"ahemed@gmail.com\"},\"receiver\":{\"company\":\"\",\"phone\":\"09786655678\",\"email\":\"olga@gmail.com\"},\"description\":\"\",\"priority\":\"\",\"cost\":{\"shipping_cost\":124.74,\"handling_fee\":0,\"insurance\":0,\"customs_fee\":0,\"tax\":0,\"discount\":0,\"additional_charges\":0},\"packages\":[{\"package_type\":\"Document\",\"weight_kg\":\"168.80\",\"length_cm\":0,\"width_cm\":0,\"height_cm\":0,\"quantity\":1,\"description\":\"\"}]},\"created_at\":\"2026-07-31T09:34:33.000000Z\",\"updated_at\":\"2026-07-31T09:38:10.000000Z\"}','{\"id\":406,\"user_id\":1,\"driver_id\":null,\"warehouse_id\":null,\"tracking_number\":\"GEX-2026-XA0JGLSU\",\"status\":\"picked_up\",\"service_level\":\"international_priority\",\"sender_name\":\"Ahmed Gonzalez\",\"recipient_name\":\"Olga Davis\",\"origin_address\":{\"address\":\"\",\"city\":\"Chicago\",\"state\":\"Illinois\",\"country\":\"United States (US)\",\"postal_code\":\"60601\"},\"destination_address\":{\"address\":\"\",\"city\":\"Sydney\",\"state\":\"New South Wales\",\"country\":\"Australia (AU)\",\"postal_code\":\"2000\",\"latitude\":\"-33.8927157\",\"longitude\":\"151.2277942\"},\"weight_kg\":\"168.80\",\"declared_value\":\"124.74\",\"quoted_amount\":\"124.74\",\"estimated_delivery_at\":\"2026-08-11T00:00:00.000000Z\",\"delivered_at\":null,\"metadata\":{\"workflow\":{\"service_level\":\"international_priority\",\"shipment_type\":\"domestic\",\"shipping_method\":\"air\",\"priority\":\"standard\"},\"costs\":{\"shipping_cost\":68.01,\"handling_fee\":26.87,\"insurance_fee\":5.13,\"customs_fee\":19.94,\"tax\":4.79,\"discount\":0,\"additional_charges\":0,\"total_cost\":124.74000000000001,\"currency\":\"USD\"},\"package\":{\"type\":\"Parcel\",\"weight_kg\":84.4,\"length_cm\":114,\"width_cm\":59,\"height_cm\":28,\"quantity\":2,\"description\":\"Test parcel contents - auto-generated for testing\"},\"payment\":{\"method\":\"prepaid\",\"status\":\"pending\"},\"sender\":{\"company\":\"FedExUS\",\"phone\":\"0904567895\",\"email\":\"ahemed@gmail.com\"},\"receiver\":{\"company\":\"\",\"phone\":\"09786655678\",\"email\":\"olga@gmail.com\"},\"description\":\"\",\"priority\":\"\",\"cost\":{\"shipping_cost\":124.74,\"handling_fee\":0,\"insurance\":0,\"customs_fee\":0,\"tax\":0,\"discount\":0,\"additional_charges\":0},\"packages\":[{\"package_type\":\"Document\",\"weight_kg\":\"168.80\",\"length_cm\":\"0\",\"width_cm\":\"0\",\"height_cm\":\"0\",\"quantity\":1,\"description\":\"\"}]},\"created_at\":\"2026-07-31T09:34:33.000000Z\",\"updated_at\":\"2026-07-31T09:42:37.000000Z\"}',NULL,'2026-07-31 13:42:37','2026-07-31 13:42:37'),(195,1,'live_chat.replied','guest_chat_message','87','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-31 13:46:14','2026-07-31 13:46:14'),(196,1,'live_chat.replied','guest_chat_message','88','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-31 13:46:20','2026-07-31 13:46:20'),(197,1,'admin.login','user','1','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-31 14:05:45','2026-07-31 14:05:45'),(198,1,'payment_request.updated','payment_request','11','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36',NULL,NULL,NULL,'{\"id\":11,\"shipment_id\":4,\"title\":\"Clearance\",\"category\":\"Clearance\",\"priority\":\"normal\",\"reason\":\"Clearance need to be paid\",\"description\":null,\"amount\":\"1500.00\",\"currency\":\"USD\",\"requested_method\":null,\"status\":\"payment_required\",\"is_active\":true,\"is_archived\":false,\"secure_token\":\"U9Se9ZavlMVKGODH5TJLJCRJmF4RCwlVJF8D970hBxUXur66qZV2yGn4PexDFXfJ\",\"due_at\":null,\"paid_at\":null,\"verified_at\":null,\"created_by\":1,\"verified_by\":null,\"metadata\":[],\"internal_notes\":null,\"payment_instructions\":null,\"payment_reference\":null,\"duplicated_from_id\":null,\"created_at\":\"2026-07-30T16:33:28.000000Z\",\"updated_at\":\"2026-07-30T16:34:05.000000Z\"}','{\"id\":11,\"shipment_id\":4,\"title\":\"Clearance\",\"category\":\"Clearance\",\"priority\":\"normal\",\"reason\":\"Clearance need to be paid\",\"description\":null,\"amount\":\"1500.00\",\"currency\":\"USD\",\"requested_method\":null,\"status\":\"paid\",\"is_active\":true,\"is_archived\":false,\"secure_token\":\"U9Se9ZavlMVKGODH5TJLJCRJmF4RCwlVJF8D970hBxUXur66qZV2yGn4PexDFXfJ\",\"due_at\":null,\"paid_at\":null,\"verified_at\":null,\"created_by\":1,\"verified_by\":null,\"metadata\":[],\"internal_notes\":null,\"payment_instructions\":null,\"payment_reference\":null,\"duplicated_from_id\":null,\"created_at\":\"2026-07-30T16:33:28.000000Z\",\"updated_at\":\"2026-07-31T10:06:05.000000Z\"}',NULL,'2026-07-31 14:06:05','2026-07-31 14:06:05'),(199,1,'admin.login','user','1','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-31 14:10:25','2026-07-31 14:10:25'),(200,1,'admin.login','user','1','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-31 14:10:53','2026-07-31 14:10:53'),(201,1,'payment_request.created','payment_request','13','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36',NULL,NULL,NULL,NULL,'{\"id\":13,\"shipment_id\":406,\"title\":\"Clearance fees\",\"category\":\"Clearance\",\"priority\":\"normal\",\"reason\":\"clearance fees need to to be paid\",\"description\":null,\"amount\":\"1700.00\",\"currency\":\"USD\",\"requested_method\":null,\"status\":\"payment_required\",\"is_active\":true,\"is_archived\":false,\"secure_token\":\"vsD9j99YMQmXGrKSM8iGV8BFbSWkJ06ItuiE1F80WCg33Z3vS0hqgfI2z7D200cH\",\"due_at\":null,\"paid_at\":null,\"verified_at\":null,\"created_by\":1,\"verified_by\":null,\"metadata\":[],\"internal_notes\":null,\"payment_instructions\":null,\"payment_reference\":null,\"duplicated_from_id\":null,\"created_at\":\"2026-07-31T10:15:45.000000Z\",\"updated_at\":\"2026-07-31T10:15:45.000000Z\"}',NULL,'2026-07-31 14:15:45','2026-07-31 14:15:45');
/*!40000 ALTER TABLE `admin_audit_logs` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `admin_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `admin_settings` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `key` varchar(128) NOT NULL,
  `value` text DEFAULT NULL,
  `type` varchar(32) NOT NULL DEFAULT 'string' COMMENT 'string, text, boolean, integer, json, email, url',
  `group` varchar(64) NOT NULL DEFAULT 'general',
  `label` varchar(255) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `options` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'Selectable options for dropdown type' CHECK (json_valid(`options`)),
  `sort_order` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `admin_settings_key_unique` (`key`),
  KEY `admin_settings_group_index` (`group`)
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `admin_settings` WRITE;
/*!40000 ALTER TABLE `admin_settings` DISABLE KEYS */;
INSERT INTO `admin_settings` VALUES (1,'live_chat_enabled','1','boolean','live_chat','Live Chat Enabled',NULL,NULL,0,'2026-07-30 17:06:42','2026-07-30 17:06:42'),(2,'live_chat_welcome_message','Welcome. Share your tracking number and our support team will help.','text','live_chat','Welcome Message',NULL,NULL,0,'2026-07-30 17:06:42','2026-07-30 17:06:42'),(3,'live_chat_guest_email_required','1','boolean','live_chat','Require Guest Email',NULL,NULL,0,'2026-07-30 17:06:42','2026-07-30 20:45:03'),(4,'live_chat_poll_seconds','8','integer','live_chat','Polling Interval Seconds',NULL,NULL,0,'2026-07-30 17:06:43','2026-07-30 17:06:43'),(5,'company_name','Max-Fx','string','app','Company Name',NULL,NULL,0,'2026-07-30 20:41:33','2026-07-31 13:31:56'),(6,'company_email','admin@example.com','email','app','Company Email',NULL,NULL,0,'2026-07-30 20:41:33','2026-07-30 20:41:33'),(7,'company_phone','','string','app','Phone Number',NULL,NULL,0,'2026-07-30 20:41:33','2026-07-30 20:41:33'),(8,'business_address','','text','app','Business Address',NULL,NULL,0,'2026-07-30 20:41:33','2026-07-30 20:41:33'),(9,'logo','','image','app','Website Logo',NULL,NULL,0,'2026-07-30 20:41:33','2026-07-30 20:41:33'),(10,'favicon','http://127.0.0.1:8000/favicon.ico','image','app','Favicon',NULL,NULL,0,'2026-07-30 20:41:33','2026-07-30 20:41:33'),(11,'website_url','http://localhost:8000','url','app','Website URL',NULL,NULL,0,'2026-07-30 20:41:33','2026-07-30 20:41:33'),(12,'currency','USD','string','app','Currency',NULL,NULL,0,'2026-07-30 20:41:33','2026-07-30 20:41:33'),(13,'timezone','UTC','string','app','Timezone',NULL,NULL,0,'2026-07-30 20:41:33','2026-07-30 20:41:33'),(14,'date_format','M d, Y','string','app','Date Format',NULL,NULL,0,'2026-07-30 20:41:33','2026-07-30 20:41:33'),(15,'default_shipment_status','shipment_requested','string','shipment','Default Shipment Status',NULL,NULL,0,'2026-07-30 20:41:33','2026-07-30 20:41:33'),(16,'email_notifications_enabled','1','boolean','email','Email Notifications Enabled',NULL,NULL,0,'2026-07-30 20:41:33','2026-07-30 20:41:33'),(17,'map_provider','openstreetmap','string','map','Map Provider',NULL,NULL,0,'2026-07-30 20:45:26','2026-07-30 20:45:26'),(18,'map_public_key','','string','map','Public Map Key',NULL,NULL,0,'2026-07-30 20:45:26','2026-07-30 20:45:26'),(19,'map_default_latitude','0','string','map','Default Latitude',NULL,NULL,0,'2026-07-30 20:45:26','2026-07-30 20:45:26'),(20,'map_default_longitude','0','string','map','Default Longitude',NULL,NULL,0,'2026-07-30 20:45:26','2026-07-30 20:45:26'),(21,'map_zoom','4','integer','map','Default Zoom',NULL,NULL,0,'2026-07-30 20:45:26','2026-07-30 20:45:26'),(22,'notifications_enabled','1','boolean','notifications','Notifications Enabled',NULL,NULL,0,'2026-07-30 20:45:32','2026-07-30 20:45:32'),(23,'notify_admin_new_chat','1','boolean','notifications','Admin New Chat Alerts',NULL,NULL,0,'2026-07-30 20:45:32','2026-07-30 20:45:32'),(24,'notify_admin_new_payment','1','boolean','notifications','Admin Payment Alerts',NULL,NULL,0,'2026-07-30 20:45:32','2026-07-30 20:45:32'),(25,'notify_guest_tracking_updates','1','boolean','notifications','Guest Tracking Update Alerts',NULL,NULL,0,'2026-07-30 20:45:32','2026-07-30 20:45:32'),(26,'notification_footer','Thank you for using our logistics service.','text','notifications','Notification Footer',NULL,NULL,0,'2026-07-30 20:45:32','2026-07-30 20:45:32'),(27,'smtp_host','','string','email','SMTP Host',NULL,NULL,0,'2026-07-31 14:27:19','2026-07-31 14:27:19'),(28,'smtp_port','587','integer','email','SMTP Port',NULL,NULL,0,'2026-07-31 14:27:19','2026-07-31 14:27:19'),(29,'smtp_username','','string','email','SMTP Username',NULL,NULL,0,'2026-07-31 14:27:19','2026-07-31 14:27:19'),(30,'smtp_password','','password','email','SMTP Password',NULL,NULL,0,'2026-07-31 14:27:19','2026-07-31 14:27:19'),(31,'smtp_encryption','tls','string','email','SMTP Encryption',NULL,NULL,0,'2026-07-31 14:27:19','2026-07-31 14:27:19'),(32,'mail_from_name','FreightFlow','string','email','Sender Name',NULL,NULL,0,'2026-07-31 14:27:19','2026-07-31 14:27:19'),(33,'mail_from_address','','email','email','Sender Email',NULL,NULL,0,'2026-07-31 14:27:19','2026-07-31 14:27:19'),(34,'notify_shipment_created','1','boolean','email','Shipment Created Notification',NULL,NULL,0,'2026-07-31 14:27:19','2026-07-31 14:27:19'),(35,'notify_status_updated','1','boolean','email','Status Updated Notification',NULL,NULL,0,'2026-07-31 14:27:19','2026-07-31 14:27:19'),(36,'notify_payment_request_created','1','boolean','email','Payment Request Notification',NULL,NULL,0,'2026-07-31 14:27:19','2026-07-31 14:27:19'),(37,'notify_payment_received','1','boolean','email','Payment Received Notification',NULL,NULL,0,'2026-07-31 14:27:19','2026-07-31 14:27:19'),(38,'notify_shipment_delivered','1','boolean','email','Shipment Delivered Notification',NULL,NULL,0,'2026-07-31 14:27:19','2026-07-31 14:27:19');
/*!40000 ALTER TABLE `admin_settings` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `bank_accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bank_accounts` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `bank_name` varchar(255) NOT NULL,
  `account_name` varchar(255) NOT NULL,
  `account_number` varchar(255) NOT NULL,
  `swift_bic` varchar(255) DEFAULT NULL,
  `iban` varchar(255) DEFAULT NULL,
  `routing_number` varchar(255) DEFAULT NULL,
  `branch_name` varchar(255) DEFAULT NULL,
  `branch_address` text DEFAULT NULL,
  `country` varchar(100) DEFAULT NULL,
  `bank_logo` varchar(255) DEFAULT NULL,
  `supported_currency` varchar(8) NOT NULL DEFAULT 'USD',
  `payment_instructions` text DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `is_default` tinyint(1) NOT NULL DEFAULT 0,
  `sort_order` int(10) unsigned NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `bank_accounts` WRITE;
/*!40000 ALTER TABLE `bank_accounts` DISABLE KEYS */;
INSERT INTO `bank_accounts` VALUES (1,'First National Bank','FreightFlow Logistics Inc.','1234567890','FNBBUS33','US1234567890123456789012','21000021','Memphis Main Branch','100 Madison Ave, Memphis, TN 38103','US',NULL,'USD','Include your payment reference in the transfer description.',1,0,1,'2026-07-30 02:13:26','2026-07-31 14:25:38'),(2,'Barclays UK','FreightFlow Logistics Ltd.','98765432','BARCGB22','GB29BARC20000098765432',NULL,'London Corporate Branch','1 Churchill Place, London E14 5HP','GB',NULL,'GBP','Quote reference number on all transfers.',0,1,2,'2026-07-30 02:13:26','2026-07-31 14:25:43');
/*!40000 ALTER TABLE `bank_accounts` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `email_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `email_logs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `sender_id` bigint(20) unsigned DEFAULT NULL,
  `recipient_user_id` bigint(20) unsigned DEFAULT NULL,
  `recipient_email` varchar(255) NOT NULL,
  `recipient_type` varchar(40) NOT NULL DEFAULT 'custom',
  `subject` varchar(255) NOT NULL,
  `message` longtext NOT NULL,
  `attachment_path` varchar(255) DEFAULT NULL,
  `status` varchar(40) NOT NULL DEFAULT 'pending',
  `error_message` text DEFAULT NULL,
  `sent_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `email_logs_recipient_email_index` (`recipient_email`),
  KEY `email_logs_recipient_type_index` (`recipient_type`),
  KEY `email_logs_status_index` (`status`),
  KEY `email_logs_sent_at_index` (`sent_at`),
  KEY `email_logs_sender_id_idx` (`sender_id`),
  KEY `email_logs_recipient_user_id_idx` (`recipient_user_id`),
  CONSTRAINT `email_logs_recipient_user_id_foreign` FOREIGN KEY (`recipient_user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `email_logs_sender_id_foreign` FOREIGN KEY (`sender_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `email_logs` WRITE;
/*!40000 ALTER TABLE `email_logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `email_logs` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `guest_chat_conversations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `guest_chat_conversations` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `shipment_id` bigint(20) unsigned DEFAULT NULL,
  `tracking_number` varchar(255) DEFAULT NULL,
  `guest_name` varchar(140) DEFAULT NULL,
  `guest_email` varchar(180) DEFAULT NULL,
  `guest_phone` varchar(60) DEFAULT NULL,
  `subject` varchar(180) DEFAULT NULL,
  `status` enum('open','pending','closed') NOT NULL DEFAULT 'open',
  `secure_token` varchar(96) NOT NULL,
  `last_guest_message_at` timestamp NULL DEFAULT NULL,
  `last_admin_message_at` timestamp NULL DEFAULT NULL,
  `closed_by` bigint(20) unsigned DEFAULT NULL,
  `closed_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `chat_status` varchar(30) NOT NULL DEFAULT 'open',
  `is_guest_notified` tinyint(1) NOT NULL DEFAULT 0,
  `is_admin_notified` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `guest_chat_conversations_secure_token_unique` (`secure_token`),
  KEY `guest_chat_conversations_shipment_id_foreign` (`shipment_id`),
  KEY `guest_chat_conversations_closed_by_foreign` (`closed_by`),
  KEY `guest_chat_conversations_tracking_number_index` (`tracking_number`),
  KEY `guest_chat_conversations_status_index` (`status`),
  KEY `guest_chat_conversations_chat_status_index` (`chat_status`),
  CONSTRAINT `guest_chat_conversations_closed_by_foreign` FOREIGN KEY (`closed_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `guest_chat_conversations_shipment_id_foreign` FOREIGN KEY (`shipment_id`) REFERENCES `shipments` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=267 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `guest_chat_conversations` WRITE;
/*!40000 ALTER TABLE `guest_chat_conversations` DISABLE KEYS */;
INSERT INTO `guest_chat_conversations` VALUES (100,155,'GEX-2026-PNKGYKIL','Diego Anderson','diego@gmail.com',NULL,'Support for GEX-2026-PNKGYKIL','open','82uVunWGfLtIbOMFrPD3e1vKn26pgA6DTtXg8w7PAmUydb4ZbpcMHd9RSHsz4Dm5','2026-07-30 21:43:19','2026-07-30 21:53:02',NULL,NULL,'2026-07-30 21:42:46','2026-07-30 21:53:02','waiting_for_guest',0,0),(266,406,'GEX-2026-XA0JGLSU','Olga Davis','Olga@gmail.com',NULL,'Support for GEX-2026-XA0JGLSU','open','PJmk4bPIRl3TOCw9LZnOiJ0KPNdrklGGKuDFaVEHfwK5OMv1v6s1WmhlbZAxSDVv','2026-07-31 13:44:51','2026-07-31 13:46:20',NULL,NULL,'2026-07-31 13:44:51','2026-07-31 13:46:20','waiting_for_guest',0,0);
/*!40000 ALTER TABLE `guest_chat_conversations` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `guest_chat_messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `guest_chat_messages` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `guest_chat_conversation_id` bigint(20) unsigned NOT NULL,
  `sender_type` enum('guest','admin','system') NOT NULL,
  `admin_user_id` bigint(20) unsigned DEFAULT NULL,
  `body` text NOT NULL,
  `attachments` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`attachments`)),
  `read_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `delivery_status` varchar(20) NOT NULL DEFAULT 'sent',
  `delivered_at` timestamp NULL DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `guest_chat_messages_guest_chat_conversation_id_foreign` (`guest_chat_conversation_id`),
  KEY `guest_chat_messages_admin_user_id_foreign` (`admin_user_id`),
  KEY `guest_chat_messages_sender_type_index` (`sender_type`),
  KEY `guest_chat_messages_delivery_status_index` (`delivery_status`),
  CONSTRAINT `guest_chat_messages_admin_user_id_foreign` FOREIGN KEY (`admin_user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `guest_chat_messages_guest_chat_conversation_id_foreign` FOREIGN KEY (`guest_chat_conversation_id`) REFERENCES `guest_chat_conversations` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=89 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `guest_chat_messages` WRITE;
/*!40000 ALTER TABLE `guest_chat_messages` DISABLE KEYS */;
INSERT INTO `guest_chat_messages` VALUES (31,100,'guest',NULL,'Why is my product delaying',NULL,'2026-07-30 21:52:26','2026-07-30 21:42:46','2026-07-30 21:52:26','read','2026-07-30 21:52:26','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0'),(32,100,'guest',NULL,'GEX-2026-PNKGYKIL',NULL,'2026-07-30 21:52:26','2026-07-30 21:43:19','2026-07-30 21:52:26','read','2026-07-30 21:52:26','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0'),(53,100,'admin',1,'i will get back to you ok?',NULL,'2026-07-30 21:52:56','2026-07-30 21:52:51','2026-07-30 21:52:56','read',NULL,NULL,NULL),(54,100,'admin',1,'i will get back to you ok?',NULL,'2026-07-30 21:53:07','2026-07-30 21:52:57','2026-07-30 21:53:07','read',NULL,NULL,NULL),(55,100,'admin',1,'i will get back to you ok?',NULL,'2026-07-30 21:53:07','2026-07-30 21:53:02','2026-07-30 21:53:07','read',NULL,NULL,NULL),(86,266,'guest',NULL,'hava not receive my product yet',NULL,'2026-07-31 13:45:51','2026-07-31 13:44:51','2026-07-31 13:45:51','read','2026-07-31 13:45:51','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36'),(87,266,'admin',1,'i will get back to you',NULL,'2026-07-31 13:46:19','2026-07-31 13:46:14','2026-07-31 13:46:19','read',NULL,NULL,NULL),(88,266,'admin',1,'i will get back to you',NULL,'2026-07-31 13:46:25','2026-07-31 13:46:20','2026-07-31 13:46:25','read',NULL,NULL,NULL);
/*!40000 ALTER TABLE `guest_chat_messages` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `migrations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `migrations` WRITE;
/*!40000 ALTER TABLE `migrations` DISABLE KEYS */;
INSERT INTO `migrations` VALUES (1,'2026_01_01_000000_create_personal_access_tokens_table',1),(2,'2026_01_01_000001_create_logistics_platform_tables',1),(3,'2026_06_27_000002_create_shipment_workflow_tables',1),(4,'2026_06_27_000003_add_route_metadata_to_tracking_events',1),(5,'2026_07_02_000010_create_admin_audit_logs_table',1),(6,'2026_07_02_000020_add_admin_control_fields_to_users_table',1),(7,'2026_07_02_000030_add_admin_permission_overrides_to_users_table',1),(8,'2026_07_21_000002_create_notification_preferences_table',1),(9,'2026_07_21_000003_create_admin_settings_table',1),(10,'2026_07_23_000001_create_email_logs_table',1),(11,'2026_07_23_000002_create_payment_settings_table',1),(12,'2026_07_23_000003_create_production_logistics_extensions',1),(13,'2026_07_23_000004_add_shipment_cost_fields',1),(14,'2026_07_26_000001_enhance_payment_settings_table',1),(15,'2026_07_26_000002_enhance_payment_transactions_table',1),(16,'2026_07_26_000003_create_payment_audit_logs_table',1),(17,'2026_07_27_134734_add_encryption_key_to_payment_settings_table',1),(18,'2026_07_27_150000_add_environment_credentials_to_payment_settings_table',1),(19,'2026_07_28_000001_create_bank_accounts_table',1),(20,'2026_07_28_000002_create_payment_proofs_table',1),(21,'2026_07_28_000003_add_payment_reference_to_payment_requests_table',1),(22,'2026_07_28_225517_add_file_hash_to_payment_proofs_table',1),(23,'2026_07_28_233438_add_notes_to_payment_proofs_table',1),(24,'2026_07_28_234523_add_country_to_bank_accounts_table',1),(25,'2026_07_29_000001_enhance_payment_requests_table',1),(26,'2026_07_30_000001_create_live_chat_tables',1),(27,'2026_07_30_150632_optimize_database_indexes_and_cleanup',1),(28,'2026_07_30_160000_remove_unused_tables',1);
/*!40000 ALTER TABLE `migrations` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `notification_preferences`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notification_preferences` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned NOT NULL,
  `email` tinyint(1) NOT NULL DEFAULT 1,
  `in_app` tinyint(1) NOT NULL DEFAULT 1,
  `sms` tinyint(1) NOT NULL DEFAULT 0,
  `marketing` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `notification_preferences_user_id_idx` (`user_id`),
  CONSTRAINT `notification_preferences_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `notification_preferences` WRITE;
/*!40000 ALTER TABLE `notification_preferences` DISABLE KEYS */;
INSERT INTO `notification_preferences` VALUES (1,1,1,1,0,0,'2026-07-30 12:16:00','2026-07-30 12:16:00');
/*!40000 ALTER TABLE `notification_preferences` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notifications` (
  `id` char(36) NOT NULL,
  `user_id` bigint(20) unsigned NOT NULL,
  `type` varchar(255) NOT NULL,
  `channel` varchar(255) NOT NULL DEFAULT 'in_app',
  `title` varchar(255) NOT NULL,
  `body` text NOT NULL,
  `data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`data`)),
  `read_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `notifications_user_id_foreign` (`user_id`),
  CONSTRAINT `notifications_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `notifications` WRITE;
/*!40000 ALTER TABLE `notifications` DISABLE KEYS */;
INSERT INTO `notifications` VALUES ('019fb41f-21eb-7305-8bf4-b6ce5d39a267',1,'live_chat','in_app','New Chat: GEX-2026-PNKGYKIL','Diego Anderson opened a chat about GEX-2026-PNKGYKIL: Why is my product delaying','{\"type\":\"live_chat\",\"action\":\"new_chat\",\"conversation_id\":100,\"tracking_number\":\"GEX-2026-PNKGYKIL\"}',NULL,'2026-07-30 21:42:47','2026-07-30 21:42:47'),('019fb41f-321a-706c-b1e5-1f12a862da74',1,'live_chat','email','New Chat: GEX-2026-PNKGYKIL','Diego Anderson opened a chat about GEX-2026-PNKGYKIL: Why is my product delaying','{\"type\":\"live_chat\",\"action\":\"new_chat\",\"conversation_id\":100,\"tracking_number\":\"GEX-2026-PNKGYKIL\",\"recipient\":\"admin@freightflow.test\",\"delivery_status\":\"logged_fallback\"}',NULL,'2026-07-30 21:42:51','2026-07-30 21:42:51'),('019fb41f-a024-7170-925b-038336c1f007',1,'live_chat','in_app','New Message: GEX-2026-PNKGYKIL','Diego Anderson: GEX-2026-PNKGYKIL','{\"type\":\"live_chat\",\"action\":\"new_message\",\"conversation_id\":100,\"tracking_number\":\"GEX-2026-PNKGYKIL\"}',NULL,'2026-07-30 21:43:19','2026-07-30 21:43:19'),('019fb78f-efeb-73f2-89db-a1c064f3eae5',1,'live_chat','in_app','New Chat: GEX-2026-XA0JGLSU','Olga Davis opened a chat about GEX-2026-XA0JGLSU: hava not receive my product yet','{\"type\":\"live_chat\",\"action\":\"new_chat\",\"conversation_id\":266,\"tracking_number\":\"GEX-2026-XA0JGLSU\"}',NULL,'2026-07-31 13:44:51','2026-07-31 13:44:51'),('019fb790-0688-72a1-a8fa-0721abf024a0',1,'live_chat','email','New Chat: GEX-2026-XA0JGLSU','Olga Davis opened a chat about GEX-2026-XA0JGLSU: hava not receive my product yet','{\"type\":\"live_chat\",\"action\":\"new_chat\",\"conversation_id\":266,\"tracking_number\":\"GEX-2026-XA0JGLSU\",\"recipient\":\"admin@freightflow.test\",\"delivery_status\":\"logged_fallback\"}',NULL,'2026-07-31 13:44:57','2026-07-31 13:44:57');
/*!40000 ALTER TABLE `notifications` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `payment_audit_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `payment_audit_logs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `payment_transaction_id` bigint(20) unsigned DEFAULT NULL,
  `event` varchar(80) NOT NULL,
  `provider` varchar(80) DEFAULT NULL,
  `provider_reference` varchar(255) DEFAULT NULL,
  `amount` decimal(12,2) DEFAULT NULL,
  `currency` varchar(8) DEFAULT NULL,
  `previous_status` enum('payment_required','payment_initiated','awaiting_verification','initiated','pending','processing','paid','verified','failed','cancelled','refunded','expired') DEFAULT NULL,
  `new_status` enum('payment_required','payment_initiated','awaiting_verification','initiated','pending','processing','paid','verified','failed','cancelled','refunded','expired') DEFAULT NULL,
  `admin_user_id` bigint(20) unsigned DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` varchar(500) DEFAULT NULL,
  `payload` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`payload`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `payment_audit_logs_event_created_at_index` (`event`,`created_at`),
  KEY `payment_audit_logs_payment_transaction_id_index` (`payment_transaction_id`),
  KEY `payment_audit_logs_event_index` (`event`),
  KEY `payment_audit_logs_provider_index` (`provider`),
  KEY `payment_audit_logs_admin_user_id_idx` (`admin_user_id`),
  CONSTRAINT `payment_audit_logs_admin_user_id_foreign` FOREIGN KEY (`admin_user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `payment_audit_logs` WRITE;
/*!40000 ALTER TABLE `payment_audit_logs` DISABLE KEYS */;
INSERT INTO `payment_audit_logs` VALUES (1,1,'payment.initiated','flutterwave','FLW-TEST-6A6A7B5C2A2EE',100.00,'USD',NULL,'initiated',NULL,NULL,NULL,'{\"test\":true,\"timestamp\":\"2026-07-29T22:14:52+00:00\"}','2026-07-30 02:14:52','2026-07-30 02:14:52'),(2,2,'payment.initiated','flutterwave','FLW-TEST-6A6A7BE24923F',100.00,'USD',NULL,'initiated',NULL,NULL,NULL,'{\"test\":true,\"timestamp\":\"2026-07-29T22:17:06+00:00\"}','2026-07-30 02:17:06','2026-07-30 02:17:06'),(3,3,'payment.initiated','flutterwave','FLW-TEST-6A6A81E862EE6',100.00,'USD',NULL,'initiated',NULL,NULL,NULL,'{\"test\":true,\"timestamp\":\"2026-07-29T22:42:48+00:00\"}','2026-07-30 02:42:48','2026-07-30 02:42:48'),(4,4,'payment.initiated','flutterwave','FLW-TEST-6A6AF21F66AFE',100.00,'USD',NULL,'initiated',NULL,NULL,NULL,'{\"test\":true,\"timestamp\":\"2026-07-30T06:41:35+00:00\"}','2026-07-30 10:41:35','2026-07-30 10:41:35'),(5,5,'payment.initiated','bank_transfer','BANK_TRANSFER-DRGMAAJVALNTSB7G8Q',1000.00,'USD',NULL,'initiated',NULL,'127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36','{\"provider\":\"bank_transfer\",\"amount\":\"1000.00\",\"currency\":\"USD\",\"timestamp\":\"2026-07-30T06:44:53+00:00\"}','2026-07-30 10:44:53','2026-07-30 10:44:53'),(6,6,'payment.initiated','flutterwave','FLW-TEST-6A6AF6AE0D1FE',100.00,'USD',NULL,'initiated',NULL,NULL,NULL,'{\"test\":true,\"timestamp\":\"2026-07-30T07:01:02+00:00\"}','2026-07-30 11:01:02','2026-07-30 11:01:02'),(7,7,'payment.initiated','flutterwave','FLW-TEST-6A6AFA3F27163',100.00,'USD',NULL,'initiated',NULL,NULL,NULL,'{\"test\":true,\"timestamp\":\"2026-07-30T07:16:15+00:00\"}','2026-07-30 11:16:15','2026-07-30 11:16:15'),(8,8,'payment.initiated','bank_transfer','BANK_TRANSFER-QM3MTUWJT8DZ6DYUHL',1500.00,'USD',NULL,'initiated',NULL,'127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36','{\"provider\":\"bank_transfer\",\"amount\":\"1500.00\",\"currency\":\"USD\",\"timestamp\":\"2026-07-30T07:31:00+00:00\"}','2026-07-30 11:31:00','2026-07-30 11:31:00'),(9,9,'payment.initiated','flutterwave','FLUTTERWAVE-XHPXC2OME7AOWKIZTB',2500.00,'USD',NULL,'initiated',NULL,'127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36','{\"provider\":\"flutterwave\",\"amount\":\"2500.00\",\"currency\":\"USD\",\"timestamp\":\"2026-07-30T07:40:08+00:00\"}','2026-07-30 11:40:08','2026-07-30 11:40:08'),(10,9,'payment.checkout_failed','flutterwave','FLUTTERWAVE-XHPXC2OME7AOWKIZTB',2500.00,'USD','initiated','failed',NULL,'127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36','{\"error\":\"Payment initialization failed: Invalid authorization key\",\"timestamp\":\"2026-07-30T07:40:10+00:00\"}','2026-07-30 11:40:10','2026-07-30 11:40:10'),(11,10,'payment.initiated','flutterwave','FLUTTERWAVE-DMJ2YYS5EBBQOEWFTB',2500.00,'USD',NULL,'initiated',NULL,'127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36','{\"provider\":\"flutterwave\",\"amount\":\"2500.00\",\"currency\":\"USD\",\"timestamp\":\"2026-07-30T07:40:13+00:00\"}','2026-07-30 11:40:13','2026-07-30 11:40:13'),(12,10,'payment.checkout_failed','flutterwave','FLUTTERWAVE-DMJ2YYS5EBBQOEWFTB',2500.00,'USD','initiated','failed',NULL,'127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36','{\"error\":\"Payment initialization failed: Invalid authorization key\",\"timestamp\":\"2026-07-30T07:40:15+00:00\"}','2026-07-30 11:40:15','2026-07-30 11:40:15'),(13,11,'payment.initiated','paypal','PAYPAL-YU9I1ERZVYPJCCDJCD',2500.00,'USD',NULL,'initiated',NULL,'127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36','{\"provider\":\"paypal\",\"amount\":\"2500.00\",\"currency\":\"USD\",\"timestamp\":\"2026-07-30T07:40:27+00:00\"}','2026-07-30 11:40:27','2026-07-30 11:40:27'),(14,11,'payment.checkout_failed','paypal','PAYPAL-YU9I1ERZVYPJCCDJCD',2500.00,'USD','initiated','failed',NULL,'127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36','{\"error\":\"Failed to authenticate with PayPal.\",\"timestamp\":\"2026-07-30T07:40:30+00:00\"}','2026-07-30 11:40:30','2026-07-30 11:40:30'),(15,12,'payment.initiated','paypal','PAYPAL-MWW34ZLKVT4JRBB1WZ',2500.00,'USD',NULL,'initiated',NULL,'127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36','{\"provider\":\"paypal\",\"amount\":\"2500.00\",\"currency\":\"USD\",\"timestamp\":\"2026-07-30T07:40:40+00:00\"}','2026-07-30 11:40:40','2026-07-30 11:40:40'),(16,12,'payment.checkout_failed','paypal','PAYPAL-MWW34ZLKVT4JRBB1WZ',2500.00,'USD','initiated','failed',NULL,'127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36','{\"error\":\"Failed to authenticate with PayPal.\",\"timestamp\":\"2026-07-30T07:40:42+00:00\"}','2026-07-30 11:40:42','2026-07-30 11:40:42'),(17,13,'payment.initiated','paypal','PAYPAL-CBNZNYDYCNYOJSZ8RL',2500.00,'USD',NULL,'initiated',NULL,'127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36','{\"provider\":\"paypal\",\"amount\":\"2500.00\",\"currency\":\"USD\",\"timestamp\":\"2026-07-30T07:40:49+00:00\"}','2026-07-30 11:40:49','2026-07-30 11:40:49'),(18,13,'payment.checkout_failed','paypal','PAYPAL-CBNZNYDYCNYOJSZ8RL',2500.00,'USD','initiated','failed',NULL,'127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36','{\"error\":\"Failed to authenticate with PayPal.\",\"timestamp\":\"2026-07-30T07:40:50+00:00\"}','2026-07-30 11:40:50','2026-07-30 11:40:50'),(19,14,'payment.initiated','stripe','STRIPE-TVGPIAMRHEPZXG8FDJ',2500.00,'USD',NULL,'initiated',NULL,'127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36','{\"provider\":\"stripe\",\"amount\":\"2500.00\",\"currency\":\"USD\",\"timestamp\":\"2026-07-30T07:40:58+00:00\"}','2026-07-30 11:40:58','2026-07-30 11:40:58'),(20,14,'payment.checkout_failed','stripe','STRIPE-TVGPIAMRHEPZXG8FDJ',2500.00,'USD','initiated','failed',NULL,'127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36','{\"error\":\"Failed to initialize Stripe checkout. Please try again.\",\"timestamp\":\"2026-07-30T07:41:00+00:00\"}','2026-07-30 11:41:00','2026-07-30 11:41:00'),(21,15,'payment.initiated','bank_transfer','BANK_TRANSFER-AQZQGP9JWCQLEUJ7J8',2500.00,'USD',NULL,'initiated',NULL,'127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36','{\"provider\":\"bank_transfer\",\"amount\":\"2500.00\",\"currency\":\"USD\",\"timestamp\":\"2026-07-30T07:41:17+00:00\"}','2026-07-30 11:41:17','2026-07-30 11:41:17'),(22,16,'payment.initiated','bank_transfer','BANK_TRANSFER-MYPFYFWESEPBKERVAP',1500.00,'USD',NULL,'initiated',NULL,'127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36','{\"provider\":\"bank_transfer\",\"amount\":\"1500.00\",\"currency\":\"USD\",\"timestamp\":\"2026-07-30T16:41:01+00:00\"}','2026-07-30 20:41:01','2026-07-30 20:41:01'),(23,17,'payment.initiated','bank_transfer','BANK_TRANSFER-ASXOPNSTU8NKXQHKPE',1600.00,'USD',NULL,'initiated',NULL,'127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0','{\"provider\":\"bank_transfer\",\"amount\":\"1600.00\",\"currency\":\"USD\",\"timestamp\":\"2026-07-30T17:44:04+00:00\"}','2026-07-30 21:44:04','2026-07-30 21:44:04'),(24,18,'payment.initiated','bank_transfer','BANK_TRANSFER-FSNSL1KGGMV6ATCMZS',1600.00,'USD',NULL,'initiated',NULL,'127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0','{\"provider\":\"bank_transfer\",\"amount\":\"1600.00\",\"currency\":\"USD\",\"timestamp\":\"2026-07-30T17:51:51+00:00\"}','2026-07-30 21:51:51','2026-07-30 21:51:51'),(25,19,'payment.initiated','bank_transfer','BANK_TRANSFER-D19XCZP40ZQMRBJEO7',1700.00,'USD',NULL,'initiated',NULL,'127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36','{\"provider\":\"bank_transfer\",\"amount\":\"1700.00\",\"currency\":\"USD\",\"timestamp\":\"2026-07-31T10:18:01+00:00\"}','2026-07-31 14:18:01','2026-07-31 14:18:01');
/*!40000 ALTER TABLE `payment_audit_logs` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `payment_proofs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `payment_proofs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `payment_request_id` bigint(20) unsigned NOT NULL,
  `payment_transaction_id` bigint(20) unsigned DEFAULT NULL,
  `tracking_number` varchar(255) NOT NULL,
  `payment_reference` varchar(255) NOT NULL,
  `file_path` varchar(255) NOT NULL,
  `file_hash` varchar(64) DEFAULT NULL,
  `file_type` varchar(20) NOT NULL,
  `file_size` bigint(20) unsigned NOT NULL DEFAULT 0,
  `original_filename` varchar(255) NOT NULL,
  `status` enum('pending','verified','rejected') NOT NULL DEFAULT 'pending',
  `verified_at` timestamp NULL DEFAULT NULL,
  `resubmission_requested_at` timestamp NULL DEFAULT NULL,
  `resubmission_reason` varchar(2000) DEFAULT NULL,
  `verified_by` bigint(20) unsigned DEFAULT NULL,
  `rejection_reason` text DEFAULT NULL,
  `internal_notes` text DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `payment_proofs_file_hash_unique` (`file_hash`),
  KEY `payment_proofs_tracking_number_index` (`tracking_number`),
  KEY `payment_proofs_payment_reference_index` (`payment_reference`),
  KEY `payment_proofs_status_index` (`status`),
  KEY `payment_proofs_payment_request_id_idx` (`payment_request_id`),
  KEY `payment_proofs_payment_transaction_id_idx` (`payment_transaction_id`),
  KEY `payment_proofs_verified_by_idx` (`verified_by`),
  CONSTRAINT `payment_proofs_payment_request_id_foreign` FOREIGN KEY (`payment_request_id`) REFERENCES `payment_requests` (`id`) ON DELETE CASCADE,
  CONSTRAINT `payment_proofs_payment_transaction_id_foreign` FOREIGN KEY (`payment_transaction_id`) REFERENCES `payment_transactions` (`id`) ON DELETE SET NULL,
  CONSTRAINT `payment_proofs_verified_by_foreign` FOREIGN KEY (`verified_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `payment_proofs` WRITE;
/*!40000 ALTER TABLE `payment_proofs` DISABLE KEYS */;
/*!40000 ALTER TABLE `payment_proofs` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `payment_requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `payment_requests` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `shipment_id` bigint(20) unsigned NOT NULL,
  `title` varchar(180) NOT NULL,
  `category` varchar(80) DEFAULT NULL,
  `priority` varchar(10) NOT NULL DEFAULT 'normal',
  `reason` text NOT NULL,
  `description` text DEFAULT NULL,
  `amount` decimal(12,2) NOT NULL,
  `currency` varchar(8) NOT NULL DEFAULT 'USD',
  `requested_method` varchar(255) DEFAULT NULL,
  `status` varchar(30) NOT NULL DEFAULT 'payment_required',
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `is_archived` tinyint(1) NOT NULL DEFAULT 0,
  `secure_token` varchar(96) NOT NULL,
  `due_at` timestamp NULL DEFAULT NULL,
  `paid_at` timestamp NULL DEFAULT NULL,
  `verified_at` timestamp NULL DEFAULT NULL,
  `created_by` bigint(20) unsigned DEFAULT NULL,
  `verified_by` bigint(20) unsigned DEFAULT NULL,
  `metadata` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`metadata`)),
  `internal_notes` text DEFAULT NULL,
  `payment_instructions` text DEFAULT NULL,
  `payment_reference` varchar(255) DEFAULT NULL,
  `duplicated_from_id` bigint(20) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `payment_requests_new_secure_token_unique` (`secure_token`),
  KEY `payment_requests_new_currency_index` (`currency`),
  KEY `payment_requests_new_requested_method_index` (`requested_method`),
  KEY `payment_requests_new_status_index` (`status`),
  KEY `payment_requests_new_payment_reference_index` (`payment_reference`),
  KEY `payment_requests_shipment_id_idx` (`shipment_id`),
  KEY `payment_requests_created_by_idx` (`created_by`),
  KEY `payment_requests_verified_by_idx` (`verified_by`),
  CONSTRAINT `payment_requests_new_created_by_foreign` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `payment_requests_new_shipment_id_foreign` FOREIGN KEY (`shipment_id`) REFERENCES `shipments` (`id`) ON DELETE CASCADE,
  CONSTRAINT `payment_requests_new_verified_by_foreign` FOREIGN KEY (`verified_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `payment_requests` WRITE;
/*!40000 ALTER TABLE `payment_requests` DISABLE KEYS */;
INSERT INTO `payment_requests` VALUES (7,2,'Customs fees clearance','Custom','normal','Customs fees clearance need to be paid',NULL,2000.00,'USD','bank_transfer','payment_required',1,0,'TdRDmf60RXgDASOkBoJrpRjd0IN2N7QQyhIuSHEs7lLxmMY8S8CuzSQbTNgMdwUm',NULL,NULL,NULL,1,NULL,'{\"allowed_methods\":[\"bank_transfer\"]}',NULL,NULL,NULL,NULL,'2026-07-30 11:11:26','2026-07-30 11:38:41'),(9,2,'shimpment fees','shipment','normal','shipment fees need to be paid',NULL,1500.00,'USD','bank_transfer','payment_initiated',1,0,'1zalRo3Hx5HUKNiAtvwLh7C7CCq1wxoKgw0N2B5krPgd17jSbBge6zifa0LJcSd1',NULL,NULL,NULL,1,NULL,'{\"allowed_methods\":[\"bank_transfer\"]}',NULL,NULL,'PAY-2AMEVJ-WYTN',NULL,'2026-07-30 11:18:57','2026-07-30 20:41:01'),(11,4,'Clearance','Clearance','normal','Clearance need to be paid',NULL,1500.00,'USD',NULL,'paid',1,0,'U9Se9ZavlMVKGODH5TJLJCRJmF4RCwlVJF8D970hBxUXur66qZV2yGn4PexDFXfJ',NULL,NULL,NULL,1,NULL,'[]',NULL,NULL,NULL,NULL,'2026-07-30 20:33:28','2026-07-31 14:06:05'),(12,155,'Customs','Customer','normal','the custom fee needs to be paid',NULL,1600.00,'USD',NULL,'payment_initiated',1,0,'wxZ6gX67rPCsoRUOAgvPl95GkqtOGmcqM3d1kI2Kb4JE3Enh2K7aOH9xddtahD3M',NULL,NULL,NULL,1,NULL,'[]',NULL,NULL,'PAY-KGYKIL-EAIY',NULL,'2026-07-30 21:39:03','2026-07-30 21:51:51'),(13,406,'Clearance fees','Clearance','normal','clearance fees need to to be paid',NULL,1700.00,'USD',NULL,'payment_initiated',1,0,'vsD9j99YMQmXGrKSM8iGV8BFbSWkJ06ItuiE1F80WCg33Z3vS0hqgfI2z7D200cH',NULL,NULL,NULL,1,NULL,'[]',NULL,NULL,'PAY-0JGLSU-LDYE',NULL,'2026-07-31 14:15:45','2026-07-31 14:18:01');
/*!40000 ALTER TABLE `payment_requests` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `payment_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `payment_settings` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `gateway_name` varchar(255) NOT NULL,
  `api_key` text DEFAULT NULL,
  `secret_key` text DEFAULT NULL,
  `public_key` text DEFAULT NULL,
  `webhook_secret` text DEFAULT NULL,
  `encryption_key` text DEFAULT NULL,
  `environment_credentials` text DEFAULT NULL,
  `webhook_url` varchar(255) DEFAULT NULL,
  `merchant_name` varchar(255) DEFAULT NULL,
  `processing_fee_percent` decimal(5,2) NOT NULL DEFAULT 0.00,
  `fixed_fee` decimal(10,2) NOT NULL DEFAULT 0.00,
  `min_amount` decimal(12,2) DEFAULT NULL,
  `max_amount` decimal(12,2) DEFAULT NULL,
  `supported_currencies` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`supported_currencies`)),
  `config` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`config`)),
  `mode` enum('test','live') NOT NULL DEFAULT 'test',
  `currency` varchar(8) NOT NULL DEFAULT 'USD',
  `is_active` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `payment_settings_gateway_name_unique` (`gateway_name`),
  KEY `payment_settings_mode_index` (`mode`),
  KEY `payment_settings_currency_index` (`currency`),
  KEY `payment_settings_is_active_index` (`is_active`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `payment_settings` WRITE;
/*!40000 ALTER TABLE `payment_settings` DISABLE KEYS */;
INSERT INTO `payment_settings` VALUES (1,'flutterwave','eyJpdiI6IkFTKzRqUjVBOEJobzBZL1lxcjBQeUE9PSIsInZhbHVlIjoiL3VTZGVEU3pvN3RQSGJaNzc1eDdCbzVEelpBYXlOTW91UDlIR1BibjBQZz0iLCJtYWMiOiI5NjVhZWM1ZjcyZGQ4NzhmYzJlNDNjODVjOWRmODNhNzlhZWVlNjFiMmMyOWVlMTlmNGQ1NDViNWE4OTNkN2I2IiwidGFnIjoiIn0=','eyJpdiI6IkdadHdUZzBETU5kbWd5OXpleFo3S2c9PSIsInZhbHVlIjoiNGZVemQ2endpWEFIc3A2SVZHcmFyalR0OUR1V3FsdWQ2ckg5Q1dQQU45ST0iLCJtYWMiOiJlYWUyZTE2NzA4YmE5ODgyYzk5N2RlNjVhYzkwODA0YzNlNjU5NjNlNzVjMDkyMWFlMWE5MmM3ODg4MmU4ZjMxIiwidGFnIjoiIn0=','eyJpdiI6IlFDK1JBa2lGazg0M21LWS9XaWNBYnc9PSIsInZhbHVlIjoiQkordzR6T0hxK3dEVCtMRm1QcW94c3REOXJza1lMaFpjVFB5SitBK3d0UT0iLCJtYWMiOiJmNzU2ODZjYzYxYWIyMmUxZTI2MDYyYmU3MDZkYTA5ODE4MWE1MmUzNTE5ODRlODk5MzM0NDJjZDM1MjExMTE0IiwidGFnIjoiIn0=','eyJpdiI6IjFxUHgxZkUrQ01keG94Q3pOM3o2L1E9PSIsInZhbHVlIjoia3JHZmcvUCtBZFRMUldVTWsxbnFZZnpnNXpIdmZXMnIzcUp4K2d4VEVFYz0iLCJtYWMiOiI3N2ZmYWRhOTc3NDM1NzQ4NWExMjEzOTI4NDQ3YTNjNjdhNjA4NjdjNDBlMDU0YTZjNjA3MjM1NDRlYjQyYzIxIiwidGFnIjoiIn0=','eyJpdiI6IjNCbEF2NHpGRlBSMXR4dE1Dek9LUmc9PSIsInZhbHVlIjoiUWMzWFZCKzJwZVU3dkovRzhoUlVUY0lXRmNDK0tNMFMzYjRXRjdhVXZzR0Y3NGk3Z1Z2SG8wRFBFdVBpbFNVaiIsIm1hYyI6IjdiOTFjMTA4YWNmNTYzYmRmZDJiYjdiZmVhYzZkZGJmY2RmMjMyNmYxNzA1ZmIxZmFkMTYxYjZjYmI3NzIwZWMiLCJ0YWciOiIifQ==',NULL,NULL,NULL,1.40,0.00,NULL,NULL,NULL,NULL,'test','USD',1,'2026-07-30 02:13:26','2026-07-30 02:14:51'),(2,'stripe','eyJpdiI6IjYvWFg3cUVkelFjdVRDckNWYno5VlE9PSIsInZhbHVlIjoidEdsL05HQ29lVGRqZFJpa2YyYXk3UT09IiwibWFjIjoiZjNiYTUyZTQ5ZTJhMDZlYzI0YjMzYmIyN2Y0NjU3ODliMGM1ZmZlZjMyOGMxMGMwY2I1NWNjNDAxMjVhNDVhMSIsInRhZyI6IiJ9','eyJpdiI6InBsU1pmSjFaVFViKzZTamNDMzdGcFE9PSIsInZhbHVlIjoiekV2QmpISlZDNWlYYXVLYlFGVXNtdz09IiwibWFjIjoiYjM1NjhhMWRkZDE5ZGI3YmNkYzQyYjM0MDRjNWE4ZWJlZjQ4NDY3ZTRmOGUyNTRlOTRjZDhiZGZlMWY5ZTI2YSIsInRhZyI6IiJ9','eyJpdiI6IlpKU0ZmMDhwMFMxSXNzZHZiSWUrMlE9PSIsInZhbHVlIjoiRkF1dkVHcVlHL2xmK01xUExqRzd6dz09IiwibWFjIjoiYTFkNDEzZmE5ZDEzZDQwMGI2ODFjYzY1ZGY4ZDJiYzI2OGYxMGY5M2RiZDdiYTExZWI4MGZlYjVmYzRlZDZiNCIsInRhZyI6IiJ9',NULL,NULL,NULL,NULL,NULL,2.90,0.30,NULL,NULL,NULL,NULL,'test','USD',1,'2026-07-30 02:13:26','2026-07-30 11:16:15'),(3,'paypal','eyJpdiI6IkoyaU9BUmZlTVRjMVMzc1djTW95RVE9PSIsInZhbHVlIjoiZ0tiZjE1Z0VGTWdEdy9PdllTT2ZVQT09IiwibWFjIjoiMDJmMTBlMDdmNjIyN2Q4NzIwMTExNWNhMjlkYzA0MjQ4ZWQ1YzQ4MWQ3OTI0ZDk1NjhkMTdjODIzOTY3YzZiNiIsInRhZyI6IiJ9','eyJpdiI6IjhOeTVlS2czM2UySUJlYW9xaWY4QXc9PSIsInZhbHVlIjoidmhqN1VWaExhejdnMmtNbFR3cXhWdz09IiwibWFjIjoiODAxN2M0MmQyMTRlMjY1NmIyZDhjODM4YjUxMDQwMGQxODEwNDhmZGQ2OGFhMWM1ZmQ5ODYwOWJmZDc0NjBjMiIsInRhZyI6IiJ9',NULL,NULL,NULL,NULL,NULL,NULL,3.49,0.49,NULL,NULL,NULL,NULL,'test','USD',1,'2026-07-30 02:13:26','2026-07-30 02:13:26'),(4,'bank_transfer',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,NULL,NULL,NULL,'{\"bank_name\":\"Test Bank\",\"account_name\":\"FreightFlow Inc\",\"account_number\":\"1234567890\",\"routing_number\":\"021000021\",\"swift_code\":\"TESTUS66\",\"payment_instructions\":\"Include reference in description.\"}','test','USD',1,'2026-07-30 02:13:26','2026-07-30 02:13:26'),(5,'crypto','eyJpdiI6Imc0anFkUE1velBJTTBKbjVnUDJ2MVE9PSIsInZhbHVlIjoiUTFFSVZiOC93RU5VaklDa2xacUpPQT09IiwibWFjIjoiMjA3ODllYTk0NzE0ZWZhZjg4MTVmMTIwZTVhYjA4NDg5NTJjYmZhNzY4OGVmZGUzNzQxOWYyYTU5MTE0Yjc1YiIsInRhZyI6IiJ9',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,NULL,NULL,NULL,'{\"provider\":\"nowpayments\",\"preferred_coin\":\"btc\"}','test','USD',1,'2026-07-30 02:13:26','2026-07-30 02:13:26');
/*!40000 ALTER TABLE `payment_settings` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `payment_transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `payment_transactions` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `payment_request_id` bigint(20) unsigned NOT NULL,
  `provider` varchar(80) NOT NULL,
  `provider_reference` varchar(255) DEFAULT NULL,
  `amount` decimal(12,2) NOT NULL,
  `currency` varchar(8) NOT NULL DEFAULT 'USD',
  `fee_amount` decimal(10,2) DEFAULT NULL,
  `net_amount` decimal(12,2) DEFAULT NULL,
  `status` enum('initiated','pending','paid','verified','failed','cancelled') NOT NULL DEFAULT 'initiated',
  `provider_payload` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`provider_payload`)),
  `metadata` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`metadata`)),
  `verified_at` timestamp NULL DEFAULT NULL,
  `webhook_received_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `payment_transactions_provider_index` (`provider`),
  KEY `payment_transactions_provider_reference_index` (`provider_reference`),
  KEY `payment_transactions_status_index` (`status`),
  KEY `payment_transactions_payment_request_id_idx` (`payment_request_id`),
  CONSTRAINT `payment_transactions_payment_request_id_foreign` FOREIGN KEY (`payment_request_id`) REFERENCES `payment_requests` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `payment_transactions` WRITE;
/*!40000 ALTER TABLE `payment_transactions` DISABLE KEYS */;
INSERT INTO `payment_transactions` VALUES (8,9,'bank_transfer','PAY-2AMEVJ-43I1',1500.00,'USD',0.00,1500.00,'pending','{\"mode\":\"manual\",\"fee_percentage\":0,\"fixed_fee\":0,\"bank_account_id\":1,\"bank_name\":\"First National Bank\",\"account_name\":\"FreightFlow Logistics Inc.\",\"account_number\":\"1234567890\",\"swift_bic\":\"FNBBUS33\",\"iban\":\"US1234567890123456789012\",\"routing_number\":\"021000021\",\"payment_instructions\":\"Include your payment reference in the transfer description.\",\"note\":\"Manual bank transfer. Awaiting proof of payment and admin verification.\"}',NULL,NULL,NULL,'2026-07-30 11:31:00','2026-07-30 11:31:00'),(16,9,'bank_transfer','PAY-2AMEVJ-WYTN',1500.00,'USD',0.00,1500.00,'pending','{\"mode\":\"manual\",\"fee_percentage\":0,\"fixed_fee\":0,\"bank_account_id\":1,\"bank_name\":\"First National Bank\",\"account_name\":\"FreightFlow Logistics Inc.\",\"account_number\":\"1234567890\",\"swift_bic\":\"FNBBUS33\",\"iban\":\"US1234567890123456789012\",\"routing_number\":\"021000021\",\"payment_instructions\":\"Include your payment reference in the transfer description.\",\"note\":\"Manual bank transfer. Awaiting proof of payment and admin verification.\"}',NULL,NULL,NULL,'2026-07-30 20:41:01','2026-07-30 20:41:01'),(17,12,'bank_transfer','PAY-KGYKIL-B9QN',1600.00,'USD',0.00,1600.00,'pending','{\"mode\":\"manual\",\"fee_percentage\":0,\"fixed_fee\":0,\"bank_account_id\":1,\"bank_name\":\"First National Bank\",\"account_name\":\"FreightFlow Logistics Inc.\",\"account_number\":\"1234567890\",\"swift_bic\":\"FNBBUS33\",\"iban\":\"US1234567890123456789012\",\"routing_number\":\"21000021\",\"payment_instructions\":\"Include your payment reference in the transfer description.\",\"note\":\"Manual bank transfer. Awaiting proof of payment and admin verification.\"}',NULL,NULL,NULL,'2026-07-30 21:44:04','2026-07-30 21:44:04'),(18,12,'bank_transfer','PAY-KGYKIL-EAIY',1600.00,'USD',0.00,1600.00,'pending','{\"mode\":\"manual\",\"fee_percentage\":0,\"fixed_fee\":0,\"bank_account_id\":1,\"bank_name\":\"First National Bank\",\"account_name\":\"FreightFlow Logistics Inc.\",\"account_number\":\"1234567890\",\"swift_bic\":\"FNBBUS33\",\"iban\":\"US1234567890123456789012\",\"routing_number\":\"21000021\",\"payment_instructions\":\"Include your payment reference in the transfer description.\",\"note\":\"Manual bank transfer. Awaiting proof of payment and admin verification.\"}',NULL,NULL,NULL,'2026-07-30 21:51:51','2026-07-30 21:51:51'),(19,13,'bank_transfer','PAY-0JGLSU-LDYE',1700.00,'USD',0.00,1700.00,'pending','{\"mode\":\"manual\",\"fee_percentage\":0,\"fixed_fee\":0,\"bank_account_id\":1,\"bank_name\":\"First National Bank\",\"account_name\":\"FreightFlow Logistics Inc.\",\"account_number\":\"1234567890\",\"swift_bic\":\"FNBBUS33\",\"iban\":\"US1234567890123456789012\",\"routing_number\":\"21000021\",\"payment_instructions\":\"Include your payment reference in the transfer description.\",\"note\":\"Manual bank transfer. Awaiting proof of payment and admin verification.\"}',NULL,NULL,NULL,'2026-07-31 14:18:01','2026-07-31 14:18:01');
/*!40000 ALTER TABLE `payment_transactions` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `payments` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `shipment_id` bigint(20) unsigned NOT NULL,
  `stage` tinyint(3) unsigned NOT NULL,
  `label` varchar(255) NOT NULL,
  `percentage` decimal(5,2) NOT NULL DEFAULT 20.00,
  `amount` decimal(12,2) NOT NULL,
  `status` enum('locked','pending','checkout_created','paid','verified','failed','rejected','refunded') NOT NULL DEFAULT 'locked',
  `provider` varchar(255) DEFAULT NULL,
  `provider_reference` varchar(255) DEFAULT NULL,
  `paid_at` timestamp NULL DEFAULT NULL,
  `unlocked_at` timestamp NULL DEFAULT NULL,
  `verified_at` timestamp NULL DEFAULT NULL,
  `verified_by` bigint(20) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `payments_shipment_id_stage_unique` (`shipment_id`,`stage`),
  KEY `payments_status_index` (`status`),
  KEY `payments_verified_by_idx` (`verified_by`),
  KEY `payments_shipment_id_stage_idx` (`shipment_id`,`stage`),
  CONSTRAINT `payments_shipment_id_foreign` FOREIGN KEY (`shipment_id`) REFERENCES `shipments` (`id`) ON DELETE CASCADE,
  CONSTRAINT `payments_verified_by_foreign` FOREIGN KEY (`verified_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=71 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `payments` WRITE;
/*!40000 ALTER TABLE `payments` DISABLE KEYS */;
INSERT INTO `payments` VALUES (6,2,1,'Booking Deposit',20.00,54.81,'pending',NULL,NULL,NULL,'2026-07-30 10:48:21',NULL,NULL,'2026-07-30 10:48:21','2026-07-30 10:48:21'),(7,2,2,'Pickup Confirmation',20.00,54.81,'verified',NULL,NULL,NULL,NULL,'2026-07-30 10:51:55',1,'2026-07-30 10:48:21','2026-07-30 10:51:55'),(8,2,3,'International Processing',20.00,54.81,'locked',NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-30 10:48:21','2026-07-30 10:48:21'),(9,2,4,'Destination Hub Processing',20.00,54.81,'locked',NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-30 10:48:21','2026-07-30 10:48:21'),(10,2,5,'Final Delivery Release',20.00,54.81,'locked',NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-30 10:48:21','2026-07-30 10:48:21'),(11,3,1,'Booking Deposit',20.00,81.58,'pending',NULL,NULL,NULL,'2026-07-30 17:19:10',NULL,NULL,'2026-07-30 17:19:10','2026-07-30 17:19:10'),(12,3,2,'Pickup Confirmation',20.00,81.58,'locked',NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-30 17:19:10','2026-07-30 17:19:10'),(13,3,3,'International Processing',20.00,81.58,'locked',NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-30 17:19:10','2026-07-30 17:19:10'),(14,3,4,'Destination Hub Processing',20.00,81.58,'locked',NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-30 17:19:10','2026-07-30 17:19:10'),(15,3,5,'Final Delivery Release',20.00,81.58,'locked',NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-30 17:19:10','2026-07-30 17:19:10'),(16,4,1,'Booking Deposit',20.00,86.23,'pending',NULL,NULL,NULL,'2026-07-30 20:29:57',NULL,NULL,'2026-07-30 20:29:57','2026-07-30 20:29:57'),(17,4,2,'Pickup Confirmation',20.00,86.23,'locked',NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-30 20:29:57','2026-07-30 20:29:57'),(18,4,3,'International Processing',20.00,86.23,'locked',NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-30 20:29:57','2026-07-30 20:29:57'),(19,4,4,'Destination Hub Processing',20.00,86.23,'locked',NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-30 20:29:57','2026-07-30 20:29:57'),(20,4,5,'Final Delivery Release',20.00,86.23,'locked',NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-30 20:29:57','2026-07-30 20:29:57'),(36,155,1,'Booking Deposit',20.00,33.79,'pending',NULL,NULL,NULL,'2026-07-30 21:34:30',NULL,NULL,'2026-07-30 21:34:30','2026-07-30 21:34:30'),(37,155,2,'Pickup Confirmation',20.00,33.79,'locked',NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-30 21:34:30','2026-07-30 21:34:30'),(38,155,3,'International Processing',20.00,33.79,'locked',NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-30 21:34:30','2026-07-30 21:34:30'),(39,155,4,'Destination Hub Processing',20.00,33.79,'locked',NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-30 21:34:30','2026-07-30 21:34:30'),(40,155,5,'Final Delivery Release',20.00,33.79,'locked',NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-30 21:34:30','2026-07-30 21:34:30'),(66,406,1,'Booking Deposit',20.00,24.95,'pending',NULL,NULL,NULL,'2026-07-31 13:34:33',NULL,NULL,'2026-07-31 13:34:33','2026-07-31 13:34:33'),(67,406,2,'Pickup Confirmation',20.00,24.95,'locked',NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-31 13:34:33','2026-07-31 13:34:33'),(68,406,3,'International Processing',20.00,24.95,'locked',NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-31 13:34:33','2026-07-31 13:34:33'),(69,406,4,'Destination Hub Processing',20.00,24.95,'locked',NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-31 13:34:33','2026-07-31 13:34:33'),(70,406,5,'Final Delivery Release',20.00,24.95,'locked',NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-31 13:34:33','2026-07-31 13:34:33');
/*!40000 ALTER TABLE `payments` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `personal_access_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `tokenable_type` varchar(255) NOT NULL,
  `tokenable_id` bigint(20) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `token` varchar(64) NOT NULL,
  `abilities` text DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `personal_access_tokens` WRITE;
/*!40000 ALTER TABLE `personal_access_tokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `personal_access_tokens` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `shipment_attachments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `shipment_attachments` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `shipment_id` bigint(20) unsigned NOT NULL,
  `uploaded_by` bigint(20) unsigned NOT NULL,
  `category` varchar(255) NOT NULL DEFAULT 'additional_document',
  `original_name` varchar(255) NOT NULL,
  `stored_name` varchar(255) NOT NULL,
  `disk` varchar(255) NOT NULL DEFAULT 'public',
  `path` varchar(255) NOT NULL,
  `mime_type` varchar(255) DEFAULT NULL,
  `size_bytes` bigint(20) unsigned NOT NULL DEFAULT 0,
  `metadata` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`metadata`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `shipment_attachments_shipment_id_category_index` (`shipment_id`,`category`),
  KEY `shipment_attachments_category_index` (`category`),
  KEY `shipment_attachments_uploaded_by_idx` (`uploaded_by`),
  CONSTRAINT `shipment_attachments_shipment_id_foreign` FOREIGN KEY (`shipment_id`) REFERENCES `shipments` (`id`) ON DELETE CASCADE,
  CONSTRAINT `shipment_attachments_uploaded_by_foreign` FOREIGN KEY (`uploaded_by`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `shipment_attachments` WRITE;
/*!40000 ALTER TABLE `shipment_attachments` DISABLE KEYS */;
INSERT INTO `shipment_attachments` VALUES (1,4,1,'package_image','ritaClerances.PNG','PF69jeU6ecDRE69HZL3UjBYUERxXZxVID2Srk2xY.png','public','shipment-attachments/4/PF69jeU6ecDRE69HZL3UjBYUERxXZxVID2Srk2xY.png','image/png',20346,'{\"visible_to_customer\":true}','2026-07-30 20:29:57','2026-07-30 20:29:57'),(17,155,1,'package_image','ritaClerances.PNG','csmnHDttIJmep5Jm9aKJ3I1O2iqSfCblN66D9hy4.png','public','shipment-attachments/155/csmnHDttIJmep5Jm9aKJ3I1O2iqSfCblN66D9hy4.png','image/png',20346,'{\"visible_to_customer\":true}','2026-07-30 21:34:30','2026-07-30 21:34:30'),(43,406,1,'package_image','ritaClerances.PNG','66VZhOEoXDFeJnmwYXdX0EhhX7oj8IUN0uC2LcQ7.png','public','shipment-attachments/406/66VZhOEoXDFeJnmwYXdX0EhhX7oj8IUN0uC2LcQ7.png','image/png',20346,'{\"visible_to_customer\":true}','2026-07-31 13:34:34','2026-07-31 13:34:34');
/*!40000 ALTER TABLE `shipment_attachments` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `shipment_drafts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `shipment_drafts` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `admin_user_id` bigint(20) unsigned NOT NULL,
  `customer_user_id` bigint(20) unsigned DEFAULT NULL,
  `last_step` tinyint(3) unsigned NOT NULL DEFAULT 1,
  `payload` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`payload`)),
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `shipment_drafts_admin_user_id_unique` (`admin_user_id`),
  KEY `shipment_drafts_customer_user_id_foreign` (`customer_user_id`),
  KEY `shipment_drafts_updated_at_index` (`updated_at`),
  CONSTRAINT `shipment_drafts_admin_user_id_foreign` FOREIGN KEY (`admin_user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `shipment_drafts_customer_user_id_foreign` FOREIGN KEY (`customer_user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `shipment_drafts` WRITE;
/*!40000 ALTER TABLE `shipment_drafts` DISABLE KEYS */;
/*!40000 ALTER TABLE `shipment_drafts` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `shipment_route_points`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `shipment_route_points` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `shipment_id` bigint(20) unsigned NOT NULL,
  `sort_order` smallint(5) unsigned NOT NULL DEFAULT 0,
  `type` enum('origin','facility','checkpoint','customs','destination') NOT NULL DEFAULT 'checkpoint',
  `label` varchar(160) NOT NULL,
  `location` varchar(255) NOT NULL,
  `latitude` decimal(10,7) DEFAULT NULL,
  `longitude` decimal(10,7) DEFAULT NULL,
  `country_code` varchar(2) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `arrived_at` timestamp NULL DEFAULT NULL,
  `departed_at` timestamp NULL DEFAULT NULL,
  `created_by` bigint(20) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `shipment_route_points_created_by_foreign` (`created_by`),
  KEY `shipment_route_points_shipment_id_sort_order_index` (`shipment_id`,`sort_order`),
  KEY `shipment_route_points_sort_order_index` (`sort_order`),
  KEY `shipment_route_points_type_index` (`type`),
  CONSTRAINT `shipment_route_points_created_by_foreign` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `shipment_route_points_shipment_id_foreign` FOREIGN KEY (`shipment_id`) REFERENCES `shipments` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `shipment_route_points` WRITE;
/*!40000 ALTER TABLE `shipment_route_points` DISABLE KEYS */;
INSERT INTO `shipment_route_points` VALUES (1,2,1,'origin','Origin','Manchester, United Kingdom (GB)',NULL,NULL,'Un','Shipment origin.',NULL,NULL,1,'2026-07-30 10:48:21','2026-07-30 10:48:21'),(2,2,100,'destination','Destination','Nairobi, Kenya (KE)',-1.3015643,36.8128437,'Ke','Shipment destination',NULL,NULL,1,'2026-07-30 10:48:21','2026-07-30 10:50:33'),(3,3,1,'origin','Origin','New York, United States (US)',41.9410874,-74.0477648,'Un','Shipment origin',NULL,NULL,1,'2026-07-30 17:19:10','2026-07-30 17:21:17'),(4,3,100,'destination','Destination','Mumbai, India (IN)',19.0760000,72.8777000,'In','Shipment destination',NULL,NULL,1,'2026-07-30 17:19:10','2026-07-30 17:21:17'),(5,4,1,'origin','Origin','New York, United States (US)',41.9410874,-74.0477648,'Un','Shipment origin',NULL,NULL,1,'2026-07-30 20:29:57','2026-07-30 20:31:10'),(6,4,100,'destination','Destination','Los Angeles, United States (US)',34.1460850,-118.1301520,'Un','Shipment destination',NULL,NULL,1,'2026-07-30 20:29:57','2026-07-30 20:31:10'),(19,155,1,'origin','Origin','Dubai, United Arab Emirates (AE)',NULL,NULL,'Un','Shipment origin.',NULL,NULL,1,'2026-07-30 21:34:30','2026-07-30 21:34:30'),(20,155,100,'destination','Destination','Toronto, Canada (CA)',43.6532000,-79.3832000,'Ca','Shipment destination',NULL,NULL,1,'2026-07-30 21:34:30','2026-07-30 21:36:29'),(41,406,1,'origin','Origin','Chicago, United States (US)',NULL,NULL,'Un','Shipment origin.',NULL,NULL,1,'2026-07-31 13:34:33','2026-07-31 13:34:33'),(42,406,100,'destination','Destination','Sydney, Australia (AU)',-33.8927157,151.2277942,'Au','Shipment destination',NULL,NULL,1,'2026-07-31 13:34:33','2026-07-31 13:38:10');
/*!40000 ALTER TABLE `shipment_route_points` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `shipment_schedules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `shipment_schedules` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `shipment_id` bigint(20) unsigned NOT NULL,
  `type` enum('pickup','delivery') NOT NULL,
  `window_start` timestamp NULL DEFAULT NULL,
  `window_end` timestamp NULL DEFAULT NULL,
  `address` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`address`)),
  `instructions` text DEFAULT NULL,
  `status` enum('scheduled','confirmed','completed','missed','cancelled') NOT NULL DEFAULT 'scheduled',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `shipment_schedules_shipment_id_foreign` (`shipment_id`),
  KEY `shipment_schedules_type_index` (`type`),
  CONSTRAINT `shipment_schedules_shipment_id_foreign` FOREIGN KEY (`shipment_id`) REFERENCES `shipments` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `shipment_schedules` WRITE;
/*!40000 ALTER TABLE `shipment_schedules` DISABLE KEYS */;
/*!40000 ALTER TABLE `shipment_schedules` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `shipments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `shipments` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned NOT NULL,
  `driver_id` bigint(20) unsigned DEFAULT NULL,
  `warehouse_id` bigint(20) unsigned DEFAULT NULL,
  `tracking_number` varchar(255) DEFAULT NULL,
  `status` enum('shipment_requested','admin_review','approved','rejected','booked','pickup_scheduled','picked_up','warehouse_processing','international_processing','destination_hub','out_for_delivery','delivered','paused','exception','cancelled') NOT NULL DEFAULT 'shipment_requested',
  `service_level` varchar(255) NOT NULL,
  `sender_name` varchar(255) NOT NULL,
  `recipient_name` varchar(255) NOT NULL,
  `origin_address` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`origin_address`)),
  `destination_address` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`destination_address`)),
  `weight_kg` decimal(10,2) NOT NULL,
  `declared_value` decimal(12,2) NOT NULL DEFAULT 0.00,
  `quoted_amount` decimal(12,2) NOT NULL DEFAULT 0.00,
  `estimated_delivery_at` timestamp NULL DEFAULT NULL,
  `delivered_at` timestamp NULL DEFAULT NULL,
  `metadata` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`metadata`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `shipments_tracking_number_unique` (`tracking_number`),
  KEY `shipments_user_id_status_index` (`user_id`,`status`),
  KEY `shipments_status_index` (`status`),
  KEY `shipments_service_level_index` (`service_level`),
  KEY `shipments_driver_id_idx` (`driver_id`),
  KEY `shipments_warehouse_id_idx` (`warehouse_id`),
  CONSTRAINT `shipments_driver_id_foreign` FOREIGN KEY (`driver_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `shipments_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `shipments_warehouse_id_foreign` FOREIGN KEY (`warehouse_id`) REFERENCES `warehouses` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=407 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `shipments` WRITE;
/*!40000 ALTER TABLE `shipments` DISABLE KEYS */;
INSERT INTO `shipments` VALUES (2,1,NULL,NULL,'GEX-2026-4Z2AMEVJ','booked','domestic_express','Olga Rodriguez','Liam Moore','{\"address\":\"\",\"city\":\"Manchester\",\"state\":\"England\",\"country\":\"United Kingdom (GB)\",\"postal_code\":\"M1 1AE\"}','{\"address\":\"\",\"city\":\"Nairobi\",\"state\":\"Nairobi\",\"country\":\"Kenya (KE)\",\"postal_code\":\"00100\",\"latitude\":\"-1.3015643\",\"longitude\":\"36.8128437\"}',35.60,274.07,274.07,'2026-08-16 04:00:00',NULL,'{\"workflow\":{\"service_level\":\"domestic_express\",\"shipment_type\":\"express\",\"shipping_method\":\"ground\",\"priority\":\"high\"},\"costs\":{\"shipping_cost\":245.08,\"handling_fee\":8.01,\"insurance_fee\":9.05,\"customs_fee\":6.98,\"tax\":4.95,\"discount\":0,\"additional_charges\":0,\"total_cost\":274.07,\"currency\":\"USD\"},\"package\":{\"type\":\"Parcel\",\"weight_kg\":8.9,\"length_cm\":16,\"width_cm\":58,\"height_cm\":19,\"quantity\":4,\"description\":\"Test parcel contents - auto-generated for testing\"},\"payment\":{\"method\":\"invoice\",\"status\":\"pending\"},\"sender\":{\"company\":\"FedExUS\",\"phone\":\"09034556432\",\"email\":\"rodriguez@gmail.com\"},\"receiver\":{\"company\":\"\",\"phone\":\"08775044232\",\"email\":\"liam@gmail.com\"},\"description\":\"\",\"priority\":\"\",\"cost\":{\"shipping_cost\":274.07,\"handling_fee\":0,\"insurance\":0,\"customs_fee\":0,\"tax\":0,\"discount\":0,\"additional_charges\":0},\"packages\":[{\"package_type\":\"flower\",\"weight_kg\":\"35.60\",\"length_cm\":0,\"width_cm\":0,\"height_cm\":0,\"quantity\":1,\"description\":\"\"}]}','2026-07-30 10:48:21','2026-07-30 10:50:33'),(3,1,NULL,NULL,'GEX-2026-9INXWJA2','booked','domestic_express','Emma Williams','Lucia Johnson','{\"address\":\"\",\"city\":\"New York\",\"state\":\"New York\",\"country\":\"United States (US)\",\"postal_code\":\"10001\",\"latitude\":\"41.9410874\",\"longitude\":\"-74.0477648\"}','{\"address\":\"\",\"city\":\"Mumbai\",\"state\":\"Maharashtra\",\"country\":\"India (IN)\",\"postal_code\":\"400001\",\"latitude\":\"19.076\",\"longitude\":\"72.8777\"}',164.40,407.89,407.89,'2026-08-08 04:00:00',NULL,'{\"workflow\":{\"service_level\":\"domestic_express\",\"shipment_type\":\"international\",\"shipping_method\":\"air\",\"priority\":\"urgent\"},\"costs\":{\"shipping_cost\":370.96,\"handling_fee\":10.82,\"insurance_fee\":14.2,\"customs_fee\":8.53,\"tax\":3.38,\"discount\":0,\"additional_charges\":0,\"total_cost\":407.88999999999993,\"currency\":\"USD\"},\"package\":{\"type\":\"Pallet\",\"weight_kg\":41.1,\"length_cm\":35,\"width_cm\":52,\"height_cm\":29,\"quantity\":4,\"description\":\"Test parcel contents - auto-generated for testing\"},\"payment\":{\"method\":\"bank_transfer\",\"status\":\"pending\"},\"sender\":{\"company\":\"\",\"phone\":\"08078564546\",\"email\":\"emmal@gmail.com\"},\"receiver\":{\"company\":\"\",\"phone\":\"0807823456\",\"email\":\"johnson@gmail.com\"},\"description\":\"\",\"priority\":\"\",\"cost\":{\"shipping_cost\":407.89,\"handling_fee\":0,\"insurance\":0,\"customs_fee\":0,\"tax\":0,\"discount\":0,\"additional_charges\":0},\"packages\":[{\"package_type\":\"Document\",\"weight_kg\":\"164.40\",\"length_cm\":\"0\",\"width_cm\":\"0\",\"height_cm\":\"0\",\"quantity\":1,\"description\":\"\"}]}','2026-07-30 17:19:10','2026-07-30 20:07:14'),(4,1,NULL,NULL,'GEX-2026-6BDLZFR1','booked','freight','Aisha Gonzalez','Carlos Garcia','{\"address\":\"\",\"city\":\"New York\",\"state\":\"New York\",\"country\":\"United States (US)\",\"postal_code\":\"10001\",\"latitude\":\"41.9410874\",\"longitude\":\"-74.0477648\"}','{\"address\":\"\",\"city\":\"Los Angeles\",\"state\":\"California\",\"country\":\"United States (US)\",\"postal_code\":\"90001\",\"latitude\":\"34.146085\",\"longitude\":\"-118.130152\"}',147.20,431.13,431.13,'2026-08-09 04:00:00',NULL,'{\"workflow\":{\"service_level\":\"freight\",\"shipment_type\":\"domestic\",\"shipping_method\":\"sea\",\"priority\":\"standard\"},\"costs\":{\"shipping_cost\":385.69,\"handling_fee\":18.31,\"insurance_fee\":4.73,\"customs_fee\":17.76,\"tax\":4.64,\"discount\":0,\"additional_charges\":0,\"total_cost\":431.13,\"currency\":\"USD\"},\"package\":{\"type\":\"Parcel\",\"weight_kg\":18.4,\"length_cm\":19,\"width_cm\":51,\"height_cm\":57,\"quantity\":8,\"description\":\"Test parcel contents - auto-generated for testing\"},\"payment\":{\"method\":\"prepaid\",\"status\":\"pending\"},\"sender\":{\"company\":\"FedExUS\",\"phone\":\"0904567857\",\"email\":\"aisha@gmail.com\"},\"receiver\":{\"company\":\"\",\"phone\":\"090334556\",\"email\":\"carlos@gmail.com\"},\"description\":\"\",\"priority\":\"\",\"cost\":{\"shipping_cost\":431.13,\"handling_fee\":0,\"insurance\":0,\"customs_fee\":0,\"tax\":0,\"discount\":0,\"additional_charges\":0},\"packages\":[{\"package_type\":\"\",\"weight_kg\":\"147.20\",\"length_cm\":0,\"width_cm\":0,\"height_cm\":0,\"quantity\":1,\"description\":\"\"}]}','2026-07-30 20:29:57','2026-07-30 20:31:10'),(155,1,NULL,NULL,'GEX-2026-PNKGYKIL','booked','domestic_express','Ahmed Johnson','Diego Anderson','{\"address\":\"\",\"city\":\"Dubai\",\"state\":\"Dubai\",\"country\":\"United Arab Emirates (AE)\",\"postal_code\":\"00000\"}','{\"address\":\"\",\"city\":\"Toronto\",\"state\":\"Ontario\",\"country\":\"Canada (CA)\",\"postal_code\":\"M5H 2N2\",\"latitude\":\"43.6532\",\"longitude\":\"-79.3832\"}',382.40,168.94,168.94,'2026-08-17 04:00:00',NULL,'{\"workflow\":{\"service_level\":\"standard\",\"shipment_type\":\"domestic\",\"shipping_method\":\"air\",\"priority\":\"urgent\"},\"costs\":{\"shipping_cost\":152.21,\"handling_fee\":6.85,\"insurance_fee\":5.37,\"customs_fee\":0.31,\"tax\":4.2,\"discount\":0,\"additional_charges\":0,\"total_cost\":168.94,\"currency\":\"USD\"},\"package\":{\"type\":\"Tube\",\"weight_kg\":47.8,\"length_cm\":85,\"width_cm\":44,\"height_cm\":20,\"quantity\":8,\"description\":\"Test parcel contents - auto-generated for testing\"},\"payment\":{\"method\":\"prepaid\",\"status\":\"pending\"},\"sender\":{\"company\":\"Fedfxus\",\"phone\":\"0947333335\",\"email\":\"ahmed.johnson@company.com\"},\"receiver\":{\"company\":\"\",\"phone\":\"09948333445\",\"email\":\"diego@gmail.com\"},\"description\":\"\",\"priority\":\"\",\"cost\":{\"shipping_cost\":168.94,\"handling_fee\":0,\"insurance\":0,\"customs_fee\":0,\"tax\":0,\"discount\":0,\"additional_charges\":0},\"packages\":[{\"package_type\":\"\",\"weight_kg\":\"382.40\",\"length_cm\":0,\"width_cm\":0,\"height_cm\":0,\"quantity\":1,\"description\":\"\"}]}','2026-07-30 21:34:30','2026-07-30 21:36:29'),(406,1,NULL,NULL,'GEX-2026-XA0JGLSU','picked_up','international_priority','Ahmed Gonzalez','Olga Davis','{\"address\":\"\",\"city\":\"Chicago\",\"state\":\"Illinois\",\"country\":\"United States (US)\",\"postal_code\":\"60601\"}','{\"address\":\"\",\"city\":\"Sydney\",\"state\":\"New South Wales\",\"country\":\"Australia (AU)\",\"postal_code\":\"2000\",\"latitude\":\"-33.8927157\",\"longitude\":\"151.2277942\"}',168.80,124.74,124.74,'2026-08-11 04:00:00',NULL,'{\"workflow\":{\"service_level\":\"international_priority\",\"shipment_type\":\"domestic\",\"shipping_method\":\"air\",\"priority\":\"standard\"},\"costs\":{\"shipping_cost\":68.01,\"handling_fee\":26.87,\"insurance_fee\":5.13,\"customs_fee\":19.94,\"tax\":4.79,\"discount\":0,\"additional_charges\":0,\"total_cost\":124.74000000000001,\"currency\":\"USD\"},\"package\":{\"type\":\"Parcel\",\"weight_kg\":84.4,\"length_cm\":114,\"width_cm\":59,\"height_cm\":28,\"quantity\":2,\"description\":\"Test parcel contents - auto-generated for testing\"},\"payment\":{\"method\":\"prepaid\",\"status\":\"pending\"},\"sender\":{\"company\":\"FedExUS\",\"phone\":\"0904567895\",\"email\":\"ahemed@gmail.com\"},\"receiver\":{\"company\":\"\",\"phone\":\"09786655678\",\"email\":\"olga@gmail.com\"},\"description\":\"\",\"priority\":\"\",\"cost\":{\"shipping_cost\":124.74,\"handling_fee\":0,\"insurance\":0,\"customs_fee\":0,\"tax\":0,\"discount\":0,\"additional_charges\":0},\"packages\":[{\"package_type\":\"Document\",\"weight_kg\":\"168.80\",\"length_cm\":\"0\",\"width_cm\":\"0\",\"height_cm\":\"0\",\"quantity\":1,\"description\":\"\"}]}','2026-07-31 13:34:33','2026-07-31 13:42:37');
/*!40000 ALTER TABLE `shipments` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `support_tickets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `support_tickets` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned DEFAULT NULL,
  `shipment_id` bigint(20) unsigned DEFAULT NULL,
  `subject` varchar(255) NOT NULL,
  `category` enum('delivery','billing','customs','damage','account','other') NOT NULL DEFAULT 'other',
  `priority` enum('low','normal','high','urgent') NOT NULL DEFAULT 'normal',
  `status` enum('open','pending','resolved','closed') NOT NULL DEFAULT 'open',
  `body` text NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `support_tickets_user_id_foreign` (`user_id`),
  KEY `support_tickets_shipment_id_foreign` (`shipment_id`),
  KEY `support_tickets_priority_index` (`priority`),
  KEY `support_tickets_status_index` (`status`),
  CONSTRAINT `support_tickets_shipment_id_foreign` FOREIGN KEY (`shipment_id`) REFERENCES `shipments` (`id`) ON DELETE SET NULL,
  CONSTRAINT `support_tickets_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `support_tickets` WRITE;
/*!40000 ALTER TABLE `support_tickets` DISABLE KEYS */;
/*!40000 ALTER TABLE `support_tickets` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `tracking_events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tracking_events` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `shipment_id` bigint(20) unsigned NOT NULL,
  `status` varchar(255) NOT NULL,
  `location` varchar(255) DEFAULT NULL,
  `latitude` decimal(10,7) DEFAULT NULL,
  `longitude` decimal(10,7) DEFAULT NULL,
  `country_code` varchar(2) DEFAULT NULL,
  `checkpoint_label` varchar(255) DEFAULT NULL,
  `warehouse_name` varchar(255) DEFAULT NULL,
  `description` text NOT NULL,
  `admin_notes` text DEFAULT NULL,
  `created_by` bigint(20) unsigned DEFAULT NULL,
  `occurred_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `time` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `tracking_events_occurred_at_index` (`occurred_at`),
  KEY `tracking_events_shipment_id_idx` (`shipment_id`),
  KEY `tracking_events_created_by_idx` (`created_by`),
  CONSTRAINT `tracking_events_created_by_foreign` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `tracking_events_shipment_id_foreign` FOREIGN KEY (`shipment_id`) REFERENCES `shipments` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=88 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `tracking_events` WRITE;
/*!40000 ALTER TABLE `tracking_events` DISABLE KEYS */;
INSERT INTO `tracking_events` VALUES (2,2,'booked','Manchester',NULL,NULL,'Un','Current Location',NULL,'Auto-generated test shipment - Box shipment',NULL,1,'2026-07-30 10:48:21',NULL,'2026-07-30 10:48:21','2026-07-30 10:48:21'),(3,2,'booked','Manchester',NULL,NULL,NULL,NULL,NULL,'Shipment details updated by administrator.',NULL,1,'2026-07-30 10:50:33',NULL,'2026-07-30 10:50:33','2026-07-30 10:50:33'),(4,3,'booked','New York',41.9410874,-74.0477648,'Un','Current Location',NULL,'Auto-generated test shipment - Parcel shipment',NULL,1,'2026-07-30 17:19:10',NULL,'2026-07-30 17:19:10','2026-07-30 17:19:10'),(5,3,'booked','New York',NULL,NULL,NULL,NULL,NULL,'Shipment details updated by administrator.',NULL,1,'2026-07-30 17:21:17',NULL,'2026-07-30 17:21:17','2026-07-30 17:21:17'),(6,3,'booked','New York',NULL,NULL,NULL,NULL,NULL,'Shipment details updated by administrator.',NULL,1,'2026-07-30 17:21:30',NULL,'2026-07-30 17:21:30','2026-07-30 17:21:30'),(7,3,'booked','New York',NULL,NULL,NULL,NULL,NULL,'Shipment details updated by administrator.',NULL,1,'2026-07-30 20:07:14',NULL,'2026-07-30 20:07:14','2026-07-30 20:07:14'),(8,4,'booked','New York',41.9410874,-74.0477648,'Un','Current Location',NULL,'Auto-generated test shipment - Envelope shipment',NULL,1,'2026-07-30 20:29:57',NULL,'2026-07-30 20:29:57','2026-07-30 20:29:57'),(9,4,'booked','New York',NULL,NULL,NULL,NULL,NULL,'Shipment details updated by administrator.',NULL,1,'2026-07-30 20:31:10',NULL,'2026-07-30 20:31:10','2026-07-30 20:31:10'),(37,155,'booked','Dubai',NULL,NULL,'Un','Current Location',NULL,'Auto-generated test shipment - Tube shipment',NULL,1,'2026-07-30 21:34:30',NULL,'2026-07-30 21:34:30','2026-07-30 21:34:30'),(38,155,'booked','Dubai',NULL,NULL,NULL,NULL,NULL,'Shipment details updated by administrator.',NULL,1,'2026-07-30 21:36:29',NULL,'2026-07-30 21:36:29','2026-07-30 21:36:29'),(84,406,'booked','Chicago',NULL,NULL,'Un','Current Location',NULL,'Auto-generated test shipment - Tube shipment',NULL,1,'2026-07-31 13:34:33',NULL,'2026-07-31 13:34:33','2026-07-31 13:34:33'),(85,406,'booked','Chicago',NULL,NULL,NULL,NULL,NULL,'Shipment details updated by administrator.',NULL,1,'2026-07-31 13:38:10',NULL,'2026-07-31 13:38:10','2026-07-31 13:38:10'),(86,406,'booked','Chicago',NULL,NULL,NULL,NULL,NULL,'Shipment details updated by administrator.',NULL,1,'2026-07-31 13:38:13',NULL,'2026-07-31 13:38:13','2026-07-31 13:38:13'),(87,406,'picked_up','Chicago',NULL,NULL,NULL,NULL,NULL,'Shipment details updated by administrator.',NULL,1,'2026-07-31 13:42:37',NULL,'2026-07-31 13:42:37','2026-07-31 13:42:37');
/*!40000 ALTER TABLE `tracking_events` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `company` varchar(255) DEFAULT NULL,
  `role` enum('super_admin','admin','manager','support','warehouse','driver','customer') NOT NULL DEFAULT 'customer',
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `email_verification_code` varchar(255) DEFAULT NULL,
  `password_reset_token` varchar(255) DEFAULT NULL,
  `password_reset_expires_at` timestamp NULL DEFAULT NULL,
  `two_factor_enabled` tinyint(1) NOT NULL DEFAULT 0,
  `two_factor_code_hash` varchar(255) DEFAULT NULL,
  `two_factor_expires_at` timestamp NULL DEFAULT NULL,
  `last_login_at` timestamp NULL DEFAULT NULL,
  `is_suspended` tinyint(1) NOT NULL DEFAULT 0,
  `suspended_at` timestamp NULL DEFAULT NULL,
  `suspension_reason` text DEFAULT NULL,
  `granted_admin_permissions` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`granted_admin_permissions`)),
  `revoked_admin_permissions` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`revoked_admin_permissions`)),
  `password` varchar(255) NOT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_unique` (`email`),
  KEY `users_role_index` (`role`),
  KEY `users_password_reset_token_index` (`password_reset_token`),
  KEY `users_is_suspended_index` (`is_suspended`)
) ENGINE=InnoDB AUTO_INCREMENT=524 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Admin Operator','admin@freightflow.test',NULL,NULL,'admin',NULL,NULL,NULL,NULL,0,NULL,NULL,'2026-07-31 14:10:53',0,NULL,NULL,NULL,NULL,'$2y$12$G8Zi.JTokl7ctd7pkbPS0u0DD6qIiJ1rvI9awaAuQniqy/o14gv7u',NULL,'2026-07-30 02:13:25','2026-07-31 14:10:53'),(2,'James Driver','driver@freightflow.test',NULL,NULL,'driver',NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,'$2y$12$PO/E1Y8L5CKAyDJH20ypO.PITnst.6se1CJJ6yhPMhUo0Mu3LbKny',NULL,'2026-07-30 02:13:25','2026-07-30 02:13:25'),(3,'Maya Carter','maya@freightflow.test',NULL,NULL,'customer',NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,'$2y$12$T9sPpDbGTfICrYQ7TGW9m.k8vx9J2O/J7IROCF4xyseVXI5ueVeAO',NULL,'2026-07-30 02:13:26','2026-07-30 02:13:26');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `warehouses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `warehouses` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `code` varchar(255) NOT NULL,
  `city` varchar(255) NOT NULL,
  `country` varchar(2) NOT NULL,
  `address` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`address`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `warehouses_code_unique` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `warehouses` WRITE;
/*!40000 ALTER TABLE `warehouses` DISABLE KEYS */;
/*!40000 ALTER TABLE `warehouses` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

