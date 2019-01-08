FROM composer:1.8 as build

COPY app/ /app/
RUN composer install --no-interaction --no-progress --optimize-autoloader
WORKDIR /app/

FROM php:7.2-alpine3.8
ENV PATH "$PATH:/app/vendor/bin/"
COPY --from=build /app/ /app/

WORKDIR /code/
# Build arguments
ARG BUILD_DATE
ARG BUILD_REF

# Labels
LABEL \
    maintainer="Robbert Müller <spam.me@grols.ch>" \
    org.label-schema.description="PHP Codesniffer in a container for gitlab-ci" \
    org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.name="PHP Codesniffer" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.url="https://pipeline-components.gitlab.io/" \
    org.label-schema.usage="https://gitlab.com/pipeline-components/php-codesniffer/blob/master/README.md" \
    org.label-schema.vcs-ref=${BUILD_REF} \
    org.label-schema.vcs-url="https://gitlab.com/pipeline-components/php-codesniffer/" \
    org.label-schema.vendor="Pipeline Components"
