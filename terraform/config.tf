provider "digitalocean" {
}

provider "ovh" {
}

resource "digitalocean_kubernetes_cluster" "my_cluster" {
  name    = "my-cluster"
  region  = "lon1"
  version = "1.18.6-do.0"
  tags    = []

  node_pool {
    name       = "worker-pool"
    size       = "s-2vcpu-2gb"
    node_count = 1
  }
}

provider "kubernetes" {
  load_config_file = false
  host  = digitalocean_kubernetes_cluster.my_cluster.endpoint
  token = digitalocean_kubernetes_cluster.my_cluster.kube_config[0].token
  cluster_ca_certificate = base64decode(
    digitalocean_kubernetes_cluster.my_cluster.kube_config[0].cluster_ca_certificate
  )
}

resource "local_file" "kube_config" {
  content = digitalocean_kubernetes_cluster.my_cluster.kube_config[0].raw_config
  filename = "${path.module}/kube_config"
}

variable "main_domain" {}

resource "ovh_domain_zone_record" "main_domain" {
    zone = var.main_domain
    subdomain = ""
    fieldtype = "A"
    ttl = "3600"
    target = digitalocean_kubernetes_cluster.my_cluster.ipv4_address
}

resource "ovh_domain_zone_record" "main_subdomains" {
    zone = var.main_domain
    subdomain = "*"
    fieldtype = "A"
    ttl = "3600"
    target = digitalocean_kubernetes_cluster.my_cluster.ipv4_address
}

resource "ovh_domain_zone_record" "dev_subdomains" {
    zone = var.main_domain
    subdomain = "*.dev"
    fieldtype = "A"
    ttl = "3600"
    target = digitalocean_kubernetes_cluster.my_cluster.ipv4_address
}

output "public_ip" {
  value = digitalocean_kubernetes_cluster.my_cluster.ipv4_address
}
