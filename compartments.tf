data "oci_identity_compartment" "root" {
  #Required
  id = var.oci_tenancy
}