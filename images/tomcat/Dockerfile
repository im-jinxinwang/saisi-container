ARG BASE_IMAGE=registry.cn-hangzhou.aliyuncs.com/aliyun_ago/kylin:v10-sp3-2403
FROM ${BASE_IMAGE} AS build

ARG JDK_TAR_AMD64
ARG JDK_TAR_ARM64
ARG TOMCAT_TAR

# Copy both JDK tarballs - buildx will only use the one for current platform
COPY ${JDK_TAR_AMD64} /tmp/jdk-amd64.tar.gz
COPY ${JDK_TAR_ARM64} /tmp/jdk-arm64.tar.gz
COPY ${TOMCAT_TAR} /tmp/tomcat.tar.gz

# Detect architecture and use appropriate JDK
RUN ARCH=$(uname -m) && \
    mkdir -p /usr/local/jdk /tmp/nms && \
    if [ "$ARCH" = "x86_64" ]; then \
        tar -zxf /tmp/jdk-amd64.tar.gz -C /usr/local/jdk --strip-components=1; \
    elif [ "$ARCH" = "aarch64" ]; then \
        tar -zxf /tmp/jdk-arm64.tar.gz -C /usr/local/jdk --strip-components=1; \
    else \
        echo "Unsupported architecture: $ARCH" && exit 1; \
    fi && \
    tar -zxf /tmp/tomcat.tar.gz -C /tmp/nms --strip-components=1 && \
    rm -rf /usr/local/jdk/src.zip /tmp/jdk-*.tar.gz /tmp/tomcat.tar.gz

FROM ${BASE_IMAGE}

ARG USERNAME=saisinms
ARG USER_UID=1000
ARG USER_GID=1000

WORKDIR /home/${USERNAME}

RUN sed -i 's|http://update.cs2c.com.cn:8080|https://update.cs2c.com.cn|g' /etc/yum.repos.d/kylin_*.repo && \
    yum makecache && \
    yum install -y iputils telnet tcpdump vim iproute net-snmp-utils mariadb && \
    yum clean all && rm -rf /var/cache/yum && \
    groupadd -g ${USER_GID} ${USERNAME} && \
    useradd -u ${USER_UID} -g ${USER_GID} -d /home/${USERNAME} -M ${USERNAME}

COPY --from=build /usr/local/jdk /usr/local/jdk
COPY --from=build /tmp/nms /home/${USERNAME}/nms
COPY scripts/entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh && \
    chown -R ${USERNAME}:${USERNAME} /home/${USERNAME} /usr/local/jdk /home/${USERNAME}/nms

ENV JAVA_HOME=/usr/local/jdk
ENV JRE_HOME=${JAVA_HOME}/jre
ENV CLASSPATH=.:${JAVA_HOME}/lib:${JAVA_HOME}/lib/tools.jar:${JRE_HOME}/lib
ENV CATALINA_HOME=/home/${USERNAME}/nms
ENV PATH=${JAVA_HOME}/bin:${CATALINA_HOME}/bin:$PATH
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en

USER root

EXPOSE 9080 9443 162/udp

ENTRYPOINT ["/entrypoint.sh"]
CMD ["catalina.sh", "run"]
