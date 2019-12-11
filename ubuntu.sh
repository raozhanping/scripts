#!/usr/bin/env bash
#
# Auto init FE develop enviorment in ubuntu
#
set -e

NODE_VERSION='v10.16.0'

setup_color() {
	# Only use colors if connected to a terminal
	if [ -t 1 ]; then
		RED=$(printf '\033[31m')
		GREEN=$(printf '\033[32m')
		YELLOW=$(printf '\033[33m')
		BLUE=$(printf '\033[34m')
		BOLD=$(printf '\033[1m')
		RESET=$(printf '\033[m')
	else
		RED=""
		GREEN=""
		YELLOW=""
		BLUE=""
		BOLD=""
		RESET=""
	fi
}

error() {
  echo ${RED}"Error:"${RESET} >&2
}

print_info() {
  echo "${BLUE}[Tools]: $@ ${RESET}"
  echo
}

wsl_automount() {
  print_info "wsl auto mount."

  echo '[automount]
enabled = true
root = /mnt
options = "metadata,umask=22,fmask=11"
mountFsTab = false' > /etc/wsl.conf
}

update_apt_list() {
  print_info "update apt list."

  cp /etc/apt/sources.list /etc/apt/sources.list.bak
  echo 'deb http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse' > /etc/apt/sources.list
}

install_nvm() {
  print_info "install nvm."

  sudo apt-get install build-essential libssl-dev
  wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.31.4/install.sh | bash
  # curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.4/install.sh | bash

  source $HOME/.nvm/nvm.sh
}
install_node() {
  print_info "install node ${NODE_VERSION}."

  NVM_NODEJS_ORG_MIRROR=https://npm.taobao.org/mirrors/node
  nvm install $NODE_VERSION
  nvm use $NODE_VERSION
}
install_yarn() {
  print_info "install yarn."

  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
  sudo apt-get update && sudo apt-get install yarn
}

install_oh_my_zsh() {
  print_info "install oh-my-zsh."

  echo -e "${yellow} install oh-my-zsh"
  sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
}

main()
{
  setup_color
  
  wsl_automount
  update_apt_list

  sudo apt update
  sudo apt upgrade

  sudo apt install zsh

  install_nvm
  install_node
  install_yarn
  install_oh_my_zsh

  print_info "--------------------------------
    FE develop enviorment init finished
--------------------------------------------"
}

main "$@"
