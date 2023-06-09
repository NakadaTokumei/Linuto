FROM ubuntu:18.04

WORKDIR /app
COPY app/ app/

ARG LINUX_VERSION
COPY image/$LINUX_VERSION/* image/

COPY drivers/ drivers/

RUN apt-get update
RUN apt-get install -y qemu-system-x86
RUN apt-get install -y telnet
RUN apt-get install -y kmod

CMD [ "sh", "app/container.sh" ]