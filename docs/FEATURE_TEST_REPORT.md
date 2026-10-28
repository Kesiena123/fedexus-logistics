# Feature-by-Feature Test Report

**Date:** 2026-10-28
**Environment:** local Windows workstation (PHP 8.2.12, Composer 2.9.3, Node 25.2.1)
**Application source available?** **Yes**
**Application bootable?** **Yes** (`php artisan --version` → Laravel 12.64.0)
**OgaHosting account available?** **No**

This report separates tests that were actually run from tests that require hosting access or a safe database. No unperformed test is reported as passing.

---

## 1. Tests actually run

| # | Test | Method | Result |
| --- | --- | --- | --- |
| 1 | Repository structure audit | Directory and Git index inspection | ✅ Completed |
| 2 | Git history/remote inspection | `git log`, `git ls-remote`, `git status` | ✅ Completed |
| 3 | Dependency inventory | `backend/vendor/composer/installed.json` | ✅ Completed |
| 4 | Frontend package inventory | `backend/node_modules/.package-lock.json` | ✅ Completed |
| 5 | Database schema audit | Parsed all three SQL dumps | ✅ Completed |
| 6 | Migration row audit | Counted and listed `migrations` inserts | ✅ Completed |
| 7 | Table engine/charset audit | Inspected `CREATE TABLE` definitions | ✅ Completed (InnoDB/utf8mb4) |
| 8 | Storage/upload inspection | Listed `storage/app/public` | ✅ Completed (one photo found) |
| 9 | Session/log/cache inspection | Listed `storage/framework`, `storage/logs` | ✅ Completed |
| 10 | Environment key inventory | Read key names from `backend/.env` (values not copied) | ✅ Completed |
| 11 | Secret exposure check | Checked tracked files | ❌ **Failed** — `.env`, credentials, cookies, logs, sessions, uploads are tracked |
| 12 | `.env.example` completeness | Compared keys with current `.env` | ✅ Completed (production template created) |
| 13 | `.gitignore` coverage | Reviewed patterns against tracked categories | ✅ Completed |
| 14 | PHP/Composer availability | `php -v`, `composer -V` | ✅ PHP 8.2.12, Composer 2.9.3 |
| 15 | Laravel startup | `php artisan --version` | ✅ Laravel 12.64.0 |
| 16 | Route list | `php artisan route:list` | ✅ 171 routes registered |
| 17 | Migration status | `php artisan migrate:status` | ⛔ Not run — would contact the remote Aiven database |
| 18 | Automated test suite | `php artisan test` / PHPUnit | ⛔ Not run — `phpunit.xml` does not isolate the DB from the remote database |
| 19 | Frontend build | `npm run build` | ✅ Vite 6.4.3 build succeeded |
| 20 | Composer validation | `composer validate` | ✅ Valid (license warning only) |
| 21 | PHP syntax checks | `php -l` on `artisan`, bootstrap, front controller | ✅ No syntax errors |
| 22 | Secret-pattern scan | Searched restored source for key/token patterns | ✅ Only documented placeholders found |
| 23 | HTTP smoke tests | Browser/curl | ⛔ Not run — no host/browser session |

---

## 2. Feature matrix

Legend:

- **Schema ✅** — the database schema supports the feature.
- **Code ✅** — source code is present; runtime behavior is not yet verified.
- **Runtime ⛔** — requires a safe test database and/or hosting access.
- **Status** — honest overall result.

