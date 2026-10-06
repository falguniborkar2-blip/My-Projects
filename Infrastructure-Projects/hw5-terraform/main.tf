terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 3.0.0"
    }
  }
}

provider "openstack" {
  cloud = "openstack"
}

resource "openstack_networking_secgroup_v2" "hw5_sg" {
  name        = "hw5-secgroup"
  description = "Security group for HW5 Flask app"
}

resource "openstack_networking_secgroup_rule_v2" "https" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 443
  port_range_max    = 443
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.hw5_sg.id
}

resource "openstack_networking_secgroup_rule_v2" "http" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.hw5_sg.id
}

resource "openstack_networking_secgroup_rule_v2" "ssh" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.hw5_sg.id
}

resource "openstack_networking_floatingip_v2" "hw5_fip" {
  pool = var.floating_ip_pool
}

resource "openstack_compute_instance_v2" "hw5_vm" {
  name            = var.vm_name
  image_id        = var.image_id
  flavor_id       = var.flavor_id
  key_pair        = var.key_pair
  security_groups = [openstack_networking_secgroup_v2.hw5_sg.name]

  network {
    uuid = var.network_id
  }

  user_data = templatefile("${path.module}/user_data.sh", {
    floating_ip = openstack_networking_floatingip_v2.hw5_fip.address
    var = {
      postgres_user     = var.postgres_user
      postgres_password = var.postgres_password
      postgres_db       = var.postgres_db
      postgres_host     = var.postgres_host
      postgres_port     = var.postgres_port
      jwt_secret_key    = var.jwt_secret_key
      aid_secret        = var.aid_secret
      software_version  = var.software_version
      uco               = var.uco
      name              = var.name
    }
  })
}

resource "openstack_networking_floatingip_associate_v2" "hw5_fip_assoc" {
  floating_ip = openstack_networking_floatingip_v2.hw5_fip.address
  port_id     = openstack_compute_instance_v2.hw5_vm.network[0].port
}

output "floating_ip" {
  value       = openstack_networking_floatingip_v2.hw5_fip.address
  description = "Public floating IP of the VM"
}

output "hostname" {
  value       = "https://mu-pub-${join("-", slice(split(".", openstack_networking_floatingip_v2.hw5_fip.address), 2, 4))}.flt.openstack.cloud.e-infra.cz"
  description = "Public hostname of the app"
}
resource "openstack_networking_secgroup_rule_v2" "icmp" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.hw5_sg.id
}