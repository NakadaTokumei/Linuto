FROM ubuntu:18.04

WORKDIR /image
ARG LINUX_VERSION
COPY image/$LINUX_VERSION/ image/

WORKDIR /app
COPY app/ app/

RUN apt-get update
RUN apt-get install -y qemu-system-x86

CMD [ "sh", "app/container.sh" ]