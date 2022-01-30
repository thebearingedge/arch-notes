#!/bin/sh

# This is a subset of the steps described in the ArchWiki.
#
# It's not meant to be run as a script, but can be followed to set up
# an aarch64 base installation in a Parallels virtual machine
# using an ISO from https://github.com/JackMyers001/archiso-aarch64/releases

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
# /dev/sda1 EFI Partition 256M (for /boot)
# /dev/sda2 Linux Swap Partition 1G or more, depending on RAM available
# /dev/sda3 Linux File System (for /)

# Disk Formatting

# FAT 32 EFI Partition
mkfs.fat -F32 /dev/sda1
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
pacstrap /mnt base linux linux-firmware man-db
# Create a file system table for the base installation
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
echo 'arch-aarch64' > /etc/hostname
# Get ethernet link
LINK="$(networkctl list -l | grep ether | awk '{$1=$1};{print$2}')"
# Enable DHCP
cat << EOF > /etc/systemd/network/20-wired.network
[Match]
Name=$LINK

[Network]
DHCP=yes
EOF
# Enable Systemd networking
systemctl enable systemd-networkd systemd-resolved

# Install GRUB bootloader
pacman -S grub efibootmgr
grub-install --efi-directory=/boot --bootloader-id=GRUB
sed -i 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=0/' /etc/default/grub

## FIX FIX FIX ##
## This is needed to fix a misnamed linux image file in /boot
## I have not idea why the name needs to be changed or how to tell grub otherwise
mv /boot/Image.gz /boot/vmlinuz-linux
## otherwise, the kernel image isn't used by grub

# Setup GRUB
grub-mkconfig -o /boot/grub/grub.cfg

# Set root password
passwd

# Done
# Exit chroot
exit
# Reboot
reboot
