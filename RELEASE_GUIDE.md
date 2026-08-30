# BYDMate Release 签名指南

## 快速开始

### 方式一：本地生成 Keystore（推荐）

#### 1. 安装 JDK 17

如果还没有安装 Java，请访问：
- https://adoptium.net/temurin/releases/?version=17

安装后确认 Java 可用：
```powershell
java -version
```

#### 2. 运行脚本生成 Keystore

在 BYDMate 目录下运行：
```powershell
cd BYDMate
powershell -ExecutionPolicy Bypass -File scripts/generate-keystore.ps1
```

脚本会自动创建：
- `BYDMate-release.jks` - 密钥库文件
- `keystore.properties` - 构建配置文件

#### 3. 构建签名 APK

```powershell
./gradlew assembleRelease
```

生成的 APK 位于：
```
app/build/outputs/apk/release/BYDMate-v3.13.2.apk
```

---

### 方式二：使用 GitHub Actions（需要配置 Secrets）

#### 1. 添加 Secrets

在 GitHub 仓库设置中（Settings → Secrets and variables → Actions），添加以下 Secrets：

| Secret Name | Value |
|-------------|-------|
| `KEYSTORE_FILE` | Base64 编码的 keystore 文件内容 |
| `KEYSTORE_PASS` | keystore 密码 |
| `KEY_PASS` | key 密码 |
| `KEY_ALIAS` | 密钥别名 |

**生成 Base64 编码的 keystore：**
```powershell
$bytes = [System.IO.File]::ReadAllBytes("BYDMate-release.jks")
$base64 = [Convert]::ToBase64String($bytes)
Write-Host $base64
```

#### 2. 触发构建

推送代码到 main 分支会自动触发构建，或手动从 Actions 页面触发。

---

## 安全提示

⚠️ **重要：**
- `BYDMate-release.jks` 和 `keystore.properties` 已在 `.gitignore` 中
- **不要**将 keystore 文件提交到 Git
- **妥善保管** keystore 文件，丢失后无法更新同一签名的应用

---

## 常见问题

### Q: 为什么我的 APK 还是未签名的？

A: 确保 `keystore.properties` 文件存在于项目根目录，并且包含正确的路径和密码。

### Q: 如何将 APK 上传到 Release？

A: 构建完成后，可以将 APK 上传到 GitHub Releases：
```powershell
gh release upload v3.13.2-zh app/build/outputs/apk/release/BYDMate-v3.13.2.apk
```

### Q: 如何验证 APK 是否已签名？

A: 使用 jarsigner 验证：
```powershell
jarsigner -verify -verbose -certs app/build/outputs/apk/release/BYDMate-v3.13.2.apk
```

---

## 技术说明

### 为什么需要签名？

Android 要求所有安装的 APK 必须经过数字签名：
1. 确保应用的完整性和来源可信
2. 允许应用更新时与原版保持签名一致
3. 防止应用被恶意篡改

### Debug vs Release 签名

- **Debug 签名**：开发调试使用，自动由 Android Studio 生成
- **Release 签名**：正式发布使用，需要使用自己的密钥库

本项目的改进：
1. 添加了自动签名配置
2. 提供了便捷的脚本生成 keystore
3. 支持 CI/CD 自动化构建
