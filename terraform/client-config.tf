provider "google" {
    project     = var.project_id
    region		= "asia-southeast2"
}

# provider "kubernetes" {
#     alias = "gke"
#     config_path = "~/.kube/config"
# }

# provider "helm" {
#     alias = "helm"
#     kubernetes {
#       config_path = "~/.kube/config"
#     }
# }

locals {
  cluster_regions = { for cluster in var.cluster : cluster.location => cluster}
}

resource "google_container_cluster" "gke" {
    for_each = local.cluster_regions
    name = "cluster-${ each.value.location }"
    location = each.value.zone
    initial_node_count = 5
}

# untuk automasi
# resource "google_container_cluster" "gke" {
#     for_each = local.clusters
#     name = "cluster-${ each.key }"
#     location = "${ each.value.zone }"

#     # membuat 5 node untuk 5 client
#     initial_node_count = 5
# }

# resource "helm_release" "client_bots" {
#     name = "minecraft-bot"
#     chart = "minecraft-chart"
# }