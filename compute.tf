locals {
  user            = "opc"
  ssh_key         = ""
  knock_ssh       = join(",", [for x in concat(var.ssh_knock) : "${x.port}:${x.protocol}"])
  knock_minecraft = join(",", [for x in concat(var.minecraft_knock) : "${x.port}:${x.protocol}"])
}

data "oci_core_images" "oraclelinux8_aarch64" {
  compartment_id = data.oci_identity_compartment.root.id

  operating_system         = "Oracle Linux"
  operating_system_version = "8"

  # include Aarch64 specific images
  filter {
    name   = "display_name"
    values = ["^.*-aarch64-.*$"]
    regex  = true
  }
}


resource "oci_core_instance" "ampere" {
  # Required
  availability_domain                 = "DThj:EU-FRANKFURT-1-AD-3"
  compartment_id                      = data.oci_identity_compartment.root.id
  shape                               = "VM.Standard.A1.Flex"
  is_pv_encryption_in_transit_enabled = true
  lifecycle {
    ignore_changes = [
      source_details
    ]
  }

  shape_config {
    memory_in_gbs = 24
    ocpus         = 4
  }

  source_details {
    source_id               = data.oci_core_images.oraclelinux8_aarch64.images.0.id
    source_type             = "image"
    boot_volume_size_in_gbs = 100
  }

  # Optional
  display_name = "Ampere server"
  create_vnic_details {
    assign_public_ip = true
    subnet_id        = oci_core_subnet.server.id
  }
  metadata = {
    ssh_authorized_keys = local.ssh_key
  }
  preserve_boot_volume = false

  provisioner "remote-exec" {
    script = "scripts/wait_for_instance.sh"
    connection {
      host = oci_core_instance.ampere.public_ip
      user = local.user
    }
  }

  provisioner "remote-exec" {
    script = "scripts/install_python.sh"
    connection {
      host = oci_core_instance.ampere.public_ip
      user = local.user
    }
  }
}

resource "oci_identity_dynamic_group" "root" {
  #Required
  compartment_id = data.oci_identity_compartment.root.id
  description    = "Arm server group"
  matching_rule  = "instance.id = '${oci_core_instance.ampere.id}'"
  name           = "main"
}