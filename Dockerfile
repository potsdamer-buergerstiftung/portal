ARG NODE_VERSION=16-alpine

FROM node:${NODE_VERSION} as builder

ARG TARGETPLATFORM

WORKDIR /directus
COPY . .
RUN \
  if [ "$TARGETPLATFORM" = 'linux/arm64' ]; then \
  apk --no-cache add \
  python3 \
  build-base \
  && ln -sf /usr/bin/python3 /usr/bin/python \
  ; fi
RUN npm i --omit=dev --no-package-lock

# Directus image
FROM node:${NODE_VERSION}

ARG VERSION
ARG REPOSITORY=directus/directus

LABEL directus.version="${VERSION}"

# Default environment variables
# (see https://docs.directus.io/reference/environment-variables/)
ENV \
  EXTENSIONS_PATH="/directus/extensions"

RUN \
  # Upgrade system and install 'ssmtp' to be able to send mails
  apk upgrade --no-cache && apk add --no-cache \
  ssmtp \
  # Add support for specifying the timezone of the container
  # using the "TZ" environment variable.
  tzdata \
  # Create directory for Directus with corresponding ownership
  # (can be omitted on newer Docker versions since WORKDIR below will do the same)
  && mkdir /directus && chown node:node /directus

# Switch to user 'node' and directory '/directus'
USER node
WORKDIR /directus

# disable npm update warnings
RUN echo "update-notifier=false" >> ~/.npmrc

COPY --from=builder --chown=node:node /directus .

RUN \
  # Create data directories
  mkdir -p \
    extensions

# Expose data directories as volumes
VOLUME \
  /directus/extensions

EXPOSE 8055
CMD npx directus start
