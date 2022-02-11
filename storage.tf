resource "oci_objectstorage_bucket" "minecraft" {
  #Required
  compartment_id = data.oci_identity_compartment.root.id
  name           = "doclm-minecraft"
  namespace      = var.oci_buckets_namespace
}

resource "oci_objectstorage_object_lifecycle_policy" "test_object_lifecycle_policy" {
  #Required
  bucket    = oci_objectstorage_bucket.minecraft.name
  namespace = oci_objectstorage_bucket.minecraft.namespace

  #Optional
  rules {
    #Required
    action      = "DELETE"
    is_enabled  = true
    name        = "Delete old minecraft backup"
    time_amount = 3
    time_unit   = "DAYS"

    #Optional
    object_name_filter {
      inclusion_prefixes = ["minecraft-"]
    }
    target = "objects"
  }
}