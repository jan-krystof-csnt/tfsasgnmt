resource "openstack_compute_instance_v2" "instance_nodes" {
  count = var.instance_count
  name = "${var.infra_name}-nd-${count.index}"
  flavor_name = data.openstack_compute_flavor_v2. flavor.name
  user_data = data.template_file.cloud_init.rendered

  network {
    port = openstack_networking_port_v2.node_port[count.index].id
  }

  block_device {
    uuid = openstack_blockstorage_volume_v3.root_volume[count.index].id
    source_type = "volume"
    destination_type = "volume"
    boot_index = 0
    delete_on_termination = false
  }

  block_device {
    uuid = openstack_blockstorage_volume_v3.logs_volume[count.index].id
    source_type = "volume"
    destination_type = "volume"
    boot_index = -1
    delete_on_termination = true
  }

  block_device {
    uuid = openstack_blockstorage_volume_v3.data_volume[count.index].id
    source_type = "volume"
    destination_type = "volume"
    boot_index = -1
    delete_on_termination = false
  }
}

resource "openstack_blockstorage_volume_v3" "root_volume" {
  count = var.instance_count
  name = "${var.infra_name}-vol-root-${count.index}"
  size = var.root_disk_size
  image_id = var.image_name
}

resource "openstack_blockstorage_volume_v3" "logs_volume" {
  count = var.instance_count
  name = "${var.infra_name}-vol-logs-${count.index}"
  size = var.logs_disk_size
}

resource "openstack_blockstorage_volume_v3" "data_volume" {
  count = var.instance_count
  name = "${var.infra_name}-vol-data-${count.index}"
  size = var.data_disk_size
}
