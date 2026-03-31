#!/usr/bin/env bash
# ============================================================
# Cosmic Morph — Keystore Generator
#
# This script prompts ONLY for company/organization details.
# It does NOT read, detect, or auto-fill any system, user,
# IP, location, hostname, or environment data.
#
# All values are provided manually by the operator.
# ============================================================

set -euo pipefail

KEYSTORE_FILE="upload-keystore.jks"
KEY_ALIAS="upload"
VALIDITY_DAYS=10000

echo "============================================"
echo " Cosmic Morph — Keystore Generator"
echo "============================================"
echo ""
echo "This script will ask for company details only."
echo "No system or personal data is read automatically."
echo ""

# --- Prompt for company details (minimum 4 fields) ---

read -rp "Company / Organization Name (e.g. MorphCosmic): " CN_ORG
if [ -z "$CN_ORG" ]; then echo "Error: Organization name is required."; exit 1; fi

read -rp "Organizational Unit (e.g. Mobile Development): " CN_OU
if [ -z "$CN_OU" ]; then echo "Error: Organizational unit is required."; exit 1; fi

read -rp "City / Locality (e.g. Tokyo): " CN_CITY
if [ -z "$CN_CITY" ]; then echo "Error: City is required."; exit 1; fi

read -rp "State / Province (e.g. Tokyo): " CN_STATE
if [ -z "$CN_STATE" ]; then echo "Error: State is required."; exit 1; fi

read -rp "Country Code — 2 letters (e.g. JP): " CN_COUNTRY
if [ -z "$CN_COUNTRY" ]; then echo "Error: Country code is required."; exit 1; fi

# --- Prompt for passwords ---

read -rsp "Keystore password (min 6 characters): " STORE_PASS
echo ""
if [ ${#STORE_PASS} -lt 6 ]; then echo "Error: Password must be at least 6 characters."; exit 1; fi

read -rsp "Key password (min 6 characters): " KEY_PASS
echo ""
if [ ${#KEY_PASS} -lt 6 ]; then echo "Error: Password must be at least 6 characters."; exit 1; fi

# --- Build the distinguished name from manual inputs only ---

DNAME="CN=${CN_ORG}, OU=${CN_OU}, O=${CN_ORG}, L=${CN_CITY}, ST=${CN_STATE}, C=${CN_COUNTRY}"

echo ""
echo "Generating keystore..."

keytool -genkeypair \
  -v \
  -keystore "$KEYSTORE_FILE" \
  -alias "$KEY_ALIAS" \
  -keyalg RSA \
  -keysize 2048 \
  -validity "$VALIDITY_DAYS" \
  -storepass "$STORE_PASS" \
  -keypass "$KEY_PASS" \
  -dname "$DNAME"

echo ""
echo "Keystore created: $KEYSTORE_FILE"
echo ""

# --- Encode to base64 ---

BASE64_VALUE=$(base64 -w 0 < "$KEYSTORE_FILE" 2>/dev/null || base64 -i "$KEYSTORE_FILE" | tr -d '\n')

echo "============================================"
echo " GitHub Secrets — Copy These Values"
echo "============================================"
echo ""
echo "Go to your GitHub repo -> Settings -> Secrets and variables -> Actions"
echo "Create the following repository secrets:"
echo ""
echo "  Secret Name                    Value"
echo "  ----------------------------   ----------------------------------------"
echo "  MorphCosmicBase64              (see base64 output below)"
echo "  MorphCosmicStorePassword       (the keystore password you entered)"
echo "  MorphCosmicKeyPassword         (the key password you entered)"
echo "  MorphCosmicKeyAlias            $KEY_ALIAS"
echo ""
echo "--- BEGIN BASE64 KEYSTORE ---"
echo "$BASE64_VALUE"
echo "--- END BASE64 KEYSTORE ---"
echo ""
echo "Copy the entire base64 string above (between the markers)"
echo "and paste it as the value for MorphCosmicBase64."
echo ""
echo "============================================"
echo " Cleanup"
echo "============================================"
echo ""
echo "The keystore file ($KEYSTORE_FILE) is in the current directory."
echo "After copying the base64 value above, you may delete it:"
echo ""
echo "  rm $KEYSTORE_FILE"
echo ""
echo "NEVER commit the .jks file or passwords to version control."
echo ""
