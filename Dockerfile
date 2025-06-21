FROM infinyon/fluvio:latest

RUN apk update
RUN apk add curl unzip bash
RUN curl -fsS https://hub.infinyon.cloud/install/install.sh?ctx=dc | VERSION='latest' bash

RUN mv /root/.fluvio/bin/fluvio /usr/local/bin/fluvio