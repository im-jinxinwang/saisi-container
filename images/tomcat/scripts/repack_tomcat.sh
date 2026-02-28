#!/bin/bash

# 使用系统 JAVA_HOME (GitHub Actions 中由 setup-java 设置)
if [ -z "$JAVA_HOME" ]; then
    echo "Error: JAVA_HOME is not set"
    exit 1
fi
export JRE_HOME=$JAVA_HOME/jre
export PATH=$JAVA_HOME/bin:$JRE_HOME/bin:$PATH

INIT_FILES=("init_hide_tomcat_version.sh" "init_tomcat.sh" "init_webapps.sh")

for FILE in apache-tomcat-*.tar.gz; do
    [ -f "$FILE" ] || continue
    [[ "$FILE" == saisi-* ]] && continue

    echo "Processing $FILE..."

    DIR="${FILE%.tar.gz}"

    rm -rf "$DIR"
    mkdir -p "$DIR"
    tar -xzf "$FILE" -C "$DIR" --strip-components=1

    for INIT in "${INIT_FILES[@]}"; do
        if [ -f "$INIT" ]; then
            cp "$INIT" "$DIR/"
            chmod +x "$DIR/$INIT"
            (cd "$DIR" && ./"$INIT")
            rm -f "$DIR/$INIT"
        fi
    done

    NEW_NAME="saisi-$FILE"
    tar -czf "$NEW_NAME" "$DIR"

    if [ $? -eq 0 ]; then
        echo "Done: $NEW_NAME"
        rm -rf "$DIR"
    else
        echo "Failed: $NEW_NAME"
    fi
done

