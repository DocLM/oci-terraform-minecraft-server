resource "oci_identity_policy" "access_minecraft_bucket" {
  #Required
  compartment_id = data.oci_identity_compartment.root.id
  description    = "Allow to access data in Minecraft bucket"
  name           = "MinecraftReadWriteAccess"
  statements = [
    "Allow dynamic-group ${oci_identity_dynamic_group.root.name} to manage objects in tenancy where all {target.bucket.name='${oci_objectstorage_bucket.minecraft.name}'}"
  ]
}

resource "oci_identity_policy" "allow_bucket_lifecycle" {
  #Required
  compartment_id = data.oci_identity_compartment.root.id
  description    = "Allow to OCI to manage "
  name           = "MinecraftBucketLifecycle"
  statements = [
    "Allow service objectstorage-${var.oci_region} to manage object-family in tenancy where all {target.bucket.name='${oci_objectstorage_bucket.minecraft.name}'}"
  ]
}