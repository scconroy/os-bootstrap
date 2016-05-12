##### Script to setup LinuxBrew and fish shell on linux ##### 

cd ~

sudo apt-get install build-essential ncurses-dev libncurses5-dev curl gettext bc autoconf ruby -y 
sudo yum groupinstall "Development Tools" -y
sudo yum install ncurses-devel curl -y

echo '### Custom exports for LinuxBrew ###' >> ~/.bashrc
echo 'export PATH="$HOME/.linuxbrew/bin:$PATH"' >> ~/.bashrc
echo 'export MANPATH="$HOME/.linuxbrew/share/man:$MANPATH"' >> ~/.bashrc
echo 'export INFOPATH="$HOME/.linuxbrew/share/info:$INFOPATH"' >> ~/.bashrc
echo 'export HOMEBREW_BUILD_FROM_SOURCE=1' >> ~/.bashrc
source ~/.bashrc

echo | ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/linuxbrew/go/install)"

brew doctor
brew update
brew install fish zsh htop
brew install coreutils binutils
brew cleanup

echo $(which fish) | sudo tee -a /etc/shells
echo $(which zsh) | sudo tee -a /etc/shells

sudo chsh -s $(which fish) $USER

echo '
function dl --description "Parallel and resumable download with aria2c"
    aria2c -c -x 4 $argv[1]
end
' > ~/.config/fish/functions/dl.fish

echo '
function sudo
    if test "$argv" = !!
        eval command sudo $history[1]
    else
        command sudo $argv
    end
end
' > ~/.config/fish/functions/sudo.fish

echo '
Now run these lazy boyyy......

set -U fish_user_paths ~/.linuxbrew/bin/ $fish_user_paths
set -U fish_user_paths ~/.linuxbrew/sbin/ $fish_user_paths
set -U fish_user_paths ~/.linuxbrew/opt/ $fish_user_paths
set -U fish_user_paths ~/.linuxbrew/share/man/ $fish_user_paths
set -U fish_user_paths ~/.linuxbrew/share/info/ $fish_user_paths
set -U HOMEBREW_BUILD_FROM_SOURCE 1

curl -Lo ~/.config/fish/functions/fisher.fish --create-dirs git.io/fisherman
fisher simple z fzf edc/bass omf/tab
fisher omf/plugin-brew
fisher omf/theme-l
'

echo "Now starting fish shell..."
fish
