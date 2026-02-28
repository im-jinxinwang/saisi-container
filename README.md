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

Push a tag to trigger builds:

```bash
git tag v9.0.115
git push origin v9.0.115
```

This will automatically build both Dragonwell and BellSoft variants.

## Pull Images

```bash
# Dragonwell JDK
docker pull registry.cn-hangzhou.aliyuncs.com/saisi/tomcat:9.0.115-dw

# BellSoft JDK
docker pull registry.cn-hangzhou.aliyuncs.com/saisi/tomcat:9.0.115-bs
```
