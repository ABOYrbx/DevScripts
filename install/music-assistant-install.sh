#!/usr/bin/env bash

# Copyright (c) 2021-2026 community-scripts ORG
# Author: ABOYrbx
# License: MIT | https://github.com/community-scripts/DevScripts/raw/main/LICENSE
# Source: https://music-assistant.io/ | Github: https://github.com/music-assistant/server

source /dev/stdin <<<"$FUNCTIONS_FILE_PATH"
color
verb_ip6
catch_errors
setting_up_container
network_check
update_os

setup_docker

msg_info "Installing Music Assistant"
mkdir -p /opt/music-assistant/data /opt/music-assistant/music
cat <<EOF >/opt/music-assistant/compose.yaml
services:
  music-assistant:
    image: ghcr.io/music-assistant/server:latest
    container_name: music-assistant
    restart: unless-stopped
    network_mode: host
    environment:
      LOG_LEVEL: info
    volumes:
      - /opt/music-assistant/data:/data
      - /opt/music-assistant/music:/media:ro
EOF
cd /opt/music-assistant
$STD docker compose up -d
msg_ok "Installed Music Assistant"

motd_ssh
customize
cleanup_lxc
