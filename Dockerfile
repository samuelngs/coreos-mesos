FROM alpine:latest

EXPOSE 5050

ENV JAVA_HOME /usr/lib/jvm/default-jvm
ENV MAVEN_HOME /usr/share/java/maven-3.3.3

ENV MESOS_HOME /usr/lib/mesos
ENV PATH ${PATH}:${JAVA_HOME}/bin:${MAVEN_HOME}/bin:${MESOS_HOME}/bin

# Add files
ADD releases/current $MESOS_HOME
ADD scripts/secure.sh $MESOS_HOME/bin

# Set work directory
WORKDIR $MESOS_HOME

RUN echo http://dl-4.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories &&\
# Install Deps
    apk add --update alpine-sdk zlib-dev curl-dev apr-dev subversion-dev cyrus-sasl-dev cyrus-sasl-crammd5 openjdk7-jre maven python-dev fts-dev linux-headers &&\
# Cleanup
    rm -rf /tmp/* \
           /var/cache/apk/* &&\
# Prepare for data and logs
    chown -R nobody:nobody $MESOS_HOME &&\
# run configure
    ./configure &&\
# build mesos from source
    make

VOLUME ["/usr/lib/mesos/data"]


