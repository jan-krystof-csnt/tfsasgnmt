data "openstack_compute_flavor_v2" "flavor" {
  name = var.flavor_name
}

data "openstack_images_image_v2" "image" {
  name = var.image_name
}

data "openstack_networking_router_v2" "router" {
  router_id = var.router_id
}

data "openstack_networking_network_v2" "network" {
  network_id = var.network_id
}

data "openstack_networking_secgroup_v2" "security_group_ssh" {
  secgroup_id = var.security_group_ssh_id
}
 
