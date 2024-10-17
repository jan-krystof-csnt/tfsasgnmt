#!/bin/bash

THIS_SCRIPT_DIR="$(dirname "$(realpath "$0")")"

# run TF scripts
cd "$THIS_SCRIPT_DIR/../tf"
terraform init

terraform apply -auto-approve --var-file tfs-meta-cloud-training.tfvars

if [ $? -ne 0 ]; then
  echo "Terraform failed"
  exit 1
fi

# generate inventory
${THIS_SCRIPT_DIR}/generate_inventory.sh

# Navigate to the directory containing Ansible playbooks and run Ansible
cd "$THIS_SCRIPT_DIR/../ansible"
for PLAY in play_after_provisioning.yml play_install_sw.yml; do
  ansible-playbook -i inventory/hosts $PLAY
  
  if [ $? -ne 0 ]; then
    echo "Ansible failed ($PLAY)"
    exit 1
  fi
done
