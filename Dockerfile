FROM alpine:latest

ENV PUID=0
ENV PGID=0

RUN apk add \
    wget \
    unzip \
    java \
    ; \
    wget https://languagetool.org/download/LanguageTool-stable.zip; \
    unzip LanguageTool-stable.zip; \
    echo -e \#\!/bin/bash > LanguageTool-stable/init; \
    echo sudo -u ${PUID} -g ${PGID} languagetool --http --port 8081 --allow-origin "*" > LanguageTool-stable/init; \
    chmod u+x LanguageTool-stable/init; \
    wget https://download.oracle.com/java/21/latest/jdk-21_linux-aarch64_bin.tar.gz; \
    cd /opt/java; \
    sudo tar -zxvf jdk-21_linux-aarch64_bin.tar.gz; \
    ln -s /opt/java/jdk1.8.0_121 /opt/java/current; \
    echo export JAVA_HOME=/opt/java/current > /etc/profile.d/java.sh; \
    echo export PATH=$PATH:$JAVA_HOME/bin >> /etc/profile.d/java.sh; \
    sh /etc/profile.d/java.sh; \
    which paxctl || apk add paxctl; \
    cd current/bin; \
    paxctl -c java; \
    paxctl -m java; \
    paxctl -c javac; \
    paxctl -m javac; \
    setfattr -n user.pax.flags -v "mr" java; \
    setfattr -n user.pax.flags -v "mr" javac

WORKDIR "$(pwd)/LanguageTool-stable"

ENTRYPOINT [ "./init" ]