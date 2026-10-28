# FreightFlow / FedExUS Logistics Platform

Logistics, shipment tracking, and payment management application built on Laravel 12.

## Status

**Not deployment-ready yet.** The repository currently does not contain the Laravel application source (`backend/app`, `backend/config`, `backend/routes`, `backend/resources`, `backend/database/migrations`, `backend/artisan`, `backend/composer.json`, `backend/public/index.php`). The dependency tree, database dumps, compiled caches, sessions, and one uploaded photo are present, but the application cannot boot without the missing source.

See [`docs/HOSTING_COMPATIBILITY_REPORT.md`](docs/HOSTING_COMPATIBILITY_REPORT.md) for the full audit and [`docs/MISSING_REQUIREMENTS.md`](docs/MISSING_REQUIREMENTS.md) for the exact list of missing files, hosting details, and credentials.

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
| [`docs/MISSING_REQUIREMENTS.md`](docs/MISSING_REQUIREMENTS.md) | Missing source, hosting info, credentials |
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
