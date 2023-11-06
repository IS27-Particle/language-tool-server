FROM alpine:latest

ENV PUID=0

RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories; \
    apk add \
    wget \
    unzip \
    attr \
    sudo \
    libc6-compat \
    openjdk21-jre-headless \
    ; \
    wget https://languagetool.org/download/LanguageTool-stable.zip; \
    unzip LanguageTool-stable.zip; \
    wget https://languagetool.org/download/ngram-data/ngrams-en-20150817.zip; \
    unzip -d /LanguageTool-6.3/en/ ngrams-en-20150817.zip; \
    rm LanguageTool-stable.zip; \
    rm ngrams-en-20150817.zip

EXPOSE 8081

ENTRYPOINT [ "java", "-cp", "/LanguageTool-6.3/languagetool-server.jar", "org.languagetool.server.HTTPServer", "--languageModel", "/LanguageTool-6.3/en", "--public", "--port", "8081", "--allow-origin", "\"*\"" ]