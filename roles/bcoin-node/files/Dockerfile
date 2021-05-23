FROM node:alpine AS base

WORKDIR /usr/src/app

ENV BCOIN_VERSION=${BCOIN_VERSION} \
    BCOIN_REPO=https://github.com/bcoin-org/bcoin.git

RUN apk upgrade --no-cache && \
    apk add --no-cache bash git

RUN git clone $BCOIN_REPO /usr/src/app && \
    git checkout $BCOIN_VERSION

FROM base AS build

# Install build dependencies
RUN apk add --no-cache g++ gcc make python2
RUN npm rebuild
RUN npm install --global

# Copy built files, but don't include build deps
FROM base
USER node
CMD "bcoin"

ENV PATH="${PATH}:/usr/src/app/bin:/usr/src/app/node_modules/.bin"
COPY --from=build /usr/src/app /usr/src/app
VOLUME /data

# Main-net and Test-net
EXPOSE 8334 8333 8332 18334 18333 18332
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 CMD [ "bcoin-cli info >/dev/null" ]