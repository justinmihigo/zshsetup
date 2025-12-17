#!/usr/bin/env bash

set -e

echo "=== Installing Zsh ==="
if command -v apt >/dev/null 2>&1; then
    sudo apt update
    sudo apt install -y zsh git curl
elif command -v pacman >/dev/null 2>&1; then
    sudo pacman -Sy --noconfirm zsh git curl
elif command -v yum >/dev/null 2>&1; then
    sudo yum install -y zsh git curl
elif command -v brew >/dev/null 2>&1; then
    brew install zsh git curl
elif command -v pkg >/dev/null 2>&1; then   # Termux
    pkg update -y
    pkg install -y zsh git curl
else
    echo "Unsupported package manager. Install zsh manually."
fi


echo "=== Installing Oh-My-Zsh ==="
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    # Install without switching shell automatically
    CHSH=no RUNZSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi


echo "=== Installing Powerlevel10k theme ==="
if [ ! -d "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
        $HOME/.oh-my-zsh/custom/themes/powerlevel10k
fi


echo "=== Installing zsh-autosuggestions ==="
if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions \
        $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions
fi


echo "=== Installing zsh-syntax-highlighting ==="
if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
        $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
fi


echo "=== Updating ~/.zshrc ==="

# Replace ZSH_THEME
sed -i 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' "$HOME/.zshrc"

# Enable plugins
sed -i 's/^plugins=.*/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' "$HOME/.zshrc"

# Add syntax-highlighting at end if needed
if ! grep -q "zsh-syntax-highlighting" "$HOME/.zshrc"; then
    echo 'source $ZSH/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh' >> "$HOME/.zshrc"
fi

echo "=== Setting Zsh as default shell ==="
if command -v chsh >/dev/null 2>&1; then
    chsh -s "$(command -v zsh)"
fi

echo "=== Zsh setup complete! ==="
echo "Restart your terminal or run: exec zsh"
