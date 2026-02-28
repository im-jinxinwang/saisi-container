#!/bin/bash
# 清空 webapps 并生成自定义 ROOT 页面（403、404、500、通用 index.html）

WEBAPPS_DIR="webapps"
ROOT_DIR="$WEBAPPS_DIR/ROOT"

# 删除 webapps 下的不带nms 的所有内容
for f in "$WEBAPPS_DIR"/*; do
    if [[ "$(basename "$f")" == nms* ]]; then
        continue
    fi
    rm -rf "$f"
done

mkdir -p "$ROOT_DIR"

# 生成 403.html
cat > "$ROOT_DIR/403.html" <<'EOF'
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>403 Forbidden</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            background-color: #f4f4f9;
        }
        .container {
            text-align: center;
        }
        h1 {
            color: #333;
        }
        p {
            color: #666;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>403 Forbidden</h1>
        <p>抱歉，您无权访问此页面。</p>
        <p>如果您认为这是一个错误，请联系网站管理员。</p>
    </div>
</body>
</html>
EOF

# 生成 404.html
cat > "$ROOT_DIR/404.html" <<'EOF'
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>404 Not Found</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            background-color: #f4f4f9;
        }
        .container {
            text-align: center;
        }
        h1 {
            color: #333;
        }
        p {
            color: #777;
        }
        a {
            color: #007BFF;
            text-decoration: none;
        }
        a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>404 - 页面未找到</h1>
        <p>抱歉，您访问的页面不存在。</p>
    </div>
</body>
</html>
EOF

# 生成 500.html
cat > "$ROOT_DIR/500.html" <<'EOF'
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>500 Internal Server Error</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            background-color: #f4f4f9;
        }
        .container {
            text-align: center;
        }
        h1 {
            color: #333;
        }
        p {
            color: #666;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>500 Internal Server Error</h1>
        <p>抱歉，服务器内部错误，无法完成您的请求。</p>
        <p>请稍后再试，或者联系网站管理员。</p>
    </div>
</body>
</html>
EOF

# 生成通用 index.html
cat > "$ROOT_DIR/index.html" <<'EOF'
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="refresh" content="1;url=/nms/#/login">
    <title>正在跳转...</title>
    <link rel="icon" href="/favicon.ico" type="image/x-icon">
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f7fc;
            color: #333;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            text-align: center;
        }
        .container {
            background-color: #fff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            max-width: 400px;
            width: 100%;
        }
        h1 {
            color: #007bff;
            font-size: 2rem;
            margin-bottom: 20px;
        }
        p {
            font-size: 1rem;
            color: #555;
        }
        .important {
            color: #e74c3c;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>页面跳转中</h1>
        <p>正在跳转到登录页面，请稍候...</p>
        <p class="important">如果没有自动跳转，请刷新页面或手动访问登录页面。</p>
    </div>
</body>
</html>
EOF

echo "403.html、404.html、500.html、index.html 已全部生成"

# 单独修改 conf/web.xml，追加自定义错误页面配置
WEB_XML="conf/web.xml"

if [ ! -f "$WEB_XML" ]; then
    echo "警告: $WEB_XML 文件不存在，无法添加错误页面配置"
    exit 1
fi
sed -i '$d' "$WEB_XML"
cat >> "$WEB_XML" <<'EOF'
    <!-- 自定义错误页面配置 -->
    <error-page>
        <error-code>404</error-code>
        <location>/404.html</location>
    </error-page>
    <error-page>
        <error-code>403</error-code>
        <location>/403.html</location>
    </error-page>
    <error-page>
        <error-code>500</error-code>
        <location>/500.html</location>
    </error-page>
</web-app>
EOF

echo "conf/web.xml 已成功添加自定义错误页面配置"

