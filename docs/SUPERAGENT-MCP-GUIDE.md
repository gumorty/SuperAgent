# SuperAgent 使用与 MCP 接入指南

## 1. Chat 会话里如何切换模型 Client

这个项目的 Chat 页面并不是直接读取 `ai_model` 表，而是读取 `ai_client` 表中 `client_type = 'chat'` 的记录。

对应链路如下：

- 前端页面：[frontend/src/components/Chat.vue](/D:/development/Learn_bugstack/MiniAgent-main/frontend/src/components/Chat.vue)
- 接口定义：[frontend/src/request/api.js](/D:/development/Learn_bugstack/MiniAgent-main/frontend/src/request/api.js)
- 用户接口：[backend/ai-agent-trigger/src/main/java/com/dasi/trigger/controller/UserController.java](/D:/development/Learn_bugstack/MiniAgent-main/backend/ai-agent-trigger/src/main/java/com/dasi/trigger/controller/UserController.java)
- 查询仓储：[backend/ai-agent-infrastructure/src/main/java/com/dasi/infrastructure/repository/QueryRepository.java](/D:/development/Learn_bugstack/MiniAgent-main/backend/ai-agent-infrastructure/src/main/java/com/dasi/infrastructure/repository/QueryRepository.java)
- SQL 映射：[backend/ai-agent-infrastructure/src/main/resources/mapper/AiClientDao.xml](/D:/development/Learn_bugstack/MiniAgent-main/backend/ai-agent-infrastructure/src/main/resources/mapper/AiClientDao.xml)

核心规则只有一条：

- 只有 `ai_client.client_type = 'chat'` 的 client，才会出现在 Chat 页面顶部的 `CLIENT` 下拉框。

因此如果你已经有模型：

- `deepseek-v4-flash`
- `gemma4:26b`

但 Chat 里只能选一个，通常不是模型没配好，而是缺少对应的 `chat client`。

当前本项目已经补好两条系统级 chat client：

- `client_DeepSeekChat_system`
- `client_Gemma4Chat_system`

你在 Chat 页面选择模型时，前端会调用：

- `dispatchArmory({ armoryType: 'chat', armoryId: clientId })`

后端会把这个 client 关联的：

- API
- Model
- Prompt
- MCP
- Advisor

装配成一个可直接调用的运行时 `ChatClient`，然后当前会话就会绑定这个 `clientId`。

注意：

- 同一个会话在发过消息后会锁定当前 client。
- 想切换到另一个模型，最稳妥的方式是新建一个 Chat 会话。

## 2. Plaza 里的智能体是怎么使用的

Plaza 不是“直接运行区”，而是“模板广场”。

对应页面和流程：

- 广场页：[frontend/src/components/Plaza.vue](/D:/development/Learn_bugstack/MiniAgent-main/frontend/src/components/Plaza.vue)
- 模板详情页：[frontend/src/components/Template.vue](/D:/development/Learn_bugstack/MiniAgent-main/frontend/src/components/Template.vue)
- 我的仓库页：[frontend/src/components/Repository.vue](/D:/development/Learn_bugstack/MiniAgent-main/frontend/src/components/Repository.vue)
- 智能体详情页：[frontend/src/components/Detail.vue](/D:/development/Learn_bugstack/MiniAgent-main/frontend/src/components/Detail.vue)
- Work 执行页：[frontend/src/components/Work.vue](/D:/development/Learn_bugstack/MiniAgent-main/frontend/src/components/Work.vue)

实际使用顺序是：

1. 在 Plaza 浏览公共模板
2. 点卡片或 `Fork`
3. 进入模板详情页看说明、评论和快照
4. 点 `Fork` 后复制到你的 Repository
5. 在 Repository 里打开这个 Agent
6. 进入 Detail / Work 会话真正执行

也就是说：

- `Plaza` 负责展示别人或系统预置的智能体模板
- `Repository` 负责保存你已经 fork 或自己创建的智能体
- `Work` 才是执行多角色工作流的地方

## 3. 这个项目里智能体真正如何工作

这个项目的智能体是“数据驱动配置 + 代码驱动编排”。

关键数据表：

- `ai_agent`：定义一个智能体本身
- `ai_flow`：定义这个智能体有哪些角色节点
- `ai_client`：节点最终绑定哪个 client
- `ai_model`：client 背后使用哪个模型
- `ai_api`：模型实际访问哪个大模型服务
- `ai_config`：把 client 和 prompt / mcp / advisor 绑定起来

三种执行策略：

- `step`
- `loop`
- `react`

策略入口在：

- [backend/ai-agent-domain/src/main/java/com/dasi/domain/ai/service/execute/ExecuteStrategyFactory.java](/D:/development/Learn_bugstack/MiniAgent-main/backend/ai-agent-domain/src/main/java/com/dasi/domain/ai/service/execute/ExecuteStrategyFactory.java)

执行前，前端会先调用 armory 装配：

- `dispatchArmory`

后端会把当前 agent 或 chat client 所依赖的模型、工具、提示词全部注册成运行时 Bean，然后再执行。

所以你可以这样理解：