| Feature | Schema support | Code present | Tested | Status |
| --- | --- | --- | --- | --- |
| Admin dashboard | `users.role`, `admin_audit_logs`, `admin_settings` | ✅ | No | ⛔ Untestable |
| Admin login | `users` (password, 2FA fields, suspend fields) | ✅ | No | ⛔ Untestable |
| Shipment creation | `shipments`, `shipment_drafts`, `warehouses` | ✅ | No | ⛔ Untestable |
| Shipment editing | `shipments`, `shipment_schedules` | ✅ | No | ⛔ Untestable |
| Multiple shipment photos | `shipment_attachments` (disk, path, mime, size) | ✅ | No | ⛔ Untestable |
| Photo add/replace/delete | `shipment_attachments` | ✅ | No | ⛔ Untestable |
| Photo persistence across deploys | Storage layout documented; deployment not verified | ✅ | No | ⚠️ Not deployed |
| Tracking number generation | `shipments.tracking_number` | ✅ | No | ⛔ Untestable |
| Guest tracking without accounts | `shipments`, `tracking_events` | ✅ | No | ⛔ Untestable |
| Shipment status + history | `shipments.status`, `tracking_events` | ✅ | No | ⛔ Untestable |
| Tracking map | `tracking_events.latitude/longitude`, `shipment_route_points`; Leaflet installed | ✅ | No | ⛔ Untestable |
| Shipment-specific locations | `shipment_route_points` | ✅ | No | ⛔ Untestable |
| Sender/receiver information | `shipments.origin_address`, `destination_address` | ✅ | No | ⛔ Untestable |
| Payment requests | `payment_requests`, `payment_audit_logs` | ✅ | No | ⛔ Untestable |
| Payment history | `payment_transactions`, `payments` | ✅ | No | ⛔ Untestable |
| Flutterwave | `payment_settings`; env key present | ✅ | No | ⛔ Untestable |
| Manual bank transfer + proof | `bank_accounts`, `payment_proofs` | ✅ | No | ⛔ Untestable |
| Pay on delivery / staged payments | `payments` (stage, percentage, status) | ✅ | No | ⛔ Untestable |
| Stripe | Stripe SDK v21 + `STRIPE_SECRET` | ✅ | No | ⛔ Untestable |
| PayPal | Env keys present; no SDK | ✅ | No | ⛔ Untestable |
| Paystack | Env key present | ✅ | No | ⛔ Untestable |
| Cryptocurrency | CryptoGateway supports BTC/ETH/USDT/USDC/LTC/DOGE/SOL | ✅ | No | ⛔ Untestable |
| Guest–admin live chat | `guest_chat_conversations`, `guest_chat_messages` | ✅ | No | ⛔ Untestable |
| Receipts | DomPDF installed; `email_logs` | ✅ | No | ⛔ Untestable |
| Barcode | `picqer/php-barcode-generator` installed | ✅ | No | ⛔ Untestable |
| QR code | Client-side `qrcode@1.5.3` via jsDelivr | ✅ | No | ⚠️ Requires CDN access |
| Email notifications | `email_logs`, Symfony Mailer | ✅ | No | ⛔ Untestable |
| Website title/logo/settings | `admin_settings` | ✅ | No | ⛔ Untestable |
| Responsive frontend | Tailwind + Alpine installed | ✅ | No | ⛔ Untestable |
| Existing routes | 171 routes registered | ✅ | No | ⛔ Untestable |
| CSRF protection | Laravel middleware + Blade CSRF tokens present | ✅ | No | ⛔ Untestable |
| Payment callback verification | Gateway callback code present; not executed | ✅ | No | ⛔ Untestable |
| Production error handling | Laravel error handling configured | ✅ | No | ⛔ Untestable |
| Missing-env handling | `.env.example` complete | ✅ | No | ✅ Template complete |
| Asset loading | `public/build` built by Vite | ✅ | No | ⛔ Untestable |

---

## 3. Security findings

| Severity | Finding | Action |
| --- | --- | --- |
| Critical | `backend/.env` was tracked with database credentials and `APP_KEY` | ✅ Removed from HEAD. ❌ Still in history — rotate the database password and store the key securely. |
| Critical | `MySQL Connection Details.txt` was tracked with a database password | ✅ Removed from HEAD. ❌ Still in history — rotate the password; purge history if the repo was public. |
| High | Cookies and session files were tracked | ✅ Removed from HEAD; local sessions should be discarded. |
| High | Logs were tracked (`laravel.log`, dev server logs) | ✅ Removed from HEAD; review history for leaked tokens. |
| High | Uploaded shipment photo was tracked | ✅ Removed from HEAD; keep it in persistent server storage. |
| Medium | SQL dumps were tracked with operational data | ✅ Removed from HEAD; keep them untracked and treat as sensitive. |
| Medium | `vendor/` and `node_modules/` were tracked | ✅ Removed from HEAD; install/build with Composer and npm. |
| Low | Local Windows `public/storage` junction | ✅ Excluded from Git; recreate with `php artisan storage:link` on the host. |

---

## 4. What must be tested on the host or a safe test database

Already completed locally: `composer validate`, `php artisan --version`, `php artisan route:list` (171 routes), `npm run build`, and PHP syntax checks.

Still required:

1. `composer install --no-dev --optimize-autoloader` on the host.
2. `php artisan migrate:status` against the intended database (after backup).
3. `php artisan test` with an isolated test database (current `phpunit.xml` does not isolate the DB).
4. Login, shipment CRUD, multi-photo workflows.
5. Guest tracking and shipment isolation.
6. Payment gateway sandbox flows and callback verification.
7. Manual bank transfer proof upload/verification.
8. Live chat polling.
9. Map loading and tile provider.
10. Receipt/barcode/QR rendering.
11. SMTP delivery.
12. Admin settings persistence.
13. Browser console and `storage/logs/laravel.log`.
14. OgaHosting-specific checks: PHP version, extensions, upload limits, document root, rewrites, WAF.

---

## 5. Conclusion

The source is restored, the application boots locally, all 171 routes register, and the frontend builds. **No runtime feature has been declared working.** Deployment still requires host confirmation, credential rotation, a production `.env`, and feature testing against a safe database.
