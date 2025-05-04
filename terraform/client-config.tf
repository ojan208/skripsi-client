provider "google" {
    project     = var.project_id
    region		= "asia-southeast2"
}

locals {
  client_region = flatten([
    for cluster in var.regions: [
      for i in range(1, 4): {
        name = "client-${ cluster.location }-${ i }"
        zone = cluster.zone
        host = cluster.host
      }
    ]
  ])
}

resource "google_compute_instance" "clients" {
  for_each = { for client in local.client_region: client.name => client }
  name = each.key
  machine_type = "e2-standard-2"
  zone = each.value.zone
  tags = [ "minecraft" ]

  boot_disk {
    initialize_params {
      image = "projects/debian-cloud/global/images/debian-12-bookworm-v20250415"
      type = "pd-ssd"
		  size = 10
    }
  }

  network_interface {
    network = "default"
    access_config {
      network_tier = "STANDARD"
    }
  }

  metadata_startup_script = <<-EOF
  curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
  sudo apt-get update
  sudo apt-get install -y git nodejs
  git clone https://github.com/ojan208/skripsi-docker-client.git /home/skripsi-docker-client
  cd /home/skripsi-docker-client/
  git checkout project-1
  cat <<EOT > .env
  HOST=${ each.value.host }
  PORT=25565
  BOT_NAME=${ each.value.name }
  EOT
  npm install 
  nohup node index.js > output.log 2>&1 &
  EOF
}


# locals {
#   cluster_regions = { for cluster in var.cluster : cluster.location => cluster}
# }

# provider "kubernetes" {
#   alias = "taiwan"
#   host = "https://${google_container_cluster.gke["taiwan"].endpoint}"
#   cluster_ca_certificate = base64decode(google_container_cluster.gke["taiwan"].master_auth[0].cluster_ca_certificate)
#   token = data.google_client_config.default.access_token
# }

# resource "kubernetes_deployment" "clients_taiwan" {
#   count = 3
#   provider = kubernetes.taiwan
#   metadata {
#     name = "client-taiwan-${ count.index + 1 }"
#   }

#   spec {
#     replicas = 1

#     selector {
#       match_labels = {
#         app = "client-taiwan-${ count.index + 1 }"
#       }
#     }

#     template {
#       metadata {
#         labels = {
#           app = "client-taiwan-${ count.index + 1 }"
#         }
#       }

#       spec {
#         container {
#           name = "minecraft-bot"
#           image = var.image

#           env {
#             name = "HOST"
#             value = local.cluster_regions["taiwan"].host
#           }

#           env {
#             name = "PORT"
#             value = "25565"
#           }

#           env {
#             name = "BOT_NAME"
#             value = "client-taiwan-${ count.index + 1 }"
#           }
#         }
#       }
#     }
#   }
# }