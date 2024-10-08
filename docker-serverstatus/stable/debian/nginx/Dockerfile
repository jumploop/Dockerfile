# The Dockerfile for build localhost source, not git repo
FROM debian:stable-slim AS builder

LABEL maintainer="jumploop"
ARG WORK=/root
ARG BRANCH=master

RUN apt-get update && apt-get -y install gcc g++ make libcurl4-openssl-dev wget unzip

RUN wget -q --no-check-certificate https://github.com/jumploop/ServerStatus/archive/refs/heads/$BRANCH.zip -P $WORK && \
    unzip $WORK/$BRANCH.zip -d $WORK && rm -rf $WORK/*.zip

WORKDIR $WORK/ServerStatus-$BRANCH/server

RUN make -j
RUN pwd && ls -a
RUN mv $WORK/ServerStatus-$BRANCH/* /
# glibc env run
FROM nginx:latest
RUN ln -sf /dev/null /var/log/nginx/access.log && ln -sf /dev/null /var/log/nginx/error.log
RUN mkdir -p /ServerStatus/server/
WORKDIR /ServerStatus/server/
COPY --from=builder server /ServerStatus/server/
COPY --from=builder web /usr/share/nginx/html/
COPY ./start_nginx.sh ./
RUN chmod +x ./start_nginx.sh
# china time
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

EXPOSE 80 35601
HEALTHCHECK --interval=5s --timeout=3s --retries=3 CMD curl --fail http://localhost:80 || bash -c 'kill -s 15 -1 && (sleep 10; kill -s 9 -1)'
CMD ["./start_nginx.sh"]
