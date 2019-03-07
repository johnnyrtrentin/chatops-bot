FROM alpine:3.6
# Dicas Sobre o Alpine: http://blog.zot24.com/tips-tricks-with-alpine-docker/
LABEL Author="Johnny Robert Trentin" 

# Dependencias Alpine
RUN apk update && apk upgrade \
  && apk add 'nodejs<6.11' \
  && apk add 'nodejs-npm<8.11' \
  && apk add 'python<2.8' \
  && apk add curl \
  && curl -sS https://bootstrap.pypa.io/get-pip.py | python \
  && npm install -g coffeescript \
  && npm install -g yo generator-hubot

# Limpeza Imagem
RUN apk --purge -v del py-pip \
  && rm -rf /var/cache/apk/*

# Create hubot user
RUN adduser -h /hubot -s /bin/bash -S hubot
USER  hubot
WORKDIR /hubot
ENV EXPRESS_PORT 8086

# INSTALACAO HUBOT
RUN yo hubot --owner="Johnny Trentin <johnny.trentin@totvs.com.br>" --name="chatOps_E2E" --description="Chatops TOTVS" --adapter=ryver --defaults
COPY package.json package.json
ADD external-scripts.json /hubot/
RUN rm hubot-scripts.json
ADD scripts/*.coffee /hubot/scripts/
RUN npm install

EXPOSE 8086

ENTRYPOINT ["/bin/sh", "-c", "./bin/hubot -a ryver"]