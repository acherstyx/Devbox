function proxy_on() {
  if [[ -z $1 ]]; then
    echo "Error: No proxy address provided."
    echo "Usage: proxy_on <proxy_address> [no_proxy_list]"
    return
  fi

  export HTTP_PROXY="$1"
  export HTTPS_PROXY=$HTTP_PROXY
  export FTP_PROXY=$HTTP_PROXY
  export SOCKS_PROXY=$HTTP_PROXY

  export NO_PROXY="${2:-localhost,127.0.0.1}"

  env | grep -e _PROXY | sort
  echo -e "\nProxy-related environment variables set."
}

function proxy_off() {
  variables=(
    "HTTP_PROXY" "HTTPS_PROXY" "FTP_PROXY" "SOCKS_PROXY" "NO_PROXY"
  )

  for i in "${variables[@]}"; do
    unset $i
  done

  env | grep -e _PROXY | sort
  echo -e "\nProxy-related environment variables removed."
}
