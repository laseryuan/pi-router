group "default" {
    targets = ["amd64", "arm32"]
}

target "amd64" {
    dockerfile = "./amd64/Dockerfile"
    platforms = [
        "linux/amd64",
    ]
    tags = ["rpi-router", "rpi-router:amd64"]
    output = ["type=docker"]
}

target "arm32" {
    dockerfile = "./arm32/Dockerfile"
    platforms = [
        "linux/arm/v6",
    ]
    tags = ["rpi-router:arm32"]
    output = ["type=docker"]
}
