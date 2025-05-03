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

data "google_client_config" "default" {}

provider "kubernetes" {
  alias = "jakarta"
  host = "https://${google_container_cluster.gke["jakarta"].endpoint}"
  cluster_ca_certificate = base64decode(google_container_cluster.gke["jakarta"].master_auth[0].cluster_ca_certificate)
  token = data.google_client_config.default.access_token
}

resource "kubernetes_deployment" "clients_jakarta" {
  count = 3
  provider = kubernetes.jakarta
  metadata {
    name = "client-jakarta-${ count.index + 1 }"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "client-jakarta-${ count.index + 1 }"
      }
    }

    template {
      metadata {
        labels = {
          app = "client-jakarta-${ count.index + 1 }"
        }
      }

      spec {
        container {
          name = "minecraft-bots"
          image = var.image

          env {
            name = "HOST"
            value = local.cluster_regions["jakarta"].host
          }

          env {
            name = "PORT"
            value = "25565"
          }

          env {
            name = "BOT_NAME"
            value = "client-jakarta-${ count.index + 1 }"
          }
        }
      }
    }
  }
}

provider "kubernetes" {
  alias = "delhi"
  host = "https://${google_container_cluster.gke["delhi"].endpoint}"
  cluster_ca_certificate = base64decode(google_container_cluster.gke["delhi"].master_auth[0].cluster_ca_certificate)
  token = data.google_client_config.default.access_token
}

resource "kubernetes_deployment" "clients_delhi" {
  count = 3
  provider = kubernetes.jakarta
  metadata {
    name = "client-delhi-${ count.index + 1 }"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "client-delhi-${ count.index + 1 }"
      }
    }

    template {
      metadata {
        labels = {
          app = "client-delhi-${ count.index + 1 }"
        }
      }

      spec {
        container {
          name = "minecraft-bots"
          image = var.image

          env {
            name = "HOST"
            value = local.cluster_regions["delhi"].host
          }

          env {
            name = "PORT"
            value = "25565"
          }

          env {
            name = "BOT_NAME"
            value = "client-delhi-${ count.index + 1 }"
          }
        }
      }
    }
  }
}