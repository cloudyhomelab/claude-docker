ARG CLAUDE_VERSION
ARG CODEX_VERSION
ARG GEMINI_VERSION
ARG JAVA_VERSION
ARG COMMON_PACKAGES
ARG EXTRA_PACKAGES=""


#====================
# base layer
#====================
FROM debian:13-slim AS base
ARG COMMON_PACKAGES
ARG EXTRA_PACKAGES

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get install -y --no-install-recommends nodejs npm ${COMMON_PACKAGES} ${EXTRA_PACKAGES} \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash agent
USER agent
WORKDIR /home/agent

RUN curl -fsSL "https://get.sdkman.io?ci=true&rcupdate=false" | bash


#====================
# install jdk
#====================
FROM base AS jdk
ARG JAVA_VERSION

USER agent

ENV SDKMAN_DIR="/home/agent/.sdkman"
RUN bash -c 'source "${SDKMAN_DIR}/bin/sdkman-init.sh" \
    && sdk install java "${JAVA_VERSION}" \
    && sdk install maven'

ENV JAVA_HOME="${SDKMAN_DIR}/candidates/java/current"
ENV PATH="${JAVA_HOME}/bin:${PATH}"


#====================
# claude
#====================
FROM jdk AS claude
ARG CLAUDE_VERSION

USER agent

RUN curl -fsSL "https://claude.ai/install.sh" | bash -s "${CLAUDE_VERSION}"

ENV PATH="/home/agent/.local/bin:${PATH}"
ENTRYPOINT ["claude"]


#====================
# codex
#====================
FROM jdk AS codex
ARG CODEX_VERSION

USER agent
ENV NPM_CONFIG_PREFIX=/home/agent/.npm-global
ENV PATH="/home/agent/.npm-global/bin:${PATH}"
RUN npm install -g @openai/codex@"${CODEX_VERSION}"

ENTRYPOINT ["codex"]


#====================
# gemini
#====================
FROM jdk AS gemini
ARG GEMINI_VERSION

USER agent
ENV NPM_CONFIG_PREFIX=/home/agent/.npm-global
ENV PATH="/home/agent/.npm-global/bin:${PATH}"
RUN npm install -g @google/gemini-cli@"${GEMINI_VERSION}"

ENTRYPOINT ["gemini"]
