FROM opensearchproject/opensearch:1.1.0

MAINTAINER Justin Henderson justin@hasecuritysolutions.com

USER root

COPY expect.sh /tmp/expect.sh

RUN yum install nc -y && \
    /root/expect.sh

USER opensearch

RUN rm -f /usr/share/opensearch/config/esnode* && \
    rm -f /usr/share/opensearch/config/kirk* && \
    chmod 0700 /usr/share/opensearch/config/log4j2.properties && \
    chmod 0700 /usr/share/opensearch/config && \
    /tmp/expect.sh
