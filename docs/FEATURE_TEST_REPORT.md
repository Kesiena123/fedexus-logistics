# Feature-by-Feature Test Report

**Date:** 2026-10-28
**Environment:** local Windows workstation, repository inspection only
**Application source available?** **No**
**Application bootable?** **No** (`app/`, `config/`, `routes/`, `artisan`, `public/index.php` missing)
**OgaHosting account available?** **No**

This report separates tests that were actually run from tests that require the missing source code or hosting access. No unperformed test is reported as passing.

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
| 14 | PHP/Composer availability | `php -v`, `composer -V` | ⚠️ Not required for repository prep; not run |
| 15 | Laravel startup | `php artisan` | ⛔ **Not possible** (Artisan missing) |
| 16 | Route list | `php artisan route:list` | ⛔ **Not possible** |
| 17 | Migration status | `php artisan migrate:status` | ⛔ **Not possible** |
| 18 | Automated test suite | `php artisan test` / PHPUnit | ⛔ **Not possible** (tests missing) |
| 19 | Frontend build | `npm run build` | ⛔ **Not possible** (`package.json` missing) |
| 20 | HTTP smoke tests | Browser/curl | ⛔ **Not possible** (no front controller) |

---

## 2. Feature matrix

Legend:

- **Schema ✅** — the database schema supports the feature.
- **Code ⛔** — the application source required to test it is missing.
- **Runtime ⛔** — requires a running application and/or hosting access.
- **Status** — honest overall result.

| Feature | Schema support | Code present | Tested | Status |
| --- | --- | --- | --- | --- |
| Admin dashboard | `users.role`, `admin_audit_logs`, `admin_settings` | ⛔ | No | ⛔ Untestable |
| Admin login | `users` (password, 2FA fields, suspend fields) | ⛔ | No | ⛔ Untestable |
| Shipment creation | `shipments`, `shipment_drafts`, `warehouses` | ⛔ | No | ⛔ Untestable |
| Shipment editing | `shipments`, `shipment_schedules` | ⛔ | No | ⛔ Untestable |
| Multiple shipment photos | `shipment_attachments` (disk, path, mime, size) | ⛔ | No | ⛔ Untestable |
| Photo add/replace/delete | `shipment_attachments` | ⛔ | No | ⛔ Untestable |
| Photo persistence across deploys | Storage layout documented | ⛔ | No | ⚠️ Plan documented only |
| Tracking number generation | `shipments.tracking_number` | ⛔ | No | ⛔ Untestable |
| Guest tracking without accounts | `shipments`, `tracking_events` | ⛔ | No | ⛔ Untestable |
| Shipment status + history | `shipments.status`, `tracking_events` | ⛔ | No | ⛔ Untestable |
| Tracking map | `tracking_events.latitude/longitude`, `shipment_route_points`; Leaflet installed | ⛔ | No | ⛔ Untestable |
| Shipment-specific locations | `shipment_route_points` | ⛔ | No | ⛔ Untestable |
| Sender/receiver information | `shipments.origin_address`, `destination_address` | ⛔ | No | ⛔ Untestable |
| Payment requests | `payment_requests`, `payment_audit_logs` | ⛔ | No | ⛔ Untestable |
| Payment history | `payment_transactions`, `payments` | ⛔ | No | ⛔ Untestable |
| Flutterwave | `payment_settings`; env key present | ⛔ | No | ⛔ Untestable |
| Manual bank transfer + proof | `bank_accounts`, `payment_proofs` | ⛔ | No | ⛔ Untestable |
| Pay on delivery / staged payments | `payments` (stage, percentage, status) | ⛔ | No | ⛔ Untestable |
| Stripe | Stripe SDK v21 + `STRIPE_SECRET` | ⛔ | No | ⛔ Untestable |
| PayPal | Env keys present; no SDK | ⛔ | No | ⛔ Untestable |
| Paystack | Env key present | ⛔ | No | ⛔ Untestable |
| Cryptocurrency | No schema/env evidence | ⛔ | No | ⚠️ Not evidenced |
| Guest–admin live chat | `guest_chat_conversations`, `guest_chat_messages` | ⛔ | No | ⛔ Untestable |
| Receipts | DomPDF installed; `email_logs` | ⛔ | No | ⛔ Untestable |
| Barcode | `picqer/php-barcode-generator` installed | ⛔ | No | ⛔ Untestable |
| QR code | No dedicated PHP QR package found | ⛔ | No | ⚠️ Confirm in source |
| Email notifications | `email_logs`, Symfony Mailer | ⛔ | No | ⛔ Untestable |
| Website title/logo/settings | `admin_settings` | ⛔ | No | ⛔ Untestable |
| Responsive frontend | Tailwind + Alpine installed | ⛔ | No | ⛔ Untestable |
| Existing routes | No `routes/` | ⛔ | No | ⛔ Untestable |
| CSRF protection | Laravel default (source missing) | ⛔ | No | ⛔ Untestable |
| Payment callback verification | Source missing | ⛔ | No | ⛔ Untestable |
| Production error handling | Source/config missing | ⛔ | No | ⛔ Untestable |
| Missing-env handling | `.env.example` created | ⛔ | No | ⚠️ Template only |
| Asset loading | `public/build` absent | ⛔ | No | ⛔ Untestable |

---

## 3. Security findings

| Severity | Finding | Action |
| --- | --- | --- |
| Critical | `backend/.env` tracked in Git with database credentials and `APP_KEY` | Remove from tracking; rotate database password; store key securely |
| Critical | `MySQL Connection Details.txt` tracked with a database password | Remove from tracking; rotate password; delete from history if the repo was public |
| High | Cookies and session files tracked | Remove from tracking; discard sessions |
| High | Logs tracked (`laravel.log`, dev server logs) | Remove from tracking; review for leaked tokens |
| High | Uploaded shipment photo tracked | Remove from tracking; keep in persistent server storage |
| Medium | SQL dumps tracked with personal/operational data | Remove from tracking; treat as sensitive |
| Medium | `vendor/` and `node_modules/` tracked | Remove from tracking; install/build properly |
| Low | Windows junction `public/storage` with local absolute path | Replace on server with a relative symlink |

---

## 4. What must be tested after the source and host are available

1. `composer install --no-dev --optimize-autoloader`
2. `php artisan about`
3. `php artisan route:list`
4. `php artisan migrate:status`
5. `php artisan test` (if a test suite exists)
6. `npm ci && npm run build`
7. Login, shipment CRUD, multi-photo workflows.
8. Guest tracking and shipment isolation.
9. Payment gateway sandbox flows and callback verification.
10. Manual bank transfer proof upload/verification.
11. Live chat polling.
12. Map loading and tile provider.
13. Receipt/barcode/QR rendering.
14. SMTP delivery.
15. Admin settings persistence.
16. Browser console and `storage/logs/laravel.log`.
17. OgaHosting-specific checks: PHP version, extensions, upload limits, document root, rewrites, WAF.

---

## 5. Conclusion

The deployment assets that can be produced without the application source have been produced. **No runtime feature has been declared working.** The application remains untestable and not deployment-ready until the source is restored and the hosting details are confirmed.
