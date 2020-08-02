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
