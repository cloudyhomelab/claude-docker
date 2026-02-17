variable "REGISTRY" { default = "docker.io" }
variable "NAMESPACE"  { default = "binarycodes" }
variable "IMAGE_NAME" { default = "claude-local" }
variable "IMAGE_VERSION" { default = "0.0.1" }

group "default" {
  targets = ["image"]
}

target "image" {
  context    = "."
  dockerfile = "Dockerfile"

  labels = {
    "org.opencontainers.image.title" = "claude-local"
    "org.opencontainers.image.description" = "Docker container to run claude workloads"
    "org.opencontainers.image.version" = IMAGE_VERSION
  }

  tags = [
    "${REGISTRY}/${NAMESPACE}/${IMAGE_NAME}:${IMAGE_VERSION}",
    "${REGISTRY}/${NAMESPACE}/${IMAGE_NAME}:latest",
  ]
}

target "image-all" {
  inherits = ["image"]
  platforms = ["linux/amd64", "linux/arm64"]
}