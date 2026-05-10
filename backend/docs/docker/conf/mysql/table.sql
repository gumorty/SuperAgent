DROP DATABASE IF EXISTS `ai-agent`;
CREATE DATABASE IF NOT EXISTS `ai-agent` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

USE `ai-agent`;

# ai_api 表：存储 API 信息
DROP TABLE IF EXISTS `ai_api`;
CREATE TABLE `ai_api`
(
    `id`                   BIGINT       NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT '自增 id',
    `api_id`               VARCHAR(32)  NOT NULL UNIQUE COMMENT '接口 id',
    `api_base_url`         VARCHAR(255) NOT NULL DEFAULT '' COMMENT '基础路径',
    `api_key`              VARCHAR(255) NOT NULL DEFAULT '' COMMENT '密钥',
    `api_completions_path` VARCHAR(255) NOT NULL DEFAULT 'v1/chat/completions' COMMENT '对话路径',
    `api_embeddings_path`  VARCHAR(255) NOT NULL DEFAULT 'v1/embeddings' COMMENT '嵌入路径',
    `api_from`             BIGINT       NOT NULL DEFAULT '0' COMMENT '归属用户 id：0-系统，其它-用户 id',
    `create_time`          DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time`          DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci COMMENT = '接口配置表';

# ai_model 表：模型配置
DROP TABLE IF EXISTS `ai_model`;
CREATE TABLE `ai_model`
(
    `id`          BIGINT      NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT '自增 id',
    `model_id`    VARCHAR(32) NOT NULL UNIQUE COMMENT '模型 id',
    `api_id`      VARCHAR(32) NOT NULL COMMENT '接口 id',
    `model_name`  VARCHAR(32) NOT NULL COMMENT '模型名称',
    `model_type`  VARCHAR(32) NOT NULL DEFAULT 'Unknown' COMMENT '模型类型',
    `model_from`  BIGINT      NOT NULL DEFAULT '0' COMMENT '归属用户 id：0-系统，其它-用户 id',
    `create_time` DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci COMMENT ='模型配置表';

# ai_client：客户端配置
DROP TABLE IF EXISTS `ai_client`;
CREATE TABLE `ai_client`
(
    `id`            BIGINT      NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT '自增 ID',
    `client_id`     VARCHAR(32) NOT NULL UNIQUE COMMENT '客户端 id',
    `client_type`   VARCHAR(32) NOT NULL COMMENT '客户端类型：chat/work',
    `client_role`   VARCHAR(32) NOT NULL COMMENT '客户端角色',
    `model_id`      VARCHAR(32) NOT NULL COMMENT '模型 id',
    `model_name`    VARCHAR(64) NOT NULL COMMENT '模型名称',
    `client_name`   VARCHAR(32) NOT NULL COMMENT '客户端名称',
    `client_status` TINYINT     NOT NULL DEFAULT '1' COMMENT '状态：0-禁用，1-启用',
    `client_from`   BIGINT      NOT NULL DEFAULT '0' COMMENT '归属用户 id：0-系统，其它-用户 id',
    `create_time`   DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time`   DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci COMMENT ='客户端配置表';

# ai_mcp：MCP 工具配置
DROP TABLE IF EXISTS `ai_mcp`;
CREATE TABLE `ai_mcp`
(
    `id`          BIGINT       NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT '自增 id',
    `mcp_id`      VARCHAR(32)  NOT NULL UNIQUE COMMENT '工具 id',
    `mcp_name`    VARCHAR(32)  NOT NULL COMMENT '工具名称',
    `mcp_type`    VARCHAR(32)  NOT NULL COMMENT '工具类型：sse/stdioConfig',
    `mcp_param`   JSON         NULL COMMENT '工具配置',
    `mcp_secret`  JSON         NULL COMMENT '工具密钥',
    `mcp_desc`    VARCHAR(255) NOT NULL DEFAULT '暂无描述' COMMENT '工具描述',
    `mcp_timeout` INT          NOT NULL DEFAULT '180' COMMENT '请求超时时间',
    `mcp_from`    BIGINT       NOT NULL DEFAULT '0' COMMENT '归属用户 id：0-系统，其它-用户 id',
    `create_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci COMMENT ='工具配置表';

# ai_prompt：配置系统提示词
DROP TABLE IF EXISTS `ai_prompt`;
CREATE TABLE `ai_prompt`
(
    `id`            BIGINT      NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT '自增 id',
    `prompt_id`     VARCHAR(32) NOT NULL UNIQUE COMMENT '提示词 id',
    `prompt_name`   VARCHAR(32) NOT NULL COMMENT '提示词名称',
    `systen_prompt` TEXT        NOT NULL COMMENT '提示词内容',
    `create_time`   DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time`   DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci COMMENT ='系统提示词配置表';

# ai_advisor：配置顾问角色
DROP TABLE IF EXISTS `ai_advisor`;
CREATE TABLE `ai_advisor`
(
    `id`            BIGINT      NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT '自增 id',
    `advisor_id`    VARCHAR(32) NOT NULL UNIQUE COMMENT '顾问 id',
    `advisor_name`  VARCHAR(32) NOT NULL COMMENT '顾问名称',
    `advisor_type`  VARCHAR(32) NOT NULL COMMENT '顾问类型',
    `advisor_param` JSON        NULL     DEFAULT NULL COMMENT '顾问参数配置',
    `create_time`   DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time`   DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci COMMENT ='顾问配置表';

# ai_config：用于存储 client 的关联信息
DROP TABLE IF EXISTS `ai_config`;
CREATE TABLE `ai_config`
(
    `id`            BIGINT      NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT '自增 id',
    `client_id`     VARCHAR(32) NOT NULL COMMENT '客户端 id',
    `config_type`   VARCHAR(32) NOT NULL COMMENT '配置类型',
    `config_value`  VARCHAR(32) NOT NULL COMMENT '配置值',
    `config_status` TINYINT     NOT NULL DEFAULT '1' COMMENT '状态：0-禁用，1-启用',
    `create_time`   DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time`   DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    UNIQUE KEY `uk_client_type_value` (`client_id`, `config_type`, `config_value`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci COMMENT ='客户端关联表';

# ai_agent：智能体的元信息
DROP TABLE IF EXISTS `ai_agent`;
CREATE TABLE `ai_agent`
(
    `id`           BIGINT       NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT '自增 id',
    `agent_id`     VARCHAR(32)  NOT NULL UNIQUE COMMENT '全局 id',
    `agent_name`   VARCHAR(32)  NOT NULL COMMENT '智能体名称',
    `agent_type`   VARCHAR(32)  NOT NULL COMMENT '智能体类型：step/loop/react',
    `agent_desc`   VARCHAR(255) NOT NULL DEFAULT '暂无描述' COMMENT '智能体描述',
    `model_id`     VARCHAR(32)  NULL     DEFAULT NULL COMMENT '模型 id',
    `template_id`  VARCHAR(64)  NULL     DEFAULT NULL COMMENT '模版 id',
    `agent_status` TINYINT      NOT NULL DEFAULT '1' COMMENT '状态：0-禁用，1-启用',
    `agent_from`   BIGINT       NOT NULL DEFAULT '0' COMMENT '归属用户 id：0-系统，其它-用户 id',
    `create_time`  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time`  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci COMMENT ='智能体配置表';

# ai_task：智能体负责的工作
DROP TABLE IF EXISTS `ai_task`;
CREATE TABLE `ai_task`
(
    `id`          BIGINT       NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT '自增 id',
    `task_id`     VARCHAR(32)  NOT NULL COMMENT '任务 id',
    `agent_id`    VARCHAR(32)  NOT NULL COMMENT '智能体 id',
    `task_cron`   VARCHAR(32)  NOT NULL COMMENT '任务时间表达式',
    `task_desc`   VARCHAR(255) NOT NULL DEFAULT '暂无描述' COMMENT '任务描述',
    `task_param`  JSON         NULL     DEFAULT NULL COMMENT '任务参数配置',
    `task_status` TINYINT      NOT NULL DEFAULT '1' COMMENT '状态：0-禁用，1-启用',
    `task_from`   BIGINT       NOT NULL DEFAULT '0' COMMENT '归属用户 id：0-系统，其它-用户 id',
    `create_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci COMMENT ='智能体任务调度配置表';

# ai_flow：配置客户端工作流
DROP TABLE IF EXISTS `ai_flow`;
CREATE TABLE `ai_flow`
(
    `id`          BIGINT      NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
    `agent_id`    VARCHAR(32) NOT NULL COMMENT '智能体ID',
    `client_id`   VARCHAR(32) NOT NULL COMMENT '客户端ID',
    `client_role` VARCHAR(32) NOT NULL COMMENT '客户端角色',
    `user_prompt` TEXT        NOT NULL COMMENT '工作流提示词',
    `flow_seq`    TINYINT     NOT NULL COMMENT '工作流顺序',
    `create_time` DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    UNIQUE KEY `uk_agent_client_seq` (`agent_id`, `client_id`, `flow_seq`),
    UNIQUE KEY `uk_agent_role` (`agent_id`, `client_role`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci COMMENT ='智能体-客户端关联表';

# ai_plaza：Agent 广场发布表
DROP TABLE IF EXISTS `ai_plaza`;
CREATE TABLE `ai_plaza`
(
    `id`            BIGINT       NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT '自增 id',
    `plaza_id`      VARCHAR(64)  NOT NULL UNIQUE COMMENT '广场记录 id',
    `plaza_title`   VARCHAR(128) NOT NULL COMMENT '展示标题',
    `plaza_desc`    VARCHAR(255) NOT NULL DEFAULT '暂无描述' COMMENT '展示描述',
    `like_count`    INT          NOT NULL DEFAULT '0' COMMENT '点赞数',
    `favor_count`   INT          NOT NULL DEFAULT '0' COMMENT '收藏数',
    `comment_count` INT          NOT NULL DEFAULT '0' COMMENT '评论数',
    `template_id`   VARCHAR(64)  NOT NULL COMMENT '关联模板 id',
    `user_id`       BIGINT       NOT NULL COMMENT '发布者用户 id',
    `agent_name`    VARCHAR(32)  NOT NULL COMMENT '智能体名称',
    `agent_type`    VARCHAR(32)  NOT NULL COMMENT '智能体类型',
    `create_time`   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time`   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    UNIQUE KEY `uk_template_id` (`template_id`),
    KEY `idx_template_id` (`template_id`),
    KEY `idx_user_id` (`user_id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci COMMENT ='Agent 广场发布表';

# ai_plaza_like：广场点赞
DROP TABLE IF EXISTS `ai_plaza_like`;
CREATE TABLE `ai_plaza_like`
(
    `id`          BIGINT      NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT '自增 id',
    `plaza_id`    VARCHAR(64) NOT NULL COMMENT '广场记录 id',
    `user_id`     BIGINT      NOT NULL COMMENT '点赞用户 id',
    `create_time` DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    UNIQUE KEY `uk_plaza_like` (`plaza_id`, `user_id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci COMMENT ='Agent 广场点赞表';

# ai_plaza_favor：广场收藏
DROP TABLE IF EXISTS `ai_plaza_favor`;
CREATE TABLE `ai_plaza_favor`
(
    `id`          BIGINT      NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT '自增 id',
    `plaza_id`    VARCHAR(64) NOT NULL COMMENT '广场记录 id',
    `user_id`     BIGINT      NOT NULL COMMENT '收藏用户 id',
    `create_time` DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    UNIQUE KEY `uk_plaza_favor` (`plaza_id`, `user_id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci COMMENT ='Agent 广场收藏表';

# ai_plaza_comment：广场评论
DROP TABLE IF EXISTS `ai_plaza_comment`;
CREATE TABLE `ai_plaza_comment`
(
    `id`              BIGINT      NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT '自增 id',
    `comment_id`      VARCHAR(64) NOT NULL UNIQUE COMMENT '评论 id',
    `plaza_id`        VARCHAR(64) NOT NULL COMMENT '广场记录 id',
    `user_id`         BIGINT      NOT NULL COMMENT '评论用户 id',
    `user_name`       VARCHAR(64) NOT NULL COMMENT '评论用户名',
    `comment_content` MEDIUMTEXT  NOT NULL COMMENT '评论内容',
    `create_time`     DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time`     DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci COMMENT ='Agent 广场评论表';

# ai_repo：用户可用的 Agent 仓库
DROP TABLE IF EXISTS `ai_repo`;
CREATE TABLE `ai_repo`
(
    `id`          BIGINT      NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT '自增 id',
    `repo_id`     VARCHAR(64) NOT NULL UNIQUE COMMENT '仓库 id',
    `user_id`     BIGINT      NOT NULL COMMENT '用户 id',
    `agent_id`    VARCHAR(32) NULL COMMENT '智能体 id',
    `template_id` VARCHAR(64) NULL COMMENT '模版 id',
    `repo_type`   VARCHAR(32) NOT NULL COMMENT '类型：self/favor/fork',
    `create_time` DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    UNIQUE KEY `uk_user_agent_repo_type` (`user_id`, `agent_id`, `repo_type`),
    UNIQUE KEY `uk_user_template_repo_type` (`user_id`, `template_id`, `repo_type`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci COMMENT ='用户 Agent 仓库表';

DROP TABLE IF EXISTS `ai_template`;
CREATE TABLE `ai_template`
(
    `id`                 BIGINT       NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT '自增 id',
    `template_id`        VARCHAR(64)  NOT NULL UNIQUE COMMENT '模板 id',

    `user_id`            BIGINT       NOT NULL COMMENT '用户 id',

    `agent_name`         VARCHAR(128) NOT NULL COMMENT '智能体名称',
    `agent_type`         VARCHAR(32)  NOT NULL COMMENT '执行策略',
    `agent_desc`         VARCHAR(512) NOT NULL DEFAULT '暂无描述' COMMENT '智能体描述',

    `api_base_url`       VARCHAR(255) NOT NULL COMMENT 'API 基础地址',
    `api_completion_url` VARCHAR(255) NOT NULL COMMENT 'API completion 地址',
    `model_name`         VARCHAR(64)  NOT NULL COMMENT '模型名',
    `model_type`         VARCHAR(32)  NOT NULL DEFAULT 'Unknown' COMMENT '模型类型',

    `snapshot`           TEXT         NOT NULL COMMENT '配置快照',

    `create_time`        DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间 / 发布时间',
    `update_time`        DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    KEY `idx_user_id` (`user_id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci COMMENT ='智能体模板表';

# ai_user：系统用户表
DROP TABLE IF EXISTS `ai_user`;
CREATE TABLE `ai_user`
(
    `id`          BIGINT       NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT '自增 id',
    `user_name`   VARCHAR(32)  NOT NULL UNIQUE COMMENT '用户名',
    `password`    VARCHAR(255) NOT NULL COMMENT '加密后的密码',
    `user_role`   VARCHAR(32)  NOT NULL DEFAULT 'account' COMMENT '角色：account / admin',
    `user_avatar` VARCHAR(255) NOT NULL DEFAULT '' COMMENT '用户头像 URL',
    `user_status` TINYINT      NOT NULL DEFAULT '1' COMMENT '状态：0-禁用，1-启用',
    `create_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci COMMENT ='系统用户表';

# ai_session：会话表
DROP TABLE IF EXISTS `ai_session`;
CREATE TABLE `ai_session`
(
    `id`            BIGINT      NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT '自增 id',
    `session_id`    VARCHAR(64) NOT NULL UNIQUE COMMENT '会话 id',
    `user_id`       BIGINT      NOT NULL COMMENT '用户 id',
    `session_title` VARCHAR(64) NOT NULL DEFAULT '未命名会话' COMMENT '会话标题',
    `session_type`  VARCHAR(32) NOT NULL COMMENT '会话类型：chat/work',
    `create_time`   DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `update_time`   DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci COMMENT ='会话记录表';

# ai_message：消息表
DROP TABLE IF EXISTS `ai_message`;
CREATE TABLE `ai_message`
(
    `id`              BIGINT      NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT '自增 id',
    `session_id`      VARCHAR(64) NOT NULL COMMENT '会话 id',
    `message_content` LONGTEXT    NOT NULL COMMENT '消息内容',
    `message_role`    VARCHAR(32) NOT NULL COMMENT '消息角色：user/assistant',
    `message_type`    VARCHAR(32) NOT NULL COMMENT '消息类型：chat/work-sse/work-answer',
    `message_seq`     INT         NOT NULL COMMENT '消息序号',
    `create_time`     DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `update_time`     DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci COMMENT ='会话记录表';

# ai_stat：运行统计表
DROP TABLE IF EXISTS `ai_stat`;
CREATE TABLE `ai_stat`
(
    `id`            BIGINT      NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT '自增 id',
    `stat_date`     DATE        NOT NULL COMMENT '统计日期',
    `stat_category` VARCHAR(32) NOT NULL COMMENT '统计类别：chat / work',
    `stat_key`      VARCHAR(32) NOT NULL COMMENT '统计键：api/model/client/agent/prompt/advisor/mcp',
    `stat_value`    VARCHAR(64) NOT NULL COMMENT '统计值：xxxid',
    `stat_count`    INT         NOT NULL DEFAULT 0 COMMENT '计数',
    `create_time`   DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time`   DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    UNIQUE KEY `uk_stat_unique` (`stat_date`, `stat_category`, `stat_key`, `stat_value`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci COMMENT ='运行统计表';
