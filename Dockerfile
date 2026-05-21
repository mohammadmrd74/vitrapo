FROM node:22-slim AS build
WORKDIR /usr/src/app

# OpenSSL is required by Prisma at runtime
RUN apt-get update && apt-get install -y --no-install-recommends openssl ca-certificates \
  && rm -rf /var/lib/apt/lists/*

COPY package.json package-lock.json* ./
RUN npm install --legacy-peer-deps

COPY . .
RUN npx prisma generate
RUN npm run build

FROM node:22-slim AS run
WORKDIR /usr/src/app
RUN apt-get update && apt-get install -y --no-install-recommends openssl ca-certificates \
  && rm -rf /var/lib/apt/lists/*

COPY --from=build /usr/src/app/node_modules ./node_modules
COPY --from=build /usr/src/app/dist ./dist
COPY --from=build /usr/src/app/src/database/schema.prisma ./src/database/schema.prisma
COPY --from=build /usr/src/app/prisma ./prisma
COPY package.json ./

CMD ["node", "dist/main.js"]
