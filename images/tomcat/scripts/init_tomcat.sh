#!/bin/bash

FILE="conf/server.xml"
PROP_FILE="conf/catalina.properties"
TEMPLATE_FILE="conf/server.xml.template"

if ! grep -q "EnvironmentPropertySource" "$PROP_FILE"; then
    echo 'org.apache.tomcat.util.digester.PROPERTY_SOURCE=org.apache.tomcat.util.digester.EnvironmentPropertySource' >> "$PROP_FILE"
fi

connector_line=$(grep -n 'org.apache.coyote.http11.Http11NioProtocol' "$FILE" | cut -d: -f1)
if [ -z "$connector_line" ]; then
    echo "未找到 Http11NioProtocol 的 Connector"
    exit 1
fi

start_comment_line=$(head -n "$connector_line" "$FILE" | grep -n '<!--' | tail -n1 | cut -d: -f1)
if [ -z "$start_comment_line" ]; then
    echo "未找到 Connector 前的 <!--"
    exit 1
fi
sed -i "${start_comment_line}s/<!--//" "$FILE"

cert_line=$(grep -n 'certificateKeystorePassword' "$FILE" | cut -d: -f1)
if [ -z "$cert_line" ]; then
    echo "未找到 certificateKeystorePassword"
    exit 1
fi

target_line=$((cert_line + 3))
sed -i "${target_line}s/-->//" "$FILE"

sed -i "/certificateKeystorePassword/s/changeit/saisinms/" "$FILE"
sed -i 's/port="8443"/port="${HTTPS_PORT:-9443}"/g' "$FILE"
sed -i 's#<SSLHostConfig>#<SSLHostConfig protocols="TLSv1.2+TLSv1.3">#g' "$FILE"
sed -i 's/port="8005"/port="-1"/' "$FILE"

LINE_NUM=$(grep -n '<Connector port="8080"' "$FILE" | cut -d: -f1)

if [ ! -z "$LINE_NUM" ]; then
    sed -i "${LINE_NUM},/\/>/d" "$FILE"
    sed -i "${LINE_NUM}i \\
    <Connector port=\"\${HTTP_PORT:-9080}\" protocol=\"HTTP/1.1\"\\
               connectionTimeout=\"\${CONN_TIMEOUT:-5000}\"\\
               server=\"\${SERVER_NAME:-Web Server}\"\\
               maxHttpHeaderSize=\"\${HEADER_SIZE:-8192}\"\\
               disableUploadTimeout=\"\${DISABLE_UPLOAD_TIMEOUT:-false}\"\\
               connectionUploadTimeout=\"\${UPLOAD_TIMEOUT:-10000}\"\\
               redirectPort=\"\${HTTPS_PORT:-9443}\"\\
               maxParameterCount=\"1000\" />" "$FILE"
fi

echo "Connector 注释块已打开，端口和密码已修改完成"

if [ -z "$JAVA_HOME" ]; then
    echo "JAVA_HOME 未设置，请先设置 JAVA_HOME"
    exit 1
fi

KEYSTORE_FILE="conf/localhost-rsa.jks"

$JAVA_HOME/bin/keytool -genkeypair \
  -alias tomcat \
  -keyalg RSA \
  -keysize 2048 \
  -keystore "$KEYSTORE_FILE" \
  -storetype PKCS12 \
  -validity 3650 \
  -storepass saisinms \
  -keypass saisinms \
  -dname "CN=localhost, OU=Saisi, O=Saisi, L=Jiaxing, ST=Zhejiang, C=CN" \
  -ext "SAN=DNS:localhost,IP:127.0.0.1"

echo "证书已生成：$KEYSTORE_FILE"

cp "$FILE" "$TEMPLATE_FILE"

sed -i 's/9080/nms_http_port/g' "$TEMPLATE_FILE"
sed -i 's/9443/nms_https_port/g' "$TEMPLATE_FILE"

echo "模板已生成：$TEMPLATE_FILE"
