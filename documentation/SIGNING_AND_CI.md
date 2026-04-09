# Signing & CI/CD Setup

This document explains how to generate a release keystore, configure GitHub Secrets, and trigger automated signed builds via GitHub Actions.

---

## Privacy Notice

The `scripts/generate_keystore.sh` script:

- Prompts **only** for company/organization details (name, unit, city, state, country code) and passwords.
- Does **NOT** read, collect, or auto-fill any system information, usernames, IP addresses, hostnames, locale data, or environment variables.
- All inputs are manually provided by the operator.

---

## 1. Generate a Keystore

**Prerequisites:** Java JDK installed (for the `keytool` command).

Run the script from the project root:

```bash
chmod +x scripts/generate_keystore.sh
./scripts/generate_keystore.sh
```

The script will:

1. Ask for your **company name**, **organizational unit**, **city**, **state**, and **country code**.
2. Ask for a **keystore password** and **key password** (min 6 characters each).
3. Generate `upload-keystore.jks` in the current directory.
4. Print the keystore as a **base64 string** and show exactly which GitHub Secrets to create.

> **Important:** After copying the base64 output, delete the `.jks` file. Never commit it.

---

## 2. Add GitHub Secrets

Go to your GitHub repository:  
**Settings → Secrets and variables → Actions → New repository secret**

Create these four secrets:

| Secret Name                  | Value                                      |
| ---------------------------- | ------------------------------------------ |
| `MorphCosmicBase64`          | The full base64 string from the script     |
| `MorphCosmicStorePassword`   | The keystore password you entered           |
| `MorphCosmicKeyPassword`     | The key password you entered                |
| `MorphCosmicKeyAlias`        | `upload` (or the alias you chose)           |

---

## 3. How the Workflow Runs

The workflow at `.github/workflows/build.yml` triggers on **every push** to any branch.

It performs these steps:

1. Checks out the repository.
2. Sets up Java 17 (Temurin) and Flutter (stable channel).
3. Decodes the base64 keystore from `MorphCosmicBase64` into `android/app/upload-keystore.jks`.
4. Creates `android/key.properties` with the signing credentials from secrets.
5. Builds a **signed release APK** (`flutter build apk --release`).
6. Builds a **signed release AAB** (`flutter build appbundle --release`).
7. **Deletes** the keystore and `key.properties` (runs even if the build fails).
8. Uploads the APK and AAB as downloadable **workflow artifacts**.

### Security

- The keystore is decoded from secrets at runtime and deleted after the build.
- `key.properties` is generated in-memory during CI and never committed.
- GitHub Actions masks secret values so they are never printed in logs.
- Both APK and AAB are signed in **release mode** — never debug.

---

## 4. Download Build Artifacts

After a successful workflow run:

1. Go to the **Actions** tab in your GitHub repo.
2. Click the latest workflow run.
3. Scroll to **Artifacts** at the bottom.
4. Download `release-apk` and/or `release-aab`.

---

## 5. Local Development

For local release builds, create `android/key.properties` manually:

```properties
storePassword=YOUR_STORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=upload
storeFile=upload-keystore.jks
```

Place the `.jks` file in `android/app/` and run:

```bash
flutter build apk --release
flutter build appbundle --release
```

Both `key.properties` and `*.jks` are excluded by `.gitignore`.

---

## 6. ProGuard / R8 Configuration

The file `android/app/proguard-rules.pro` contains `-dontwarn` rules for Google Play Core classes that Flutter references for deferred components. Since Neon Grid Action Runner does not use deferred components, these rules tell R8 to safely ignore the missing classes during release builds.

No action is required — the rules are applied automatically via `build.gradle.kts`.

---

## File Summary

| File                                    | Purpose                                        |
| --------------------------------------- | ---------------------------------------------- |
| `scripts/generate_keystore.sh`          | Interactive keystore generator                  |
| `.github/workflows/build.yml`           | GitHub Actions signed build workflow            |
| `android/app/build.gradle.kts`          | Gradle config with release signing & R8         |
| `android/app/proguard-rules.pro`        | R8 rules to suppress Play Core warnings         |
| `.gitignore`                            | Excludes keystores, key.properties, secrets     |
