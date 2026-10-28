# Database Migration and Import Guide (OgaHosting MySQL/MariaDB)

This guide explains how to create the production database, import the existing schema/data safely, and verify it. Destructive operations are explicitly avoided.

> **Never run `php artisan migrate:fresh`, `db:wipe`, or any destructive command against production.** Do not import demo shipments, fake payments, or test admin credentials into a new production site.

---

## 1. Dumps currently in the repository

| File | Tables | Migration rows | Purpose / notes |
| --- | --- | --- | --- |
| `backend/database/logistics_db.sql` | 29 | 27 | MySQL dump converted from the SQLite export. Best candidate for schema comparison. |
| `backend/database/logistics_db_infinityfree.sql` | 29 | 27 | Same schema/migration set, prepared for an InfinityFree-style import. |
| `backend/database/logistics_db_local.sql` | 25 | 1 | Raw local export. Older/incomplete. Do not use for a production upgrade. |

All three are excluded from Git by `.gitignore`. They remain on this workstation for reference. They are **not** deployed automatically.

The two 29-table dumps contain operational data (shipments, payment requests, audit logs, chat messages). Review them before importing into a new production database. If the goal is a clean production launch, import structure only, then create the real admin account and settings through the application.

---

## 2. Schema summary

- 29 tables, all `ENGINE=InnoDB`, `CHARSET=utf8mb4`, `COLLATE=utf8mb4_unicode_ci`.
- Foreign keys are used throughout; the dump wraps imports in `SET FOREIGN_KEY_CHECKS = 0;`.
- Core tables: `users`, `shipments`, `shipment_attachments`, `tracking_events`, `shipment_route_points`, `shipment_schedules`, `payment_requests`, `payment_transactions`, `payment_proofs`, `payments`, `payment_settings`, `bank_accounts`, `admin_settings`, `guest_chat_conversations`, `guest_chat_messages`, `notifications`, `email_logs`, `admin_audit_logs`, `warehouses`, `addresses`, `support_tickets`, `personal_access_tokens`, `migrations`.
- `payment_settings` and `admin_settings` are database-backed; **do not move their content into `.env`**.
- `shipment_attachments` stores multiple files per shipment (`disk`, `path`, `stored_name`, `mime_type`, `size_bytes`).

---

## 3. Create the database and user in the control panel

1. Log in to OgaHosting (cPanel or equivalent).
2. Open **MySQL Databases**.
3. Create a database, for example `<account>_fedexus`.
4. Create a user with a strong password.
5. Add the user to the database with **all privileges** on that database.
6. Record:
   - host (usually `localhost`, confirm)
   - port (usually `3306`, confirm)
   - database name
   - username
   - password

Use these values in `backend/.env`:

```dotenv
DB_CONNECTION=mysql
DB_HOST=localhost
DB_PORT=3306
DB_DATABASE=<account>_fedexus
DB_USERNAME=<account>_fedexus_user
DB_PASSWORD=<strong-password>
```

Do not reuse the Aiven host/credentials currently present in the local `.env`.

---

## 4. Recommended import paths

### Option A — Clean production launch (structure only)

Use this when the site is new and must not contain test data.

1. Open the dump in a text editor or phpMyAdmin export screen.
2. Export/import **structure only**:
   - cPanel phpMyAdmin → select the local database or open the dump → **Export** → choose **Structure** only → SQL format → Go.
3. Import the structure-only SQL into the production database.
4. If the dump does not include the `migrations` rows, add them only after confirming the restored source expects them. Otherwise run approved migrations later.
5. Create the real admin account and website settings through the application.
6. Do not insert demo shipments, fake payments, or test users.

### Option B — Migrate existing production data

Use this only when moving an existing live site (for example from XAMPP or another host) and the data must be preserved.

1. Export the current live database from the old host:
   - phpMyAdmin → **Export** → **Quick** or **Custom** → SQL → include structure and data.
2. Open the export and confirm:
   - `SET NAMES utf8mb4;`
   - `ENGINE=InnoDB`
   - `FOREIGN_KEY_CHECKS=0;` at the top and `FOREIGN_KEY_CHECKS=1;` at the end.
3. Import into the new database through phpMyAdmin.
4. Import the matching uploaded files separately (see section 7).
5. Verify row counts and relationships (section 6).

### Choosing between the committed dumps

- If you must reconstruct the schema from this repository, use `logistics_db.sql` or `logistics_db_infinityfree.sql` and remove the `INSERT` statements for demo/test rows before importing into a production site.
- Do not use `logistics_db_local.sql`; it is older and has only one migration row.

---

## 5. Import through phpMyAdmin (when SSH/Artisan is unavailable)

1. Open cPanel → **phpMyAdmin**.
2. Select the production database in the left sidebar.
3. Open the **Import** tab.
4. Choose the `.sql` file.
5. Set:
   - Character set: `utf8`
   - Allow the import to interrupt on errors: **off** only if you understand the errors; otherwise **on**
   - Partial import: off
