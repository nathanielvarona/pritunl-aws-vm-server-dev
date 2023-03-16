output "project_name" {
  value = mongodbatlas_project.project.name
}

output "project_id" {
  value = mongodbatlas_project.project.id
}

output "standard" {
  value = mongodbatlas_advanced_cluster.cluster.connection_strings[0].standard
}

output "standard_srv" {
  value = mongodbatlas_advanced_cluster.cluster.connection_strings[0].standard_srv
}

output "server_authority_address" {
  value = regex("(?:(?P<scheme>[^:/?#]+):)?(?://(?P<authority>[^/?#]*))?(?P<path>[^?#]*)(?:\\?(?P<query>[^#]*))?(?:#(?P<fragment>.*))?", mongodbatlas_advanced_cluster.cluster.connection_strings[0].standard_srv)["authority"]
}
