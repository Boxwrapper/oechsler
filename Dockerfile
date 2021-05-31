FROM node:16-alpine as BUILD

# Install dependencies
RUN apk update && \
    apk add yarn

# Fix node-gyp errors on arm
RUN apk add \
    g++ \
    make \ 
    python3

# Setup project build context
RUN mkdir /project
WORKDIR /project
COPY . .
RUN yarn install

# Build project into /project/build
RUN yarn build && \
    yarn generate

FROM caddy:alpine as DEPLOY

# Add built react app
COPY --from=BUILD /project/dist /var/www/html

# Add caddy server config
COPY ./Caddyfile /etc/caddy/Caddyfile
