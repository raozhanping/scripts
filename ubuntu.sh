#!/usr/bin/env bash
#
# Auto init FE develop enviorment in ubuntu
#
set -e

NODE_VERSION='v14.17.0'
UBUNTU_CODENAME=$(lsb_release -cs)

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

error() {
  echo ${RED}"Error:"${RESET} >&2
}
print_info() {
  echo
  echo "${BLUE}[Tools]: $@ ${RESET}"
  echo
}
# 判断命令是否存在
is_cmd_exist() {
  command -v "$@" >/dev/null 2>&1
}
# 安装依赖
install_deps()
{
  echo $@
  for dep in $@
  do
    if ! is_cmd_exist $dep
      # 命令不存在
      echo "命令'$?'不存在"
    then
      sudo apt install $dep
    fi
  done
}

# ================ WSL 配置 ================
# /etc/wsl.conf
print_info "wsl auto mount."

sh -c "echo '[automount]
enabled = true
root = /mnt
options = \"metadata,umask=22,fmask=11\"
mountFsTab = false' > /etc/wsl.conf"

# ================ 切换到阿里镜像源 ================
print_info "update apt list."

cp /etc/apt/sources.list /etc/apt/sources.list.bak
echo "deb http://mirrors.aliyun.com/ubuntu/ $UBUNTU_CODENAME main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ $UBUNTU_CODENAME-security main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ $UBUNTU_CODENAME-updates main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ $UBUNTU_CODENAME-proposed main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ $UBUNTU_CODENAME-backports main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ $UBUNTU_CODENAME main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ $UBUNTU_CODENAME-security main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ $UBUNTU_CODENAME-updates main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ $UBUNTU_CODENAME-proposed main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ $UBUNTU_CODENAME-backports main restricted universe multiverse" > /etc/apt/sources.list

# ================ 安装 nvm ================
print_info "install nvm."

apt-get install build-essential libssl-dev
wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.31.4/install.sh | bash
# curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.4/install.sh | bash

source $HOME/.nvm/nvm.sh

# ================ 安装 node ================
print_info "install node ${NODE_VERSION}."

NVM_NODEJS_ORG_MIRROR=https://npm.taobao.org/mirrors/node
nvm install $NODE_VERSION
nvm use $NODE_VERSION

# ================ 安装 yarn ================
print_info "install yarn."

curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
apt-get update && apt-get install yarn

# ================ 安装 oh-my-zsh ================
print_info "install oh-my-zsh."

if ! [ -e $ZSH ]; then
  sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
fi

# CUR_PATH=$(pwd)
TEMP_FOLDER=$HOME/temp
# ================ autojump ================
if ! [ -e $TEMP_FOLDER ]; then
  mkdir $TEMP_FOLDER
  if ! [ -e ./autojump]; then
    cd $TEMP_FOLDER
    git clone git://github.com/wting/autojump.git
  fi
fi
AUTOJUMP_PATH=$TEMP_FOLDER/autojump
cd $AUTOJUMP_PATH
if is_cmd_exist python; then
  ./install.py
elif is_cmd_exist python3; then
  python3 ./install.py
fi
cd $CUR_PATH

# ================ 更新zsh配置 ================
print_info "更新zsh配置"
if [ -s $HOME/.zshrc ]; then
  mv $HOME/.zshrc $HOME/.zshrc.bak
fi
cat ./zshrc.conf > $HOME/.zshrc
source $HOME/.zshrc