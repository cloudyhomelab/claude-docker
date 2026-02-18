variable "REGISTRY" { default = "docker.io" }
variable "NAMESPACE"  { default = "binarycodes" }
variable "IMAGE_NAME" { default = "claude-local" }

variable "title" { default = "claude-local" }
variable "description" { default = "Docker container to run claude workloads" }


group "default" {
  targets = ["all-java-versions"]
}

target "all-java-versions" {
  context    = "."
  dockerfile = "Dockerfile"

  labels = {
    "org.opencontainers.image.title" = title
    "org.opencontainers.image.description" = description
    "org.opencontainers.image.version" = "jdk-${item.major}"
  }

  matrix = {
    item = [
      { major = "25", version = "25.0.2.fx-zulu" },
      { major = "21", version = "21.0.10.fx-zulu" },
      { major = "17", version = "17.0.18.fx-zulu" },
      { major = "11", version = "11.0.30.fx-zulu" },
      { major = "8",  version = "8.0.482.fx-zulu" },
    ]
  }

  name="jdk-${item.major}"

  args = {
    JAVA_VERSION = item.version
  }

  tags = [
    "${REGISTRY}/${NAMESPACE}/${IMAGE_NAME}:jdk-${item.major}",
  ]
}

target "multi-arch" {
  context    = "."
  dockerfile = "Dockerfile"

  labels = {
    "org.opencontainers.image.title" = title
    "org.opencontainers.image.description" = description
    "org.opencontainers.image.version" = "jdk-${item.major}"
  }

  matrix = {
    item = [
      { major = "25", version = "25.0.2.fx-zulu" },
      { major = "21", version = "21.0.10.fx-zulu" },
      { major = "17", version = "17.0.18.fx-zulu" },
      { major = "11", version = "11.0.30.fx-zulu" },
      { major = "8",  version = "8.0.482.fx-zulu" },
    ]
  }

  name="jdk-${item.major}"

  args = {
    JAVA_VERSION = item.version
  }

  tags = [
    "${REGISTRY}/${NAMESPACE}/${IMAGE_NAME}:jdk-${item.major}",
  ]

  platforms = ["linux/amd64", "linux/arm64"]
}
