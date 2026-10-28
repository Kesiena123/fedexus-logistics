# Production Configuration Checklist

Use this checklist before, during, and after the OgaHosting deployment. Items marked **[BLOCKER]** must be resolved before going live.

---

## 1. Source and repository

- [ ] **[BLOCKER]** Full Laravel source restored (`app/`, `config/`, `routes/`, `resources/`, `database/migrations/`, `artisan`, `bootstrap/app.php`, `bootstrap/providers.php`).
- [ ] **[BLOCKER]** `composer.json` and `composer.lock` restored and consistent.
- [ ] **[BLOCKER]** `package.json` and `package-lock.json` restored.
- [ ] **[BLOCKER]** `public/index.php` and `public/.htaccess` restored.
- [ ] `.env` is not tracked in Git.
- [ ] `vendor/`, `node_modules/`, `.npm-cache/`, logs, sessions, compiled views, SQL dumps, and uploads are not tracked.
- [ ] Real credentials are not present in Git history for the current HEAD. (Rotate anything that was previously committed.)
- [ ] Repository is private until the application is safe to publish.

## 2. Environment

- [ ] `APP_ENV=production`
- [ ] `APP_DEBUG=false`
- [ ] `APP_URL=https://<real-domain>` (no trailing slash)
- [ ] `APP_KEY` copied from the existing installation — **not regenerated**
- [ ] `APP_TIMEZONE` matches business requirements (default `UTC`)
- [ ] `LOG_CHANNEL=stack`, `LOG_STACK=daily`, `LOG_LEVEL=error`
- [ ] `.env` permissions `600` (or the host's equivalent)
- [ ] `.env` not reachable over HTTP (`https://<domain>/.env` returns 403/404)

## 3. Database

- [ ] Database and least-privilege user created in the control panel.
- [ ] `DB_HOST`, `DB_PORT`, `DB_DATABASE`, `DB_USERNAME`, `DB_PASSWORD` correct.
- [ ] `DB_CHARSET=utf8mb4`, `DB_COLLATION=utf8mb4_unicode_ci`.
- [ ] Schema imported successfully; all tables InnoDB/utf8mb4.
- [ ] Foreign keys valid.
- [ ] `migrations` state reviewed.
- [ ] No demo shipments, fake payments, or test accounts in production.
- [ ] `payment_settings` and `admin_settings` content preserved.
- [ ] Database backup taken and verified.

## 4. Sessions, cache, queues

- [ ] `SESSION_DRIVER=file`
- [ ] `SESSION_ENCRYPT=true`
- [ ] `SESSION_SECURE_COOKIE=true`
- [ ] `SESSION_SAME_SITE=lax` (or `strict` if compatible with payment redirects)
- [ ] `SESSION_DOMAIN` correct for the real domain
- [ ] `CACHE_STORE=file`
- [ ] `QUEUE_CONNECTION=sync`
- [ ] `BROADCAST_CONNECTION=log`
- [ ] No Redis, Supervisor, or queue worker required.

## 5. Filesystem and uploads

- [ ] `storage/` and `bootstrap/cache/` writable by PHP (`775` typical).
- [ ] `public/storage` → `storage/app/public` link exists and resolves.
- [ ] `storage/app/public` is persistent across deployments.
- [ ] Existing shipment photos copied and visible.
- [ ] Multi-photo create/edit/delete works.
- [ ] Upload limits allow the expected photo sizes.
- [ ] Directory listing is disabled.
- [ ] `storage/`, `.env`, `composer.json`, `artisan`, and `database/` are not web-accessible.

## 6. Frontend assets

- [ ] `npm ci` completed locally.
- [ ] `npm run build` completed with no errors.
- [ ] `public/build/` uploaded.
- [ ] CSS, JS, images, and Leaflet assets load over HTTPS.
- [ ] Browser console has no blocking errors.

## 7. Email

- [ ] SMTP mailbox created.
- [ ] `MAIL_MAILER`, `MAIL_HOST`, `MAIL_PORT`, `MAIL_USERNAME`, `MAIL_PASSWORD`, `MAIL_ENCRYPTION` set.
- [ ] `MAIL_FROM_ADDRESS` and `MAIL_FROM_NAME` set.
- [ ] SPF/DKIM configured for the sending domain.
- [ ] Test email received.
- [ ] Shipment notification emails received.

## 8. Payments

- [ ] Gateway credentials stored in `.env` or the existing secure mechanism.
- [ ] Admin gateway enable/disable switches still work.
- [ ] Test/live mode separation preserved.
- [ ] Flutterwave callback verified server-side.
- [ ] Stripe webhook signature verified (if enabled).
- [ ] PayPal, Paystack, or other enabled gateways verified.
- [ ] Manual bank transfer proof upload and admin verification work.
- [ ] Pay-on-delivery / staged payment flows work.
- [ ] Amounts, currencies, references, and statuses remain consistent.
- [ ] No secrets in JavaScript, HTML, logs, or error pages.

## 9. Live chat, map, receipts

- [ ] Guest–admin chat sends and polls.
- [ ] `live_chat_poll_seconds` setting respected.
- [ ] Tracking map loads with shipment-specific points.
- [ ] Map tile provider reachable over HTTPS.
- [ ] Receipt PDF renders.
- [ ] Barcode renders.
- [ ] QR code renders.

## 10. Security

- [ ] HTTPS enforced (redirect HTTP → HTTPS).
- [ ] HSTS enabled if the host supports it.
- [ ] `APP_DEBUG=false`.
- [ ] Error pages do not reveal stack traces or secrets.
- [ ] CSRF protection active.
- [ ] Admin login rate limiting/2FA behavior preserved.
- [ ] `composer audit` reviewed after source restoration.
- [ ] `npm audit` reviewed after source restoration.
- [ ] Exposed Aiven credentials rotated.
- [ ] Previously committed cookies/session/logs considered compromised and discarded.

## 11. Caches and optimization

- [ ] `php artisan optimize:clear` run after deployment (or manual cache clearing).
- [ ] `php artisan config:cache` run.
- [ ] `php artisan route:cache` run if all routes are cacheable.
- [ ] `php artisan view:cache` run.
- [ ] No stale compiled views from the local machine.

## 12. Final smoke test

- [ ] Home page.
- [ ] Admin login.
- [ ] Shipment create/edit.
- [ ] Multiple photo upload/edit/delete.
- [ ] Guest tracking.
- [ ] Tracking history and status.
- [ ] Map.
- [ ] Payment request and payment page.
- [ ] Bank transfer proof verification.
- [ ] Receipt/barcode/QR.
- [ ] Email notifications.
- [ ] Live chat.
- [ ] Website title/logo/admin settings.
- [ ] Mobile/responsive layout.
- [ ] `storage/logs/laravel.log` clean.

## 13. Sign-off

| Item | Name | Date | Result |
| --- | --- | --- | --- |
| Backups verified | | | |
| Database imported | | | |
| Environment configured | | | |
| Smoke test passed | | | |
| Payments verified | | | |
| Email verified | | | |
| Uploads verified | | | |
| Rollback plan confirmed | | | |
