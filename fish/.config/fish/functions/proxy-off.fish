# 定义关闭 HTTP/HTTPS 代理的函数
function proxy-off
    set -e http_proxy
    set -e https_proxy
    set -e all_proxy

    git config --global --unset http.proxy
    git config --global --unset https.proxy

    echo "HTTP/HTTPS 代理已关闭"
end
