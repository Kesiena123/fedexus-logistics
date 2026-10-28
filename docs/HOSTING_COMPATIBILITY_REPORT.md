# OgaHosting Compatibility and Deployment-Readiness Report

**Project:** FreightFlow / FedExUS logistics platform
**Repository:** `Kesiena123/fedexus-logistics`
**Audit date:** 2026-10-28
**Auditor:** automated repository and dependency audit
**Verdict:** **NOT DEPLOYMENT-READY YET.** The application source is now present and the app boots locally, but OgaHosting capabilities are unconfirmed, exposed credentials are unrotated, and no runtime feature has been tested on the host. Details below.

---

## 1. Executive summary

The repository now contains the complete Laravel application source, Composer and npm manifests and lock files, 31 migration files, 171 routes, and a production frontend build. The app boots locally and the frontend builds successfully. The two 29-table dumps have only 27 migrations applied, leaving 5 pending migrations to reconcile before production.

The source was restored from the authoritative sibling copy at `..\..\Fed\FedExUs\backend`, excluding `vendor/`, `node_modules/`, `.env`, logs, cookies, SQL dumps, and local storage. No application logic was edited during the copy.

The most important operational findings are:

1. **Source restored and boot-verified** — `php artisan --version` reports Laravel 12.64.0, `php artisan route:list` reports 171 routes, `composer validate` passes (license warning only), and `npm run build` succeeds.
2. **Secrets are no longer tracked in the current commit** — `backend/.env`, `MySQL Connection Details.txt`, cookies, logs, sessions, SQL dumps, and uploaded files were removed from Git tracking and pushed. They remain in Git history and the exposed credentials must still be rotated.
3. **Database dumps remain on disk but untracked** — the SQL dumps contain real/test operational data. Do not commit or import them into production without review.
4. **The stack is modern** — Laravel 12.64, PHP 8.2+, MySQL/MariaDB with `utf8mb4`, Vite 6, Tailwind 3, Alpine 3, Leaflet 1.9, Livewire 3.8, Sanctum 4.3, Reverb 1.11, Stripe 21, DomPDF 3.1, and a PHP barcode generator.
5. **Shared-hosting-compatible defaults are possible** — file sessions, file cache, synchronous queues, log broadcasting, and AJAX polling for live chat. No Redis, Supervisor, permanent Node process, or cron job is required for the current feature set.

---

## 2. Repository contents audit

### 2.1 Present

| Path | Notes |
| --- | --- |
| `backend/app/`, `backend/bootstrap/`, `backend/config/`, `backend/routes/`, `backend/resources/`, `backend/tests/` | Application source restored and tracked. |
| `backend/database/migrations/`, `backend/database/seeders/` | 31 migration files plus seeders restored and tracked; the dumps record 27 as applied. |
| `backend/artisan`, `backend/composer.json`, `backend/composer.lock` | CLI entry point and reproducible PHP dependencies restored. |
| `backend/package.json`, `backend/package-lock.json`, `backend/vite.config.js`, `backend/tailwind.config.js`, `backend/postcss.config.js` | Frontend manifests and build configuration restored. |
| `backend/public/index.php`, `backend/public/.htaccess`, `backend/public/build/` | Front controller, rewrite rules, and production assets restored/built. |
| `backend/vendor/` | Composer-installed dependencies on disk, untracked. Install with Composer on the host. |
| `backend/node_modules/` | Frontend toolchain on disk, untracked. Build with npm or upload `public/build`. |
| `backend/.env` | Real environment file with local credentials; untracked and must stay private. |
| `backend/storage/app/public/shipment-attachments/406/...png` | Uploaded shipment photo on disk; untracked and must persist on the server. |
| `backend/storage/framework/sessions/*`, `backend/storage/framework/views/*.php`, `backend/storage/logs/*` | Local runtime state; untracked. |
| `backend/database/logistics_db.sql` | MySQL dump (29 tables, 27 migration rows), untracked. |
| `backend/database/logistics_db_infinityfree.sql` | MySQL dump (same schema and migration set), untracked. |
| `backend/database/logistics_db_local.sql` | Raw local export (25 tables, only one migration row), untracked. |
| `backend/public/storage` | Local symlink; excluded from Git. Recreate on the server with `php artisan storage:link`. |
| `allpromt/` | Internal prompt/notes folder; ignored. |

