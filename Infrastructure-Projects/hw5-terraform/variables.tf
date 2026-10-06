variable "vm_name" {
  description = "Name of the virtual machine"
}

variable "image_id" {
  description = "Name of the image to use for the VM"
  default     = "14034757-37db-4fbf-a87d-a2938545ab22" # debian 13
}

variable "flavor_id" {
  description = "Flavor ID for the VM"
}

variable "key_pair" {
  description = "Name of the key pair for SSH access"
}

variable "network_id" {
  description = "ID of the network to attach the VM"
}

variable "floating_ip_pool" {
  description = "Floating IP pool name"
}

variable "postgres_user" {
  description = "PostgreSQL username for the application"
}

variable "postgres_password" {
  description = "PostgreSQL password for the application"
}

variable "postgres_db" {
  description = "PostgreSQL database name for the application"
}

variable "postgres_host" {
  description = "PostgreSQL host address for the application"
}

variable "postgres_port" {
  description = "PostgreSQL port number for the application"
}

variable "jwt_secret_key" {
  description = "Secret key for JWT authentication in the application"
}

variable "aid_secret" {
  description = "Secret key for AID in the application"
}

variable "software_version" {
  description = "Version of the software to be deployed (e.g., '1.0.0')"
}

variable "uco" {
  description = "Univerzitné číslo osoby (UČO) of MUNI"
}

variable "name" {
  description = "Full name of the student"
}