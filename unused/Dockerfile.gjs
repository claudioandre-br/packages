FROM claudioandre/gjs:imagem

MAINTAINER Claudio André

ENV BASE ubuntu
ENV OS claudioandre/gjs:imagem
ENV TYPE GTK

COPY build-image.sh .
RUN ./build-image.sh

