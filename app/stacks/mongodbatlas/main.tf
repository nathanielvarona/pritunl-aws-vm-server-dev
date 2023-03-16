resource "mongodbatlas_project" "project" {
  name   = var.project_name
  org_id = var.atlas_org_id
}


resource "mongodbatlas_advanced_cluster" "cluster" {
  project_id     = mongodbatlas_project.project.id
  name           = var.cluster_name
  cluster_type   = "REPLICASET"
  backup_enabled = false

  replication_specs {
    region_configs {
      electable_specs {
        instance_size = "M0"
      }
      provider_name         = "TENANT"
      backing_provider_name = "AWS"
      region_name           = "US_EAST_1"
      priority              = 7
    }
  }
}

resource "mongodbatlas_database_user" "user" {
  username           = var.atlas_dbuser
  password           = var.atlas_dbpassword
  auth_database_name = "admin"
  project_id         = mongodbatlas_project.project.id
  roles {
    role_name     = "readWriteAnyDatabase"
    database_name = "admin"
  }
}
