FROM alpine:latest

EXPOSE 5050

ENV MESOS_HOME /usr/lib/mesos
ENV PATH ${PATH}:${MESOS_HOME}/bin

# Add files
ADD releases/current $MESOS_HOME
ADD scripts/secure.sh $MESOS_HOME/bin

# Set work directory
WORKDIR $MESOS_HOME

# Install Bash
RUN apk --update add bash &&\
# Cleanup
    rm -rf /tmp/* &&\
    rm -rf /var/cache/apk/* &&\
# Prepare for data and logs
    chown -R nobody:nobody $MESOS_HOME &&\
# Secure image
    bin/secure.sh

USER nobody

VOLUME ["/usr/lib/mesos/data"]


