FROM alpine
LABEL org.opencontainers.image.source https://github.com/ahmetozer/github-actions-multi-arch-container-ghcr.io
WORKDIR /container
COPY . .
RUN chmod +x *
ENTRYPOINT [ "/container/entrypoint.sh" ]