# Summary

This solution creates new VM in the Openstack platform and other components including 
* Docker
* Postgres
* Node exporter.

## Prerequisites:
* Terraform
* Ansible
* Have Openstack project along with proper Application Credentials. The project has the following capabilities:
  * Image with Ubuntu LTS image 
  * Flavor covering the requirements (2 vCPUs, 8 GB RAM, 30 GB Disk storage)
  * Router
  * Network  
  * Security group enabling SSH access

## Scope of provisioning
* Infrastructure
  * create subnet, port
  * create compute
  * create storage (3x)

* OS level 
  * Create OS level user `thermo` allowing ssh access via the shared ssh-key pair
  * Disk management and related changes
    * Docker installation goes to separate disk 
    * OS logs goe into separate disk
 * SW installation 
   * Docker
   * Postgres as container
   * Node exporter

## Instructions
1. Edit `tf/tfs.tfvars` and adjust variables according to the Openstack hosting: 
1. Source respective Application credentials
1. run `automation/run.sh`. This script 
   * run terraform and provision required machine/s
   * generates Ansible inventory
   * installs Docker + Postgres +  Node exporter

# Known limitations
* Terraform is not able to guarantee order of volumes being attached. Despite mechanism introduces in `tf/instance_node.tf` there is a chance that volumes mismatch the intended order expected by the Ansible configuration (see `data_volume` and `logs_volume` in `ansible/group_vars/nodes.yml`) as I encountered during testing. In the case that `play_after_provisioning` fails, the quick workaround is to comment in `data_volume` and `logs_volume` variables ~ such action leads to giving up on employment of additional disks for logs and data.
