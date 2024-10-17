
data "template_file" "cloud_init" {
  template = file("cloud-init.tpl")   

  vars = {
    ssh_authorized_keys = file("../id_rsa.pub")
    ssh_user = var.default_ssh_user
  }
}
