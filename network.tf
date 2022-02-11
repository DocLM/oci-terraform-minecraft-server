module "vcn" {
  source  = "oracle-terraform-modules/vcn/oci"
  version = "2.2.0"
  # insert the 7 required variables here

  compartment_id           = data.oci_identity_compartment.root.id
  internet_gateway_enabled = true
  lockdown_default_seclist = true
  vcn_cidr                 = "10.0.0.0/16"

  internet_gateway_route_rules = []
  nat_gateway_route_rules      = []
  vcn_dns_label                = ""
  vcn_name                     = "Main network"
}

resource "oci_core_subnet" "server" {
  #Required
  cidr_block     = "10.0.0.0/24"
  compartment_id = data.oci_identity_compartment.root.id
  vcn_id         = module.vcn.vcn_id

  display_name = "Minecraft server network"

  route_table_id    = module.vcn.ig_route_all_attributes[0].id
  security_list_ids = [oci_core_security_list.minecraft.id]
}