### 2.2 Remaining gaps

| Item | Impact |
| --- | --- |
| OgaHosting account details | PHP version/extensions, document root, SSH, Composer, Git, cron, SMTP, and upload limits are still unknown. |
| Production `backend/.env` | Must be created on the server from `.env.example` with the real `APP_KEY` and rotated credentials. |
| Credential rotation | The Aiven database password and other secrets exposed in Git history are still valid until rotated. |
| Runtime testing | No feature has been exercised against the real database or host; PHPUnit was not run to avoid touching the remote database. |

**Conclusion:** The repository is a runnable Laravel project locally. Deployment still requires host confirmation, production configuration, credential rotation, and runtime verification.

---

## 3. Runtime requirements

### 3.1 PHP

| Requirement | Value | Source |
| --- | --- | --- |
| Minimum PHP | **8.2** | `laravel/framework` v12.64.0 requires `^8.2`; multiple Symfony 7.4 packages require `>=8.2` |
| Recommended PHP | **8.3** | Current local project documentation and dependency compatibility |
| Maximum tested | 8.5 supported by Symfony/Nette constraints, but confirm with OgaHosting | `vendor/composer/installed.json` |

Required PHP extensions (Laravel 12 + the installed packages):

- `ctype`
- `curl`
- `dom`
- `fileinfo`
- `filter`
- `gd` (needed by DomPDF and `picqer/php-barcode-generator` for image output)
- `hash`
- `mbstring`
- `openssl`
- `pcre`
- `pdo`
- `pdo_mysql`
- `session`
- `tokenizer`
- `xml`
- `zip` (recommended for Composer and archive handling)

Recommended PHP settings for shipment photo uploads (confirm actual limits with the application code and hosting provider):

- `upload_max_filesize = 20M` or higher
- `post_max_size = 25M` or higher
- `max_file_uploads = 20` or higher
- `memory_limit = 256M` or higher
- `max_execution_time = 120` (payment verification, PDF receipts)
- `allow_url_fopen = On` only if required by DomPDF remote images

### 3.2 Database

| Requirement | Value |
| --- | --- |
| Engine | MySQL 8.0+ or MariaDB 10.4+ |
| Charset | `utf8mb4` |
| Collation | `utf8mb4_unicode_ci` |
| Table engine | InnoDB |
| Foreign keys | Required and used extensively |
| SSL | Not required on typical shared hosting; the repository's Aiven configuration uses SSL and must not be copied to OgaHosting unless required |

### 3.3 Dependencies installed in `backend/vendor`

Key production packages:

| Package | Version |
| --- | --- |
| `laravel/framework` | v12.64.0 |
| `laravel/sanctum` | v4.3.3 |
| `laravel/reverb` | v1.11.0 |
| `livewire/livewire` | v3.8.2 |
| `barryvdh/laravel-dompdf` | v3.1.2 |
| `dompdf/dompdf` | v3.1.6 |
| `picqer/php-barcode-generator` | v3.2.4 |
| `stripe/stripe-php` | v21.1.0 |
| `guzzlehttp/guzzle` | v7.15.2 |
| `pusher/pusher-php-server` | v7.2.8 |

Development-only packages present in `vendor/` (not required in production): PHPUnit 11.5, Laravel Pint, Faker.

> `composer.lock` is present and valid. Install with `composer install --no-dev --optimize-autoloader` so the exact tested versions are used.

### 3.4 Frontend build

