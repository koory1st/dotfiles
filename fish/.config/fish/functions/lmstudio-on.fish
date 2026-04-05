# 定义开启 LM Studio 本地模型的函数
function lmstudio-on
    set -x ANTHROPIC_BASE_URL http://192.168.31.210:1234
    set -x ANTHROPIC_AUTH_TOKEN lmstudio

    echo "LM Studio 已开启："
    echo "ANTHROPIC_BASE_URL: $ANTHROPIC_BASE_URL"
    echo "ANTHROPIC_AUTH_TOKEN: $ANTHROPIC_AUTH_TOKEN"
end
