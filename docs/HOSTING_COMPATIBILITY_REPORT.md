# OgaHosting Compatibility and Deployment-Readiness Report

**Project:** FreightFlow / FedExUS logistics platform
**Repository:** `Kesiena123/fedexus-logistics`
**Audit date:** 2026-10-28
**Auditor:** automated repository and dependency audit
**Verdict:** **NOT DEPLOYMENT-READY YET.** A hard blocker exists: the Laravel application source code is not present in this repository (see section 2). Everything that can be verified from the files that are present is documented below.

---

## 1. Executive summary

The repository contains a Laravel 12 dependency tree, database dumps, compiled Blade view caches, session files, and one uploaded shipment photo. It does **not** contain the application source code, front controller, routes, configuration, migrations, Composer manifest, or frontend build manifest.

Because of that, the application cannot be booted, tested, built, or safely deployed from this repository as it currently stands. The deployment configuration, `.env.example`, `.gitignore`, and documentation in this repository have been prepared from the dependency tree and database schema, but they cannot be validated against real application code until the missing source is restored.

The most important operational findings are:

1. **Source code missing** — `backend/app`, `backend/config`, `backend/routes`, `backend/resources`, `backend/database/migrations`, `backend/artisan`, `backend/composer.json`, `backend/composer.lock`, `backend/package.json`, `backend/public/index.php`, and `backend/public/.htaccess` are absent.
2. **Secrets are currently tracked in Git** — `backend/.env`, `MySQL Connection Details.txt`, cookies, logs, sessions, and an uploaded photo are committed. They must be removed from tracking and the exposed credentials must be rotated.
3. **Database dumps are committed** — the SQL dumps contain what appears to be real/test operational data. Do not import them into a clean production database without review.
4. **The stack is modern** — Laravel 12.64, PHP 8.2+, MySQL/MariaDB with `utf8mb4`, Vite 6, Tailwind 3, Alpine 3, Leaflet 1.9, Livewire 3.8, Sanctum 4.3, Reverb 1.11, Stripe 21, DomPDF 3.1, and a PHP barcode generator.
5. **Shared-hosting-compatible defaults are possible** — file sessions, file cache, synchronous queues, log broadcasting, and AJAX polling for live chat. No Redis, Supervisor, or permanent Node process is required for the existing feature set.

---

## 2. Repository contents audit

### 2.1 Present

| Path | Notes |
| --- | --- |
| `backend/vendor/` | Composer-installed dependencies. Tracked in Git; should be untracked. |
| `backend/node_modules/` | Vite/Tailwind/Alpine/Leaflet toolchain. Tracked in Git; should be untracked. |
| `backend/.env` | Real environment file containing database credentials and `APP_KEY`. Tracked in Git. |
| `backend/bootstrap/cache/packages.php`, `services.php` | Compiled package discovery cache. Should not be committed. |
| `backend/storage/app/public/shipment-attachments/406/...png` | One uploaded shipment photo. Must not be committed. |
| `backend/storage/framework/sessions/*` | 60 session files. Must not be committed. |
| `backend/storage/framework/views/*.php` | Compiled Blade views. Must not be committed. |
| `backend/storage/logs/laravel.log` | Application log. Must not be committed. |
| `backend/database/logistics_db.sql` | MySQL dump (29 tables, 27 migration rows). |
| `backend/database/logistics_db_infinityfree.sql` | MySQL dump (same schema and migration set). |
| `backend/database/logistics_db_local.sql` | Raw local export (25 tables, only one migration row). |
| `backend/public/storage` | Windows junction pointing to an absolute local path. Must not be deployed as-is. |
| `allpromt/` | Internal prompt/notes folder. Now ignored. |

### 2.2 Missing (hard blocker)

