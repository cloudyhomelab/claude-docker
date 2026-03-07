variable "REGISTRY" { default = "docker.io" }
variable "NAMESPACE"  { default = "binarycodes" }
variable "IMAGE_NAME" { default = "claude-local" }
variable "CLAUDE_VERSION" { default = "2.1.71" }
variable "LOCAL" { default = false }

target "common" {
  labels = {
    "org.opencontainers.image.title"       = "claude-local"
    "org.opencontainers.image.description" = "Docker container to run claude workloads"
    "net.cloudyhome.claude.version"        = CLAUDE_VERSION
  }
  platforms = LOCAL ? [] : ["linux/amd64", "linux/arm64"]
}

group "default" {
  targets = ["python", "all-java-versions"]
}

target "python" {
  inherits = ["common"]
  context = "."
  dockerfile = "Dockerfile.python"

  args = {
    CLAUDE_VERSION = CLAUDE_VERSION
  }

  tags = ["${REGISTRY}/${NAMESPACE}/${IMAGE_NAME}:python"]
}

target "java-base" {
  inherits = ["common"]
  context = "."
  dockerfile = "Dockerfile.java"
  target = "base-installer"

  args = {
    CLAUDE_VERSION = CLAUDE_VERSION
  }
}

target "all-java-versions" {
  inherits = ["java-base"]
  target = "final"

  labels = {
    "org.opencontainers.image.version" = "jdk-${item.major}"
  }

  matrix = {
    item = [
      { major = "25", version = "25.0.2.fx-zulu", extra_tags = ["latest"] },
      { major = "21", version = "21.0.10.fx-zulu", extra_tags = ["lts"] },
      { major = "17", version = "17.0.18.fx-zulu", extra_tags = [] },
      { major = "11", version = "11.0.30.fx-zulu", extra_tags = [] },
      { major = "8",  version = "8.0.482.fx-zulu", extra_tags = [] },
    ]
  }

  name="jdk-${item.major}"

  args = {
    JAVA_VERSION = item.version
  }

  tags = concat(
    ["${REGISTRY}/${NAMESPACE}/${IMAGE_NAME}:jdk-${item.major}"],
    [for t in item.extra_tags : "${REGISTRY}/${NAMESPACE}/${IMAGE_NAME}:${t}"]
    )
}

