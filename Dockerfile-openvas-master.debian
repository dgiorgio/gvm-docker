FROM debian:stretch-20190204

ENV OS debian

ENV OPENVAS_SRC /root/openvas-src
RUN mkdir -p ${OPENVAS_SRC}
WORKDIR ${OPENVAS_SRC}

# gvm-libs
ENV APP gvm-libs
RUN mkdir -p ${OPENVAS_SRC}/${APP}
WORKDIR ${OPENVAS_SRC}/${APP}
COPY ./src/${APP}/deps/${OS}-deps.sh .
RUN chmod +x ./${OS}-deps.sh && ./${OS}-deps.sh
COPY ./src/${APP}/build.sh .
RUN chmod +x ./build.sh && ./build.sh

# gvmd
ENV APP gvmd
RUN mkdir -p ${OPENVAS_SRC}/${APP}
WORKDIR ${OPENVAS_SRC}/${APP}
COPY ./src/${APP}/deps/${OS}-deps.sh .
RUN chmod +x ./${OS}-deps.sh && ./${OS}-deps.sh
COPY ./src/${APP}/build.sh .
RUN chmod +x ./build.sh && ./build.sh

# openvas-smb
ENV APP openvas-smb
RUN mkdir -p ${OPENVAS_SRC}/${APP}
WORKDIR ${OPENVAS_SRC}/${APP}
COPY ./src/${APP}/deps/${OS}-deps.sh .
RUN chmod +x ./${OS}-deps.sh && ./${OS}-deps.sh
COPY ./src/${APP}/build.sh .
RUN chmod +x ./build.sh && ./build.sh

# openvas-scanner
ENV APP openvas-scanner
RUN mkdir -p ${OPENVAS_SRC}/${APP}
WORKDIR ${OPENVAS_SRC}/${APP}
COPY ./src/${APP}/deps/${OS}-deps.sh .
RUN chmod +x ./${OS}-deps.sh && ./${OS}-deps.sh
COPY ./src/${APP}/build.sh .
RUN chmod +x ./build.sh && ./build.sh
COPY ./src/${APP}/config/openvassd.conf /usr/local/etc/openvas/openvassd.conf
COPY ./src/${APP}/config/redis.conf /etc/redis.conf

# gsa
ENV APP gsa
RUN mkdir -p ${OPENVAS_SRC}/${APP}
WORKDIR ${OPENVAS_SRC}/${APP}
COPY ./src/${APP}/deps/${OS}-deps.sh .
RUN chmod +x ./${OS}-deps.sh && ./${OS}-deps.sh
COPY ./src/${APP}/build.sh .
RUN chmod +x ./build.sh && ./build.sh

# ssmtp
ENV APP ssmtp
RUN mkdir -p ${OPENVAS_SRC}/${APP}
WORKDIR ${OPENVAS_SRC}/${APP}
COPY ./src/${APP}/deps/${OS}-deps.sh .
RUN chmod +x ./${OS}-deps.sh && ./${OS}-deps.sh
COPY ./src/${APP}/config/ssmtp.conf /etc/ssmtp/ssmtp.conf
COPY ./src/${APP}/config/revaliases /etc/ssmtp/revaliases

WORKDIR /
RUN rm -rf ${OPENVAS_SRC}

ENV APP master
COPY ./scripts/bin/${APP}/greenbone-setup.sh /usr/local/bin
RUN chmod +x /usr/local/bin/greenbone-setup.sh

COPY ./scripts/entrypoint/${APP}/docker-entrypoint.sh /usr/local/bin
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

VOLUME ["/usr/local/var/lib/openvas", "/usr/local/var/lib/gvm"]
EXPOSE 80 443 9390 9391 9392
