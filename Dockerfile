FROM composer:2.8.9 as composer

FROM php:8.4.10-alpine3.22 as build
COPY --from=composer /usr/bin/composer /usr/bin/composer
WORKDIR /app/
COPY app/ /app/
RUN export COMPOSER_ALLOW_SUPERUSER=1 && chmod a+rx /usr/bin/composer && /usr/bin/composer install --no-interaction --no-progress --optimize-autoloader

FROM pipelinecomponents/base-entrypoint:0.5.0 as entrypoint

FROM php:8.4.10-alpine3.22
COPY --from=entrypoint /entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
ENV DEFAULTCMD phpcs

ENV PATH "$PATH:/app/vendor/bin/"
COPY --from=composer /usr/bin/composer /usr/bin/composer
RUN chmod a+rx /usr/bin/composer
COPY --from=build /app/ /app/
COPY php.ini /usr/local/etc/php/php.ini

WORKDIR /code/
# Build arguments
ARG BUILD_DATE
ARG BUILD_REF

# Labels
LABEL \
    maintainer="Robbert Müller <dev@pipeline-components.dev>" \
    org.label-schema.description="PHP Codesniffer in a container for gitlab-ci" \
    org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.name="PHP Codesniffer" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.url="https://pipeline-components.gitlab.io/" \
    org.label-schema.usage="https://gitlab.com/pipeline-components/php-codesniffer/blob/main/README.md" \
    org.label-schema.vcs-ref=${BUILD_REF} \
    org.label-schema.vcs-url="https://gitlab.com/pipeline-components/php-codesniffer/" \
    org.label-schema.vendor="Pipeline Components"
