# STAGE 1
FROM node:20 AS builder

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

RUN npm run build

# FINAL STAGE

FROM nginx:alpine

WORKDIR /app

COPY --from=builder /app/build /usr/share/nginx/html

EXPOSE 80

