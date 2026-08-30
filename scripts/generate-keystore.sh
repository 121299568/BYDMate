#!/bin/bash
# Generate release keystore for BYDMate
# Run this script to create BYDMate-release.jks

KEYSTORE_FILE="BYDMate-release.jks"
KEYSTORE_PASS="bydmate123"
KEY_PASS="bydmate123"
ALIAS="bydmate-release"

echo "Generating keystore: $KEYSTORE_FILE"
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
echo "File: $(pwd)/$KEYSTORE_FILE"
echo ""
echo "To use in build.gradle.kts, add:"
echo "keystore.properties:"
echo "storeFile=/path/to/$KEYSTORE_FILE"
echo "storePassword=$KEYSTORE_PASS"
echo "keyAlias=$ALIAS"
echo "keyPassword=$KEY_PASS"