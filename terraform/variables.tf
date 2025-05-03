variable "project_id" {
    type = string
    default = "client-bot-2"
}

variable "image" {
    type = string
    default = "asia-southeast2-docker.pkg.dev/client-bot-2/minecraft/minecraft-client"
}

variable "cluster" {
    type = list(object({
        zone = string
        location = string
        host = string
    }))

    default = [
        {
            zone = "asia-northeast1-b",
            location = "tokyo",
            host = "35.200.115.14"
        },
        {
            zone = "asia-east1-b",
            location = "taiwan",
            host = "34.80.0.197"
        },
    ]
}
