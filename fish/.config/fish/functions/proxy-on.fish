# 定义开启 HTTP/HTTPS 代理的函数
function proxy-on
    # 设置代理地址和端口（请替换为你的实际代理地址，比如 127.0.0.1:7890）
    set -x http_proxy http://127.0.0.1:7897
    set -x https_proxy http://127.0.0.1:7897
    set -x all_proxy socks5://127.0.0.1:7897 # 可选：添加 socks5 代理

    git config --global http.proxy http://127.0.0.1:7897
    git config --global https.proxy http://127.0.0.1:7897

    # 可选：对 curl/wget 等工具生效（部分工具优先读取小写变量）
    set -x HTTP_PROXY $http_proxy
    set -x HTTPS_PROXY $https_proxy
    set -x ALL_PROXY $all_proxy

    # 提示代理已开启
    echo "HTTP/HTTPS 代理已开启："
    echo "http_proxy: $http_proxy"
    echo "https_proxy: $https_proxy"
end
