resource "mongodbatlas_project_ip_access_list" "pritunl_vm_ip_address" {
  project_id = var.mongodbatlas_project_id
  ip_address = var.pritunl_vm_ip_address
  comment    = "IP Address for accessing the cluster"
}

# resource "mongodbatlas_project_ip_access_list" "current_ip_address" {
#   project_id = var.mongodbatlas_project_id
#   ip_address = var.current_ip_address
#   comment    = "IP Address for accessing the cluster"
# }
