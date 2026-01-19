Procedure: 

1. Clone the Golden Template 

In Nutanix/VM console, right-click on the Golden Template. 

Select Clone/Deploy VM option. 

2. Provide a name for the new server. 

3. Assign Resources 

Configure vCPU, RAM, and Disk size as per project needs. 

If extra storage is required, attach a new disk. 

Boot and Verify 

Power on the cloned VM. 

4. Login using the ariadmin account. 

Confirm that root login is disabled and hardening policies are active. 

5. Extend partitions using LVM inside the OS if needed. 

6. Set Networking 

Assign static IP or DHCP depending on environment. 

7. Update /etc/hostname and /etc/hosts with the new server name. 

8. Verify connectivity with ping or ssh. 

9. Update NTP Configuration 

Ensure the server syncs with internal/external NTP server for accurate time. 

10. Install / Configure Applications 

Deploy required apps or services as per use case. 

Keep /opt directory for third-party software. 

11. Security & Monitoring Setup 

Ensure SentinelOne EDR is running (sentinelctl status). 

Final Checks 

12. Verify partitions (lsblk, df -h). 

13. Check users. 

14. Confirm firewall/security settings. 

Hand over server for testing/use. 
