FROM debian:13-slim

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

SHELL ["/bin/bash", "-lc"]
ENV SDKMAN_DIR="/home/claude/.sdkman"

RUN curl -sSL "https://get.sdkman.io" | bash
RUN source "${SDKMAN_DIR}/bin/sdkman-init.sh" \
    && sdk version \
    && sdk install java 21.0.10.fx-zulu

RUN curl -fsSL https://claude.ai/install.sh | bash

ENV PATH="/home/claude/.local/bin:${PATH}"

ENTRYPOINT ["claude"]

