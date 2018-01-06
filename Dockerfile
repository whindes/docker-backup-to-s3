FROM alpine:3.7
LABEL maintainer="William Hindes <bhindes@hotmail.com>"

ADD ./config /tmp

RUN apk update \
    && apk add --no-cache \
        bash \
        python \
        py-pip \
        openrc \
        dcron \
    && rm -rf /var/cache/apk/* \
    && pip install s3cmd \
    && mv /tmp/s3cfg /root/.s3cfg \
    && mv /tmp/start.sh /start.sh \
    && chmod +x /start.sh \
    && mv /tmp/sync.sh /sync.sh \
    && chmod +x /sync.sh \
    && mv /tmp/get.sh /get.sh \
    && chmod +x /get.sh \
    && rm -rf /tmp/*

ENTRYPOINT ["/start.sh"]
CMD [""]
