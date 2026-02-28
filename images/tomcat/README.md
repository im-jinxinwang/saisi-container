# Tomcat Container Image

基于 Apache Tomcat 9 的定制容器镜像，支持多架构（amd64/arm64）。

## 特性

- 自动获取最新 Tomcat 9 版本
- 自动获取最新 Dragonwell JDK 8
- 多架构支持（linux/amd64, linux/arm64）
- 自定义 SSL 证书
- 自定义错误页面（403、404、500）
- 隐藏 Tomcat 版本号
- 支持环境变量配置

## 构建

### 本地构建

```bash
# 使用 Dragonwell JDK
./build-Dragonwell.sh
```

### GitHub Actions

推送 `v*` 标签自动构建，或手动触发 workflow。

## 镜像标签

- `registry.cn-hangzhou.aliyuncs.com/saisi/tomcat:9.0.x-dw` (Dragonwell)

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
