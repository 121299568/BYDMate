# BYDMate

## 关于本项目

本项目基于 [AndyShaman/BYDMate](https://github.com/AndyShaman/BYDMate) 修改，主要改进：

1. **默认语言改为中文** - 新用户自动使用中文界面
2. **高速盲区摄像头** - 去除原车低速限制，支持所有车速触发
3. **Release 签名** - 添加 keystore 生成脚本和 CI 自动签名

## 下载 APK

- [最新版本 Release](https://github.com/121299568/BYDMate/releases)
- Release APK 已签名，可直接安装

## 快速开始

### 安装前准备

1. **开启 ADB 调试**：
   - DiLink 3/4: 设置 → 版本管理 → 点击"恢复出厂设置"10次 → 开启 USB 调试和无线 ADB
   - DiLink 5.0+: 需要付费解锁（淘宝搜索 "DiLink 5.0 ADB"）

2. **连接车机**：
   ```bash
   # 无线连接
   adb connect <车机IP>
   
   # 有线连接
   adb devices
   ```

3. **安装 APK**：
   ```bash
   adb install BYDMate-v3.13.2-zh.apk
   ```

### 配置盲区摄像头

1. 打开 BYDMate
2. 进入 **设置 → 显示 → 盲区摄像头**
3. 开启"**转向联动摄像头**"
4. 设置"**速度阈值**"为 `0`（无限制）
5. 选择显示位置：仪表盘 / 屏幕小窗

## 功能特性

| 功能 | 说明 |
|------|------|
| 🚗 盲区摄像头 | 打转向灯自动显示侧方摄像头（无速度限制） |
| ⚠️ 车辆检测 | 检测到后方来车时橙色边框高亮 |
| 📱 分屏显示 | 1/3 + 2/3 双应用同屏 |
| 🎯 仪表盘投射 | 导航/摄像头投射到仪表盘 |
| 💡 HUD 显示 | 转向提示显示在原车 HUD 上 |
| 📊 行程记录 | GPS 路线、能耗统计 |
| 🤖 AI 洞察 | 本地或云端驾驶分析 |

## 编译安装

### 本地编译

```bash
# 1. 安装 JDK 17
# https://adoptium.net/temurin/releases/?version=17

# 2. 生成 Keystore
cd BYDMate
python scripts/generate-keystore.py

# 3. 构建 Debug APK
./gradlew assembleDebug

# 4. 构建 Release APK（签名）
./gradlew assembleRelease
```

生成的 APK：
- Debug: `app/build/outputs/apk/debug/BYDMate-v3.13.2-debug.apk`
- Release: `app/build/outputs/apk/release/BYDMate-v3.13.2.apk`

### GitHub Actions 自动构建

推送代码到 main 分支会自动触发 CI，构建并上传 APK 到 Release。

## 项目结构

```
BYDMate/
├── app/                    # Android 应用源码
│   ├── src/main/
│   │   ├── kotlin/com/bydmate/app/  # Kotlin 源代码
│   │   └── res/values-zh/        # 中文字符串
│   └── build.gradle.kts    # 构建配置
├── .github/workflows/      # CI/CD 配置
├── scripts/               # 辅助脚本
│   ├── generate-keystore.py  # Keystore 生成脚本
│   └── SIGNING.md          # 签名指南
├── README.zh.md           # 中文文档
└── RELEASE.md             # Release 说明
```

## 许可证

本项目基于 PolyForm Noncommercial 1.0.0 许可证开源。

原始项目：[AndyShaman/BYDMate](https://github.com/AndyShaman/BYDMate)
修改版本：[121299568/BYDMate](https://github.com/121299568/BYDMate)
