FROM opensearchproject/opensearch:3.9.0
MAINTAINER Justin Henderson jhenderson@hasecuritysolutions.com

USER root

RUN yum install nc -y

USER opensearch

COPY entrypoint.sh /usr/share/opensearch/entrypoint.sh

RUN rm -f /usr/share/opensearch/config/esnode* && \
    rm -f /usr/share/opensearch/config/kirk* && \
    chmod 0700 /usr/share/opensearch/config/log4j2.properties && \
    chmod 0700 /usr/share/opensearch/config && \
    /usr/share/opensearch/bin/opensearch-plugin install --batch repository-s3

# Tenant isolation: run as any UID with a read-only root filesystem.
# - home is o+x, and the stock config is kept, world-readable, as config.dist;
# - config and logs are symlinks into /run/tellaro/os. An isolated run mounts a
#   tmpfs there and copies config.dist into it before the entrypoint.
# - For runs as UID 1000 on a writable root filesystem (no tmpfs), the image
#   also ships /run/tellaro/os/config (a 0700 copy owned by 1000) and
#   /run/tellaro/os/logs, so those runs work unchanged. A tmpfs mount hides them.
USER root

RUN chmod o+x /usr/share/opensearch && \
    install -d -m 0755 -o root -g root /run/tellaro && \
    install -d -m 0700 -o 1000 -g 1000 /run/tellaro/os && \
    cp -a /usr/share/opensearch/config /run/tellaro/os/config && \
    mv /usr/share/opensearch/logs /run/tellaro/os/logs && \
    mv /usr/share/opensearch/config /usr/share/opensearch/config.dist && \
    chmod -R o+rX /usr/share/opensearch/config.dist && \
    ln -s /run/tellaro/os/config /usr/share/opensearch/config && \
    ln -s /run/tellaro/os/logs /usr/share/opensearch/logs

USER opensearch
