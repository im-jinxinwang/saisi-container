#!/bin/bash

set -e

BASE_IMAGE=${BASE_IMAGE:-registry.cn-hangzhou.aliyuncs.com/aliyun_ago/kylin:v10-sp3-2403}
TOMCAT_TAR=$(ls -1v images/tomcat/scripts/saisi-*.tar.gz 2>/dev/null | tail -n 1)

TOMCAT_VERSION=$(echo "$TOMCAT_TAR" | grep -oP '[0-9]+\.[0-9]+\.[0-9]+')
IMAGE_TAG="${TOMCAT_VERSION}-dw"
echo "Final image tag: ${IMAGE_TAG}"

docker run --rm --privileged multiarch/qemu-user-static --reset -p yes

BUILDER_NAME="multiarch-builder"
if ! docker buildx inspect "$BUILDER_NAME" >/dev/null 2>&1; then
    docker buildx create --name "$BUILDER_NAME" --driver docker-container --use
else
    docker buildx use "$BUILDER_NAME"
fi
docker buildx inspect --bootstrap

declare -A JDK_MAP
JDK_MAP[amd64]="Alibaba_Dragonwell_Standard_8.27.26_x64_linux.tar.gz"
JDK_MAP[arm64]="Alibaba_Dragonwell_Standard_8.27.26_aarch64_linux.tar.gz"

PLATFORMS=("amd64" "arm64")
IMAGE_LIST=()

for ARCH in "${PLATFORMS[@]}"; do
    PLATFORM_TAG="${IMAGE_TAG}-${ARCH}"
    echo "=============================="
    echo "Building for ${ARCH}..."
    echo "=============================="

    docker build \
        --platform "linux/${ARCH}" \
        --build-arg BASE_IMAGE="$BASE_IMAGE" \
        --build-arg JDK_TAR="${JDK_MAP[$ARCH]}" \
        --build-arg TOMCAT_TAR="$TOMCAT_TAR" \
        -t "registry.cn-hangzhou.aliyuncs.com/saisi/tomcat:${PLATFORM_TAG}" \
        -f images/tomcat/Dockerfile \
        images/tomcat

    echo "Pushing ${PLATFORM_TAG} ..."
    docker push "registry.cn-hangzhou.aliyuncs.com/saisi/tomcat:${PLATFORM_TAG}"

    IMAGE_LIST+=("registry.cn-hangzhou.aliyuncs.com/saisi/tomcat:${PLATFORM_TAG}")
done

echo "=============================="
echo "Creating multi-arch image ..."
echo "=============================="

docker buildx imagetools create \
    -t "registry.cn-hangzhou.aliyuncs.com/saisi/tomcat:${IMAGE_TAG}" \
    "${IMAGE_LIST[@]}"

echo "=============================="
echo "Multi-arch image created and pushed:"
echo "registry.cn-hangzhou.aliyuncs.com/saisi/tomcat:${IMAGE_TAG}"
echo "=============================="
