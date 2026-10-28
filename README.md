# FreightFlow / FedExUS Logistics Platform

Logistics, shipment tracking, and payment management application built on Laravel 12.

## Status

**Source restored and locally verified; not yet deployed.** The Laravel application source is now in `backend/`. Locally verified: `php artisan --version` (Laravel 12.64.0), `php artisan route:list` (171 routes), `composer validate`, and `npm run build` all succeed on PHP 8.2.12 / Node 25.2.1.

The project is **not deployment-ready** until OgaHosting capabilities are confirmed, the exposed Aiven credentials are rotated, a production `backend/.env` is created, and runtime features are tested against the real host.

Database note: the source has 31 migration files, but the two 29-table dumps record only 27 applied migrations. Reconcile the 5 pending migrations after a backup — one of them drops legacy `conversations`, `messages`, and `addresses` tables. Follow `docs/DATABASE_MIGRATION_GUIDE.md` section 8.1.

See [`docs/HOSTING_COMPATIBILITY_REPORT.md`](docs/HOSTING_COMPATIBILITY_REPORT.md) for the full audit and [`docs/MISSING_REQUIREMENTS.md`](docs/MISSING_REQUIREMENTS.md) for remaining hosting details and credentials.

## Stack

- PHP 8.2+ (8.3 recommended)
- Laravel 12.64
- MySQL 8 / MariaDB 10.4+ (`utf8mb4`, InnoDB)
- Vite 6, Tailwind CSS 3, Alpine.js 3, Leaflet 1.9
- Livewire 3.8, Sanctum 4.3
- DomPDF 3.1, picqer barcode generator 3.2
- Stripe PHP SDK 21
- Shared-hosting safe defaults: file sessions, file cache, synchronous queue, AJAX polling chat

## Deployment documents

| Document | Purpose |
| --- | --- |
| [`docs/OGAHOSTING_DEPLOYMENT.md`](docs/OGAHOSTING_DEPLOYMENT.md) | Main step-by-step deployment runbook |
| [`docs/HOSTING_COMPATIBILITY_REPORT.md`](docs/HOSTING_COMPATIBILITY_REPORT.md) | Compatibility audit, requirements, blockers |
| [`docs/DATABASE_MIGRATION_GUIDE.md`](docs/DATABASE_MIGRATION_GUIDE.md) | Database creation, import, verification, rollback |
| [`docs/PRODUCTION_CONFIG_CHECKLIST.md`](docs/PRODUCTION_CONFIG_CHECKLIST.md) | Production configuration checklist |
| [`docs/BACKUP_AND_ROLLBACK.md`](docs/BACKUP_AND_ROLLBACK.md) | Backup and rollback procedures |
| [`docs/GITHUB_TO_OGAHOSTING.md`](docs/GITHUB_TO_OGAHOSTING.md) | GitHub preparation and host connection |
| [`docs/FEATURE_TEST_REPORT.md`](docs/FEATURE_TEST_REPORT.md) | Feature-by-feature test status |
| [`docs/MISSING_REQUIREMENTS.md`](docs/MISSING_REQUIREMENTS.md) | Remaining hosting info, credentials, and security actions |
| [`docs/FILES_CHANGED.md`](docs/FILES_CHANGED.md) | Change record |

Inactive deployment templates are under [`deployment/`](deployment/). They must be verified against the real hosting account before being enabled.

## Environment

Copy `backend/.env.example` to `backend/.env` on the server and fill in the placeholders. Never commit the real `.env`.

**Do not generate a new `APP_KEY` for an existing installation.** Copy the production key so existing encrypted data remains readable.

Website title, logo, bank accounts, enabled payment gateways, and other editable settings are stored in the database through the Admin Settings system. Do not move them into `.env`.

## Security notice

Earlier commits in this repository tracked `backend/.env`, a database credential file, cookies, sessions, logs, SQL dumps, and an uploaded shipment photo. Those files are now excluded from Git tracking, but they remain in history. Rotate any exposed credentials and review [`docs/GITHUB_TO_OGAHOSTING.md`](docs/GITHUB_TO_OGAHOSTING.md) before making the repository public.

## Do not

- Commit `.env` or real credentials.
- Commit `vendor/`, `node_modules/`, `.npm-cache/`, logs, sessions, or uploads.
- Import demo/test data into production.
- Run `migrate:fresh`, `db:wipe`, or destructive SQL on production.
- Copy the entire Laravel project into `public_html`.
- Assume SSH, Composer, cron, or a persistent Node/WebSocket process is available.
