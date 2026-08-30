# BYDMate Release APK 签名说明

## 生成的 Keystore 文件

由于当前环境没有安装 JDK，无法直接生成 keystore。以下是完整指南：

### 步骤 1：安装 JDK 17

**Windows:**
```powershell
winget install EclipseFoundation.Temurin.17
```
或者下载：https://adoptium.net/temurin/releases/?version=17

**macOS:**
```bash
brew install --cask temurin@17
```

**Linux (Ubuntu):**
```bash
sudo apt update
sudo apt install openjdk-17-jdk
```

### 步骤 2：生成 Keystore

在 BYDMate 目录下运行：

```bash
keytool -genkeypair -v \
    -dname "CN=BYDMate, OU=Development, O=BYDMate, L=Shenzhen, S=Guangdong, C=CN" \
    -storepass bydmate123 \
    -keypass bydmate123 \
    -alias bydmate-release \
    -keystore BYDMate-release.jks \
    -keyalg RSA \
    -keysize 2048 \
    -validity 10000
```

或运行脚本：
```bash
python scripts/generate-keystore.py
```

### 步骤 3：创建 keystore.properties

```bash
echo "storeFile=BYDMate-release.jks" > keystore.properties
echo "storePassword=bydmate123" >> keystore.properties
echo "keyAlias=bydmate-release" >> keystore.properties
echo "keyPassword=bydmate123" >> keystore.properties
```

### 步骤 4：构建签名 APK

```bash
./gradlew assembleRelease
```

生成的 APK：`app/build/outputs/apk/release/BYDMate-v3.13.2.apk`

---

## 安全提示

⚠️ **重要：**
- `BYDMate-release.jks` 已加入 `.gitignore`
- `keystore.properties` 已加入 `.gitignore`
- **妥善保管 keystore 文件！** 丢失后无法用同一签名更新应用

---

## GitHub Actions 自动签名

工作流已配置为使用 debug keystore 自动签名：
- 密钥库路径：`~/.android/debug.keystore`
- 密码：`android`
- 别名：`debug`

这确保了每次 CI 构建都会生成已签名的 APK。
