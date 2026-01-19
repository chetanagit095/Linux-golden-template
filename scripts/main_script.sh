#!/bin/bash

apt-get update -y

cat <<EOF > /etc/sysctl.d/99-disable-ipv6.conf
# Disable IPv6
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
EOF

cat <<EOF > /etc/sysctl.d/99-disable-ipv6-ra.conf
net.ipv6.conf.default.accept_ra = 0
net.ipv6.conf.all.accept_ra = 0
EOF

sysctl --system

echo "IPv6 disabled"

cat <<EOF > /etc/sysctl.d/99-hardening-icmp.conf


# Disable ICMP redirect acceptance for IPv4
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0


# Disable secure ICMP redirect acceptance for IPv4
net.ipv4.conf.all.secure_redirects = 0
net.ipv4.conf.default.secure_redirects = 0


# Disable ICMP redirect acceptance for IPv6
net.ipv6.conf.all.accept_redirects = 0
net.ipv6.conf.default.accept_redirects = 0


# Ignore broadcast ICMP requests (IPv4)
net.ipv4.icmp_echo_ignore_broadcasts = 1
EOF

grep -v '^net.ipv4.ip_forward' /etc/sysctl.conf > /tmp/sysctl.temp
echo "net.ipv4.ip_forward = 0" >> /tmp/sysctl.temp
mv /tmp/sysctl.temp /etc/sysctl.conf
sysctl -p

sysctl --system

echo "Packet redirects and ip forwarding disabled (IPv4 and IPv6)"

cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
sed -i '/^#\?PermitRootLogin/d' /etc/ssh/sshd_config
echo "PermitRootLogin no" >> /etc/ssh/sshd_config
systemctl restart ssh
echo "Root login disabled. Password login for users still enabled."

echo "Disabling unnecessary services..."

systemctl disable --now bluetooth.service
echo "Disabled bluetooth.service"

systemctl disable --now qemu-guest-agent.service
echo "Disabled qemu-guest-agent.service"

systemctl disable --now cups.service
echo "Disabled cups.service"

echo "Finished disabling services."

sudo apt install auditd audispd-plugins -y
systemctl enable auditd --now
systemctl restart auditd

# reverse path filtering is known as source address validation

cat <<EOF | tee -a /etc/sysctl.conf >/dev/null

# Enable reverse path filtering (strict mode)
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1
EOF

# 2. Apply immediately without reboot
sudo sysctl -p

# Enable TCP SYN cookies persistently

echo 'net.ipv4.tcp_syncookies = 1' > /etc/sysctl.d/99-syn-cookies.conf
sysctl --system

cp /etc/fstab /etc/fstab.bak
sed -i '/\/dev\/shm/d' /etc/fstab
echo 'tmpfs /dev/shm tmpfs defaults,noexec,nosuid,nodev 0 0' >> /etc/fstab
mount -o remount /dev/shm

chown root:root /etc/passwd && chmod 644 /etc/passwd
chown root:root /etc/shadow && chmod 640 /etc/shadow
chown root:root /etc/group && chmod 644 /etc/group
chown root:root /etc/gshadow && chmod 640 /etc/gshadow
chown root:root /etc/shells && chmod 644 /etc/shells
