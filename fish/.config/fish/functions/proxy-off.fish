# 定义关闭 HTTP/HTTPS 代理的函数
function proxy-off
    # 清除所有代理相关环境变量
    set -e http_proxy
    set -e https_proxy
    set -e all_proxy
    set -e HTTP_PROXY
    set -e HTTPS_PROXY
    set -e ALL_PROXY

    # 提示代理已关闭
    echo "HTTP/HTTPS 代理已关闭"
end
