<div align="center">

<img src="app/src/main/res/mipmap-xxxhdpi/ic_launcher.png" width="120" alt="BYDMate 图标">

# BYDMate

### 比亚迪 DiLink 盲区摄像头 & 行程记录

[![Android](https://img.shields.io/badge/Android-10%2B-3DDC84?style=flat-square&logo=android&logoColor=white)](https://developer.android.com)
[![Kotlin](https://img.shields.io/badge/Kotlin-2.1-7F52FF?style=flat-square&logo=kotlin&logoColor=white)](https://kotlinlang.org)
[![License](https://img.shields.io/badge/License-PolyForm_Noncommercial-blue?style=flat-square)](LICENSE)
[![GitHub release](https://img.shields.io/github/v/release/121299568/BYDMate?style=flat-square)](https://github.com/121299568/BYDMate/releases)

**高速变道辅助 · 转向灯联动侧方摄像头 · 原生体验**

专为比亚迪车主设计的侧方盲区摄像头应用，支持**所有车速**触发（不限低速），变道更安全。

已在 DiLink 3.0/5.0/5.1 上测试，支持豹5、宋PLUS、海狮07、汉、海豹等车型。

---

**中文** | [English](README.en.md) | [Русский](README.md)

[功能](#功能) | [安装](#安装) | [常见问题](#常见问题) | [原始项目](#关于原作者)

</div>

---

## 功能

| 功能 | 说明 |
|------|------|
| **盲区摄像头** | 打转向灯自动显示对应侧摄像头画面（无速度限制） |
| **车辆检测高亮** | 检测到侧后方来车时，窗口以橙色边框警告 |
| **仪表盘投射** | 将导航/摄像头投射到仪表盘显示 |
| **HUD 抬头显示** | 转向提示显示在原车 HUD 上 |
| **分屏显示** | 1/3 + 2/3 双应用同屏显示 |
| **行程记录** | GPS 路线、能耗统计、充电记录 |
| **AI 洞察** | 本地或云端驾驶分析 |
| **语音助手** | 离线语音控制（俄语/中文） |
| **自动化** | WHEN→THEN 规则控制车辆 |

---

## 核心改进：高速盲区摄像头

### 原车限制

比亚迪原厂"转向联动"功能仅在**低速**（≤20 km/h）时触发侧方摄像头，主要用于泊车场景。

### 本项目的改进

通过修改触发逻辑，**关闭了速度限制**，实现：

- ✅ 高速公路上打转向灯即可触发侧方摄像头
- ✅ 关闭转向灯后摄像头自动关闭
- ✅ 速度阈值可调（默认设为 0 = 无限制）

---

## 安装

### 1. 开启 ADB 调试

**DiLink 3/4：**
```
设置 → 版本管理 → 连续点击"恢复出厂设置"10次
→ 开启"USB调试"和"无线ADB调试"
```

**DiLink 5.0+：**
需要付费解锁（淘宝搜索"DiLink 5.0 ADB"，约 ¥40）。

### 2. 下载 APK

从 [Releases](https://github.com/121299568/BYDMate/releases) 下载最新版 APK。

### 3. 安装并授权

```bash
# 有线连接
adb install BYDMate-v3.13.2.apk

# 无线连接（需先配对）
adb connect <车机IP>:5555
adb install BYDMate-v3.13.2.apk
```

### 4. 配置盲区摄像头

1. 打开 BYDMate
2. 进入 **设置 → 显示 → 盲区摄像头**
3. 开启"**转向联动摄像头**"
4. 设置"**速度阈值**"为 `0`（无限制）
5. 选择显示位置：仪表盘 / 屏幕小窗

---

## 常见问题

### Q: 为什么高速上不打转向灯时摄像头会一直开着？

A: 这是正常行为。当转向灯开启时，侧方摄像头会自动显示；关闭转向灯后自动关闭。如果发现问题，请检查"速度阈值"设置。

### Q: 如何调整摄像头显示位置？

A: 在 **设置 → 显示 → 盲区摄像头** 中，点击"设置位置"，然后用手指拖动窗口到期望位置。

### Q: 为什么我的车型没有侧方摄像头画面？

A: 需要车辆配备全景影像系统（360°摄像头）。部分低配车型可能没有侧方摄像头硬件。

### Q: 能否完全关闭此功能？

A: 在 **设置 → 显示 → 盲区摄像头** 中关闭"转向联动摄像头"开关即可。

---

## 关于原始项目

本项目基于 [AndyShaman/BYDMate](https://github.com/AndyShaman/BYDMate) 修改，保留了原始功能并添加了高速盲区摄像头支持。

原始项目特点：
- 真实能耗记录（来自 BMS）
- 仪表盘导航投射
- HUD 抬头显示
- 分屏显示
- 俄语语音助手
- ABRP 实时遥测

---

## 技术栈

- Kotlin + Jetpack Compose
- Room (SQLite) + Hilt (DI)
- Min SDK 29 / Target SDK 29

---

## 许可证

**PolyForm Noncommercial 1.0.0** — 源码开放，仅限非商业使用。

---

## 赞助

本项目为开源爱好项目。如需支持，请见 [SUPPORT.md](SUPPORT.md)。

Copyright (C) 2026 [121299568](https://github.com/121299568)
