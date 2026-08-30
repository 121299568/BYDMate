#!/bin/bash
# BYDMate Release Keystore Generator
# This script generates a release keystore for signing BYDMate APK

set -e

KEYSTORE_FILE="BYDMate-release.jks"
KEYSTORE_PASS="bydmate-release-2024"
KEY_PASS="bydmate-key-2024"
ALIAS="bydmate-release"

echo "======================================"
echo "BYDMate Release Keystore Generator"
echo "======================================"
echo ""

# Check if keytool is available
if ! command -v keytool &> /dev/null; then
    echo "ERROR: keytool not found!"
    echo "Please install JDK 17 or later:"
    echo "  Windows: https://adoptium.net/temurin/releases/?version=17"
    echo "  macOS: brew install --cask temurin@17"
    echo "  Linux: sudo apt install openjdk-17-jdk"
    exit 1
fi

echo "Keytool found: $(keytool -version 2>&1 | head -1)"
echo ""

# Generate keystore
echo "Generating keystore: $KEYSTORE_FILE"
echo ""

keytool -genkeypair -v \
    -dname "CN=BYDMate, OU=Development, O=BYDMate, L=Shenzhen, S=Guangdong, C=CN" \
    -storepass "$KEYSTORE_PASS" \
    -keypass "$KEY_PASS" \
    -alias "$ALIAS" \
    -keystore "$KEYSTORE_FILE" \
    -keyalg RSA \
    -keysize 2048 \
    -validity 10000

echo ""
echo "Keystore generated successfully!"
echo ""
echo "======================================"
echo "Keystore Details:"
echo "======================================"
echo "File: $(pwd)/$KEYSTORE_FILE"
echo "Alias: $ALIAS"
echo "Store Password: $KEYSTORE_PASS"
echo "Key Password: $KEY_PASS"
echo ""
echo "To use this keystore, create keystore.properties:"
echo "----------------------------------------------"
cat > keystore.properties << EOF
storeFile=$(pwd)/$KEYSTORE_FILE
storePassword=$KEYSTORE_PASS
keyAlias=$ALIAS
keyPassword=$KEY_PASS
EOF
echo "Created: $(pwd)/keystore.properties"
echo ""
echo "======================================"
echo "Build Command:"
echo "======================================"
echo "./gradlew assembleRelease"
echo ""
echo "APK Location:"
echo "app/build/outputs/apk/release/BYDMate-v3.13.2.apk"
echo ""
echo "======================================"
echo "IMPORTANT SECURITY NOTES:"
echo "======================================"
echo "1. NEVER commit $KEYSTORE_FILE to Git"
echo "2. NEVER commit keystore.properties to Git"
echo "3. Both files are already in .gitignore"
echo "4. Backup your keystore in a secure location"
echo "5. If you lose the keystore, you cannot update the same app"
echo ""
