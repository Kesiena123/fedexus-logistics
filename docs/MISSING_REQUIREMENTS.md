# Missing Requirements and Credentials

Everything in this document must be resolved before the project can be declared deployment-ready. Do not invent values for any item.

---

## 1. Application source (resolved)

The source was restored from the authoritative sibling copy at `..\..\Fed\FedExUs\backend`, excluding `vendor/`, `node_modules/`, `.env`, logs, cookies, SQL dumps, and local storage.

| Path | Status |
| --- | --- |
| `backend/app/` | ✅ Restored |
| `backend/bootstrap/app.php`, `backend/bootstrap/providers.php` | ✅ Restored |
| `backend/config/` | ✅ Restored |
| `backend/database/migrations/`, `backend/database/seeders/` | ✅ Restored (31 files; dumps have 27 applied, 5 pending) |
| `backend/resources/` | ✅ Restored |
| `backend/routes/` | ✅ Restored (171 routes) |
| `backend/tests/` | ✅ Restored |
| `backend/artisan` | ✅ Restored |
| `backend/composer.json`, `backend/composer.lock` | ✅ Restored, `composer validate` passes |
| `backend/package.json`, `backend/package-lock.json` | ✅ Restored |
| `backend/vite.config.js`, `backend/tailwind.config.js`, `backend/postcss.config.js` | ✅ Restored |
| `backend/public/index.php`, `backend/public/.htaccess` | ✅ Restored |
| `backend/public/build/` | ✅ Built with Vite 6.4.3 |

Local verification: Laravel 12.64.0 boots on PHP 8.2.12; 171 routes register; the frontend builds. No application logic was edited.

---

## 2. OgaHosting account details

Obtain from OgaHosting support or the control panel:

| Item | Placeholder in docs | Status |
| --- | --- | --- |
| Control panel URL | — | ❌ Unknown |
| Hosting plan / account username | `<account>` | ❌ Unknown |
| Supported PHP versions | — | ❌ Unknown |
| PHP CLI path | `<PHP_BIN>` | ❌ Unknown |
| Enabled PHP extensions | — | ❌ Unknown |
| Composer availability/path | `<COMPOSER_BIN>` | ❌ Unknown |
| MySQL version | — | ❌ Unknown |
| MySQL host | `<db-host>` | ❌ Unknown |
| MySQL port | `3306` (assumed) | ❌ Confirm |
| Database name | `<db-name>` | ❌ Unknown |
| Database user | `<db-user>` | ❌ Unknown |
| Database password | — | ❌ Unknown |
| Document root capability | `<DEPLOY_PATH>` | ❌ Unknown |
| Ability to point document root at `public/` | — | ❌ Unknown |
| SSH access | — | ❌ Unknown |
| SFTP/FTP access | — | ❌ Unknown |
| Cron availability | — | ❌ Unknown |
| Git integration (native/cPanel/Actions) | — | ❌ Unknown |
| Upload limits (`upload_max_filesize`, `post_max_size`, `max_file_uploads`) | — | ❌ Unknown |
| ModSecurity/WAF behavior for webhooks and uploads | — | ❌ Unknown |
| Outbound HTTPS access | — | ❌ Unknown |
| SSL certificate status | — | ❌ Unknown |
| Real domain/subdomain | `<real-domain>` | ❌ Unknown |

---

## 3. Credentials

| Credential | Needed for | Status |
| --- | --- | --- |
| Existing production `APP_KEY` | Preserving encrypted data | ❌ Must be copied securely (do not regenerate) |
| SMTP host/port/encryption/username/password | Email notifications | ❌ Missing |
| `MAIL_FROM_ADDRESS` / `MAIL_FROM_NAME` | Email notifications | ❌ Missing |
| Flutterwave public key, secret key, webhook secret | Flutterwave payments | ❌ Missing / confirm names used in source |
| Stripe publishable key, secret key, webhook secret | Stripe payments | ❌ Missing / confirm names used in source |
| PayPal client ID, client secret, mode | PayPal payments | ❌ Missing |
| Paystack public key, secret key | Paystack payments | ❌ Missing |
| Map tile provider | Tracking map | ✅ OpenStreetMap tiles, no API key required |
| QR code | Receipt rendering | ✅ Client-side `qrcode@1.5.3` loaded from jsDelivr; allow CDN or vendor the script locally |

Payment gateway credentials are stored in the database `payment_settings` table and managed from the Admin payment settings screens (encrypted). The gateway classes read `PaymentSetting::$secret_key`/related fields, not `.env` directly. `.env` gateway keys are retained only as optional seeding/reference values; do not assume they activate a gateway. Confirm test/live mode in Admin Settings.

---

## 4. Security actions

- [x] Remove `.env`, credential notes, cookies, sessions, logs, uploads, and SQL dumps from Git tracking (committed and pushed).
- [ ] Rotate the Aiven database password that was committed in `MySQL Connection Details.txt` and `backend/.env`.
- [ ] Decide whether to purge secrets from Git history (required if the repo was ever public/shared).
- [ ] Store the production `APP_KEY` in a password manager.
- [ ] Keep the GitHub repository private until verification is complete.
- [ ] Confirm whether the uploaded shipment photo in history is sensitive and purge history if necessary.

---

## 5. Configuration decisions confirmed from source

1. Shipment attachments use the `public` disk and are served via `public/storage`.
2. Shipment photos: maximum 10 files, 5 MB each, `jpg/jpeg/png/webp`. Chat attachments: maximum 5 files, 10 MB each.
3. Sessions use `file`; there is no `sessions` table in the schema. Keep `SESSION_DRIVER=file`.
4. Queue stays `sync`; no worker or Supervisor required.
5. Broadcast events exist (`GuestChatMessageSent`, `ShipmentUpdated`) and implement `ShouldBroadcast`, but `BROADCAST_CONNECTION=log` disables real-time delivery. Keep `log` on shared hosting.
6. Live chat and tracking use AJAX polling (5 s and 4 s intervals respectively), with WebSocket fallback only if configured.
7. Tracking maps use OpenStreetMap tiles (`tile.openstreetmap.org`); no API key is required.
8. QR codes are generated client-side with `qrcode@1.5.3` from jsDelivr; allow the CDN or vendor the script locally.
9. Payment gateways are enabled and configured in Admin Settings and stored (encrypted) in `payment_settings`; confirm live/test mode there, not in `.env`.
10. No scheduled tasks are registered in `routes/console.php`; no cron job is required.
11. The app uses the standard Vite `public/build` manifest, which is included in the repository.
12. No feature requires Redis, Supervisor, or a persistent Node process. Reverb is installed but not required.

---

## 6. Readiness statement

The project is **not deployment-ready**. The source is restored and boot-verified locally, the repository is secured for the current commit, and the deployment documentation and templates are in place. The remaining blockers are:

1. Unconfirmed OgaHosting capabilities and account details.
2. Unrotated exposed credentials still present in Git history.
3. No production `backend/.env` or server-side Composer install yet.
4. No runtime feature testing against a safe database or the real host.
