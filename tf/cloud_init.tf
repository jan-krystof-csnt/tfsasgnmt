data "external" "ssh_public_key" {
  program = [
    "bash",
    "-c",
    "echo '{ \"ssh_key\": \"'$(yq eval '.ssh_public' ${path.root}../ansible/credentials/ssh_key_infrastructure.yml)'\" }'"
  ]
}

locals {
  ssh_public_key = data.external.ssh_public_key.result.ssh_key
}

data "template_file" "cloud_init" {
  template = file("${path.module}/cloud-init.tpl")

  vars = {
    ssh_authorized_keys = local.ssh_public_key
    ssh_user = var.default_ssh_user
  }
}
