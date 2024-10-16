resource "openstack_networking_subnet_v2" "subnet" {
  name = "${var.infra_name}-subnet"
  network_id = data.openstack_networking_network_v2.network.id
  cidr = var.internal_network_cidr
  ip_version = 4
  dns_nameservers = ["1.1.1.1", "8.8.8.8"]
}

resource "openstack_networking_router_interface_v2" "router_subnet_connection" {
  router_id = data.openstack_networking_router_v2.router.id
  subnet_id = openstack_networking_subnet_v2.subnet.id
}

resource "openstack_networking_port_v2" "node_port" {
  count = var.instance_count
  name = "${var.infra_name}-node-port-${count.index}"
  network_id = data.openstack_networking_network_v2.network.id
  admin_state_up = "true"
  security_group_ids = [ data.openstack_networking_secgroup_v2.security_group_ssh.secgroup_id]
  fixed_ip {
    subnet_id = openstack_networking_subnet_v2.subnet.id
    ip_address = cidrhost(var.internal_network_cidr, 4 + count.index)
  }
}

# TODO: delme
resource "openstack_networking_floatingip_v2" "bastion_fip" {
  count = var.instance_count
  pool  = "external-ipv4-general-public"
}

# TODO: delme
resource "openstack_networking_floatingip_associate_v2" "bastion_fip_associate" {
  count      = var.instance_count
  floating_ip = openstack_networking_floatingip_v2.bastion_fip[count.index].address
  port_id    = openstack_networking_port_v2.node_port[count.index].id
}