| Tool | Version |
| --- | --- |
| Vite | 6.4.3 |
| `laravel-vite-plugin` | 1.3.0 |
| Tailwind CSS | 3.4.19 |
| Alpine.js | 3.15.12 |
| Axios | 1.18.1 |
| Leaflet | 1.9.4 |
| `vite-plugin-full-reload` | 1.2.0 |

The frontend builds successfully with `npm run build` (Vite 6.4.3). The generated `backend/public/build/` directory is committed for hosts without Node.js. A permanent Node.js process is **not** required at runtime.

---

## 4. Database schema findings

The dumps define 29 tables, all InnoDB with `utf8mb4_unicode_ci`:

`addresses`, `admin_audit_logs`, `admin_settings`, `bank_accounts`, `conversation_user`, `conversations`, `email_logs`, `guest_chat_conversations`, `guest_chat_messages`, `messages`, `migrations`, `notification_preferences`, `notifications`, `payment_audit_logs`, `payment_proofs`, `payment_requests`, `payment_settings`, `payment_transactions`, `payments`, `personal_access_tokens`, `shipment_attachments`, `shipment_drafts`, `shipment_route_points`, `shipment_schedules`, `shipments`, `support_tickets`, `tracking_events`, `users`, `warehouses`.

Observations:

- Foreign keys use `ON DELETE CASCADE`, `SET NULL`, and `SET DEFAULT` variants consistently. Import with `FOREIGN_KEY_CHECKS=0` (already in the dump) and re-enable afterwards.
- `shipments` uses a status `CHECK` constraint with 15 lifecycle values.
- `users.role` is constrained to `super_admin`, `admin`, `manager`, `support`, `warehouse`, `driver`, `customer`.
- `payment_settings` is database-backed and stores gateway `api_key`, `secret_key`, `public_key`, `mode` (`test`/`live`), `is_active`, fees, currencies, webhook settings, and encrypted credential payloads. **This is the Admin-configurable gateway system that must remain in the database, not be moved to `.env`.**
- `admin_settings` is the database-backed website settings system (title, logo, live chat, etc.). Preserve it.
- `shipment_attachments` supports multiple photos per shipment, with `disk`, `path`, `stored_name`, `mime_type`, and `size_bytes`. The one stored file uses `storage/app/public/shipment-attachments/406/...`.
- `payment_proofs` supports manual bank-transfer proof upload and verification.
- `guest_chat_conversations` / `guest_chat_messages` support guest–admin chat without customer accounts.
- `tracking_events` and `shipment_route_points` support shipment-specific location data and map checkpoints.
- `personal_access_tokens` supports Sanctum.

The `logistics_db.sql` and `logistics_db_infinityfree.sql` dumps both contain 27 rows in `migrations` and 144 `INSERT` statements, including real-looking shipments, admin audit logs, chat messages, and payment requests. `logistics_db_local.sql` is a raw export with only one migration row and should not be used for the production upgrade.

The restored source has **31 migration files**, while those dumps record **27 applied migrations**. After importing a dump, 5 migrations are pending:

- `2026_07_30_150632_optimize_database_indexes_and_cleanup` (adds indexes; safe/idempotent)
- `2026_07_30_160000_remove_unused_tables` (**destructive**; drops `messages`, `conversation_user`, `conversations`, `addresses`)
- `2026_09_13_000001_set_website_url_setting` (inserts the `website_url` setting)
- `2026_09_13_000002_set_company_email_setting` (inserts the `company_email` setting)
- `2026_09_13_000003_add_shipment_location_fields` (adds shipment coordinates and creates `shipment_location_history`)

One applied dump migration, `2026_07_21_000001_create_addresses_table`, has no source file. Do **not** run `php artisan migrate --force` blindly after importing a dump; take a backup, review the five files, confirm the old `addresses`/`conversations` data is disposable, then run them deliberately.

---

## 5. Storage and uploads

