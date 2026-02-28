ARG BASE_IMAGE=registry.cn-hangzhou.aliyuncs.com/aliyun_ago/kylin:v10-sp3-2403
FROM ${BASE_IMAGE} AS build

# Copy JDK and Tomcat tarballs
COPY --chown=root:root *.tar.gz /tmp/

# Detect architecture and extract appropriate JDK
RUN ARCH=$(uname -m) && \
    mkdir -p /usr/local/jdk /tmp/nms && \
    # Find and extract JDK based on architecture
    if [ "$ARCH" = "x86_64" ]; then \
        JDK_FILE=$(ls /tmp/*x64*.tar.gz /tmp/*amd64*.tar.gz 2>/dev/null | head -1); \
    elif [ "$ARCH" = "aarch64" ]; then \
        JDK_FILE=$(ls /tmp/*aarch64*.tar.gz 2>/dev/null | head -1); \
    else \
        echo "Unsupported architecture: $ARCH" && exit 1; \
    fi && \
    if [ -z "$JDK_FILE" ]; then \
        echo "JDK file not found" && exit 1; \
    fi && \
    echo "Extracting JDK: $JDK_FILE" && \
    tar -zxf "$JDK_FILE" -C /usr/local/jdk --strip-components=1 && \
    # Extract Tomcat
    TOMCAT_FILE=$(ls /tmp/saisi-apache-tomcat-*.tar.gz 2>/dev/null | head -1) && \
    tar -zxf "$TOMCAT_FILE" -C /tmp/nms --strip-components=1 && \
    rm -rf /usr/local/jdk/src.zip /tmp/*.tar.gz

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
