#!/bin/bash
# BYDMate Release APK Builder
# This script will help you build a signed release APK

set -e

echo "======================================"
echo "BYDMate Release APK Builder"
echo "======================================"
echo ""

# Check for Java
if ! command -v java &> /dev/null; then
    echo "ERROR: Java not found!"
    echo ""
    echo "Please install JDK 17 first:"
    echo "  Windows: Download from https://adoptium.net/temurin/releases/?version=17"
    echo "  macOS:   brew install --cask temurin@17"
    echo "  Linux:   sudo apt install openjdk-17-jdk"
    echo ""
    exit 1
fi

echo "Java found: $(java -version 2>&1 | head -1)"
echo ""

# Check for keytool
if ! command -v keytool &> /dev/null; then
    echo "ERROR: keytool not found in Java installation"
    exit 1
fi

# Generate keystore if not exists
KEYSTORE_FILE="BYDMate-release.jks"
KEYSTORE_PASS="bydmate-release-2024"
KEY_PASS="bydmate-key-2024"
ALIAS="bydmate-release"

if [ ! -f "$KEYSTORE_FILE" ]; then
    echo "Generating keystore..."
    keytool -genkeypair -v \
        -dname "CN=BYDMate, OU=Dev, O=BYDMate, L=Shenzhen, S=Guangdong, C=CN" \
        -storepass "$KEYSTORE_PASS" \
        -keypass "$KEY_PASS" \
        -alias "$ALIAS" \
        -keystore "$KEYSTORE_FILE" \
        -keyalg RSA \
        -keysize 2048 \
        -validity 10000
    echo "Keystore generated: $KEYSTORE_FILE"
else
    echo "Keystore already exists: $KEYSTORE_FILE"
fi
echo ""

# Create keystore.properties
if [ ! -f "keystore.properties" ]; then
    cat > keystore.properties << EOF
storeFile=$(pwd)/$KEYSTORE_FILE
storePassword=$KEYSTORE_PASS
keyAlias=$ALIAS
keyPassword=$KEY_PASS
EOF
    echo "Created: keystore.properties"
else
    echo "keystore.properties already exists"
fi
echo ""

# Build release APK
echo "Building Release APK..."
if [ -f "./gradlew" ]; then
    ./gradlew assembleRelease
elif [ -f "./gradlew.bat" ]; then
    ./gradlew.bat assembleRelease
else
    echo "ERROR: gradlew not found!"
    exit 1
fi

echo ""
echo "======================================"
echo "Build Complete!"
echo "======================================"
echo ""
echo "APK Location:"
ls -lh app/build/outputs/apk/release/*.apk 2>/dev/null || echo "Checking..."
echo ""

# Verify signature
APK_FILE=$(ls app/build/outputs/apk/release/*.apk 2>/dev/null | head -1)
if [ -n "$APK_FILE" ]; then
    echo "Verifying signature..."
    jarsigner -verify -verbose -certs "$APK_FILE" && echo "APK is signed!" || echo "WARNING: APK may not be signed"
    echo ""
    echo "File size: $(du -h "$APK_FILE" | cut -f1)"
fi
echo ""

echo "======================================"
echo "Next Steps:"
echo "======================================"
echo "1. Install the APK on your BYD vehicle"
echo "2. Configure blind-spot camera in settings"
echo "3. Set speed threshold to 0 for no-limit triggering"
echo ""
echo "Security Note:"
echo "- Keep $KEYSTORE_FILE safe - do NOT commit to Git"
echo "- Backup this file - losing it means you cannot update the app"
echo ""
