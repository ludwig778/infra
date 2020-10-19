provider "digitalocean" {
}

provider "ovh" {
}

data "digitalocean_kubernetes_versions" "main" {}

resource "digitalocean_kubernetes_cluster" "my_cluster" {
    name    = "my-cluster"
    region  = "lon1"
    version = data.digitalocean_kubernetes_versions.main.latest_version
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

resource "digitalocean_loadbalancer" "public" {
    name   = "kubernetes-load-balancer"
    region = "lon1"

    forwarding_rule {
        entry_port     = 80
        entry_protocol = "tcp"
        target_port     = 80
        target_protocol = "tcp"
    }

    forwarding_rule {
        entry_port     = 443
        entry_protocol = "tcp"
        target_port     = 443
        target_protocol = "tcp"
    }

    healthcheck {
        port     = 22
        protocol = "tcp"
    }

    droplet_ids = [for node in digitalocean_kubernetes_cluster.my_cluster.node_pool[0].nodes: node.droplet_id]
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
    target = digitalocean_loadbalancer.public.ip
}

resource "ovh_domain_zone_record" "main_subdomains" {
    zone = var.main_domain
    subdomain = "*"
    fieldtype = "A"
    ttl = "3600"
    target = digitalocean_loadbalancer.public.ip
}

resource "ovh_domain_zone_record" "in_subdomains" {
    zone = var.main_domain
    subdomain = "*.in"
    fieldtype = "A"
    ttl = "3600"
    target = digitalocean_loadbalancer.public.ip
}

resource "ovh_domain_zone_record" "dev_subdomains" {
    zone = var.main_domain
    subdomain = "*.dev"
    fieldtype = "A"
    ttl = "3600"
    target = digitalocean_loadbalancer.public.ip
}

output "kubernetes_cluster_ip" {
    value = digitalocean_kubernetes_cluster.my_cluster.ipv4_address
}

output "load_balancer_ip" {
    value = digitalocean_loadbalancer.public.ip
}
