# OgaHosting Deployment Guide

This is the main deployment runbook for the FreightFlow / FedExUS Laravel application.

> **Placeholders.** Values written as `<...>` are account-specific and must be obtained from OgaHosting. This guide deliberately does not invent paths, PHP versions, database names, or capabilities. See `docs/MISSING_REQUIREMENTS.md` for the information you must collect first.

> **Current status.** The Laravel source is present in `backend/` and boot-verified locally (Laravel 12.64.0, 171 routes, Vite build succeeds). The remaining blockers are OgaHosting capability confirmation, production `.env` creation, and credential rotation. See `docs/HOSTING_COMPATIBILITY_REPORT.md` and `docs/MISSING_REQUIREMENTS.md`.

---

## 0. Deployment strategy

Choose the highest option that OgaHosting actually supports. Do not enable automation until the capability is confirmed.

| Priority | Method | When to use |
| --- | --- | --- |
| 1 | OgaHosting-native GitHub/Git deployment | Only if the control panel explicitly offers it |
| 2 | cPanel Git Version Control | If cPanel Git is available and the repository can be cloned on the server |
| 3 | GitHub Actions over SSH/SFTP | Only if SSH or SFTP is available and credentials can be stored in GitHub Secrets |
| 4 | Manual GitHub ZIP + File Manager/FTP | Always available fallback |

The default recommendation for an unknown shared host is **method 4 (manual)** until the host confirms otherwise.

---

## 1. Prerequisites

Collect and record:

- OgaHosting control panel URL and login.
- Domain/subdomain for the site.
- PHP version and CLI path (for example `/usr/local/bin/php` — **placeholder, confirm**).
- PHP extensions enabled.
- MySQL host, port, database name, database user, and password.
- Document-root capability (can it point to `backend/public`?).
- SSH/SFTP/FTP access.
- Composer availability.
- Cron availability.
- SMTP mailbox credentials.
- Git integration support.
- Upload limits and WAF/ModSecurity behavior.

---

## 2. Directory layout

### 2.1 Preferred: document root points to Laravel `public/`

```text
/home/<account>/fedexus/                 <- private Laravel root
├── app/
├── bootstrap/
├── config/
├── database/
├── public/                              <- document root
│   ├── index.php
│   ├── .htaccess
│   ├── build/
│   └── storage -> ../../storage/app/public
├── resources/
├── routes/
├── storage/
├── vendor/
├── .env                                 <- private, not web-accessible
├── artisan
└── composer.json / composer.lock
```

The web server document root must be `/home/<account>/fedexus/public`.

### 2.2 Fallback: only `public_html` is writable/assignable as document root

Do **not** upload `.env`, `app/`, `config/`, `routes/`, `resources/`, `storage/`, `vendor/`, or `composer.json` into `public_html`.

```text
/home/<account>/fedexus/                 <- private Laravel root
└── ... (all Laravel files)

/home/<account>/public_html/             <- document root
├── index.php                            <- adjusted to require ../fedexus/vendor/autoload.php
├── .htaccess
├── build/
└── storage -> ../fedexus/storage/app/public
```

Use `deployment/public_html-index.php.example` as the template. Replace every `<ABSOLUTE_PATH>` placeholder with the real absolute path returned by the host. Never guess this path.

---

## 3. First-time deployment (manual, recommended default)

### Step 1 — Back up the existing site and database

Complete `docs/BACKUP_AND_ROLLBACK.md` first. Do not continue until both backups exist and you have verified they can be downloaded.

### Step 2 — Confirm the application source is present

The repository contains the full Laravel project. Confirm these exist before continuing:

```text
backend/app/
backend/bootstrap/app.php
backend/bootstrap/providers.php
backend/config/
backend/database/migrations/
backend/resources/
backend/routes/
backend/tests/
backend/artisan
backend/composer.json
backend/composer.lock
backend/package.json
backend/package-lock.json
backend/vite.config.js
backend/tailwind.config.js
backend/postcss.config.js
backend/public/index.php
backend/public/.htaccess
backend/public/build/
```

Do not commit or upload `vendor/`, `node_modules/`, `.env`, uploads, logs, or SQL dumps.

### Step 3 — Create the production database and user

In the OgaHosting control panel:

