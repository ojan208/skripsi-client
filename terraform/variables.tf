variable "project_id" {
    type = string
    default = "client-bot-2"
}

variable "image" {
    type = string
    default = "asia-southeast2-docker.pkg.dev/extreme-battery-426200-u1/minecraft/minecraft-client"
}

variable "cluster" {
    type = list(object({
        zone = string
        location = string
    }))

    default = [
        {
            zone = "asia-northeast1-b",
            location = "tokyo",
        },
        {
            zone = "asia-east1-b",
            location = "taiwan",
        },
    ]
}
