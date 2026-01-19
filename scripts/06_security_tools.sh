### These security tools are optional if you want to increase the security of your server futher
### 1. Install the SentinelOne Agent 

sudo dpkg -i /path/to/sentinelone-agent.deb 

### Replace /path/to/sentinelone-agent.deb with the actual file path of your SentinelOne Debian package. 

### This installs the SentinelOne agent. 

### 2. Set Management Site Token 

sudo /opt/sentinelone/bin/sentinelctl management token set <site_token> 
 
### Replace <site_token> with your actual SentinelOne site token. 

### This links the agent to your SentinelOne management console. 

### 3. Start the SentinelOne Agent 

sudo /opt/sentinelone/bin/sentinelctl control start 
 
### Starts the agent service. 

### 4. Check Agent Status 

sudo /opt/sentinelone/bin/sentinelctl control status  

### Displays the running status of the agent.  

### 5. Check Agent Version 

sudo /opt/sentinelone/bin/sentinelctl version 
 
### Shows the installed agent version. 

### 6. Set CPU Resource Limit 

sudo /opt/sentinelone/bin/sentinelctl config set '{"resource_cpu-limit": 25}' 
 
### Sets the CPU usage limit to 25% for the agent process. 

### 7. Set Memory Resource Limit 

sudo /opt/sentinelone/bin/sentinelctl config set '{"resource_memory-limit": 2147483648}' 
 
### Sets the memory limit to 2GB (2147483648 bytes) for the agent. 

### 2 INSTALLATION of SIEM  ###

### 1. Update Package Lists 

sudo apt-get update 

### Ensures your system has the latest package metadata. 

### 2. Install rsyslog 

sudo apt-get install rsyslog -y 

### Installs the rsyslog package if not already present. 

### 3. Check rsyslog Service Status 

systemctl status rsyslog 

### Verifies that the rsyslog service is active and running. 

### 4. Edit rsyslog Configuration File 

sudo vim /etc/rsyslog.conf 

### Add the following lines at the end of the file to forward logs to your DC and DR syslog servers: 

# Forward logs to DC syslog server 
*.* @<DC_IP>:514 
 
# Forward logs to DR syslog server 
*.* @<DR_IP>:514 
 

### Replace <DC_IP> and <DR_IP> with the actual IP addresses of your Data Center and Disaster Recovery syslog servers.

### Use @ for UDP (default) or @@ for TCP. 
