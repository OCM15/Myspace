Nimi Places 的整理思路 + Flow Launcher 的搜索 + Nexus 的视觉效果 + 你自己的 Edge 自动登录能力

可以。考虑到你前面确定的方向，我建议给 GitHub Copilot 的需求文件不要写成“我要做一个桌面快捷方式工具”这么简单，而是把**产品目标、技术栈、核心功能、UI原则、Playwright/Edge Profile设计、配置方式**都明确下来。

下面这份可以直接作为项目根目录的 `REQUIREMENTS.md` 使用。

# Windows Dashboard - Requirements

## 1. 项目目的

开发一个运行在 Windows 上的个人 Dashboard 应用，用于统一管理：

* 文件夹
* 文件
* Windows 应用程序
* Web 网站
* 需要登录的 Web 系统

目标是替代 Windows 桌面上大量的快捷方式，使桌面保持整洁，同时通过一个统一的 Dashboard 快速访问常用资源。

应用定位为：

> **个人 Windows 工作台 / Dashboard / Launcher**

---

# 2. 技术栈

必须使用：

* Java
* Java Swing
* Maven
* Playwright Java
* Microsoft Edge

目标运行环境：

* Windows 10 / Windows 11
* Microsoft Edge

不要使用：

* Electron
* Python
* Node.js 作为主程序
* WebView 作为 Dashboard 主界面

Dashboard 本身使用 Java Swing 实现。

---

# 3. 总体架构

```text
┌──────────────────────────────────────┐
│          Java Swing Dashboard        │
│                                      │
│  Applications                        │
│  Files / Folders                     │
│  Web Systems                          │
│                                      │
└───────────────┬──────────────────────┘
                │
                ├──────── Windows Process
                │          ↓
                │       Applications
                │
                ├──────── File Explorer
                │
                └──────── Playwright
                           ↓
                    Microsoft Edge
                           ↓
                    Web Application
```

Dashboard负责：

* 显示项目
* 管理项目
* 启动资源
* 管理Web系统

Playwright只负责Web自动化和Edge控制。

---

# 4. Dashboard核心功能

Dashboard至少支持以下项目类型：

### 4.1 Folder

打开Windows文件夹。

例如：

```text
Documents
Project
Downloads
Work
```

点击后使用Windows Explorer打开。

---

### 4.2 File

打开指定文件。

例如：

```text
Excel
Word
PDF
TXT
```

使用Windows默认程序打开。

---

### 4.3 Application

启动Windows应用程序。

例如：

```text
Excel
Notepad
IntelliJ IDEA
Visual Studio Code
```

使用Java `ProcessBuilder`启动。

---

### 4.4 Web

普通网站。

例如：

```text
GitHub
Google
Microsoft 365
```

使用Microsoft Edge打开。

---

### 4.5 Web Application with Profile

需要登录的Web系统。

例如：

```text
Internal System A
Internal System B
SharePoint
```

使用Playwright启动Microsoft Edge，并使用专用User Profile。

---

# 5. Edge Profile设计

不要直接使用用户日常使用的Edge Profile。

禁止直接操作：

```text
%LOCALAPPDATA%\Microsoft\Edge\User Data
```

中的默认Profile。

每个Web系统使用独立的Playwright Profile。

推荐目录：

```text
Dashboard/
└── data/
    └── edge-profiles/
        ├── system-a/
        ├── system-b/
        ├── sharepoint/
        └── github/
```

每个系统的Profile相互独立。

---

# 6. Web系统登录机制

采用以下设计：

### 第一次使用

```text
Dashboard
   ↓
点击Web System
   ↓
Playwright启动Edge
   ↓
使用专用Profile
   ↓
打开登录页面
   ↓
用户手动输入ID/PW
   ↓
用户完成MFA/验证码
   ↓
登录成功
   ↓
Profile保存认证状态
```

不要默认保存用户密码。

不要在源代码中保存：

* User ID
* Password
* OTP
* MFA Secret

---

### 第二次使用

```text
Dashboard
   ↓
点击Web System
   ↓
Playwright启动Edge
   ↓
加载对应Profile
   ↓
打开Web系统
   ↓
如果Session仍有效
   ↓
直接进入登录后的页面
```

如果Session已经失效：

```text
打开登录页面
↓
用户重新登录
↓
继续使用
```

---

# 7. Playwright要求

使用Playwright Java API。

优先使用：

