
# brew
/bin/zsh -c "$(curl -fsSL https://gitee.com/cunkai/HomebrewCN/raw/master/Homebrew.sh)"
echo 'export PATH="/opt/homebrew/bin:$PATH"' >> \~/.bash_profile
source \~/.bash_profile

# ohmyzsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
brew install autojump


# fnm Fast Node Manager
brew install fnm


# bun
curl -fsSL https://bun.net.cn/install | bash # for macOS, Linux, and WSL

# claude
bun add -g @anthropic-ai/claude-code
