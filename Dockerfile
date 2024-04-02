FROM quay.io/fedora/nodejs-20:latest as builder

USER 0

WORKDIR /app

COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build && \
  chmod -R u=rwX,g=rX,o=rX dist

FROM registry.fedoraproject.org/fedora:39

RUN dnf -y install nginx && \
  dnf clean all

COPY --from=builder /app/dist /app
COPY nginx /etc/nginx

USER 1001
EXPOSE 8080

ENTRYPOINT ["/usr/sbin/nginx"]
CMD ["-g", "daemon off;"]
