# BYDMate Release Keystore Generator (Windows)
# 运行此脚本生成签名密钥库

$KeyStoreFile = "BYDMate-release.jks"
$KeyStorePass = "bydmate-release-2024"
$KeyPass = "bydmate-key-2024"
$Alias = "bydmate-release"

Write-Host "======================================" -ForegroundColor Cyan
Write-Host "BYDMate Release Keystore Generator" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""

# Check Java installation
$javaPath = Get-Command java -ErrorAction SilentlyContinue
if (-not $javaPath) {
    Write-Host "ERROR: Java not found!" -ForegroundColor Red
    Write-Host "Please install JDK 17:" -ForegroundColor Yellow
    Write-Host "  https://adoptium.net/temurin/releases/?version=17" -ForegroundColor Gray
    exit 1
}

Write-Host "Java found: $($javaPath.Source)" -ForegroundColor Green
Write-Host ""

# Find keytool
$keytoolPath = Join-Path (Split-Path $javaPath.Source -Parent) "keytool.exe"
if (-not (Test-Path $keytoolPath)) {
    Write-Host "ERROR: keytool not found at: $keytoolPath" -ForegroundColor Red
    exit 1
}

Write-Host "Generating keystore: $KeyStoreFile" -ForegroundColor Cyan
Write-Host ""

# Generate keystore
& $keytoolPath -genkeypair -v `
    -dname "CN=BYDMate, OU=Dev, O=BYDMate, L=Shenzhen, S=Guangdong, C=CN" `
    -storepass $KeyStorePass `
    -keypass $KeyPass `
    -alias $Alias `
    -keystore $KeyStoreFile `
    -keyalg RSA `
    -keysize 2048 `
    -validity 10000

Write-Host ""
Write-Host "Keystore generated successfully!" -ForegroundColor Green
Write-Host ""

# Create keystore.properties
$propsContent = @"
storeFile=$(Get-Location)\$KeyStoreFile
storePassword=$KeyStorePass
keyAlias=$Alias
keyPassword=$KeyPass
"@

$propsContent | Out-File -FilePath "keystore.properties" -Encoding utf8
Write-Host "Created: keystore.properties" -ForegroundColor Green
Write-Host ""

Write-Host "======================================" -ForegroundColor Cyan
Write-Host "Keystore Details:" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host "File: $(Get-Location)\$KeyStoreFile"
Write-Host "Alias: $Alias"
Write-Host "Store Password: $KeyStorePass"
Write-Host "Key Password: $KeyPass"
Write-Host ""

Write-Host "======================================" -ForegroundColor Cyan
Write-Host "Build Commands:" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host "./gradlew assembleRelease"
Write-Host ""
Write-Host "APK Location:"
Write-Host "app/build/outputs/apk/release/BYDMate-v3.13.2.apk"
Write-Host ""

Write-Host "======================================" -ForegroundColor Red
Write-Host "IMPORTANT SECURITY NOTES:" -ForegroundColor Red
Write-Host "======================================" -ForegroundColor Red
Write-Host "1. NEVER commit $KeyStoreFile to Git" -ForegroundColor Yellow
Write-Host "2. NEVER commit keystore.properties to Git" -ForegroundColor Yellow
Write-Host "3. Both files are already in .gitignore" -ForegroundColor Yellow
Write-Host "4. Backup your keystore in a secure location" -ForegroundColor Yellow
Write-Host "5. If you lose the keystore, you cannot update the same app" -ForegroundColor Yellow
Write-Host ""
