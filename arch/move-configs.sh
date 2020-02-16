cd /home/tareifz

mkdir Pictures
mkdir Downloads
mkdir Documents
mkdir .config
mkdir .emacs.d
mkdir .local
mkdir ./.local/share
mkdir .config/systemd
mkdir .config/systemd/user

# cp ./dotfiles/arch/config-files/sway-session.desktop /usr/share/wayland-sessions/sway-session.desktop
# cp ./dotfiles/arch/config-files/sway-service.sh /usr/local/bin/sway-service.sh

cd dotfiles/

stow emacs sway waybar fonts rofi wallpapers

systemctl --user enable --now waybar

cd ..
mkdir aur
cd aur

git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

yay nerd-fonts-terminus
yay ttf-ubuntu-font-family
yay gohu
yay ttf-arabeyes-fonts
# yay grim
# yay slurp

curl https://sh.rustup.rs -sSf | sh

# echo /usr/local/bin/fish | sudo tee -a /etc/shells
chsh -s /usr/bin/fish