1. Create a MySQL database, for example `<account>_fedexus`.
2. Create a database user with a strong password.
3. Grant the user all privileges on that database only.
4. Record host, port, database name, username, and password.

Do not use the Aiven credentials that are currently in the local `.env`.

### Step 4 — Upload the application

Using File Manager, FTP/SFTP, or the ZIP workflow:

1. Upload the project **outside** `public_html` (for example `/home/<account>/fedexus`).
2. Upload `backend/public/*` into the document root if the host cannot point the document root at `backend/public`.
3. Do not upload `.git/`, `.env`, `node_modules/`, local logs, sessions, or SQL dumps.

### Step 5 — Create the production `.env`

1. Copy `backend/.env.example` to `backend/.env` on the server.
2. Fill in the database credentials, `APP_URL`, SMTP, and payment keys.
3. Set `APP_ENV=production` and `APP_DEBUG=false`.
4. Copy the **existing production `APP_KEY`** from the old installation. Do not generate a new key for an existing database.
5. Set `SESSION_SECURE_COOKIE=true` and use `https://` in `APP_URL`.
6. Keep `SESSION_DRIVER=file`, `CACHE_STORE=file`, `QUEUE_CONNECTION=sync`, and `BROADCAST_CONNECTION=log` unless OgaHosting confirms otherwise.
7. Protect the file with permissions `600` if the host allows it.

### Step 6 — Install Composer dependencies

If SSH and Composer are available:

```bash
cd /home/<account>/fedexus
composer install --no-dev --prefer-dist --optimize-autoloader --no-interaction
```

If Composer is not available on the host, install dependencies locally against the same PHP version and upload the resulting `vendor/` directory. This is a documented fallback, not the default. Record which method was used.

### Step 7 — Build or upload frontend assets

If Node.js is available locally (recommended):

```bash
cd backend
npm ci
npm run build
```

Upload the generated `public/build/` directory. Do not upload `node_modules/` or run a permanent Vite server in production.

If `package-lock.json` is missing, restore it first. A reproducible build requires a lock file.

### Step 8 — Set permissions

Typical shared-hosting permissions (confirm with the host):

```bash
cd /home/<account>/fedexus
find . -type d -exec chmod 755 {} \;
find . -type f -exec chmod 644 {} \;
chmod -R 775 storage bootstrap/cache
chmod 600 .env
```

If the host runs PHP as the same user, `775` is usually correct. Do not use `777`.

### Step 9 — Create the storage link

If the host supports relative symlinks:

```bash
cd /home/<account>/fedexus
php artisan storage:link
```

If `artisan` is unavailable, create the link manually:

```bash
ln -s ../storage/app/public public/storage
```

If symlinks are blocked, copy `storage/app/public` into `public/storage` and document that uploads must be synced back. Symlinks are strongly preferred because they keep uploads persistent across deployments.

### Step 10 — Import the database

Follow `docs/DATABASE_MIGRATION_GUIDE.md`.

- Prefer a reviewed, data-clean dump or a structure-only import.
- Do not import the demo/test data that is currently in the committed SQL dumps into a brand-new production database without review.
- After importing a 29-table dump, expect **5 pending migrations**. Review guide section 8.1 first; `2026_07_30_160000_remove_unused_tables` drops legacy `conversations`, `messages`, and `addresses` tables.
- Back up before migrating. Do not run `migrate:fresh`, `db:wipe`, or any unreviewed destructive migration.

### Step 11 — Clear and rebuild caches

If `artisan` is available:

```bash
cd /home/<account>/fedexus
php artisan optimize:clear
php artisan config:cache
php artisan route:cache
php artisan view:cache
```

If `artisan` is not available, delete the contents of `bootstrap/cache/` and `storage/framework/views/` manually, then let Laravel rebuild them on first request. Do not delete `bootstrap/cache/.gitignore`.

### Step 12 — Configure the web server

- Ensure the document root is correct.
- Ensure `index.php` is the directory index.
- Ensure `.htaccess` / rewrite rules route all non-file requests to `index.php`.
- Confirm `mod_rewrite` is enabled if using Apache.
- Deny directory listing.
- Deny access to `.env`, `composer.json`, `composer.lock`, `artisan`, `storage/`, and other private paths.

