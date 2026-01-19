#!/bin/bash

## Disable IPV6 ##
cat <<EOF > /etc/sysctl.d/99-disable-ipv6.conf
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
EOF

cat <<EOF > /etc/sysctl.d/99-disable-ipv6-ra.conf
net.ipv6.conf.default.accept_ra = 0
net.ipv6.conf.all.accept_ra = 0
EOF

sysctl --system

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

echo "Packet redirects and ip forwarding disabled (IPv4 and IPv6)"

## Disable unnecessary services ##
echo "Disabling unnecessary services..."

systemctl disable --now bluetooth.service
echo "Disabled bluetooth.service"

systemctl disable --now qemu-guest-agent.service
echo "Disabled qemu-guest-agent.service"

systemctl disable --now cups.service
echo "Disabled cups.service"

## You can add more services as per your preference ##
echo "Finished disabling services."
sysctl --system

## Enable auditing
sudo apt install auditd audispd-plugins -y
systemctl enable auditd --now
systemctl restart auditd

## Enable reverse path filteringm, it is known as source address validation ##

cat <<EOF | sudo tee -a /etc/sysctl.conf >/dev/null

# Enable reverse path filtering (strict mode)
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1
EOF

# Apply immediately without reboot
sudo sysctl -p


# Enable TCP SYN cookies persistently

echo 'net.ipv4.tcp_syncookies = 1' > /etc/sysctl.d/99-syn-cookies.conf
sysctl --system

## Password Quality ## 
apt install libpam-pwquality -y

cat <<STOP > /etc/security/pwquality.conf
minlen = 12
dcredit = -1
ucredit = -1
ocredit = -1
lcredit = -1
STOP

sed -i '/^PASS_MAX_DAYS/ d' /etc/login.defs
sed -i '/^PASS_MIN_DAYS/ d' /etc/login.defs
sed -i '/^PASS_WARN_AGE/ d' /etc/login.defs

echo "PASS_MAX_DAYS   90" >> /etc/login.defs
echo "PASS_MIN_DAYS   7" >> /etc/login.defs
echo "PASS_WARN_AGE   14" >> /etc/login.defs

cp /etc/pam.d/common-password /etc/pam.d/common-password.bak

sed -i '/^password.*pam_unix.so/ s/$/ remember=3/' /etc/pam.d/common-password

chmod 600 /etc/security/opasswd



### FOR PASSWORD LOCKOUT POLICY MAKE MANUAL CONFIGURATION LIKE THIS :
### sudo vi /etc/pam.d/common-auth	:  #### Edit this file

### Paste the below in the file:

### auth    required        pam_faillock.so preauth silent  audit   deny=3  unlock_time=600
### auth    [success=1 default=bad] pam_unix.so
### auth    [default=die]   pam_faillock.so authfail        audit
### account required        pam_faillock.so

### sudo vi /etc/pam.d/common-account  :

### account	required	pam_faillock.so

## Secure /dev/shm file system ##

cp /etc/fstab /etc/fstab.bak
sed -i '/\/dev\/shm/d' /etc/fstab
echo 'tmpfs /dev/shm tmpfs defaults,noexec,nosuid,nodev 0 0' >> /etc/fstab
mount -o remount /dev/shm

## Secure system files ##
chown root:root /etc/passwd && chmod 644 /etc/passwd
chown root:root /etc/shadow && chmod 640 /etc/shadow
chown root:root /etc/group && chmod 644 /etc/group
chown root:root /etc/gshadow && chmod 640 /etc/gshadow
chown root:root /etc/shells && chmod 644 /etc/shells
