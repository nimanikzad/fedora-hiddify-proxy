# Fedora Hiddify Proxy — source this file from Bash, then run: proxy
# MIT License. See LICENSE.

proxy() {
    local action="${1:-}" port url

    if [[ -z "$action" ]]; then
        printf '\nHiddify terminal proxy\n1) Enable\n0) Disable\ns) Status\nq) Exit\nChoice: '
        IFS= read -r action || return 1
    fi

    case "$action" in
        1|on)
            port="${2:-${HIDDIFY_PROXY_PORT:-12334}}"
            if [[ ! "$port" =~ ^[0-9]{1,5}$ ]]; then
                printf 'Invalid port: %s (expected 1–65535)\n' "$port" >&2
                return 1
            fi
            if (( 10#$port < 1 || 10#$port > 65535 )); then
                printf 'Invalid port: %s (expected 1–65535)\n' "$port" >&2
                return 1
            fi
            port=$((10#$port))
            url="http://127.0.0.1:$port"
            export http_proxy="$url" https_proxy="$url"
            export HTTP_PROXY="$url" HTTPS_PROXY="$url"
            export all_proxy="$url" ALL_PROXY="$url"
            export no_proxy="localhost,127.0.0.1,::1"
            export NO_PROXY="$no_proxy"
            printf 'Proxy enabled for this terminal: %s\n' "$url"
            ;;
        0|off)
            unset http_proxy https_proxy HTTP_PROXY HTTPS_PROXY
            unset all_proxy ALL_PROXY no_proxy NO_PROXY
            printf 'Proxy disabled for this terminal.\n'
            ;;
        s|status)
            if [[ -n "${http_proxy:-}${https_proxy:-}${all_proxy:-}${HTTP_PROXY:-}${HTTPS_PROXY:-}${ALL_PROXY:-}" ]]; then
                printf 'Proxy environment variables:\n'
                local name
                for name in http_proxy https_proxy all_proxy HTTP_PROXY HTTPS_PROXY ALL_PROXY no_proxy NO_PROXY; do
                    if [[ -v "$name" ]]; then
                        printf '  %s=%s\n' "$name" "${!name}"
                    fi
                done
            else
                printf 'Proxy environment variables are unset (direct unless another proxy or TUN is active).\n'
            fi
            ;;
        q|exit)
            return 0
            ;;
        *)
            printf 'Usage: proxy [on [PORT] | off | status]\n' >&2
            return 1
            ;;
    esac
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    printf 'Load this file in your current Bash terminal:\n  source "%s"\nThen run:\n  proxy\n' "$0"
fi
