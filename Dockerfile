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
        jq \
    # Add dcron to init
	&& rc-update add dcron default \
	&& echo 'null::respawn:/sbin/syslogd -n -S -D -O /proc/1/fd/1' >> /etc/inittab \
	&& rm -fr /var/cache/apk/* \
	&& mkdir -p /var/log/cron \
    && mkdir -m 0644 -p /var/spool/cron/crontabs \
    && mkdir -m 0644 -p /etc/cron.d \
	&& sed -i '/tty/d' /etc/inittab \
	&& sed -i 's/#rc_sys=""/rc_sys="docker"/g' /etc/rc.conf \
	&& echo 'rc_provide="loopback net"' >> /etc/rc.conf \
	&& sed -i 's/^#\(rc_logger="YES"\)$/\1/' /etc/rc.conf \
	&& sed -i 's/hostname $opts/# hostname $opts/g' /etc/init.d/hostname \
	&& sed -i 's/mount -t tmpfs/# mount -t tmpfs/g' /lib/rc/sh/init.sh \
	&& sed -i 's/cgroup_add_service /# cgroup_add_service /g' /lib/rc/sh/openrc-run.sh \
	&& rm -f hwclock hwdrivers modules modules-load modloop \
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
