# Missing Requirements and Credentials

Everything in this document must be resolved before the project can be declared deployment-ready. Do not invent values for any item.

---

## 1. Application source (blocker)

The following are absent from the repository and must be restored from the authoritative copy:

| Path | Why it is required |
| --- | --- |
| `backend/app/` | Controllers, models, middleware, providers, jobs, policies, services |
| `backend/bootstrap/app.php` | Laravel application bootstrap |
| `backend/bootstrap/providers.php` | Provider registration (Laravel 11/12 style) |
| `backend/config/` | Database, mail, filesystems, session, cache, queue, services, payments |
| `backend/database/migrations/` | Reproducible schema changes |
| `backend/resources/` | Blade views, CSS, JavaScript |
| `backend/routes/` | Web, API, console routes |
| `backend/tests/` | Test suite |
| `backend/artisan` | CLI entry point |
| `backend/composer.json` | Dependency manifest |
| `backend/composer.lock` | Reproducible dependency lock |
| `backend/package.json` | Frontend dependency manifest |
| `backend/package-lock.json` | Reproducible frontend lock |
| `backend/vite.config.js` | Vite build configuration |
| `backend/tailwind.config.js` | Tailwind configuration |
| `backend/postcss.config.js` | PostCSS configuration |
| `backend/public/index.php` | HTTP front controller |
| `backend/public/.htaccess` | Apache rewrite/security rules (or server equivalent) |

Until these exist, the site cannot be booted, tested, built, or deployed.

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
| Map tile provider key (if required) | Tracking map | ❌ Confirm provider and key |
| QR code library/key (if external) | QR rendering | ❌ Confirm in source |

The existing `.env` contains `STRIPE_SECRET`, `PAYPAL_CLIENT_ID`, `PAYPAL_CLIENT_SECRET`, `FLUTTERWAVE_SECRET_KEY`, and `PAYSTACK_SECRET_KEY` names. The restored source must confirm the exact variable names it reads. Do not rename variables blindly.

---

## 4. Security actions

- [ ] Rotate the Aiven database password that was committed in `MySQL Connection Details.txt` and `backend/.env`.
- [ ] Remove `.env`, credential notes, cookies, sessions, logs, uploads, and SQL dumps from Git tracking.
- [ ] Decide whether to purge secrets from Git history (required if the repo was ever public/shared).
- [ ] Store the production `APP_KEY` in a password manager.
- [ ] Keep the GitHub repository private until verification is complete.
- [ ] Confirm whether the uploaded shipment photo in the repository is sensitive and remove it from history if necessary.

---

## 5. Configuration decisions to confirm

These cannot be confirmed without the restored source:

1. Exact storage disk used for shipment attachments (`public` per the schema, confirm code).
2. Maximum number/size of shipment photos.
3. Whether sessions are expected to use `file` (no `sessions` table exists) — current `.env` uses `file`.
4. Whether the queue is expected to stay `sync`.
5. Whether Reverb/WebSockets are actually used or only configured.
6. Whether the live chat uses AJAX polling or broadcasting.
7. Whether the map tile provider requires a key.
8. Whether QR codes are generated server-side or client-side.
9. Which payment gateways are enabled in Admin settings and their live/test modes.
10. Which scheduled tasks/cron jobs the application registers.
11. Whether the app uses `public/build` or a different asset path.
12. Whether any feature depends on Redis, Supervisor, or a persistent Node process (none should be assumed).

---

## 6. Readiness statement

The project is **not deployment-ready**. The repository now contains a secure `.gitignore`, a production `.env.example`, deployment documentation, and inactive deployment templates. The remaining blockers are:

1. Missing application source and manifests.
2. Unconfirmed OgaHosting capabilities.
3. Unrotated exposed credentials.
4. No runtime tests possible until (1) is resolved.
