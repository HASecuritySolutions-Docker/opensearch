FROM opensearchproject/opensearch:1.3.1

MAINTAINER Justin Henderson justin@hasecuritysolutions.com

USER root

RUN yum install nc -y

USER opensearch

RUN rm -f /usr/share/opensearch/config/esnode* && \
    rm -f /usr/share/opensearch/config/kirk* && \
    chmod 0700 /usr/share/opensearch/config/log4j2.properties && \
    chmod 0700 /usr/share/opensearch/config && \
    /usr/share/opensearch/bin/opensearch-plugin install --batch repository-s3
