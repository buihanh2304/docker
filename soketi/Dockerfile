ARG NODE_VERSION=16-debian
ARG BASE_IMAGE_TAG_PREFIX=latest
FROM quay.io/soketi/soketi:${BASE_IMAGE_TAG_PREFIX}-${NODE_VERSION}

LABEL maintainer="WuweiMing <wwm041544363@gmail.com>"

COPY config.json /app/bin/config.json

CMD ["--config=/app/bin/config.json"]

EXPOSE 6001 9601
