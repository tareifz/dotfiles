cd ~

mkdir Pictures
mkdir Downloads
mkdir Documents
mkdir .config
mkdir .emacs.d
mkdir .local
mkdir ./.local/share
mkdir .config/systemd
mkdir .config/systemd/user

cp ~/dotfiles/arch/config-files/sway-session.desktop /usr/share/wayland-sessions/sway-session.desktop
cp ~/dotfiles/arch/config-files/sway-service.sh /usr/local/bin/sway-service.sh

cd dotfiles/

stow emacs sway waybar fonts rofi wallpapers

systemctl --user enable --now waybar
