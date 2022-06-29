#!/usr/bin/env sh
set -o errexit

# create boot
mkfs.vfat -F32 /dev/nvme1n1p1

# create rootfs
zpool create -f zroot /dev/nvme{1n1p2,1n1p3}
zpool set autotrim=on zroot
zfs set compression=lz4 zroot
zfs set mountpoint=none zroot

zfs create -o mountpoint=none zroot/data
zfs create -o mountpoint=none zroot/ROOT
zfs create -o mountpoint=/ zroot/ROOT/default
zfs create -o mountpoint=/home zroot/data/home
zfs create -o mountpoint=/etc/ssh zroot/data/ssh
zfs create -o mountpoint=/etc/NetworkManager/system-connections zroot/data/connections
zfs create -o mountpoint=/usr/local zroot/data/usr-local

zfs create \
        -o encryption=on \
        -o keyformat=passphrase \
        -o mountpoint=/home/maxhero/projects zroot/data/maxhero-projects

zfs create -o mountpoint=none -o recordsize=1M zroot/games
zfs create -o mountpoint=/home/maxhero/.local/share/Steam/steamapps/common zroot/games/steam
zfs create -o mountpoint=/home/maxhero/Games zroot/games/home

zfs create -o mountpoint=/home/maxhero/.cache/btdownloads -o recordsize=16K zroot/data/btdownloads

# finish rootfs
zpool set bootfs=zroot/ROOT/default zroot
zpool export zroot
zpool import -R /mnt zroot

# swaps
mkswap /dev/nvme0n1p2
swapon /dev/nvme0n1p2

echo "Finished"
