# Manual Deployment Steps
This document explains the steps that are performed manually during deployment.
These steps depend on the environment and are not fully automated to avoid configuration issues.
## Network Interface Handling
- The LAN interface is disconnected before converting the system into a golden template.
- This helps prevent network conflicts when the template is cloned.
## IP Address Assignment
Private Cloud (Nutanix / VMware)
- Static IP or DHCP configuration is done manually after deployment.
- The configuration is handled through the hypervisor or system console, based on the environment’s network setup.
Public Cloud (AWS)
- When the image is uploaded to AWS, it is converted into an AMI.
- IP management is handled by AWS:
 - Elastic IPs or AWS-managed private IPs are assigned at the VPC level.
- No static IP configuration is included inside the image.
## Hostname Configuration
- Hostnames are set manually after deployment.
- Each server is given a unique hostname to avoid conflicts.
## NTP Configuration
- NTP client configuration is done manually in the template.
- Time synchronization is verified manually after deployment to ensure it is working correctly.
## System Package Updates
- apt update and apt upgrade are run automatically during template creation.
- After deployment or handover, administrators should:
  - Manually update packages when required.
  - Follow the organization’s patching and maintenance process.
 ## Notes
- These steps can vary depending on the infrastructure and environment.
- Automation should be added only after proper testing and validation.
