# saisi-container

Docker image build scripts for Tomcat with multi-JDK support.

## Workflows

### Dragonwell JDK

- **Workflow**: `.github/workflows/build-dragonwell.yml`
- **Tag**: `v9.0.x-dw`
- **JDK**: Alibaba Dragonwell 8 (auto-fetch latest)

### BellSoft JDK

- **Workflow**: `.github/workflows/build-bellsoft.yml`
- **Tag**: `v9.0.x-bs`
- **JDK**: BellSoft Liberica 8 (auto-fetch latest)

## Images

- `images/tomcat/` - Tomcat Docker image configuration

## Registry

- **Registry**: `registry.cn-hangzhou.aliyuncs.com`
- **Image Name**: `saisi/tomcat`

## Usage

### Trigger by Issue

Create a new issue with title containing the version number:

```
Build 9.0.115
```

This will automatically build both Dragonwell and BellSoft variants.

### Manual Trigger

1. Go to Actions tab
2. Select the workflow (`Build and Push Dragonwell Image` or `Build and Push BellSoft Image`)
3. Click "Run workflow"
4. Select branch (usually `main`)
5. Click "Run workflow"

## Pull Images

```bash
# Dragonwell JDK
docker pull registry.cn-hangzhou.aliyuncs.com/saisi/tomcat:9.0.115-dw

# BellSoft JDK
docker pull registry.cn-hangzhou.aliyuncs.com/saisi/tomcat:9.0.115-bs
```

## Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `HTTP_PORT` | HTTP Port | 9080 |
| `HTTPS_PORT` | HTTPS Port | 9443 |
| `CONN_TIMEOUT` | Connection Timeout (ms) | 5000 |
| `SERVER_NAME` | Server Header | Web Server |
| `HEADER_SIZE` | Request Header Size | 8192 |

## Ports

- 9080 (HTTP)
- 9443 (HTTPS)
- 162/UDP (SNMP)