- `shipment_attachments.disk` defaults to `public`.
- Stored files live under `backend/storage/app/public/`.
- Laravel exposes them through `backend/public/storage` → `storage/app/public`.
- The current `backend/public/storage` is a Windows junction to an absolute path on this workstation. It will not work on the server and must be replaced by a relative symlink or a direct directory copy.
- Uploaded photos are **not** code. They must be excluded from Git and stored in a persistent directory that survives deployments.
- Deleting/replacing application code must not delete `backend/storage/app/public/`.

Recommended OgaHosting layout:

```text
/home/<account>/fedexus/              <- Laravel root (private)
  app/
  bootstrap/
  config/
  database/
  public/                             <- document root (or copied into public_html)
    index.php
    .htaccess
    build/
    storage/ -> ../../storage/app/public
  resources/
  routes/
  storage/
  vendor/
  .env                                <- private
```

If OgaHosting cannot point the document root at `public/`, see `docs/OGAHOSTING_DEPLOYMENT.md` for the `public_html` layout and the required `index.php` path adjustments. **Do not copy the entire Laravel project into `public_html`.**

---

## 6. Sessions, cache, queues, broadcasting

| Concern | Current setting | Shared-hosting recommendation |
| --- | --- | --- |
| Session | `file` | Keep `file` (no `sessions` table in the schema) |
| Cache | `file` | Keep `file`; no Redis required |
| Queue | `sync` | Keep `sync`; no worker/Supervisor required |
| Broadcasting | `log` | Keep `log`; Reverb is installed but not assumed available |
| Live chat | AJAX polling (`live_chat_poll_seconds` setting exists) | Preserve polling; do not replace with WebSockets |
| Scheduler | No scheduled tasks registered in `routes/console.php` | No cron job required for the current feature set |

---

## 7. Email

- Laravel's `symfony/mailer` is installed.
- The current `.env` has no mail settings, so notifications cannot be assumed to work.
- Production must use SMTP credentials from a mailbox created in the OgaHosting control panel.
- Verify SPF/DKIM records for the sending domain to avoid delivery failures.

---

## 8. Payments

Gateway support indicated by the environment keys and installed packages:

- **Flutterwave** (`FLUTTERWAVE_SECRET_KEY`; public key and webhook secret recommended)
- **Stripe** (`STRIPE_SECRET`; Stripe PHP SDK v21 installed)
- **PayPal** (`PAYPAL_CLIENT_ID`, `PAYPAL_CLIENT_SECRET`; no dedicated SDK, likely direct REST calls)
- **Paystack** (`PAYSTACK_SECRET_KEY`)
- **Manual bank transfer** with proof upload and admin verification (database tables present)
- **Pay on delivery / staged payments** (database tables present)

Critical requirements for the restored source:

- Verify every gateway callback/server-side transaction before marking a payment paid.
- Never trust a browser redirect alone.
- Keep `payment_settings.mode` test/live separation.
- Keep Admin enable/disable controls working.
- Do not expose secrets in JavaScript, logs, or error pages.

---

## 9. Maps, barcode, QR, receipts

- **Leaflet 1.9.4** is installed for the tracking map.
- Tile providers may require outbound HTTPS access and, for some providers, an API key. Confirm the tile provider with the restored source.
- **`picqer/php-barcode-generator` 3.2.4** supports barcodes.
- **DomPDF 3.1.6** supports PDF receipts.
- QR generation may be client-side or server-side; confirm with the restored source.

---

## 10. Incompatibilities and blockers

