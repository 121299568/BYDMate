# BYDMate 本地签名 APK 构建指南

## 前提条件

1. **Java JDK 17** - 必须安装
2. **Git** - 用于版本控制
3. **Gradle** - 项目构建工具（项目自带 wrapper）

---

## 步骤一：安装 JDK 17

### 方法 A：使用 winget（推荐）

```powershell
# 打开 PowerShell（管理员模式）
winget install EclipseAdoptium.Temurin.17.JDK --accept-package-agreements --accept-source-agreements
```

如果 winget 失败，请手动下载：

### 方法 B：手动下载安装

1. 访问：https://adoptium.net/temurin/releases/?version=17
2. 下载 Windows x64 MSI 安装包
3. 运行安装程序，记住安装路径（例如：`C:\Program Files\Eclipse Adoptium\jdk-17.0.20.1-hotspot`）
4. 添加环境变量：
   - `JAVA_HOME` = JDK 安装路径
   - 将 `%JAVA_HOME%\bin` 添加到 `PATH`

验证安装：
```powershell
java -version
javac -version
```

---

## 步骤二：克隆并进入项目

```powershell
cd C:\path\to\work
git clone https://github.com/121299568/BYDMate.git
cd BYDMate
```

---

## 步骤三：生成 Keystore（仅首次）

```powershell
# 运行生成脚本
powershell -ExecutionPolicy Bypass -File scripts/generate-keystore.ps1
```

或手动执行：
```powershell
keytool -genkeypair -v `
    -dname "CN=BYDMate, OU=Dev, O=BYDMate, L=Shenzhen, S=Guangdong, C=CN" `
    -storepass bydmate-release-2024 `
    -keypass bydmate-key-2024 `
    -alias bydmate-release `
    -keystore BYDMate-release.jks `
    -keyalg RSA `
    -keysize 2048 `
    -validity 10000
```

这会创建两个文件：
- `BYDMate-release.jks` - 密钥库文件（**务必妥善保管！**）
- `keystore.properties` - 构建配置

---

## 步骤四：构建 Release APK

```powershell
# 使用 Gradle wrapper 构建
./gradlew assembleRelease
```

或使用 Windows 批处理：
```powershell
.\gradlew.bat assembleRelease
```

构建成功后，APK 位于：
```
app/build/outputs/apk/release/BYDMate-v3.13.2.apk
```

---

## 步骤五：验证 APK 签名

```powershell
# 验证 APK 是否已签名
jarsigner -verify -verbose -certs app/build/outputs/apk/release/BYDMate-v3.13.2.apk
```

如果输出包含 `META-INF/*.RSA` 和 `META-INF/*.SF`，则签名成功。

---

## 步骤六：上传到 GitHub Releases

### 方法 A：使用 GitHub CLI

```powershell
# 登录 GitHub
gh auth login

# 创建 Release
gh release create v3.13.2-zh `
    --title "BYDMate v3.13.2 (Chinese)" `
    --notes "比亚迪 DiLink 盲区摄像头应用 - 中文默认语言版" `
    app/build/outputs/apk/release/BYDMate-v3.13.2.apk
```

### 方法 B：手动上传

1. 打开：https://github.com/121299568/BYDMate/releases/new
2. 填写 Tag: `v3.13.2-zh`
3. 标题: BYDMate v3.13.2 (Chinese)
4. 描述：
   ```
   比亚迪 DiLink 盲区摄像头应用
   
   ## 功能
   - 转向灯触发侧方摄像头（无速度限制）
   - 盲区检测橙色高亮警告
   - 默认语言：中文
   - 支持 DiLink 3.0/5.0/5.1
   
   ## 安装
   1. 开启车机 ADB 调试
   2. 安装 APK
   3. 在设置中配置盲区摄像头
   ```
5. 拖拽上传 APK 文件
6. 点击 "Publish release"

---

## 常见问题

### Q: 提示 "gradlew 不是内部或外部命令"

**A:** 确保你在 BYDMate 目录下，并使用正确的命令：
```powershell
# Windows
.\gradlew.bat assembleRelease

# 或使用完整路径
& ".\gradlew.bat" assembleRelease
```

### Q: 提示 "keystore.properties not found"

**A:** 确保 `keystore.properties` 文件存在且格式正确：
```properties
storeFile=BYDMate-release.jks
storePassword=bydmate-release-2024
keyAlias=bydmate-release
keyPassword=bydmate-key-2024
```

### Q: APK 构建成功但无法安装

**A:** 可能原因：
1. APK 未签名 - 检查是否生成了 keystore.properties
2. 设备安全设置 - 允许安装未知来源应用
3. 签名冲突 - 如果之前安装过 debug 版本，需要先卸载

### Q: 如何更新已有应用？

**A:** 必须使用**相同的 keystore** 签名，否则 Android 会拒绝安装。

---

## 安全提醒

⚠️ **重要：**
- `BYDMate-release.jks` 是应用的唯一签名，丢失后无法更新应用
- 将 keystore 备份到多个安全位置（云盘、加密 U 盘等）
- **不要**将 keystore 提交到 Git
- `keystore.properties` 已加入 `.gitignore`

---

## 配置文件示例

### build.gradle.kts（无需修改）

项目已配置自动签名，只需 keystore.properties 存在即可。

### .github/workflows/ci.yml

CI 流程已配置为自动生成 debug keystore 并签名。如需自定义，可修改工作流。