A reference Apache `.htaccess` is provided at `deployment/public.htaccess.example`.

### Step 13 — Smoke test

Open the site and verify:

1. Home page loads over HTTPS.
2. Static assets load (`/build/...`, CSS, JS).
3. Admin login works with an existing admin account.
4. A shipment can be created, edited, and tracked.
5. Multiple shipment photos upload and display.
6. Existing photos still display after a deployment.
7. Guest tracking works without an account.
8. Payment request pages load; gateway callbacks verify server-side.
9. Manual bank-transfer proof upload and admin verification work.
10. Guest–admin chat messages send and poll.
11. Tracking map loads with shipment-specific points.
12. Receipt, barcode, and QR code render.
13. Email notifications send through SMTP.
14. Website title, logo, and Admin settings still load from the database.
15. No errors appear in `storage/logs/laravel.log` or the browser console.

Record results in `docs/FEATURE_TEST_REPORT.md`.

---

## 4. Updating an existing deployment

1. Back up files and database.
2. Put the site into maintenance mode if `artisan` is available:
   ```bash
   php artisan down --render="errors::503"
   ```
3. Upload the new application files **without deleting** `storage/app/public`, `.env`, or `public/storage`.
4. Run `composer install --no-dev --optimize-autoloader` if dependencies changed.
5. Build and upload new frontend assets.
6. Run only approved migrations after a backup; the known legacy-table drop must be explicitly approved.
7. Clear/rebuild caches.
8. Bring the site back up:
   ```bash
   php artisan up
   ```
9. Re-run the smoke tests.

If `artisan` is unavailable, use the host's file manager and the manual cache-clearing steps. Do not upload a public migration script.

---

## 5. Cron (not required for the current feature set)

No scheduled tasks are registered in `routes/console.php`. Add a cron entry only if that changes:

```cron
* * * * * cd /home/<account>/fedexus && /usr/local/bin/php artisan schedule:run >> /dev/null 2>&1
```

Replace `/usr/local/bin/php` with the real PHP CLI path confirmed by OgaHosting. Do not add queue workers; the current configuration uses `QUEUE_CONNECTION=sync`.

---

## 6. What is automated vs manual

| Step | Automated? |
| --- | --- |
| Secret removal from Git | Yes, in this repository |
| `.env.example` generation | Yes |
| Hosting capability verification | **No — must be done manually with OgaHosting** |
| Source restoration | ✅ Complete and committed |
| Database creation | **No — control panel** |
| Composer install | Only if SSH/Composer confirmed |
| Frontend build | Local build recommended |
| Upload/deploy | Manual by default; automation templates provided but inactive |
| Database import | Manual (phpMyAdmin) |
| Cache clearing | Artisan if available, otherwise manual |
| Smoke tests | Manual |

---

## 7. Rollback

Follow `docs/BACKUP_AND_ROLLBACK.md`. Keep the previous application directory and database dump until the smoke tests pass.

---

## 8. Troubleshooting

| Symptom | Likely cause | Action |
| --- | --- | --- |
| 500 error on every page | Wrong document root, missing `vendor/`, or unwritable `storage`/`bootstrap/cache` | Check `storage/logs/laravel.log`; verify permissions and paths |
| `No application encryption key` | `APP_KEY` missing | Copy the existing production key; do not regenerate for an existing DB |
| 404 on all routes except home | Rewrite rules missing | Enable `mod_rewrite` and use the supplied `.htaccess` |
| CSS/JS 404 | `public/build` not uploaded or `APP_URL` wrong | Upload assets and set the correct `APP_URL` |
| Uploads fail | PHP upload limits or storage permissions | Raise `upload_max_filesize`/`post_max_size`; check `storage` permissions |
| Images 404 after upload | `public/storage` symlink missing or broken | Recreate the link; check the storage disk |
| Session/login loops | `SESSION_DOMAIN`/`SESSION_SECURE_COOKIE` mismatch | Match the cookie domain to the real domain and HTTPS |
| Payment stuck pending | Callback not verified or webhook blocked | Check server-side verification, logs, and WAF rules |
| Email not sent | Missing SMTP settings | Configure SMTP and test from the admin panel |
| Live chat not updating | Polling blocked or wrong endpoint | Check browser console/network and the `live_chat_poll_seconds` setting |
