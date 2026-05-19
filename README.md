# 🚀 SuperAgent - 新一代企业级 AI Agent 构建与分发平台

![License](https://img.shields.io/badge/License-MIT-blue.svg)
![Java](https://img.shields.io/badge/Java-17+-orange.svg)
![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.x-brightgreen.svg)
![Vue](https://img.shields.io/badge/Vue-3.x-4fc08d.svg)
![Architecture](https://img.shields.io/badge/Architecture-DDD-purple.svg)

> SuperAgent 是一个基于 **DDD（领域驱动设计）** 的全栈 AI Agent 平台。它不仅提供开箱即用的 Agent 编排、对话与管理功能，还**原生深度集成了 MCP（Model Context Protocol）**。无论你是想构建具有复杂推理能力的 ReAct Agent，还是需要基于知识库的 RAG 智能体，SuperAgent 都能为你提供强有力的底层支持。

## ✨ 核心特性

- 🧠 **多样化推理引擎**：内置 `ReAct`、`Loop`、`Step` 等多种 Agent 编排策略，轻松应对从单步问答到复杂多步逻辑的业务场景。
- 🔌 **原生 MCP 生态支持**：全面拥抱 Model Context Protocol 标准。项目自带多个独立的高质量 MCP Server，赋予大模型感知真实世界的能力：
  - 🗺️ **Amap (高德)**: 实时天气查询与地理位置服务。
  - 🔍 **Bocha (博查)**: 深度联网 Web 搜索能力。
  - 🏢 **WeCom (企业微信)**: 自动化企业内部消息触达。
  - 📧 **Email**: 标准邮件自动化发送。
  - ✍️ **CSDN**: 社区文章快速保存与发布。
- 📚 **强大的 RAG 架构**：内置 PgVector 向量数据库支持，轻松实现知识库的高效切分、向量化嵌入（Embedding）与精准召回，打造专属知识大脑。
- 🛒 **Agent 广场 (Plaza)**：内置智能体应用市场，支持 Agent 的发布、分享、点赞、收藏与评论，构建活跃的 AI 开发者生态。
- 📊 **可视化控制台 (Studio & Dashboard)**：提供完善的 Admin 控制台，实时监控会话统计、Agent 调用趋势，轻松管理模型、Prompt 和工作流配置。
- 🏗️ **极致的工程化实践**：后端采用标准的 DDD 四层架构，结合 Spring AI 框架；数据层整合 MySQL + PostgreSQL + Redis + RabbitMQ，具备出色的扩展性与企业级高可用基因。

## 🛠️ 技术栈

### 后端 (Backend)
- **核心框架**: Java 17, Spring Boot 3, Spring AI
- **架构模式**: 领域驱动设计 (DDD)
- **持久层**: MyBatis, MySQL 8.x
- **向量数据库**: PostgreSQL + PgVector
- **缓存与消息**: Redis, RabbitMQ
- **对象存储**: 兼容 S3 的 OSS 服务
- **工具链**: Maven, Docker

### 前端 (Frontend)
- **核心框架**: Vue 3 (Composition API), Vite, Pinia, Vue Router
- **UI & 样式**: Tailwind CSS
- **网络请求**: Axios

### MCP Servers (独立模块)
- 基于 Project Reactor 与 Spring WebFlux 的轻量级响应式服务。
- 标准 `stdio` 与 `SSE` 双模通信支持。

## 📁 项目结构

```text
SuperAgent/
├── backend/                       # 后端核心服务 (基于 DDD 架构)
│   ├── ai-agent-api/              # API 定义层
│   ├── ai-agent-app/              # 应用层 (启动入口, 配置, AOP)
│   ├── ai-agent-domain/           # 领域层 (核心业务逻辑: AI/User/Workspace/Admin)
│   ├── ai-agent-infrastructure/   # 基础设施层 (MySQL/Redis/PgVector/RabbitMQ 实现)
│   ├── ai-agent-trigger/          # 触发器层 (Controller, 定时任务, MQ Listener)
│   ├── ai-agent-types/            # 全局公共类型 (常量, 异常, Result)
│   └── docs/docker/               # Docker Compose 及环境初始化脚本
├── frontend/                      # 前端 Vue3 项目
│   ├── src/components/            # 页面与组件 (Chat, Studio, Plaza, Admin Dashboard 等)
│   ├── src/request/               # Axios 接口封装
│   └── src/assets/                # 静态资源与样式
└── mcp/                           # MCP 扩展服务阵列
    ├── mcp-server-amap/           # 高德地图 MCP Server
    ├── mcp-server-bocha/          # 博查 Web 搜索 MCP Server
    ├── mcp-server-csdn/           # CSDN MCP Server
    ├── mcp-server-email/          # 邮件服务 MCP Server
    └── mcp-server-wecom/          # 企业微信 MCP Server

🚀 快速开始
1. 环境准备
确保您的本地已安装以下环境：

Docker & Docker Compose

JDK 17+

Node.js 18+ & npm/yarn

2. 一键启动基础设施 (中间件)
项目提供了完整的容器化中间件编排文件。

Bash
cd backend/docs/docker
cp .env.example .env  # 按需修改环境变量
docker-compose up -d
(注：Docker 启动将自动初始化 MySQL 表结构与 PgVector 扩展库)

3. 启动后端服务
在根目录的 backend 目录下：

Bash
mvn clean install
cd ai-agent-app
# 配置 application-dev.yml 中的大模型 API Key 及 OSS 信息
mvn spring-boot:run
4. 启动前端服务
在根目录的 frontend 目录下：

Bash
npm install
npm run dev
访问 http://localhost:5173 即可进入 SuperAgent 的世界！

5. 挂载 MCP Servers (可选)
如果想让你的 Agent 具备联网、查天气、发企微等能力，可以进入 mcp 目录下对应的 server 目录，配置好相关平台的 Credential 后启动相应的 Spring Boot 服务，然后在 SuperAgent 工作台中添加对应的 MCP 节点。

📸 预览体验
(建议在此处添加几张截图：如聊天界面、Agent 编排画布、Agent 广场、数据大盘统计图等)

🤝 参与贡献
我们非常欢迎任何形式的贡献！如果你发现了 Bug 或有新功能的想法，请提交 Issue。如果你想直接贡献代码：

Fork 本仓库

创建你的特性分支 (git checkout -b feature/AmazingFeature)

提交你的更改 (git commit -m 'Add some AmazingFeature')

推送到分支 (git push origin feature/AmazingFeature)

开启一个 Pull Request

📄 开源协议
本项目采用 MIT License 协议开源。

***

### 💡 写在最后的小建议：
1. **完善截图**：在 `📸 预览体验` 栏目，强烈建议你放几张前端跑起来后的真实截图（比如 `AdminDashboard` 的图表、`Chat` 的对话界面，或者 `Plaza` 的卡片）。视觉冲击力是吸引路人点赞（Star）的第一要素！
2. **环境变量提示**：项目依赖了许多外部 API (如 Bocha, 高德, 大模型 API)。建议在根目录额外提供一个详尽的《配置
