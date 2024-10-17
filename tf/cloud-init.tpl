#cloud-config
users:
  - name: ${ssh_user}
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    groups: sudo
    shell: /bin/bash    
    ssh_authorized_keys:
      - ${ssh_authorized_keys}

package_update: true
package_upgrade: true
packages:
  - apt-transport-https
  - ca-certificates
  - curl
  - gnupg
  - lsb-release
  - iputils

#preserve_hostname: false
#hostname: myhostname
