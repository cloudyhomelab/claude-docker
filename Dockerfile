ARG JAVA_VERSION="21.0.10.fx-zulu"

FROM debian:13-slim

ARG JAVA_VERSION

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

SHELL ["/bin/bash", "-c"]
ENV SDKMAN_DIR="/home/claude/.sdkman"

RUN curl -s "https://get.sdkman.io?ci=true&rcupdate=false" | bash
RUN source "${SDKMAN_DIR}/bin/sdkman-init.sh" \
    && sdk version \
    && sdk install java "${JAVA_VERSION}"

RUN curl -fsSL https://claude.ai/install.sh | bash

ENV JAVA_HOME="${SDKMAN_DIR}/candidates/java/current"
ENV PATH="/home/claude/.local/bin:${JAVA_HOME}/bin:${PATH}"

ENTRYPOINT ["claude"]
