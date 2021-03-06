set -e

export WORKDIR=$HOME/.fe
export CUR_PATH=$(pwd)

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

if ! test -e $WORKDIR;then
  mkdir -p $WORKDIR
fi

cd $WORKDIR
curl -O https://raw.githubusercontent.com/raozhanping/scripts/master/ubuntu.sh
curl -O https://raw.githubusercontent.com/raozhanping/scripts/master/zshrc.conf

# export ZSH
sudo -E bash ./ubuntu.sh
cd $CUR_PATH

printf %s "$GREEN"
cat <<'EOF'
#-------------------------------------------#
#                                           #
#    FE develop enviorment init finished    #
#                                           #
#-------------------------------------------#
EOF
printf %s "$RESET"