FROM alpine
WORKDIR /container
COPY . .
RUN chmod +x *
ENTRYPOINT [ "/container/entrypoint.sh" ]