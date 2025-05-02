variable "project_id" {
    type = string
    default = "client-bot-458613"
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
            zone = "asia-southeast2-b",
            location = "jakarta",
        }, 
        {
            zone = "asia-south2-b",
            location = "delhi",
        },
    ]
}
