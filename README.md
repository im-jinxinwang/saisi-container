# saisi-container

基于 Apache Tomcat 的多 JDK 支持 Docker 镜像。

## Workflows

### Dragonwell JDK

- **Workflow**: `.github/workflows/build-dragonwell.yml`
- **镜像标签**: `9.0.x-dw`
- **JDK**: 阿里 Dragonwell 8（自动获取最新版）

### BellSoft JDK

- **Workflow**: `.github/workflows/build-bellsoft.yml`
- **镜像标签**: `9.0.x-bs`
- **JDK**: BellSoft Liberica 8（自动获取最新版）

## 镜像

- `images/tomcat/` - Tomcat Docker 镜像配置

## 仓库

- **仓库**: `registry.cn-hangzhou.aliyuncs.com`
- **镜像名**: `saisi/tomcat`

## 使用方法

### 通过 Issue 模板触发（推荐）

1. 进入 [Issues](../../issues) 页面
2. 点击 "New issue"
3. 选择 "构建镜像" 模板
4. 填写表单：
   - **Tomcat 版本号**：例如 `9.0.115`
   - **JDK 类型**：可选 Dragonwell 8、BellSoft 8 或全部构建
   - **备注说明**：其他需要说明的信息（可选）
5. 提交 issue 后自动触发构建

### 手动触发

1. 进入 Actions 标签
2. 选择对应的 workflow
   - `Build and Push Dragonwell Image` (Dragonwell JDK)
   - `Build and Push BellSoft Image` (BellSoft JDK)
3. 点击 "Run workflow"
4. 输入版本号（可选，留空则使用最新版）
5. 点击 "Run workflow"

## 拉取镜像

```bash
# Dragonwell JDK
docker pull registry.cn-hangzhou.aliyuncs.com/saisi/tomcat:9.0.115-dw

# BellSoft JDK
docker pull registry.cn-hangzhou.aliyuncs.com/saisi/tomcat:9.0.115-bs
```

## 环境变量

| 变量 | 说明 | 默认值 |
|------|------|--------|
| `HTTP_PORT` | HTTP 端口 | 9080 |
| `HTTPS_PORT` | HTTPS 端口 | 9443 |
| `CONN_TIMEOUT` | 连接超时 (ms) | 5000 |
| `SERVER_NAME` | Server 头 | Web Server |
| `HEADER_SIZE` | 请求头大小 | 8192 |

## 端口

- 9080 (HTTP)
- 9443 (HTTPS)
- 162/UDP (SNMP)
