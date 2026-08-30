#!/usr/bin/env python3
"""Generate release keystore for BYDMate APK signing."""
import subprocess
import sys
import os

KEYSTORE_FILE = "BYDMate-release.jks"
KEYSTORE_PASS = "bydmate123"  # Change this!
KEY_PASS = "bydmate123"        # Change this!
ALIAS = "bydmate-release"

def run(cmd):
    result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
    return result.returncode == 0

print(f"Generating keystore: {KEYSTORE_FILE}")
print(f"This will create a self-signed certificate for test/development use.")
print(f"Passwords: {KEYSTORE_PASS}")
print()

# Check if keytool is available
java_home = os.environ.get('JAVA_HOME')
keytool_path = None
if java_home:
    keytool_path = os.path.join(java_home, 'bin', 'keytool.exe')
    if not os.path.exists(keytool_path):
        keytool_path = os.path.join(java_home, 'bin', 'keytool')
else:
    # Try to find in PATH
    keytool_path = 'keytool'

if keytool_path and os.path.exists(keytool_path):
    print(f"Using keytool: {keytool_path}")
else:
    print("Keytool not found in JAVA_HOME or PATH")
    print("Please install JDK 17+ and ensure it's in your PATH")
    sys.exit(1)

# Generate keystore
cmd = f'{keytool_path} -genkeypair -v \\
    -dname "CN=BYDMate, OU=Development, O=BYDMate, L=Shenzhen, S=Guangdong, C=CN" \\
    -storepass "{KEYSTORE_PASS}" \\
    -keypass "{KEY_PASS}" \\
    -alias "{ALIAS}" \\
    -keystore "{KEYSTORE_FILE}" \\
    -keyalg RSA \\
    -keysize 2048 \\
    -validity 10000'

result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
if result.returncode != 0:
    print(f"Error: {result.stderr}")
    sys.exit(1)

print(f"\nKeystore generated successfully!")
print(f"File: {os.path.abspath(KEYSTORE_FILE)}")
print()
print("To use in build.gradle.kts, create keystore.properties:")
print("=" * 50)
print(f"storeFile={os.path.abspath(KEYSTORE_FILE)}")
print(f"storePassword={KEYSTORE_PASS}")
print(f"keyAlias={ALIAS}")
print(f"keyPassword={KEY_PASS}")
print("=" * 50)
