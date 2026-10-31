FROM debian:bookworm

# Fail the build if curl fails inside the NodeSource pipe below.
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Debian pins rot on every security update; track the bookworm suite instead.
# hadolint ignore=DL3008
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    gnupg \
    && rm -rf /var/lib/apt/lists/*

# Node.js 22 LTS: nodemailer 10 requires Node >= 20.
# hadolint ignore=DL3008
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y --no-install-recommends nodejs \
    && rm -rf /var/lib/apt/lists/*

RUN node --version && npm --version

WORKDIR /app

COPY package*.json ./
RUN npm ci --omit=dev

COPY src/ ./src/

EXPOSE 3000

ENTRYPOINT ["node", "src/server.js"]