```text
Persistent Browser Context
```

通过独立的 `userDataDir` 管理每个Web系统的登录状态。

Edge必须使用：

```text
channel = "msedge"
```

而不是默认启动Chromium。

---

# 8. Browser生命周期

Dashboard启动时：

> 不要自动启动所有Edge实例。

只有用户点击Web项目时才启动Edge。

点击：

```text
System A
```

才启动：

```text
Playwright → Edge → System A Profile
```

Dashboard关闭时，应正确处理Playwright和Browser资源。

避免产生残留的Edge进程。

---

# 9. UI设计

UI目标：

> 简洁、现代、类似Windows Launcher / Dashboard，而不是传统Windows Form程序。

建议：

```text
┌──────────────────────────────────────────────┐
│  My Dashboard                         ⚙     │
├──────────────────────────────────────────────┤
│                                              │
│  ⭐ Favorites                                │
│                                              │
│  ┌─────────┐ ┌─────────┐ ┌─────────┐       │
│  │ GitHub  │ │ System A│ │ System B│       │
│  │   🌐    │ │   🌐    │ │   🌐    │       │
│  └─────────┘ └─────────┘ └─────────┘       │
│                                              │
│  📁 Work                                     │
│                                              │
│  ┌─────────┐ ┌─────────┐                    │
│  │Project  │ │Documents│                    │
│  │   📁    │ │   📁    │                    │
│  └─────────┘ └─────────┘                    │
│                                              │
│  💻 Applications                             │
│                                              │
│  ┌─────────┐ ┌─────────┐                    │
│  │ IntelliJ│ │ VS Code │                    │
│  └─────────┘ └─────────┘                    │
│                                              │
└──────────────────────────────────────────────┘
```

---

# 10. UI原则

优先考虑：

* 大按钮
* Icon + Name
* 清晰的分类
* 少量文字
* 鼠标点击方便
* 键盘操作方便
* 窗口可以调整大小
* 高DPI支持
* Windows 11风格

避免：

* 传统复杂菜单
* 大量Toolbar
* 大量Dialog
* 过度使用Tab
* UI拥挤

---

# 11. 分类

默认支持：

```text
Favorites
Work
Applications
Folders
Files
Web
```

用户可以自定义分类。

一个项目可以设置：

```text
Name
Type
Path / URL
Icon
Category
Description
Enabled
```

Web项目额外支持：

```text
Profile Name
Login URL
Home URL
```

---

# 12. 配置文件

不要把Dashboard项目硬编码在Java代码中。

使用配置文件。

例如：

```text
config/
    dashboard.json
```

示例：

```json
{
  "categories": [
    {
      "name": "Web",
      "items": [
        {
          "name": "GitHub",
          "type": "WEB",
          "url": "https://github.com"
        },
        {
          "name": "System A",
          "type": "WEB_PROFILE",
          "url": "https://example.com",
          "profile": "system-a"
        }
      ]
    }
  ]
}
```

程序启动时读取配置。

配置修改后可以通过UI重新加载。

---

# 13. 项目管理功能

Dashboard需要支持：

* 添加项目
* 编辑项目
* 删除项目
* 修改分类
* 修改显示顺序
* 设置Favorite
* 设置Icon
* 启用/禁用项目

第一阶段可以只实现读取JSON和手工修改JSON。

后续再增加UI管理。

---

# 14. 搜索功能

Dashboard顶部提供搜索框。

输入：

```text
git
```

可以找到：

```text
GitHub
Git
Git Project
```

搜索范围：

* Name
* Description
* Category

支持键盘快速启动。

例如：

```text
Ctrl + Space
```

打开Dashboard搜索框。

---

# 15. 错误处理

所有启动操作必须有错误处理。

例如：

```text
文件不存在
应用程序不存在
URL无法访问
Edge启动失败
Playwright启动失败
Profile被其他Edge进程占用
```

不要直接显示Java Stack Trace。

向用户显示友好的错误信息。

同时写入：

```text
logs/dashboard.log
```

---

# 16. Logging

使用标准Java Logging框架。

至少记录：

```text
Application started
Item clicked
Application launched
Edge launched
Playwright launched
Profile path
Navigation URL
Login state detection
Exception
Application closed
```

不要记录：

* Password
* Cookie
* Session Token
* OTP
* Access Token

---

# 17. 安全要求

严禁：

```text
password = "xxxxxx"
```

这种方式保存密码。