| ID | Severity | Finding | Required action |
| --- | --- | --- | --- |
| B1 | Resolved | Application source restored | None; boot-verified locally |
| B2 | Resolved | `composer.json` / `composer.lock` restored | Run `composer install --no-dev --optimize-autoloader` on the host |
| B3 | Resolved | `public/index.php` and `.htaccess` restored | Verify Apache rewrites on the host |
| B4 | High | Real `.env` and database credentials remain in Git history | Rotate the database password and any other exposed secrets; preserve the real `APP_KEY` securely |
| B5 | Resolved in HEAD | Uploaded photos, sessions, logs, compiled views, and SQL dumps untracked | Keep them out of Git; use persistent server storage |
| B6 | Resolved in HEAD | `vendor/` and `node_modules/` untracked | Install/build with Composer and npm on the host |
| B7 | Blocker | OgaHosting capabilities unknown | Obtain PHP version, extensions, document-root, SSH, Composer, Git, cron, and SMTP details before deployment |
| B8 | Medium | Reverb/WebSockets configured | Keep `BROADCAST_CONNECTION=log` and AJAX polling unless the host explicitly supports persistent processes |
| B9 | Medium | Upload limits unknown | Confirm the host allows the photo sizes used by the shipment editor |
| B10 | Low | Local Windows `public/storage` symlink | Excluded from Git; recreate with `php artisan storage:link` on the server |

---

## 11. Information required from OgaHosting

1. Supported PHP versions and available extensions (especially `gd`, `pdo_mysql`, `mbstring`, `xml`, `zip`, `curl`, `fileinfo`).
2. Ability to set the document root to `public/`; if not, the supported `public_html` layout.
3. MySQL/MariaDB version, database name, username, host, and port.
4. SSH access availability and the PHP CLI binary path.
5. Composer availability (CLI or web installer) and the allowed working directory.
6. Cron job availability and minimum interval.
7. Git deployment support (OgaHosting integration, cPanel Git Version Control, or neither).
8. FTP/SFTP access details if Git automation is unavailable.
9. SMTP host, port, encryption, username, and password.
10. Upload limits and any ModSecurity/WAF rules that may block payment webhooks or file uploads.
11. Outbound HTTPS access for Flutterwave, Stripe, PayPal, Paystack, map tiles, and any external API.

---

## 12. Verification performed in this audit

Actually performed:

- Full repository tree and Git index inspection.
- Git remote/history inspection and push of the secured commit.
- Dependency inventory from `backend/vendor/composer/installed.json`.
- Frontend package inventory from `backend/node_modules/.package-lock.json`.
- Database schema, engine, charset, foreign-key, and migration inspection from all three SQL dumps.
- Storage, upload, log, and session inspection.
- `.env` key inventory (values were never copied into documentation).
- Source restoration from the authoritative sibling copy, excluding secrets and generated files.
- Laravel boot: `php artisan --version` → Laravel 12.64.0.
- Route registration: `php artisan route:list` → 171 routes.
- `composer validate` → valid, license warning only.
- Frontend build: `npm run build` → Vite 6.4.3 build succeeded.
- PHP syntax checks on `artisan`, `bootstrap/app.php`, and `public/index.php`.
- Secret-pattern scan of restored source; only documented placeholders found.

Not performed (requires hosting access or a safe test database):

- Migrations against the production database or PHPUnit (phpunit.xml does not isolate the DB, so tests were not run to avoid touching the remote Aiven database).
- Feature workflows (shipment create/edit, multi-photo upload, tracking, chat, payments, receipts, email).
- Payment callback verification against live/test gateways.
- Mail delivery.
- OgaHosting compatibility checks on the actual account.

---

## 13. Readiness checklist

| Area | Status |
| --- | --- |
| Application source | ✅ Restored and tracked |
| Composer manifest/lock | ✅ Present and valid |
| Front controller and rewrite rules | ✅ Present |
| Database schema | ✅ Dumps plus 31 migration files available |
| Database migration path | ⚠️ 5 migrations pending vs dumps; one destructive drop must be reviewed after backup |
| Secrets removed from Git HEAD | ✅ Untracked in current commit |
| Secrets removed from Git history | ❌ Still in history; rotation required |
| Production `.env.example` | ✅ Complete template |
| Frontend production build | ✅ `public/build` generated |
| Storage persistence plan | ✅ Documented |
| Hosting details | ❌ Not yet obtained |
| Deployment automation | ⚠️ Templates only; must be verified against the host |
| Local boot/build checks | ✅ Passed |
| Runtime feature tests | ❌ Not run against a safe database/host |
| Deployment-ready verdict | ❌ **No** |
