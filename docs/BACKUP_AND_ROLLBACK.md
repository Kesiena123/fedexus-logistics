# Backup and Rollback Guide

**No deployment may overwrite the current production site until both the file backup and the database backup are complete, downloaded, and verified.**

---

## 1. Before you start

Record:

- Current application version / Git commit.
- Current database name and size.
- Current `APP_KEY` (store it securely; you will need it if you restore the old environment).
- Current uploaded files size.
- The person performing the deployment and the date/time.

---

## 2. Back up website files

### Option A — Host file manager / FTP

1. Compress the entire application directory (for example `/home/<account>/fedexus`) into a `<site>-files-YYYYMMDD-HHMM.zip`.
2. Download the archive to your computer.
3. Verify the archive opens and contains `app/`, `public/`, `storage/`, `.env`, and `vendor/`.
4. Leave the server archive outside `public_html`.

### Option B — SSH

```bash
cd /home/<account>
tar -czf ~/backups/<site>-files-$(date +%Y%m%d-%H%M).tar.gz fedexus
```

Download the archive:

```bash
scp <account>@<host>:~/backups/<site>-files-YYYYMMDD-HHMM.tar.gz .
```

Verify:

```bash
tar -tzf <site>-files-YYYYMMDD-HHMM.tar.gz | head -50
```

### Do not forget

- `storage/app/public/` (shipment photos and proofs)
- `.env`
- `public/build/`
- Any custom files outside the Laravel root

---

## 3. Back up the database

### Option A — phpMyAdmin

1. Open cPanel → **phpMyAdmin**.
2. Select the production database.
3. Click **Export**.
4. Choose **Custom**:
   - Format: SQL
   - Include: structure and data
   - Add `DROP TABLE` / `IF NOT EXISTS`: choose the safe option for your restore plan
   - Character set: `utf8mb4`
5. Click **Go** and download the `.sql` file.
6. Verify the file contains `CREATE TABLE` and `INSERT` statements.

### Option B — SSH / mysqldump

```bash
mysqldump \
  --host=<db-host> \
  --user=<db-user> \
  --password \
  --single-transaction \
  --routines \
  --triggers \
  --default-character-set=utf8mb4 \
  <db-name> > ~/backups/<site>-db-$(date +%Y%m%d-%H%M).sql
```

Download it:

```bash
scp <account>@<host>:~/backups/<site>-db-YYYYMMDD-HHMM.sql .
```

Verify:

```bash
grep -c "CREATE TABLE" <site>-db-YYYYMMDD-HHMM.sql
```

The count should match the expected number of tables (29 for the current schema).

---

## 4. Verify the backups

- [ ] File archive downloads completely and opens.
- [ ] Database dump downloads completely.
- [ ] Database dump contains all expected tables.
- [ ] Database dump contains data (for example `users`, `shipments`).
- [ ] Uploaded files are present in the archive.
- [ ] Backups are stored in at least two locations (local computer + secure cloud/offline).
- [ ] Backups are **not** inside `public_html`.

Test a restore on a staging/local database before relying on the backup.

---

## 5. Deployment rollback plan

### 5.1 Prepare a previous release directory

Before uploading new code, rename the current application directory:

```bash
cd /home/<account>
mv fedexus fedexus_previous_YYYYMMDD
```

Deploy the new code into a fresh `fedexus` directory, then point the document root to it. This makes rollback a rename, not a file-by-file restore.

### 5.2 If the site breaks after deployment

1. Put the site into maintenance mode if possible:
   ```bash
   cd /home/<account>/fedexus
   php artisan down
   ```
2. Restore the previous application directory:
   ```bash
   cd /home/<account>
   mv fedexus fedexus_failed_YYYYMMDD
   mv fedexus_previous_YYYYMMDD fedexus
   ```
3. If the document root points directly to the directory name, update it back.
4. Restore the database only if the deployment changed data:
   - **Preferred:** use phpMyAdmin to import the verified dump into the existing database.
   - If the new release created a new database, point `.env` back to the old database instead of overwriting it.
5. Clear caches if Artisan is available:
   ```bash
   cd /home/<account>/fedexus
   php artisan optimize:clear
   ```
6. Verify the site and the smoke tests.
7. Preserve the failed directory and logs for investigation; do not delete them until the cause is known.

### 5.3 Database rollback

1. Stop the site.
2. Export the current (broken) database first, so you do not lose evidence.
3. Confirm the target backup file and database name.
4. Import the backup through phpMyAdmin or:
   ```bash
   mysql --host=<db-host> --user=<db-user> --password <db-name> < <site>-db-YYYYMMDD-HHMM.sql
   ```
5. Verify table count, row counts, and foreign keys.
6. Restart the site and test.

Never drop a database without confirming it is not the live one.

---

## 6. Rollback of uploaded files

Uploaded shipment photos are data, not code.

- If a deployment accidentally replaced `storage/app/public`, restore it from the file archive:
  ```bash
  cd /home/<account>/fedexus
  rm -rf storage/app/public
  tar -xzf ~/backups/<site>-files-YYYYMMDD-HHMM.tar.gz \
    --strip-components=3 \
    fedexus/storage/app/public
  ```
  Adjust `--strip-components` to match the archive layout.
- Recreate the link if needed:
  ```bash
  php artisan storage:link
  ```
- Verify a known shipment photo URL returns `200`, not `404`.

---

## 7. Rollback of environment changes

- Keep a copy of the previous `.env` in a private location (never in Git).
- If a configuration change breaks the site, restore the previous `.env` values one section at a time.
- Do **not** regenerate `APP_KEY` during rollback; keep the key that matches the restored database.

---

## 8. Post-incident actions

1. Write down what failed, when, and which step.
2. Preserve logs from `storage/logs/laravel.log` and the web server.
3. Rotate any credential that may have been exposed.
4. Update the deployment checklist to prevent recurrence.
5. Only delete the previous release after the new release has passed all smoke tests and a new verified backup exists.