- Chat：单 client 的问答模式
- Work：多角色、多轮次的工作流模式
- Plaza：模板市场
- Repository：你的 agent 资产库

## 4. MCP 在这个项目里的接入方式

这个项目支持两种 MCP 接入方式：

- `sse`
- `stdio`

对应代码：

- 运行时装配：[backend/ai-agent-domain/src/main/java/com/dasi/domain/ai/service/armory/node/ArmoryMcpNode.java](/D:/development/Learn_bugstack/MiniAgent-main/backend/ai-agent-domain/src/main/java/com/dasi/domain/ai/service/armory/node/ArmoryMcpNode.java)
- 配置结构：[backend/ai-agent-domain/src/main/java/com/dasi/domain/ai/model/vo/AiMcpVO.java](/D:/development/Learn_bugstack/MiniAgent-main/backend/ai-agent-domain/src/main/java/com/dasi/domain/ai/model/vo/AiMcpVO.java)
- 用户侧设置页：[frontend/src/components/Sidebar.vue](/D:/development/Learn_bugstack/MiniAgent-main/frontend/src/components/Sidebar.vue)
- 用户设置 DTO：[backend/ai-agent-domain/src/main/java/com/dasi/domain/user/model/dto/SettingMcpDTO.java](/D:/development/Learn_bugstack/MiniAgent-main/backend/ai-agent-domain/src/main/java/com/dasi/domain/user/model/dto/SettingMcpDTO.java)

### 4.1 SSE 模式

适合：

- 已经运行成 HTTP/SSE 服务的 MCP
- Docker 里独立起容器的 MCP

配置格式：

```json
{
  "baseUri": "http://mcp-server-wecom:9002",
  "sseEndPoint": "/sse"
}
```

`mcp_secret` 是一段 JSON 文本，后端会：

1. 原样读取
2. Base64 编码
3. 通过 Header 发给 MCP 服务

Header 名称固定是：

- `X-MiniAgent-Mcp-UserId`
- `X-MiniAgent-Mcp-Secret`

所以你的 SSE MCP 如果要接入本项目，最好也按这个方式读取 Header。

### 4.2 STDIO 模式

适合：

- 你在 GitHub 上托管的 `npx` 启动型 MCP
- 本地命令行式 MCP

配置格式：

```json
{
  "command": "npx",
  "args": ["-y", "@modelcontextprotocol/server-filesystem", "/tmp"],
  "env": {
    "NODE_ENV": "production"
  }
}
```

这种模式下，后端会直接拉起一个子进程作为 MCP。

注意：

- 如果 backend 在 Docker 容器里运行，`stdio` 依赖的命令必须存在于 backend 容器内。
- 当前这个项目的 backend 镜像默认只适合 Java 运行，不适合直接跑大量 Node/uv 型 MCP。

因此在你的部署方式下，更推荐：

- 能做成独立服务的 MCP，一律用 `sse`

## 5. Email / Bocha / CSDN / Amap / WeCom 分别怎么配

当前容器化部署里已经预置了这些 MCP 服务：

- `mcp-server-csdn`
- `mcp-server-wecom`
- `mcp-server-amap`
- `mcp-server-email`
- `mcp-server-bocha`

Docker 服务名和端口：

- `http://mcp-server-csdn:9001`
- `http://mcp-server-wecom:9002`
- `http://mcp-server-amap:9003`
- `http://mcp-server-email:9004`
- `http://mcp-server-bocha:9005`

### 5.1 WeCom

`mcp_param`

```json
{
  "baseUri": "http://mcp-server-wecom:9002",
  "sseEndPoint": "/sse"
}
```

`mcp_secret`

```json
{
  "corpId": "你的企业ID",
  "corpSecret": "你的应用Secret",
  "agentId": "你的应用AgentId"
}
```

用途：

- 发送企业微信应用消息

### 5.2 Amap Weather

`mcp_param`

```json
{
  "baseUri": "http://mcp-server-amap:9003",
  "sseEndPoint": "/sse"
}
```

`mcp_secret`

```json
{
  "apiKey": "你的高德开放平台Key"
}
```

用途：

- 查询天气

### 5.3 Email

`mcp_param`

```json
{
  "baseUri": "http://mcp-server-email:9004",
  "sseEndPoint": "/sse"
}
```

`mcp_secret`

```json
{
  "smtpHost": "smtp.qq.com",
  "smtpPort": "465",
  "smtpUsername": "your_mail@qq.com",
  "smtpPassword": "你的SMTP授权码",
  "fromAddress": "your_mail@qq.com",
  "fromName": "Jianwei"
}
```

用途：

- 发邮件

### 5.4 Bocha

`mcp_param`

```json
{
  "baseUri": "http://mcp-server-bocha:9005",
  "sseEndPoint": "/sse"
}
```

`mcp_secret`

```json
{
  "apiKey": "你的Bocha API Key"
}
```

用途：

- 联网搜索

### 5.5 CSDN

`mcp_param`

```json
{
  "baseUri": "http://mcp-server-csdn:9001",
  "sseEndPoint": "/sse"
}
```

`mcp_secret`

