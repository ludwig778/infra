provider "scaleway" {}

resource "scaleway_instance_ip" "public_ip" {}

resource "scaleway_instance_security_group" "www" {
  inbound_default_policy  = "drop"
  outbound_default_policy = "accept"

  inbound_rule {
    action = "accept"
    port   = "22"
  }

  inbound_rule {
    action = "accept"
    port   = "80"
  }

  inbound_rule {
    action = "accept"
    port   = "443"
  }

  inbound_rule {
    action = "accept"
    port   = "6443"
  }
}

data "template_file" "shell-script" {
  template = file("modules/scaleway/scripts/cloud-init.sh")
}

data "template_cloudinit_config" "cloudinit-example" {
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.shell-script.rendered
  }
}

resource "scaleway_instance_server" "test-instance" {
  name = "test-instance"
  type  = "DEV1-S"
  image = "debian-buster"

  tags = [ "dev" ]

  root_volume {
    size_in_gb = 20
    delete_on_termination = false
  }
  enable_ipv6 = false

  ip_id = scaleway_instance_ip.public_ip.id

  security_group_id = scaleway_instance_security_group.www.id

  cloud_init = data.template_cloudinit_config.cloudinit-example.rendered
}

output "ips" {
  value = scaleway_instance_ip.public_ip
}
