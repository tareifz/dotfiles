pacstrap /mnt base \
         base-devel \
         linux \
         linux-firmware \
         emacs \
         nano \
         lvm2 \
         grub \
         efibootmgr \
         networkmanager \
         network-manager-applet \
         dialog \
         dhcpcd \
         sudo \
         intel-ucode \
         mesa \
         xf86-video-amdgpu \
         vulkan-radeon \
         libva-mesa-driver \
         mesa-vdpau \
         wayland \
         gdm \
         sway \
         swaybg \
         waybar \
         stow \
         git \
         firefox \
         fish \
         rofi

#### intel-ucode or amd-ucode ####

genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt /bin/bash

systemctl enable dhcpcd.service
systemctl enable NetworkManager.service

# Add Google DNS
echo 'nameserver 8.8.8.8' >> /etc/resolv.conf

echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen
locale-gen
echo 'LANG=en_US.UTF-8' >> /etc/locale.conf

ln -sf /usr/share/zoneinfo/Asia/Riyadh /etc/localtime
hwclock --systohc --utc

echo 'tareifz' >> /etc/hostname
echo '127.0.0.1   localhost' >> /etc/hosts
echo '::1         localhost' >> /etc/hosts
echo '127.0.1.1   tareifz.localdomain   tareifz' >> /etc/hosts

# Swapfile
fallocate -l 16G /swapfile
chmod 600 /swapfile
mkswap /swapfile
echo '/swapfile none swap sw 0 0' | tee -a /etc/fstab

echo '##########################################' >> /etc/mkinitcpio.conf
echo '# ADD "lvm2" in HOOKS before filesystems #' >> /etc/mkinitcpio.conf
echo '##########################################' >> /etc/mkinitcpio.conf

nano /etc/mkinitcpio.conf

mkinitcpio -P

passwd

useradd -m -G wheel tareifz
passwd tareifz

echo 'uncomment %wheel All=(ALL) ALL to grant privilige' >> /etc/sudoers
nano /etc/sudoers

grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
