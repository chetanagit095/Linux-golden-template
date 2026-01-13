apt install -y chrony   # install chrony on system
cp config/ntp.conf /etc/chrony/chrony.conf  # copy file
# Example /etc/chrony/chrony.conf content:
server time.google.com iburst
server pool.ntp.org iburst
# Enable and Start Chrony
systemctl enable chrony
systemctl restart chrony
# Verify Time Synchronization
chronyc sources -v




