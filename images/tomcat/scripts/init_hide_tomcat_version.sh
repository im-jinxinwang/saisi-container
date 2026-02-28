#!/bin/bash
JAR_PATH="lib/catalina.jar"
TMP_DIR="catalina_tmp"
FILE_PATH="org/apache/catalina/util/ServerInfo.properties"

rm -rf "$TMP_DIR"
mkdir -p "$TMP_DIR"
cd "$TMP_DIR" || exit 1

jar xf "../$JAR_PATH" "$FILE_PATH"

cat > "$FILE_PATH" <<EOF
server.info=Apache Tomcat
server.number=
server.built=
server.built.iso=
EOF

jar uf "../$JAR_PATH" "$FILE_PATH"

cd ..
rm -rf "$TMP_DIR"

echo "已完成版本号隐藏，catalina.jar 已更新"

