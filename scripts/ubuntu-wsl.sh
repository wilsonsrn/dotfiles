#!/usr/bin/env bash

set -e

dir_installation=$(pwd)

echo "### PACOTES PÓS-INSTALAÇÃO DO UBUNTU WSL ### \n\n"
echo "---> Atualizando pacotes do Ubuntu. \n"
# Atualização de pacotes do Ubuntu.
sudo apt update
sudo apt upgrade -y

echo "---> Instalando pacotes. \n"

# Pacotes importantes.
sudo apt install git curl unzip wget fuse libfuse2 zsh -y

# Torna o ZSH o Shell principal.
chsh -s $(which zsh)

# Cria pasta de configuração
mkdir -p ~/.config

# Instala o Oh-My-ZSH.
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Instala plugins para ZSH.
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Adiciona plugins em ".zshrc".
sed -i 's/^plugins=\(.*\)/plugins=(\n  git\n  zsh-syntax-highlighting\n  zsh-autosuggestions\n  )/g' ~/.zshrc

# Adiciona alguns aliases em ".zshrc".
echo '# MY ALIASES' >> ~/.zshrc
echo 'alias ls="exa --icons --tree --level=2"' >> ~/.zshrc
echo 'alias vim="lvim"'

# Instala Starship
curl -sS https://starship.rs/install.sh | sh

# Cria arquivo de configuração do Starship
touch ~/.config/starship.toml
cp config/starship.toml ~/.config/

# Pacotes de dependencias Python para desenvolvimento.
sudo apt install -y aria2 blt-dev build-essential /
checkinstall gettext libbz2-dev libc6-dev libffi-dev /
libgdbm-dev liblzma-dev liblzma-doc libncurses5-dev /
libncursesw5-dev libnss3-dev libnss3-tools libpq-dev /
libreadline-dev libsqlite3-dev libssl-dev llvm lzma /
python-dev python-openssl python3-dev python3-pip /
python3-venv tcl-dev tk-dev xz-utils zlib1g-dev -y
# Atualiza PIP
pip install --upgrade pip
# Instala PIPX
sudo apt install pipx -y

# Instala Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Configuração do Git
git config --get --global user.email "wilsonsrochaneto@gmail.com"
git config --get --global user.name "Wilson Rocha Neto"
git config --global core.editor nvim
git config --global credential.helper 'cache --timeout=7200'

# Instala Git Credential Manager
curl -L https://aka.ms/gcm/linux-install-source.sh | sh
git-credential-manager configure

# Instala pacote GitHub
sudo apt install gh -y
gh auth login -w

# Instala Neovim
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage
sudo mv nvim.appimage /usr/local/bin/nvim

# Instala a versão mais recente do nvm
NVM_VERSION=$(curl -s "https://api.github.com/repos/nvm-sh/nvm/releases/latest" | grep -Po '"tag_name": "\K[^"]*')
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh | bash

# Atualiza os dois shells
source ~/.bashrc
source ~/.zshrc

# Instala o Node mais recente
nvm install node

# Pacote adicionais em Rust
cargo install ripgrep
cargo install exa

# Instala LazyGit
mkdir -p ~/.stuff
cd ~/.stuff
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin
cd $dir_installation

# Instala Pyenv
curl https://pyenv.run | bash
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
echo 'eval "$(pyenv init -)"' >> ~/.zshrc

# Instala Poetry
pipx install poetry

# Pacotes bestas.
sudo apt install neofetch htop -y

# Instala LunarVim
LV_BRANCH='release-1.3/neovim-0.9' bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.3/neovim-0.9/utils/installer/install.sh)

# Instala Tmux e Oh-My-Tmux!
sudo apt install tmux -y
git clone https://github.com/gpakosz/.tmux.git "/path/to/oh-my-tmux"
mkdir -p "~/.config/tmux"
ln -s "/path/to/oh-my-tmux/.tmux.conf" "~/.config/tmux/tmux.conf"
cp "/path/to/oh-my-tmux/.tmux.conf.local" "~/.config/tmux/tmux.conf.local"