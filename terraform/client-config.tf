provider "google" {
    project     = var.project_id
    region		= "asia-southeast2"
}

locals {
  cluster_regions = { for cluster in var.cluster : cluster.location => cluster}
}

resource "google_container_cluster" "gke" {
    for_each = local.cluster_regions
    name = "cluster-${ each.value.location }"
    location = each.value.zone
    initial_node_count = 3
    release_channel {
      channel = "STABLE"
    }

    deletion_protection = false

    node_config {
      machine_type = "e2-standard-2"
      tags = [ "minecraft" ]
      disk_size_gb = 20
      disk_type = "pd-ssd"
    }
}