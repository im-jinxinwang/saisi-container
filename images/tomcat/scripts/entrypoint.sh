#!/bin/bash

CONFIG_FILE="/home/saisinms/nms/webapps/nms/WEB-INF/classes/Config-dev.properties"

if [ -f "$CONFIG_FILE" ]; then
    KEYS=$(grep -v '^[[:space:]]*#' "$CONFIG_FILE" | grep -v '^[[:space:]]*$' | cut -d= -f1)

    for key in $KEYS; do
        env_var=$(echo "$key" | tr '.' '_')        
        val=$(printenv "$env_var")

        if [ -n "$val" ]; then
            grep -v "^$key=" "$CONFIG_FILE" > "${CONFIG_FILE}.tmp" && mv "${CONFIG_FILE}.tmp" "$CONFIG_FILE"
            echo "$key=$val" >> "$CONFIG_FILE"
        fi
    done
fi

exec "$@"
