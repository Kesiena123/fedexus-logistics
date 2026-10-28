# Connecting GitHub to OgaHosting

This guide covers preparing the GitHub repository safely and connecting it to OgaHosting. **No OgaHosting integration is claimed to exist.** Verify each capability in the control panel before relying on it.

Repository: `https://github.com/Kesiena123/fedexus-logistics.git`
Default branch: `main`

---

## 1. Security first: the current repository contains secrets

The current `main` (commit `1f3b4e6`) tracks:

- `backend/.env` with a database host, username, password, and `APP_KEY`
- `MySQL Connection Details.txt` with a database password
- cookies, session files, logs
- an uploaded shipment photo
- SQL dumps with operational data
- `vendor/` and `node_modules/`

`.gitignore` now excludes these categories, but adding a file to `.gitignore` does **not** remove it from Git history.

Required actions:

1. Rotate the exposed database password immediately.
2. Treat the uploaded photo, cookies, sessions, and logs as sensitive. Discard them from the server and rotate any token found in the logs.
3. Untrack the sensitive files in a new commit (see section 2).
4. If the repository has ever been public or shared, consider rewriting history to purge the secrets (section 3).
5. Keep the real `APP_KEY` in a password manager; do not regenerate it for the existing database.

---

## 2. Untrack sensitive and generated files

From the repository root:

```powershell
git rm -r --cached --ignore-unmatch `
  backend/.env `
  backend/vendor `
  backend/node_modules `
  .npm-cache `
  backend/storage `
  backend/bootstrap/cache `
  backend/database/*.sql `
  backend/cookies.txt `
  cookies.txt `
  "MySQL Connection Details.txt" `
  response_headers.txt `
  allpromt
```

Then:

```powershell
git add .gitignore backend/.env.example
git status
git commit -m "chore: secure repository for OgaHosting deployment"
```

The files remain on your local disk but will no longer be part of new commits.

> Because the repo already contains these files in history, rotate anything sensitive. Untracking only protects future commits.

---

## 3. Optional: purge secrets from history

Only do this if the repository was public or shared, and coordinate with every collaborator. It rewrites history and requires a force push.

Using `git filter-repo` (install separately):

```bash
git filter-repo \
  --path backend/.env \
  --path "MySQL Connection Details.txt" \
  --path cookies.txt \
  --path backend/cookies.txt \
  --path backend/storage \
  --invert-paths
```

Then:

```bash
git push --force-with-lease origin main
```

After rewriting, rotate every credential that was ever committed. History rewriting does not make an exposed password safe.

---

## 4. Prepare branches and protection

Recommended:

- `main` = production-ready only.
- `develop` or feature branches for changes.
- Require pull requests before merging to `main` (GitHub → Settings → Branches).
- Require status checks if CI is added.
- Keep the repository **private** until the app is verified.

---

## 5. Choose the deployment method

Verify in this order. Do not skip verification.

### Option 1 — OgaHosting-native GitHub/Git deployment

Ask OgaHosting support:

- Does the control panel offer a GitHub integration?
- Which repository/branch can it deploy?
- What directory does it deploy to?
- Does it run Composer/npm?
- Does it preserve `storage/` and `.env`?

If the answer is yes, follow the provider's instructions. Do not create a `.cpanel.yml` unless the provider confirms cPanel Git Version Control.

### Option 2 — cPanel Git Version Control

Only if cPanel shows **Git Version Control**:

1. Confirm the repository URL and branch.
2. Confirm the clone path (for example `/home/<account>/fedexus`).
3. Confirm the PHP CLI path and Composer path.
4. Copy `deployment/cpanel.yml.example` to `.cpanel.yml` at the repository root.
5. Replace every placeholder (`<DEPLOY_PATH>`, `<PHP_BIN>`, `<COMPOSER_BIN>`, `<APP_ROOT>`).
6. Keep persistent data (`storage/app/public`, `.env`) out of the copy/delete operations.
7. Commit and push `.cpanel.yml`.
8. In cPanel, run **Pull or Deploy** and review the output.

> The example file is **not active**. It is a template. Do not rename it to `.cpanel.yml` until the paths are confirmed.

### Option 3 — GitHub Actions over SSH/SFTP

Only if SSH or SFTP is available.

1. Copy `deployment/github-actions-deploy.example.yml` to `.github/workflows/deploy.yml`.
2. Replace placeholders.
3. Add secrets in GitHub → Settings → Secrets and variables → Actions:
   - `SSH_HOST`
   - `SSH_USER`
   - `SSH_PRIVATE_KEY`
   - `SSH_PORT` (optional)
   - `DEPLOY_PATH`
4. Restrict the workflow to `main`.
5. Run tests/build before upload.
6. Exclude `.env`, `.git`, `vendor/` (unless deliberately uploading it), `node_modules/`, logs, sessions, and uploads.
7. Never delete `storage/app/public`.
8. Stop if the build or tests fail.

Do not hardcode credentials in the workflow file.

### Option 4 — Manual deployment (default safe fallback)

1. Push the verified code to GitHub.
2. Download the repository ZIP from GitHub (or use `git archive`).
3. Upload it with the hosting File Manager or FTP/SFTP.
4. Follow `docs/OGAHOSTING_DEPLOYMENT.md`.
5. Do not upload `.env`, `.git`, logs, sessions, SQL dumps, or local uploads.

---

## 6. What to exclude from every deployment

- `.env` (create it on the server instead)
- `.git/`
- `node_modules/`
- `.npm-cache/`
- `backend/vendor/` (unless Composer is unavailable and the fallback is documented)
- `backend/storage/framework/{cache,sessions,views}/*`
- `backend/storage/logs/*`
- `backend/storage/app/public/*` (uploaded files; preserve the server copy)
- `backend/bootstrap/cache/*.php`
- `*.sql`, `*.sqlite`
- `cookies.txt`, credential notes, `response_headers.txt`
- `allpromt/`
- local logs (`dev-server.log`, `vite-server.log`, etc.)

---

## 7. First push from this workstation

```powershell
git status
git add .gitignore backend/.env.example docs deployment
git commit -m "docs: prepare OgaHosting deployment assets and secure repository"
git push origin main
```

If the remote changed:

```powershell
git pull --rebase origin main
git push origin main
```

Do not force push unless you intentionally rewrote history and coordinated with collaborators.

---

## 8. Verification after connecting

- [ ] The deployed commit hash matches the intended GitHub commit.
- [ ] `.env` was not overwritten.
- [ ] `storage/app/public` still contains the existing shipment photos.
- [ ] `public/build` is current.
- [ ] The site loads over HTTPS.
- [ ] Admin login works.
- [ ] The smoke tests in `docs/PRODUCTION_CONFIG_CHECKLIST.md` pass.

---

## 9. What is automated today

| Step | Automated in this repo |
| --- | --- |
| Secret exclusion | ✅ `.gitignore` |
| Environment template | ✅ `backend/.env.example` |
| Documentation | ✅ `docs/` |
| cPanel deploy | ❌ Template only |
| GitHub Actions deploy | ❌ Template only |
| Host capability detection | ❌ Manual |
| Source restoration | ❌ Manual (currently missing) |
| Database import | ❌ Manual |
| Post-deploy smoke test | ❌ Manual |
