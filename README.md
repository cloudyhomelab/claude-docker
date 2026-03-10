# Agent CLI Docker Images

This repository builds and publishes Docker images for three AI agent CLIs:

- `claude`
- `codex`
- `gemini`

Images are published on Docker Hub under:

- `docker.io/binarycodes/claude-local`
- `docker.io/binarycodes/codex-local`
- `docker.io/binarycodes/gemini-local`

## Available Images

Each agent has the following tagged image variants:

- `python`
- `jdk-8`
- `jdk-11`
- `jdk-17`
- `jdk-21`
- `jdk-25`
- `jdk-lts` (currently JDK 21)
- `jdk-latest` (currently JDK 25)

## Quick Start

### Run the CLI directly:

#### Claude
```bash
docker run --rm -it docker.io/binarycodes/claude-local:python
```

#### Codex
```bash
docker run --rm -it docker.io/binarycodes/codex-local:python
```

#### Gemini
```bash
docker run --rm -it docker.io/binarycodes/gemini-local:python
```

### Run with your current project mounted:

```bash
docker run --rm -it \
  -v "$PWD:/workspace" \
  -w /workspace \
  docker.io/binarycodes/codex-local:python
```

Use a Java variant:

```bash
docker run --rm -it docker.io/binarycodes/codex-local:jdk-lts
```

### Shell helper function
Add to your shell rc file such as `~/.bashrc` or `~/.zshrc`

```bash
agent() {
	[[ $# -ne 3 ]] && { echo "usage: agent <tool> <variant> <project_path>"; return 1; }
	local tool="$1"
	local variant="$2"
	local project_path="$3"
	docker run --pull always --rm -it \
	-v "${tool}_home:/home/agent" \
	-v "${project_path}:/workspace" \
	-w /workspace \
	"docker.io/binarycodes/${tool}-local:${variant}"
}
```

Example:

```bash
agent codex python "/path/to/workspace"
```

## Build Locally

Build all default targets:

```bash
docker buildx bake
```

Print the resolved build plan:

```bash
docker buildx bake --print
```
