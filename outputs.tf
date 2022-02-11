output "minecraft_ip" {
  value = oci_core_instance.ampere.public_ip
}

output "root_compartment" {
  value = data.oci_identity_compartment.root.id
}

output "command" {
  value = "ansible-playbook --inventory '${oci_core_instance.ampere.public_ip},' --extra-vars 'skip_updates=true openssh_knock_ports=\"${local.knock_ssh}\" minecraft_knock_ports=\"${local.knock_minecraft}\" minecraft_backup_namespace=\"${oci_objectstorage_bucket.minecraft.namespace}\" minecraft_backup_bucket=\"${oci_objectstorage_bucket.minecraft.name}\"' --ssh-extra-args '-o StrictHostKeyChecking=no' -u ${local.user} minecraft.yml"
}