6. Click **Go**.
7. If the file is larger than the upload limit, compress it as `.sql.gz` and retry, or ask OgaHosting to raise `upload_max_filesize`/`post_max_size`.
8. Re-enable foreign key checks if the dump does not do so:
   ```sql
   SET FOREIGN_KEY_CHECKS = 1;
   ```

Do **not** create a public PHP script that runs migrations or imports SQL. Any maintenance script must be CLI-only or protected and removed immediately after use.

---

## 6. Verify the import

Run these read-only queries in phpMyAdmin → SQL:

```sql
SHOW TABLE STATUS;
SELECT COUNT(*) AS tables_count
FROM information_schema.tables
WHERE table_schema = DATABASE();

SELECT COUNT(*) AS migrations_count FROM migrations;

SELECT COUNT(*) AS users_count FROM users;
SELECT COUNT(*) AS shipments_count FROM shipments;
SELECT COUNT(*) AS attachments_count FROM shipment_attachments;
SELECT COUNT(*) AS payment_requests_count FROM payment_requests;
SELECT COUNT(*) AS payment_proofs_count FROM payment_proofs;
SELECT COUNT(*) AS chat_conversations_count FROM guest_chat_conversations;
SELECT COUNT(*) AS chat_messages_count FROM guest_chat_messages;

SELECT TABLE_NAME, ENGINE, TABLE_COLLATION
FROM information_schema.tables
WHERE table_schema = DATABASE()
ORDER BY TABLE_NAME;
```

Expected:

- All tables use `InnoDB` and `utf8mb4_unicode_ci`.
- `migrations` matches the restored source's migration list (27 rows for the two 29-table dumps).
- Attachment rows have corresponding files under `storage/app/public/shipment-attachments/`.

Check foreign keys:

```sql
SELECT TABLE_NAME, CONSTRAINT_NAME, REFERENCED_TABLE_NAME
FROM information_schema.KEY_COLUMN_USAGE
WHERE table_schema = DATABASE()
  AND REFERENCED_TABLE_NAME IS NOT NULL
ORDER BY TABLE_NAME, CONSTRAINT_NAME;
```

---

## 7. Uploaded shipment photos

Database rows alone are not enough. Copy the physical files from the old installation:

- Source: old `storage/app/public/` (including `shipment-attachments/`)
- Destination: `/home/<account>/fedexus/storage/app/public/`
- Ensure the web-accessible link exists: `public/storage -> ../storage/app/public`

Preserve directory structure, for example:

```text
storage/app/public/shipment-attachments/406/66VZhOEoXDFeJnmwYXdX0EhhX7oj8IUN0uC2LcQ7.png
```

After copying:

```bash
cd /home/<account>/fedexus
php artisan storage:link
find storage/app/public -type d -exec chmod 755 {} \;
find storage/app/public -type f -exec chmod 644 {} \;
```

Do not delete or replace `storage/app/public` during future code deployments.

---

## 8. Migration status when the source is restored

If the restored source includes `database/migrations/`, check status before running anything:

```bash
php artisan migrate:status
```

Rules:

- If all listed migrations are already present in the database, do not run them again.
- If new migrations exist, review each one for destructive operations (`drop`, `truncate`, `change` that removes columns) before running.
- Run only approved migrations, and only after a verified backup:
  ```bash
  php artisan migrate --force
  ```
- Never use `migrate:fresh` or `db:wipe` on production.

If Artisan is unavailable, do not run a public migration script. Ask OgaHosting for SSH or run the equivalent reviewed SQL manually through phpMyAdmin.

---

## 9. Seeding policy

**Do not run** `php artisan db:seed` on production unless a specific, reviewed production seeder exists.

Specifically:

- No demo shipments.
- No fake payments or payment requests.
- No test admin or customer credentials.
- No sample chat messages.

Create the first real admin account through the application's admin creation flow, an approved one-off console command, or a reviewed SQL insert using a strong password hash. Record who created it and when.

---

## 10. Rollback of a database import

1. Before importing, export the current production database (see `docs/BACKUP_AND_ROLLBACK.md`).
2. If the import fails or corrupts data, stop the site (maintenance mode or rename `index.php`).
3. Drop the newly created database **only after** confirming it is the new empty database, not the live one.
4. Recreate it and re-import the verified backup.
5. Verify row counts and the site.
6. Do not keep failed import dumps in a web-accessible directory.

---

## 11. Data-safety notes

- The committed dumps contain operational records and personal data (names, emails, phone numbers, addresses). Treat them as sensitive and never publish them.
- The current `backend/.env` contains live-looking Aiven credentials. Rotate that database password and remove the file from Git tracking.
- Keep database exports outside `public_html`.
- Use a dedicated database user per site with least privilege (all privileges on that database only).
