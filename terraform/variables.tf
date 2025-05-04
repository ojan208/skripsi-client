variable "project_id" {
    type = string
    default = "client-bot-458613"
}

variable "image" {
    type = string
    default = "asia-southeast2-docker.pkg.dev/client-bot-458613/minecraft/minecraft-client"
}

variable "regions" {
    type = list(object({
        zone = string
        location = string
        host = string
    }))

    default = [
        {
            zone = "asia-southeast2-b",
            location = "jakarta",
            host = "34.128.103.190"
        }, 
        {
            zone = "asia-south2-b",
            location = "delhi",
            host = "34.131.87.5"
        },
    ]
}
