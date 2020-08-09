FROM alpine

RUN apk add --no-cache --update curl ca-certificates openssl git bash grep diffutils jq bash unzip perl sed \
    && adduser -D -h /home/container container

RUN curl -LO https://github.com/ericchiang/pup/releases/download/v0.4.0/pup_v0.4.0_linux_amd64.zip && unzip pup*.zip && mv pup /usr/bin

USER container
ENV  USER=container HOME=/home/container

WORKDIR /home/container

COPY ./entrypoint.sh /entrypoint.sh

CMD ["/bin/bash", "/entrypoint.sh"]