| Expected file/directory | Impact |
| --- | --- |
| `backend/app/` | No controllers, models, middleware, providers, or jobs. Application cannot run. |
| `backend/config/` | No Laravel configuration. |
| `backend/routes/` | No web/API/console routes. |
| `backend/resources/` | No Blade views, CSS, or JavaScript source. |
| `backend/database/migrations/` | No migrations. `php artisan migrate` cannot run. |
| `backend/artisan` | No CLI entry point. |
| `backend/composer.json`, `backend/composer.lock` | No reproducible dependency manifest. |
| `backend/package.json`, `vite.config.js`, `tailwind.config.js`, `postcss.config.js` | No frontend build configuration. |
| `backend/public/index.php`, `backend/public/.htaccess` | No front controller or rewrite rules. |
| `backend/bootstrap/app.php`, `backend/bootstrap/providers.php` | No application bootstrap. |
| `backend/tests/` | No test suite. |
| `.env.example` at repository level | Created during this audit as `backend/.env.example`. |

**Conclusion:** The repository is not a runnable Laravel project. Restoring these files from the authoritative source is a prerequisite for every remaining deployment step.

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

> `composer.lock` is missing. A dependency lock file must be restored before production installation so the exact tested versions are installed.

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

The frontend must be built with `npm ci && npm run build` (once `package.json` and `package-lock.json` are restored) or the production `public/build` directory must be uploaded. A permanent Node.js process is **not** required at runtime.

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
| Scheduler | Unknown (source missing) | Add cron only if the restored source registers scheduled tasks |

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
| B1 | Blocker | Application source is missing from the repository | Restore authoritative `app/`, `config/`, `routes/`, `resources/`, `database/migrations/`, `artisan`, bootstrap files, Composer and npm manifests |
| B2 | Blocker | `composer.json` / `composer.lock` missing | Restore and run `composer install --no-dev --optimize-autoloader` on a supported host |
| B3 | Blocker | `public/index.php` and `.htaccess` missing | Restore from source; do not invent a different front controller |
| B4 | High | Real `.env` and database credentials committed to Git | Remove from tracking, rotate the database password, preserve the real `APP_KEY` securely |
| B5 | High | Uploaded photos, sessions, logs, compiled views, and SQL dumps committed | Remove from tracking; use persistent server storage |
| B6 | High | `vendor/` and `node_modules/` committed | Remove from tracking; install/build with Composer and npm |
| B7 | Medium | OgaHosting capabilities unknown | Obtain PHP version, extensions, document-root, SSH, Composer, Git, cron, and SMTP details before deployment |
| B8 | Medium | Reverb/WebSockets configured | Keep `BROADCAST_CONNECTION=log` and AJAX polling unless the host explicitly supports persistent processes |
| B9 | Medium | Upload limits unknown | Confirm the host allows the photo sizes used by the shipment editor |
| B10 | Low | Windows junction `public/storage` | Replace with a portable relative symlink on the server |

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
- Git remote/history inspection.
- Dependency inventory from `backend/vendor/composer/installed.json`.
- Frontend package inventory from `backend/node_modules/.package-lock.json`.
- Database schema, engine, charset, foreign-key, and migration inspection from all three SQL dumps.
- Storage, upload, log, and session inspection.
- `.env` key inventory (values were never copied into documentation).

Not performed (impossible without source or hosting access):

- Laravel boot, route registration, view rendering, middleware, and CSRF checks.
- `php artisan` commands, migrations, cache clearing, queue tests.
- Feature workflows (shipment create/edit, multi-photo upload, tracking, chat, payments, receipts, email).
- Production build (`npm run build`).
- Payment callback verification against live/test gateways.
- Mail delivery.
- OgaHosting compatibility checks on the actual account.

---

## 13. Readiness checklist

| Area | Status |
| --- | --- |
| Application source | ❌ Missing |
| Composer manifest/lock | ❌ Missing |
| Front controller and rewrite rules | ❌ Missing |
| Database schema | ✅ Available in dumps |
| Database migration path | ⚠️ Dumps only; no migrations |
| Secrets removed from Git | ⚠️ `.gitignore` prepared; untracking and rotation required |
| Production `.env.example` | ✅ Created |
| Storage persistence plan | ✅ Documented |
| Hosting details | ❌ Not yet obtained |
| Deployment automation | ⚠️ Templates only; must be verified against the host |
| Local application tests | ❌ Cannot run |
| Deployment-ready verdict | ❌ **No** |