严禁将Edge Profile加入Git。

`.gitignore`必须包含：

```text
data/edge-profiles/
logs/
```

---

# 18. Maven项目结构

推荐：

```text
src/
├── main/
│   └── java/
│       └── com.example.dashboard/
│           ├── Main.java
│           │
│           ├── ui/
│           │   ├── DashboardFrame.java
│           │   ├── DashboardPanel.java
│           │   ├── SearchPanel.java
│           │   └── SettingsDialog.java
│           │
│           ├── model/
│           │   ├── DashboardItem.java
│           │   ├── Category.java
│           │   └── ItemType.java
│           │
│           ├── service/
│           │   ├── ApplicationLauncher.java
│           │   ├── FileLauncher.java
│           │   ├── WebLauncher.java
│           │   └── PlaywrightService.java
│           │
│           ├── config/
│           │   └── ConfigManager.java
│           │
│           └── util/
│               ├── PathUtil.java
│               └── LogUtil.java
│
└── test/
```

---

# 19. PlaywrightService设计

Playwright相关代码集中在：

```text
PlaywrightService
```

不要在Swing UI代码中直接操作Playwright。

例如：

```text
DashboardFrame
       ↓
ApplicationLauncher
       ↓
PlaywrightService
       ↓
Edge
```

这样以后修改Playwright实现不会影响UI。

---

# 20. Threading

Swing UI线程不能执行长时间阻塞操作。

特别是：

* 启动Edge
* Playwright操作
* 页面导航
* 等待网页
* 文件操作

不能阻塞EDT。

使用：

```text
SwingWorker
```

或者适当的后台线程。

UI必须保持响应。

---

# 21. 第一阶段MVP

不要一次实现全部功能。

第一阶段只实现：

1. Java Swing Dashboard
2. 分类
3. 项目Tile/Button
4. Folder启动
5. Application启动
6. Web启动
7. Playwright + Edge
8. 独立Edge Profile
9. 手动首次登录
10. 第二次启动保持登录状态
11. JSON配置
12. Logging

暂时不实现：

* 拖拽排序
* 插件系统
* 云同步
* 自动密码管理
* 自动更新
  -复杂动画
* 多用户支持

---

# 22. 开发原则

请遵循以下原则：

### 原则1：简单优先

不要为了未来可能需要的功能增加复杂架构。

### 原则2：模块化

UI、配置、Windows启动、Playwright必须分离。

### 原则3：配置驱动

Dashboard项目尽量不要硬编码。

### 原则4：安全优先

不保存密码，不记录Token，不使用普通文本保存敏感认证信息。

### 原则5：Windows优先

这是一个Windows Desktop Application。

### 原则6：Copilot友好

代码应该：

* 类职责明确
* 方法短小
* 命名清晰
* 避免过度复杂设计模式
* 添加必要的JavaDoc
* 优先使用标准Java API

---

# 23. GitHub Copilot开发方式

请不要一次生成整个项目。

按照以下顺序开发：

```text
Step 1
建立Maven项目
↓
Step 2
实现Swing Dashboard
↓
Step 3
实现Folder/Application Launcher
↓
Step 4
实现JSON Configuration
↓
Step 5
实现Web Launcher
↓
Step 6
加入Playwright
↓
Step 7
实现Edge Persistent Profile
↓
Step 8
验证首次登录/再次登录
↓
Step 9
加入Search
↓
Step 10
UI优化
↓
Step 11
Logging和Exception Handling
↓
Step 12
jpackage打包Windows应用
```

每完成一个Step后进行编译和测试，不要一次生成大量代码。

---

# 24. 最重要的产品定义

这个项目不是一个Web自动化测试工具。

它是：

> **一个Windows个人工作Dashboard。**

Playwright只是其中一个基础设施，用于：

> **管理需要登录的Web系统，并利用Edge独立Profile保存登录状态。**

因此UI和用户体验优先，Playwright应该被封装在后台服务层，而不是成为整个应用的核心UI逻辑。

这份需求可以直接作为 **`REQUIREMENTS.md`**，然后让 Copilot 按 **Step 1 → Step 12** 一步一步实现。这样比直接让 Copilot “帮我做一个 Dashboard”稳定得多。

另外，考虑到你之前已经在用 **Java Swing + Copilot**，我建议这次就不要再换 VB.NET 了；这个项目正好可以作为一个比较完整的 Java Windows Desktop 实战项目。
