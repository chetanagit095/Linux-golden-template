Linux Golden Template:
- Overview
   A reusable Linux golden template to standardize server provisioning with a secure and consistent baseline.
   Built on Ubuntu Server 22.04 LTS and designed with practical enterprise constraints in mind.
- What This Template Does
   Validates LVM-based filesystem layout
   Installs base system packages
   Applies basic system hardening
   Creates administrative users
   Configures NTP (chrony)
   Disables root access after setup
   Cleans system before image creation
   Configures a login security banner
- Directory Structure
  scripts/   - Automation scripts {and information of some steps}
  config/    - Configuration files
  docs/      - Process documentation
  notes/     - Manual deployment steps
- Supported Platforms
  Private Cloud: Nutanix, VMware
  Public Cloud: AWS (AMI-based)
- Contributors
  Chetana Sonawane
  Rushikesh Thorat
