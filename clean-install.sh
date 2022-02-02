#!/bin/sh

# This is a subset of the steps described in the ArchWiki.
#
# It's not meant to be run as a script, but can be followed to set up
# an aarch64 base installation in a Parallels virtual machine
# https://wiki.archlinux.org/title/Archboot

# Parallels VM
## Create an "Other Linux" VM.
## Start with a scaled display.
## Disable all sharing of any kind, except the Network
## Disable all keyboard shortcuts - use the Generic preset.

# Connectivity

# Ensure that the network interface is up.
ip link
# Double-check internet connectivity through the shared network.
ping google.com

# Clock

# Sync the system clock to network time.
timedatectl set-ntp true

# Disk Partitioning

# Look at block devices to find the virtual hard disk e.g. /dev/sda
lsblk
# Partition the virtual hard disk
fdisk /dev/sda
# Start a GUID Partition Table (GPT)
# /dev/sda1 EFI Partition 128M (for /boot)
# /dev/sda2 Linux Swap Partition 1G or more, depending on RAM (optional)
# /dev/sda3 Linux File System (for /)

# Disk Formatting

# EFI Partition
mkfs.vfat /dev/sda1
# Swap Partition
mkswap /dev/sda2
# Root Partition
mkfs.ext4 /dev/sda3

# Disk Mounting

# Root Partition
mount /dev/sda3 /mnt
# Boot Partition
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot
# Swap
swapon /dev/sda2

# Installation

# Install the base OS on the mounted partition(s)
pacstrap /mnt \
  base \
  base-devel \
  linux \
  linux-headers \
  linux-firmware \
  grub \
  efibootmgr \
  dosfstools \
  bash-completion \
  man-db \
  htop
## Create a file system table for the base installation
genfstab -U /mnt >> /mnt/etc/fstab

# Base Configuration

# Chroot to the new system
arch-chroot /mnt
# Set Time zone (I'm US Pacific)
ln -sf /usr/share/zoneinfo/US/Pacific /etc/localtime
# Use local time
hwclock --systohc
# Localization
echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen
echo 'LANG=en_US.UTF-8' > /etc/locale.conf

# Network
echo 'arch' > /etc/hostname
# Get ethernet link
cat << EOF > /etc/systemd/network/20-wired.network
[Match]
Name=eth* en*

[Network]
DHCP=yes
EOF
# Enable Systemd networking
systemctl enable systemd-networkd systemd-resolved

# Install GRUB bootloader
grub-install --efi-directory=/boot --bootloader-id=GRUB
## disable grub menu timeout
sed -i 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=0/' /etc/default/grub


## FIX FIX FIX ##
## This is needed to fix a misnamed linux kernek image file in /boot
## grub only looks for vmlinu(x|z)-* kernels
mv /boot/Image.gz /boot/vmlinuz-linux
## otherwise, the kernel image isn't used by grub and the system won't boot

# Setup GRUB
grub-mkconfig -o /boot/grub/grub.cfg

# Set root password
passwd

# Done
# Exit chroot
exit
# Reboot
reboot
