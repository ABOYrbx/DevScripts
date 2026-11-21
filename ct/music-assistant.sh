#!/usr/bin/env bash
_CS_DEFAULT_URL="https://raw.githubusercontent.com/community-scripts/DevScripts/main"
_cs_boot="${COMMUNITY_SCRIPTS_CORE_DIR:-$(dirname "${BASH_SOURCE[0]}")/../../core}/core/build.func"
source "$_cs_boot" 2>/dev/null || source <(curl -fsSL "${COMMUNITY_SCRIPTS_CORE_URL:-https://raw.githubusercontent.com/community-scripts/core/main}/core/build.func")

# Copyright (c) 2021-2026 community-scripts ORG
# Author: ABOYrbx
# License: MIT | https://github.com/community-scripts/DevScripts/raw/main/LICENSE
# Source: https://music-assistant.io/ | Github: https://github.com/music-assistant/server

APP="Music Assistant"
var_tags="${var_tags:-music;smarthome;docker}"
var_cpu="${var_cpu:-2}"
var_ram="${var_ram:-2048}"
var_disk="${var_disk:-16}"
var_os="${var_os:-debian}"
var_version="${var_version:-13}"
#var_arm64="${var_arm64:-no}" # unset = ask the user; set yes/no only when verified
var_unprivileged="${var_unprivileged:-1}"

header_info "$APP"
variables
color
catch_errors

function update_script() {
  header_info
  check_container_storage
  check_container_resources

  if [[ ! -f /opt/music-assistant/compose.yaml ]]; then
    msg_error "No ${APP} Installation Found!"
    exit
  fi

  UPD=$(msg_menu "Music Assistant Update Options" \
    "1" "Update Music Assistant" \
    "2" "Remove Unused Images")

  if [[ "$UPD" == "1" ]]; then
    msg_info "Updating Music Assistant"
    cd /opt/music-assistant || exit
    $STD docker compose pull
    $STD docker compose up -d
    msg_ok "Updated Music Assistant"
    exit
  fi
  if [[ "$UPD" == "2" ]]; then
    msg_info "Removing Unused Images"
    $STD docker image prune -af
    msg_ok "Removed Unused Images"
    exit
  fi
  exit
}

start
build_container
description

msg_ok "Completed Successfully!\n"
echo -e "${CREATING}${GN}${APP} setup has been successfully initialized!${CL}"
echo -e "${INFO}${YW}Access it using the following URL:${CL}"
echo -e "${GATEWAY}${BGN}http://${IP}:8095${CL}"
