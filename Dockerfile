FROM node:22.23.4-alpine

ENV NODE_ENV=production

WORKDIR /app

# Dependencies first — this layer is cached until package*.json changes.
# `npm ci` installs optionalDependencies (https-proxy-agent) so HTTP_PROXY works.
COPY package.json package-lock.json ./
RUN npm ci --omit=dev && npm cache clean --force

COPY index.js ./
COPY src ./src

# Unprivileged user shipped with the official image
USER node

CMD ["node", "index.js"]
