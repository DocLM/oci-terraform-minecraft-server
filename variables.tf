variable "oci_tenancy" {
  type = string
}

variable "oci_region" {
  type = string
}

variable "oci_buckets_namespace" {
  type = string
}

variable "ssh_port" {
  type    = number
  default = 22
}

variable "minecraft_ports" {
  type = list(object({
    port     = number,
    protocol = string
  }))
  default = [
    { port = 25565, protocol = "tcp" },
    { port = 25566, protocol = "tcp" },
  ]
}

variable "ssh_knock" {
  type = list(object({
    port     = number,
    protocol = string
  }))
  default = [
    { port = 1111, protocol = "tcp" },
    { port = 2222, protocol = "udp" },
    { port = 3333, protocol = "udp" },
  ]
}

variable "minecraft_knock" {
  type = list(object({
    port     = number,
    protocol = string
  }))
  default = [
    { port = 4444, protocol = "tcp" },
    { port = 5555, protocol = "udp" },
    { port = 6666, protocol = "udp" },
  ]
}

variable "ssh_key" {
  type = string
}