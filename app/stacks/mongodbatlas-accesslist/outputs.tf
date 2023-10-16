output "pritunl_vm_ip_address" {
  value = {
    for k, v in mongodbatlas_project_ip_access_list.pritunl_vm_ip_address : k => v.ip_address
  }
}

# output "current_ip_address" {
#   value = mongodbatlas_project_ip_access_list.current_ip_address.ip_address
# }
