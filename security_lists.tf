locals {
  tcp_ports = [
    for item in [for x in concat(
      [{ port = var.ssh_port, protocol = "tcp" }],
      var.minecraft_ports,
      var.ssh_knock,
      var.minecraft_knock
    ) : x if x.protocol == "tcp"] :
    {
      minport     = item.port
      maxport     = item.port
      source_cidr = null
      protocol    = "6" # TCP
      stateless   = false
    }
  ]
  udp_ports = [
    for item in [for x in concat(var.ssh_knock, var.minecraft_knock) : x if x.protocol == "udp"] :
    {
      minport     = item.port
      maxport     = item.port
      source_cidr = null
      protocol    = "17" # TCP
    }
  ]
}
resource "oci_core_security_list" "minecraft" {
  #Required
  compartment_id = data.oci_identity_compartment.root.id
  vcn_id         = module.vcn.vcn_id

  #Optional
  display_name = "Minecraft server firewall"
  egress_security_rules {
    #Required
    destination = "0.0.0.0/0"
    protocol    = "all"

    #Optional
    description = "Internet"
  }

  dynamic "ingress_security_rules" {
    iterator = port
    for_each = [for x in local.tcp_ports : {
      minport     = x.minport
      maxport     = x.maxport
      source_cidr = x.source_cidr != null ? x.source_cidr : "0.0.0.0/0"
      stateless   = x.stateless
    }]
    content {
      protocol  = "6" # TCP
      source    = port.value.source_cidr
      stateless = port.value.stateless
      tcp_options {
        // These values correspond to the destination port range.
        min = port.value.minport
        max = port.value.maxport
      }
    }
  }

  dynamic "ingress_security_rules" {
    iterator = port
    for_each = [for x in local.udp_ports : {
      minport     = x.minport
      maxport     = x.maxport
      source_cidr = x.source_cidr != null ? x.source_cidr : "0.0.0.0/0"
    }]
    content {
      protocol = "17" # UDP
      source   = port.value.source_cidr
      udp_options {
        // These values correspond to the destination port range.
        min = port.value.minport
        max = port.value.maxport
      }
    }
  }
}