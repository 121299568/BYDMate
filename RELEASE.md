# BYDMate Release 签名指南

## 方式一：使用 GitHub Actions（推荐）

### 1. 添加 Secrets

在 GitHub 仓库设置中添加以下 Secrets：

| Secret Name | Value |
|-------------|-------|
| `KEYSTORE_PASS` | 你的 keystore 密码 |
| `KEY_PASS` | 你的 key 密码 |
| `KEY_ALIAS` | 密钥别名（如：bydmate-release） |

**如何生成这些值：**

```bash
# 打开 https://github.com/121299568/BYDMate/settings/secrets/actions
# 点击 "New repository secret"
```

### 2. 触发构建

```bash
# 推送到 main 分支会自动触发
git push origin main

# 或手动触发
# 打开 https://github.com/121299568/BYDMate/actions
# 点击 "Run workflow"
```

---

## 方式二：本地生成 Keystore

### 1. 安装 JDK 17

下载并安装 Eclipse Temurin 17：
- https://adoptium.net/temurin/releases/?version=17

或使用命令行：
```powershell
# Windows (winget)
winget install EclipseFoundation.Temurin.17

# macOS (brew)
brew install --cask temurin@17

# Linux (apt)
sudo apt update
sudo apt install openjdk-17-jdk
```

### 2. 运行生成脚本

```bash
cd BYDMate
python scripts/generate-keystore.py
```

或手动执行：
```bash
keytool -genkeypair -v \
    -dname "CN=BYDMate, OU=Dev, O=BYDMate, L=Shenzhen, S=Guangdong, C=CN" \
    -storepass bydmate123 \
    -keypass bydmate123 \
    -alias bydmate-release \
    -keystore BYDMate-release.jks \
    -keyalg RSA \
    -keysize 2048 \
    -validity 10000
```

### 3. 创建 keystore.properties

```bash
echo "storeFile=BYDMate-release.jks" > keystore.properties
echo "storePassword=bydmate123" >> keystore.properties
echo "keyAlias=bydmate-release" >> keystore.properties
echo "keyPassword=bydmate123" >> keystore.properties
```

### 4. 构建签名 APK

```bash
./gradlew assembleRelease
```

生成的 APK 位于：
```
app/build/outputs/apk/release/BYDMate-v3.13.2.apk
```

---

## 安全提示

⚠️ **重要：不要将 keystore 文件提交到 Git！**

- `BYDMate-release.jks` 已加入 `.gitignore`
- `keystore.properties` 已加入 `.gitignore`
- 妥善保管 keystore 文件，丢失后无法更新同一签名的应用

---

## 版本更新流程

1. 修改版本号：`app/build.gradle.kts` → `versionCode` 和 `versionName`
2. 创建 Git tag：
   ```bash
   git tag v3.13.3
   git push origin v3.13.3
   ```
3. GitHub Actions 会自动构建并上传到 Release
