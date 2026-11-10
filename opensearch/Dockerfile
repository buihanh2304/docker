ARG OPENSEARCH_VERSION
FROM opensearchproject/opensearch:${OPENSEARCH_VERSION}

ARG PUID=1000
ENV PUID ${PUID}
ARG PGID=1000
ENV PGID ${PGID}

USER root
RUN groupmod -o -g ${PGID} opensearch && \
    usermod -o -u ${PUID} opensearch && \
    chown -R opensearch:opensearch /usr/share/opensearch

USER opensearch

EXPOSE 9200 9600