```json
{
  "cookie": "你的CSDN登录Cookie",
  "categories": "默认分类",
  "tags": "标签1,标签2",
  "coverUrl": "封面图URL"
}
```

用途：

- 将 markdown 发布到 CSDN

## 6. 你自己的 GitHub MCP 怎么接到这个项目

你自己的 MCP 如果也想接进来，先判断它属于哪一类。

### 6.1 如果它本身就是 HTTP/SSE 服务

直接按 `sse` 接入。

在本项目里新增一条 `ai_mcp` 记录，或者在前端右下角个人设置里的 `MCP 管理` 新增：

- `mcpName`：你想显示的名字
- `mcpType`：`sse`
- `mcpParam`：

```json
{
  "baseUri": "http://你的服务名或地址:端口",
  "sseEndPoint": "/sse"
}
```

- `mcpSecret`：你的密钥 JSON

如果你的 MCP 也运行在同一个 Docker Compose 网络里，`baseUri` 推荐直接写服务名。

例子：

```json
{
  "baseUri": "http://mcp-server-github:9010",
  "sseEndPoint": "/sse"
}
```

然后把这个 MCP 选进：

- Chat 页顶部的 MCP 下拉
- 或 Studio 里创建 Agent 时选入工具列表

### 6.2 如果它是 `npx` / `uvx` / `python -m` 这种命令型 MCP

有两种方式：

1. 最推荐：把它单独包成 HTTP/SSE 服务，再按上面的 `sse` 方式接
2. 备选：直接用 `stdio`

`stdio` 示例：

```json
{
  "command": "npx",
  "args": ["-y", "@your-scope/your-mcp"],
  "env": {
    "GITHUB_TOKEN": "你的Token"
  }
}
```

但你当前是“backend 也在 Docker 容器里”：

- 容器里未必安装 `node` / `npm` / `uv`
- 容器里也未必能访问你本机路径

所以对这个项目来说，`stdio` 更适合开发机本地直跑 backend 的情况；而你的“全 Docker”方案里，最佳实践仍然是：

- 把 GitHub MCP 单独做成容器或 HTTP 服务
- 再通过 `sse` 接入 SuperAgent

## 7. 如何让 MCP 真正参与 Agent 执行

只是把 MCP 配进系统还不够，还要让 Agent 能用到它。

有两种方式：

### 7.1 Chat 模式

在 Chat 页顶部直接勾选 MCP。

这适合：

- 直接问天气
- 直接发邮件
- 直接联网搜索

### 7.2 Work / Agent 模式

在 Studio 创建或编辑 Agent 时，把 MCP 配进对应 client 的配置里。

执行时流程是：

1. 选中 Agent
2. 前端先调用 armory
3. 后端装配这个 Agent 绑定的 client / prompt / mcp
4. `step / loop / react` 节点执行时，模型可以调对应的 MCP 工具

如果你只是把 MCP 放进系统里，但没有在：

- Chat 里勾选
- 或 Agent 配置里绑定

那它不会自动生效。

## 8. 当前项目里最推荐的 MCP 接入策略

结合你现在的部署方式，建议你统一按下面做：

- DeepSeek：做系统级 Chat / Work 模型
- Ollama Gemma：做系统级 Chat / Work 模型
- Amap / WeCom / Email / Bocha / CSDN：全部做 `sse`
- 你自己的 GitHub MCP：优先容器化后 `sse` 接入

这样有 3 个好处：

- backend 容器保持干净，不需要额外塞大量 Node/Python 运行时
- MCP 服务之间职责清晰，坏一个不影响全部
- 后续新增 MCP 时，只要加容器和一条 `ai_mcp` 配置即可

## 9. 如果你要手工插入一条新的 MCP 记录

SQL 模板如下：

```sql
INSERT INTO ai_mcp (
  mcp_id,
  mcp_name,
  mcp_type,
  mcp_param,
  mcp_secret,
  mcp_desc,
  mcp_timeout,
  mcp_from
) VALUES (
  'mcp_system_github',
  'GitHub MCP',
  'sse',
  '{"baseUri":"http://mcp-server-github:9010","sseEndPoint":"/sse"}',
  '{"token":"你的GitHub Token"}',
  'Operate GitHub through a custom MCP server',
  180,
  0
);
```

说明：

- `mcp_from = 0` 表示系统级
- 当前项目已经改成“系统级 MCP + 当前用户 MCP”都会查出来

## 10. 当前这次代码调整后，你要怎么继续配

你接下来只需要做这几步：

1. 进入平台右下角个人设置，打开 `MCP 管理`
2. 把 WeCom / Amap / Email / Bocha / CSDN 的 `secret` 填成你自己的真实值
3. 如果你有自己的 GitHub MCP：
   - 先让它变成一个 HTTP/SSE 服务
   - 再新增一条 MCP 记录
4. 去 Chat 页验证单工具调用
5. 去 Studio / Work 页验证多角色工作流调用

如果某个 MCP 已经添加但不生效，优先检查：

- `baseUri` 是否写成了容器内可访问地址
- `secret JSON` 字段名是否和对应 MCP 代码要求完全一致
- 这个 MCP 是否真的被选入当前 Chat 或当前 Agent
