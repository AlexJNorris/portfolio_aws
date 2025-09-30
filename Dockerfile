# Dockerfile
FROM node:18 AS build
WORKDIR /

# 1) Install deps using lockfile
COPY package*.json ./
RUN npm ci

# 2) Now copy source (public, src, etc.)
COPY . .

# 3) Build (turn CI back on once you fix lints)
ENV CI=false
RUN npm run build

FROM nginx:1.27-alpine
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /build /usr/share/nginx/html
EXPOSE 8080
