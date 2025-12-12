# Dolphie UI - MySQL Web 监控面板

[![Docker Pulls](https://img.shields.io/docker/pulls/izerui/dolphie-ui?style=flat-square)](https://hub.docker.com/r/izerui/dolphie-ui)
[![Docker Image Size](https://img.shields.io/docker/image-size/izerui/dolphie-ui?style=flat-square)](https://hub.docker.com/r/izerui/dolphie-ui)
[![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/izerui/dolphie-ui/docker-push.yml?branch=main&style=flat-square)](https://github.com/izerui/dolphie-ui/actions)
[![GitHub Release](https://img.shields.io/github/v/release/izerui/dolphie-ui?style=flat-square)](https://github.com/izerui/dolphie-ui/releases)
[![License](https://img.shields.io/github/license/izerui/dolphie-ui?style=flat-square)](https://github.com/izerui/dolphie-ui/blob/main/LICENSE)
[![Last Commit](https://img.shields.io/github/last-commit/izerui/dolphie-ui?style=flat-square)](https://github.com/izerui/dolphie-ui/commits/main)

一个基于 Docker 的 MySQL 监控 Web 界面，通过 ttyd 提供 Dolphie 的 Web 访问能力。

## 简介

Dolphie 是一个现代的 MySQL 监控工具，提供直观的终端界面实时显示 MySQL 服务器性能指标。本项目将 Dolphie 封装在 Docker 容器中，并通过 ttyd 提供 Web 访问界面，使您无需安装客户端即可在浏览器中监控 MySQL 性能。

![demo.png](demo.png)

## 功能特点

- 🚀 基于 Homebrew Ubuntu 24.04 镜像构建
- 🌐 提供 Web 界面访问，无需安装客户端
- 📊 实时监控 MySQL 性能指标
- 🔄 支持自动构建和多架构部署
- 🛠️ 提供多种部署方式：Docker、Docker Compose 和 Kubernetes
- 📝 使用配置文件管理连接参数

## 项目结构

```
dolphie-ui/
├── .github/workflows/
│   └── docker-push.yml     # CI/CD 工作流配置
├── docker/
│   ├── rds.conf           # MySQL 监控配置文件
│   └── start.sh           # Docker 启动脚本
├── docker-compose/
│   ├── docker-compose.yml # Docker Compose 配置
│   ├── rds.conf           # MySQL 监控配置文件
│   └── start.sh           # Docker Compose 启动脚本
├── kubernetes/
│   ├── deploy.sh          # Kubernetes 部署脚本
│   └── dolphie-ui.yaml    # Kubernetes 部署配置
├── .gitignore             # Git 忽略文件配置
├── Dockerfile             # Docker 镜像构建文件
├── build.sh               # 本地构建脚本
└── README.md              # 项目说明文档
```

## 快速开始

本项目提供三种部署方式：Docker、Docker Compose 和 Kubernetes。

### 方式一：使用 Docker

最简单的部署方式，适合快速测试和单机部署：

```bash
cd docker
./start.sh
```

手动启动：

```bash
docker run -d -p 7681:7681 \
  -v $(pwd)/docker/rds.conf:/home/linuxbrew/rds.conf \
  --name dolphie-ui \
  izerui/dolphie-ui \
  ttyd -p 7681 --writable -c admin:admin123 dolphie --config-file rds.conf --hostgroup rds_cluster --tab-setup
```

### 方式二：使用 Docker Compose

适合需要持久化和更多配置选项的场景：

```bash
cd docker-compose
./start.sh
```

手动启动：

```bash
docker-compose up -d
```

### 方式三：使用 Kubernetes

适合生产环境和集群部署：

```bash
cd kubernetes
./deploy.sh
```

手动部署：

```bash
kubectl apply -f dolphie-ui.yaml
```

## 访问方式

部署成功后，您可以通过以下方式访问：

- Docker/Docker Compose: http://localhost:7681
- Kubernetes: https://dolphie-ui.yourdomain.com (取决于您的 Ingress 配置)

登录凭据：
- 用户名: admin
- 密码: admin123

## 配置说明

### MySQL 连接配置

配置文件 `rds.conf` 包含以下主要部分：

1. **全局设置** `[dolphie]`：定义 Dolphie 的全局行为
2. **凭据配置** `[credential_profile_mysql_creds]`：定义 MySQL 连接凭据
3. **主机组配置** `[rds_cluster]`：定义要监控的 MySQL 实例

示例配置：

```ini
# 凭据配置文件
[credential_profile_mysql_creds]
user = your_username
password = your_password

# 主机组配置
[rds_cluster]
1={"host": "192.168.10.10", "port": 3306, "tab_title": "[cyan]ERP[/cyan] :master:", "credential_profile": "mysql_creds"}
2={"host": "192.168.10.11", "port": 3306, "tab_title": "[bright_cyan]ERP[/bright_cyan] :slave:", "credential_profile": "mysql_creds"}
```

### 启动参数

Dolphie 支持以下常用参数：

- `--config-file`: 指定配置文件路径
- `--hostgroup`: 指定要监控的主机组
- `--tab-setup`: 初始设置的标签页

## Docker 镜像信息

- 基础镜像: homebrew/ubuntu24.04
- 镜像名称: izerui/dolphie-ui
- 暴露端口: 7681
- 时区设置: Asia/Shanghai

## Dolphin 监控系统功能对照表

| 英文名称 | 中文说明 | 功能描述 - 对 MySQL 性能的影响分析 |
|---------|---------|--------------------------------|
| **Host Information** | 主机信息 | 显示 MySQL 服务器的基本信息，包括版本、操作系统、运行时间等 |
| **Version** | 版本 | MySQL 数据库版本号，用于确认数据库版本兼容性和特性支持 |
| **Type** | 类型 | 数据库类型（MySQL），确认数据库类型 |
| **Uptime** | 运行时间 | 服务器已运行的时间，评估系统稳定性，长时间运行可能影响性能 |
| **Replicas** | 副本 | 副本数量，监控主从复制架构的副本状态，影响数据同步性能 |
| **Threads** | 线程 | 连接数统计（con/run/cac），监控并发连接数和线程使用情况，高连接数可能导致性能下降 |
| **Tables** | 表 | 表打开情况，监控表缓存使用效率，频繁打开表可能影响性能 |
| **Runtime** | 运行时间 | 运行时间和延迟，评估查询性能，长时间运行可能表示查询效率低下 |
| **InnoDB** | InnoDB 引擎 | InnoDB 存储引擎相关指标，监控 InnoDB 引擎性能 |
| **Read Hit** | 读取命中率 | 读取缓存命中率，评估缓冲池效率，高命中率表示缓存使用良好，低命中率可能导致磁盘I/O增加 |
| **AHI Hit** | AHI 命中率 | 自适应哈希索引命中率，监控哈希索引使用效率，低命中率可能表示哈希索引配置不当 |
| **BP Instances** | 缓冲池实例 | 缓冲池实例数量，监控 InnoDB 缓冲池配置，过多实例可能增加管理开销 |
| **BP Size** | 缓冲池大小 | 缓冲池总大小，评估内存使用情况，过小可能导致频繁磁盘I/O |
| **BP Available** | 可用缓冲池 | 可用缓冲池空间，监控内存剩余情况，空间不足可能影响性能 |
| **BP Dirty** | 脏页 | 脏页大小，监控需要写入磁盘的脏页数量，过多脏页可能导致写入延迟 |
| **History List** | 历史列表 | 历史列表长度，监控 InnoDB 事务历史，过长可能影响性能 |
| **Binary Log** | 二进制日志 | 二进制日志相关信息，监控复制和恢复 |
| **File name** | 文件名 | 日志文件名，确认二进制日志文件 |
| **Position** | 位置 | 当前日志位置，监控复制进度，延迟可能表示复制性能问题 |
| **Size** | 大小 | 日志文件大小，评估日志增长，过大可能影响磁盘空间和写入性能 |
| **Cache Hit** | 缓存命中率 | 缓存命中率，评估查询缓存效率，低命中率可能表示查询缓存配置不当 |
| **Format** | 格式 | 日志格式，确认二进制日志格式 |
| **GTID** | 全局事务ID | 全局事务ID状态，监控 GTID 复制 |
| **Compression** | 压缩 | 压缩状态，确认日志压缩设置 |
| **Statistics/s** | 统计/秒 | 每秒统计信息，实时监控数据库活动 |
| **Queries** | 查询 | 每秒查询数，评估数据库负载，高查询数可能表示系统繁忙 |
| **SELECT/INSERT/UPDATE/DELETE** | 查询类型 | 各类 SQL 操作统计，分析查询模式，过多写操作可能影响性能 |
| **COMMIT/ROLLBACK** | 事务 | 事务提交和回滚数，监控事务处理，频繁回滚可能表示事务问题 |
| **Metric Graphs** | 指标图表 | 性能指标趋势图，可视化性能变化 |
| **Read Requests** | 读取请求 | 读取请求数，监控读取负载，高读取可能表示读密集型应用 |
| **Write Requests** | 写入请求 | 写入请求数，监控写入负载，高写入可能表示写密集型应用 |
| **Disk Reads** | 磁盘读取 | 磁盘读取数，评估 I/O 性能，高磁盘读取可能表示缓冲池不足 |
| **DML** | 数据操作语言 | 数据操作语言相关监控，分析 DML 操作 |
| **BP Requests** | 缓冲池请求 | 缓冲池请求统计，监控缓冲池使用，高请求可能表示内存压力 |
| **History List** | 历史列表 | 历史列表监控，监控 InnoDB 历史列表 |
| **AHI** | 自适应哈希索引 | 自适应哈希索引监控，评估索引效率 |
| **Checkpoint** | 检查点 | 检查点监控，监控 InnoDB 检查点活动，频繁检查点可能影响性能 |
| **Redo Log** | 重做日志 | 重做日志监控，监控事务恢复 |
| **Table Cache** | 表缓存 | 表缓存监控，评估表缓存效率，低命中率可能表示表缓存不足 |
| **Threads** | 线程 | 线程监控，监控线程使用，过多线程可能增加上下文切换开销 |
| **Temp Objects** | 临时对象 | 临时对象监控，评估临时表使用，过多临时表可能影响性能 |
| **Aborted Connections** | 中断连接 | 中断连接监控，评估连接稳定性，高中断可能表示网络或配置问题 |
| **Disk I/O** | 磁盘I/O | 磁盘I/O监控，评估磁盘性能，高I/O可能表示磁盘瓶颈 |
| **Metadata Locks** | 元数据锁 | 元数据锁状态，监控元数据锁争用，高锁等待可能表示并发问题 |
| **Object Type** | 对象类型 | 锁定的对象类型，分析锁类型 |
| **Object Schema** | 对象架构 | 锁定的对象架构，确认锁定范围 |
| **Object Name** | 对象名称 | 锁定的对象名称，定位具体对象 |
| **Lock Type** | 锁类型 | 锁的类型，分析锁模式 |
| **Lock Status** | 锁状态 | 锁的状态，监控锁等待 |
| **Code Source** | 代码源 | 锁的来源代码，定位问题源头 |
| **Thread Source** | 线程源 | 锁的线程源，分析线程活动 |
| **Process ID** | 进程ID | 锁定的进程ID，确认进程信息 |
| **User** | 用户 | 锁定的用户，分析用户活动 |
| **Age** | 年龄 | 锁的持有时间，评估锁等待 |
| **Query** | 查询 | 导致锁的查询，定位问题查询 |
| **Performance Schema Metrics** | 性能模式指标 | 性能模式统计信息，深入性能分析 |
| **Delta since last reset** | 自上次重置以来的增量 | 自上次重置以来的变化量，监控变化趋势 |
| **Total since MySQL restart** | 自MySQL重启以来的总计 | 自MySQL重启以来的总计，评估累计性能 |
| **File I/O** | 文件I/O | 文件I/O统计，监控文件系统性能 |
| **Table I/O Waits** | 表I/O等待 | 表I/O等待统计，分析表级I/O瓶颈 |
| **Processlist** | 进程列表 | 当前活跃进程列表，监控活跃连接 |
| **Thread ID** | 线程ID | 线程标识符，确认线程信息 |
| **Protocol** | 协议 | 连接协议，确认连接类型 |
| **Username** | 用户名 | 连接用户，分析用户活动 |
| **Hostname/IP** | 主机名/IP | 客户端主机名或IP，确认客户端信息 |
| **Database** | 数据库 | 当前使用的数据库，确认数据库上下文 |
| **Command** | 命令 | 当前执行的命令，分析当前操作 |
| **State** | 状态 | 线程状态，监控线程活动状态 |
| **TRX State** | 事务状态 | 事务状态，监控事务处理 |
| **R-Lock** | 读锁 | 读锁状态，分析读锁争用 |
| **R-Mod** | 读修改 | 读修改状态，分析读修改冲突 |
| **Age** | 年龄 | 线程运行时间，评估线程寿命 |
| **Query** | 查询 | 当前执行的SQL查询，定位问题查询 |
| **Statements Summary** | 语句摘要 | SQL语句统计摘要，分析查询性能 |
| **Schema** | 架构 | 数据库架构，确认数据库上下文 |
| **Count** | 计数 | 语句执行次数，评估查询频率 |
| **Latency** | 延迟 | 语句执行延迟，分析查询性能，高延迟表示查询效率低下 |
| **Lock time** | 锁定时间 | 锁定时间，分析锁等待，长时间锁定可能表示锁争用 |
| **Rows examined** | 检查的行数 | 查询检查的行数，评估查询效率，过多行检查可能表示索引问题 |
| **Rows affected** | 影响的行数 | 查询影响的行数，确认数据变更 |
| **Rows sent** | 发送的行数 | 返回的行数，评估网络传输 |
| **Errors** | 错误 | 错误数，监控错误发生，高错误可能表示系统问题 |
| **Warnings** | 警告 | 警告数，监控潜在问题 |
| **Bad idx** | 错误索引 | 错误索引数，分析索引问题 |
| **No idx** | 无索引 | 无索引数，评估查询优化，高无索引数表示查询未使用索引 |
| **Query** | 查询 | 具体SQL语句，定位问题查询 |

## 相关链接

[![Dolphie](https://img.shields.io/badge/Dolphie-官方仓库-blue?style=flat-square)](https://github.com/charles-001/dolphie)
[![ttyd](https://img.shields.io/badge/ttyd-官方仓库-blue?style=flat-square)](https://github.com/tsl0922/ttyd)
[![Docker Hub](https://img.shields.io/badge/Docker_Hub-镜像-blue?style=flat-square)](https://hub.docker.com/r/izerui/dolphie-ui)

- [Dolphie 官方仓库](https://github.com/charles-001/dolphie)
- [ttyd 官方仓库](https://github.com/tsl0922/ttyd)
- [Docker Hub 镜像](https://hub.docker.com/r/izerui/dolphie-ui)

## 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情。