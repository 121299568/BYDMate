# BYDMate Release APK 构建脚本 (Windows)
# 运行此脚本构建签名版 APK

Write-Host "======================================" -ForegroundColor Cyan
Write-Host "BYDMate Release APK Builder" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""

# 检查 Java
Write-Host "Checking Java installation..." -ForegroundColor Yellow
$javaCmd = Get-Command java -ErrorAction SilentlyContinue
if (-not $javaCmd) {
    Write-Host ""
    Write-Host "ERROR: Java not found!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please install JDK 17 first:" -ForegroundColor Yellow
    Write-Host "  1. Visit: https://adoptium.net/temurin/releases/?version=17" -ForegroundColor Gray
    Write-Host "  2. Download: Windows x64 Installer (.msi)" -ForegroundColor Gray
    Write-Host "  3. Run installer and remember the path" -ForegroundColor Gray
    Write-Host "  4. Add to PATH or set JAVA_HOME environment variable" -ForegroundColor Gray
    Write-Host ""
    Write-Host "After installation, restart PowerShell and run this script again." -ForegroundColor Yellow
    exit 1
}

Write-Host ("Java found: " + ($javaCmd.Source)) -ForegroundColor Green
Write-Host ("Version: " + (java -version 2>&1 | Select-Object -First 1)) -ForegroundColor Green
Write-Host ""

# 设置密钥库路径
$keyStoreFile = "BYDMate-release.jks"
$keyStorePass = "bydmate-release-2024"
$keyPass = "bydmate-key-2024"
$alias = "bydmate-release"

# 找到 keytool
$javaHome = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\JavaSoft\Java Development Kit' -ErrorAction SilentlyContinue).CurrentJDK
if (-not $javaHome) {
    $javaHome = Split-Path $javaCmd.Source -Parent
    $javaHome = Split-Path $javaHome -Parent
}
$keytoolPath = Join-Path $javaHome "bin\keytool.exe"

if (-not (Test-Path $keytoolPath)) {
    Write-Host "ERROR: keytool not found at: $keytoolPath" -ForegroundColor Red
    exit 1
}

Write-Host ("Keytool: " + $keytoolPath) -ForegroundColor Green
Write-Host ""

# 生成 keystore（如果不存在）
if (-not (Test-Path $keyStoreFile)) {
    Write-Host "Generating keystore..." -ForegroundColor Yellow
    & $keytoolPath -genkeypair -v `
        -dname "CN=BYDMate, OU=Dev, O=BYDMate, L=Shenzhen, S=Guangdong, C=CN" `
        -storepass $keyStorePass `
        -keypass $keyPass `
        -alias $alias `
        -keystore $keyStoreFile `
        -keyalg RSA `
        -keysize 2048 `
        -validity 10000
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Keystore generated: $keyStoreFile" -ForegroundColor Green
    } else {
        Write-Host "ERROR: Failed to generate keystore" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "Keystore already exists: $keyStoreFile" -ForegroundColor Green
}
Write-Host ""

# 创建 keystore.properties
$propsContent = @"
storeFile=$(Get-Location)\$keyStoreFile
storePassword=$keyStorePass
keyAlias=$alias
keyPassword=$keyPass
"@

if (-not (Test-Path "keystore.properties")) {
    $propsContent | Out-File -FilePath "keystore.properties" -Encoding utf8
    Write-Host "Created: keystore.properties" -ForegroundColor Green
} else {
    Write-Host "keystore.properties already exists" -ForegroundColor Green
}
Write-Host ""

# 构建 Release APK
Write-Host "Building Release APK..." -ForegroundColor Yellow
if (Test-Path ".\gradlew.bat") {
    & .\gradlew.bat assembleRelease
} elseif (Test-Path ".\gradle\wrapper\gradle-wrapper.jar") {
    java -jar gradle\wrapper\gradle-wrapper.jar assembleRelease
} else {
    Write-Host "ERROR: Gradle wrapper not found!" -ForegroundColor Red
    exit 1
}

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "======================================" -ForegroundColor Cyan
    Write-Host "Build Complete!" -ForegroundColor Green
    Write-Host "======================================" -ForegroundColor Cyan
    Write-Host ""
    
    # 查找生成的 APK
    $releaseDir = "app\build\outputs\apk\release"
    if (Test-Path $releaseDir) {
        $apkFiles = Get-ChildItem $releaseDir -Filter "*.apk"
        foreach ($apk in $apkFiles) {
            Write-Host ("APK: " + $apk.FullName) -ForegroundColor Green
            Write-Host ("Size: " + [math]::Round($apk.Length / 1MB, 2) + " MB") -ForegroundColor Green
        }
    }
    Write-Host ""
    
    # 验证签名
    Write-Host "Verifying APK signature..." -ForegroundColor Yellow
    $apkFile = Get-ChildItem $releaseDir -Filter "*.apk" | Select-Object -First 1
    if ($apkFile) {
        Write-Host ("Verifying: " + $apkFile.Name) -ForegroundColor Gray
        & jarsigner -verify -verbose -certs $apkFile.FullName
        if ($LASTEXITCODE -eq 0) {
            Write-Host "APK is properly signed!" -ForegroundColor Green
        } else {
            Write-Host "WARNING: APK signature verification failed" -ForegroundColor Red
        }
    }
} else {
    Write-Host ""
    Write-Host "ERROR: Build failed!" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "======================================" -ForegroundColor Cyan
Write-Host "Next Steps:" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host "1. Install the APK on your BYD vehicle via ADB" -ForegroundColor White
Write-Host "   adb install app\build\outputs\apk\release\BYDMate-v*.apk" -ForegroundColor Gray
Write-Host ""
Write-Host "2. Configure blind-spot camera:" -ForegroundColor White
Write-Host "   Settings → Display → Blind-spot Camera" -ForegroundColor Gray
Write-Host "   Enable turn signal linkage" -ForegroundColor Gray
Write-Host "   Set speed threshold to 0 (no limit)" -ForegroundColor Gray
Write-Host ""
Write-Host "Security Note:" -ForegroundColor Red
Write-Host "- Keep $keyStoreFile safe - DO NOT commit to Git" -ForegroundColor Yellow
Write-Host "- Backup this file - losing it means you cannot update the app" -ForegroundColor Yellow
Write-Host "- Both files are in .gitignore" -ForegroundColor Yellow
Write-Host ""
