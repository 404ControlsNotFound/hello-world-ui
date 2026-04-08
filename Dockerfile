FROM alpine:3.21 AS build

WORKDIR /workspace

ARG APP_VERSION=dev

COPY src/ ./src/

RUN mkdir -p dist \
 && sed "s/__APP_VERSION__/${APP_VERSION}/g" src/index.html > dist/index.html \
 && sed "s/__APP_VERSION__/${APP_VERSION}/g" src/app.js > dist/app.js \
 && cp src/styles.css dist/styles.css

FROM nginxinc/nginx-unprivileged:1.29-alpine

LABEL org.opencontainers.image.title="hello-world-ui"
LABEL org.opencontainers.image.description="Static UI for an Argo CD GitOps demo"
LABEL org.opencontainers.image.source="https://github.com//hello-world-ui"

COPY nginx/default.conf /etc/nginx/conf.d/default.conf
COPY --from=build /workspace/dist/ /usr/share/nginx/html/

EXPOSE 8080

