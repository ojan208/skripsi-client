variable "project_id" {
    type = string
    default = "extreme-battery-426200-u1"
}

variable "image" {
    type = string
    default = "asia-southeast2-docker.pkg.dev/extreme-battery-426200-u1/minecraft/minecraft-client"
}

variable "cluster" {
    type = list(object({
        zone = string
        location = string
        host = string
    }))

    default = [
        {
            zone = "asia-southeast2-a",
            location = "jakarta",
            host = "34.34.220.138"
        }, 
        {
            zone = "asia-south2-a",
            location = "delhi",
            host = "34.131.180.233"
        },
        {
            zone = "asia-northeast1-a",
            location = "tokyo",
            host = "34.146.146.19"
        },
    ]
}
