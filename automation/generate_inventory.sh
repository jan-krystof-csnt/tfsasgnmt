#!/bin/bash
set -e
THIS_SCRIPT_DIR="$(dirname "$(realpath "$0")")"

INVENTORY_FILE=$THIS_SCRIPT_DIR/../ansible/inventory/hosts
JSON_FILE=$THIS_SCRIPT_DIR/../tf/node_port_ips.json

# if inventory file exists, cerate a backup
if [ -f "$INVENTORY_FILE" ]; then  
  INVENTORY_FILE_BACKUP=${INVENTORY_FILE}.backup
  echo "Inventory ($INVENTORY_FILE) already exists. Taking backup of this $INVENTORY_FILE_BACKUP"
  cp "$INVENTORY_FILE" "$INVENTORY_FILE_BACKUP"  
fi

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo "jq is required to run this script. Please install jq and try again."
    exit 1
fi

# Check if the JSON file exists
if [ ! -f "$JSON_FILE" ]; then
    echo "File $JSON_FILE not found! Was the terraform run already?"
    exit 1
fi

NODE_PORT_IPS=($(jq -r '.[]' "$JSON_FILE"))

# write inventory header
echo "[nodes]" > "$INVENTORY_FILE"

# write IPs to the inventory file
for I in "${!NODE_PORT_IPS[@]}"; do
  IP="${NODE_PORT_IPS[I]}"
  HOSTNAME="node-$((I + 1))"
  echo "$HOSTNAME ansible_host=$IP" >> "$INVENTORY_FILE"
done

echo "Inventory $INVENTORY_FILE was successfully generated."
