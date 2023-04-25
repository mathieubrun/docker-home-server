FROM alpine:3

RUN apk add --no-cache \
    bash \
    postgresql-client

ADD https://downloads.rclone.org/rclone-current-linux-amd64.zip /tmp
RUN cd /tmp && \
    unzip rclone-current-linux-amd64.zip && \
    cd rclone-*-linux-amd64 && \
    cp rclone /usr/bin/ && \
    chown root:root /usr/bin/rclone && \
    chmod 755 /usr/bin/rclone

ENTRYPOINT [ "crond", "-f" ]