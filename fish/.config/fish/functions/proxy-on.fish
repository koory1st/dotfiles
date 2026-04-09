# 定义开启 HTTP/HTTPS 代理的函数
function proxy-on
    export http_proxy http://127.0.0.1:7897
    export https_proxy http://127.0.0.1:7897
    export all_proxy socks5://127.0.0.1:7897

    git config --global http.proxy http://127.0.0.1:7897
    git config --global https.proxy http://127.0.0.1:7897

    echo "HTTP/HTTPS 代理已开启："
    echo "http_proxy: $http_proxy"
    echo "https_proxy: $https_proxy"
end
