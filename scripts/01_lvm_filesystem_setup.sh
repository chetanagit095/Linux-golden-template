lsblk
sudo vgs
sudo lvs
df -h

sudo fdisk /dev/sdb     ### here you can add according to disk name for example: /dev/sda   /dev/sdb   /dev/sdc like this
## Create /dev/sdb1 as type 8e – Linux LVM
sudo pvcreate /dev/sdb1
sudo vgextend vgubuntu /dev/sdb1    ### Here ( vgubuntu ) is the volume group name (default is vg0) and to extend it to the PV /dev/sb1
sudo vgs  ## To verify

### To increase SWAP ###

sudo swapoff /dev/vgubuntu/lvswap      ## Here   (lvswap)    is the lvm name for swap 
sudo lvresize -L 6G /dev/vgubuntu/lvswap  ### This will resize swap to 6GB Total
sudo mkswap /dev/vgubuntu/lvswap 
sudo swapon /dev/vgubuntu/lvswap
sudo swapon --show

### To increase lvm size ### 

sudo lvextend -L +10G /dev/vgubuntu/lvdata     ### +10G means this will add plus 10GB in the (lvdata) lvm with volume group  (vgubuntu)
sudo resize2fs /dev/vgubuntu/lvdata     ### This resize2fs  is for ext4  file system format

sudo xfs_growfs dev/vgubuntu/lvvar      ### this xfs   is for xfs file system format


### To create logical volume ###

sudo lvcreate -L 400G -n lv-data vg0    ## Here we created lvm named lv-data in volume group  vg0
sudo mkfs.ext4 /dev/vg0/lv-data
sudo mkdir -p /data     ### here /data is our mount point
sudo mount /dev/vg0/lv-data /data 
echo "/dev/vg0/lv-data /data ext4 defaults 0 2" | sudo tee -a /etc/fstab   ###   this is done to mount it persistently across reboot
sudo mount -a
