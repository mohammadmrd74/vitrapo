# Base image
FROM node:22

# Create app directory
WORKDIR /usr/src/app

# A wildcard is used to ensure both package.json AND package-lock.json are copied
RUN npm i -g pnpm

COPY package*.json ./
COPY pnpm-lock.yaml ./

# RUN npm config set strict-ssl false

# Install app dependencies
RUN pnpm install

# Bundle app source
COPY . .

RUN npx prisma generate
# Creates a "dist" folder with the production build
RUN pnpm build


# Start the server using the production build
CMD [ "node", "dist/main.js" ]