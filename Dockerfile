ARG JAVA_VERSION="21.0.10.fx-zulu"

FROM debian:13-slim AS base-installer

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        git \
        bash \
        terminfo \
        ncurses-term \
        unzip \
        zip \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash claude
USER claude
WORKDIR /home/claude

RUN curl -fsSL "https://get.sdkman.io?ci=true&rcupdate=false" | bash
RUN curl -fsSL "https://claude.ai/install.sh" | bash



FROM base-installer
ARG JAVA_VERSION

USER claude

ENV SDKMAN_DIR="/home/claude/.sdkman"
RUN bash -c 'source "${SDKMAN_DIR}/bin/sdkman-init.sh" && sdk install java "${JAVA_VERSION}"'

ENV JAVA_HOME="${SDKMAN_DIR}/candidates/java/current"
ENV PATH="/home/claude/.local/bin:${JAVA_HOME}/bin:${PATH}"

ENTRYPOINT ["claude"]
