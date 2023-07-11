ARG BASE_IMAGE
ARG FROM_IMAGE
ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
ARG RAILS_ENV
FROM $FROM_IMAGE as builder
FROM $BASE_IMAGE

LABEL org.label-schema.build-date=${BUILD_DATE} \
      org.label-schema.name="decidim" \
      org.label-schema.description="Docker image for decidim" \
      org.label-schema.url="https://github.com/decidim/docker" \
      org.label-schema.vcs-ref=${VCS_REF} \
      org.label-schema.vcs-url="https://github.com/decidim/decidim" \
      org.label-schema.vendor="Decidim Community" \
      org.label-schema.version=${VERSION} \
      org.label-schema.schema-version="1.0.0-rc.1" \
      org.opencontainers.image.created=${BUILD_DATE} \
      org.opencontainers.image.title="decidim" \
      org.opencontainers.image.description="Docker image for decidim" \
      org.opencontainers.image.url="https://github.com/decidim/decidim" \
      org.opencontainers.image.revision=${VCS_REF} \
      org.opencontainers.image.source="https://github.com/decidim/decidim" \
      org.opencontainers.image.vendor="Decidim Community" \
      org.opencontainers.image.version=${VERSION} \
      org.opencontainers.image.licenses="GPL-3.0" \
      maintainer="Hadrien Froger <hadrien@octree.ch>"

ENV LANG="en_US.UTF-8" LANGUAGE="en_US.UTF-8" LC_ALL="en_US.UTF-8" \
    TERM="xterm" DEBIAN_FRONTEND="noninteractive" DEBIAN_RELEASE="buster" \
    DEBIAN_SUITE="oldstable" ROOT="/home/decidim/app"

# Decidim specifics environments variables
ENV DATABASE_HOST="localhost" DATABASE_PASSWORD="" DATABASE_PORT="5432" \
    DATABASE_USERNAME="" DATABASE_URL="" RAILS_ENV="development" \
    SECRET_KEY_BASE="" SMTP_ADDRESS="" SMTP_DOMAIN="" SMTP_PASSWORD="" \
    SMTP_USERNAME="" DECIDIM_APPLICATION_NAME="My Application Name" \
    DECIDIM_MAILER_SENDER="change-me@example.org" SMTP_PORT="587" \
    SMTP_STARTTLS_AUTO="true" SMTP_AUTHENTICATION="plain" \
    QUEUE_ADAPTER="async" SIDEKIQ_CONCURRENCY="5"

ENV STORAGE_PROVIDER="local" STORAGE_CDN_HOST="" AWS_ACCESS_KEY_ID="" \
    AWS_SECRET_ACCESS_KEY="" AWS_BUCKET="" AWS_REGION="" AWS_ENDPOINT="" \
    AZURE_STORAGE_ACCESS_KEY="" AZURE_STORAGE_ACCOUNT_NAME="" AZURE_CONTAINER="" \
    GCS_PROJECT="" GCS_BUCKET="" GCS_TYPE="service_account" \
    GCS_PROJECT_ID="" GCS_PRIVATE_KEY_ID="" GCS_PRIVATE_KEY="" \
    GCS_CLIENT_EMAIL="" GCS_CLIENT_ID="" \
    GCS_AUTH_URI="https://accounts.google.com/o/oauth2/auth" \
    GCS_TOKEN_URI="https://accounts.google.com/o/oauth2/token" \
    GCS_AUTH_PROVIDER_X509_CERT_URL="https://www.googleapis.com/oauth2/v1/certs" \
    GCS_CLIENT_X509_CERT_URL=""

ENV MAPS_PROVIDER="" MAPS_API_KEY="" \
    MAPS_DYNAMIC_URL="" MAPS_STATIC_URL="https://image.maps.ls.hereapi.com/mia/1.6/mapview" \
    MAPS_ATTRIBUTION="" MAPS_EXTRA_VARS="" MAPS_GEOCODING_HOST="" \
    MAPS_DYNAMIC_PROVIDER="" MAPS_STATIC_PROVIDER="" MAPS_STATIC_API_KEY="" \
    MAPS_DYNAMIC_API_KEY="" ETHERPAD_SERVER="" ETHERPAD_API_KEY="" \
    ETHERPAD_API_VERSION="1.2.1" OMNIAUTH_FACEBOOK_APP_ID="" \
    OMNIAUTH_FACEBOOK_APP_SECRET="" OMNIAUTH_GOOGLE_CLIENT_ID="" \
    OMNIAUTH_GOOGLE_CLIENT_SECRET="" OMNIAUTH_TWITTER_API_KEY="" \
    OMNIAUTH_TWITTER_API_SECRET="" BULLETIN_BOARD_SERVER="" \
    BULLETIN_BOARD_PUBLIC_KEY="" BULLETIN_BOARD_API_KEY=""

RUN apt-get upgrade -yq \
  && apt-get update -yq \
  && apt-get install -yq gnupg2 
RUN curl -sL https://deb.nodesource.com/setup_${NODE_MAJOR_VERSION}.x | bash - \
  && apt-get install -yq --no-install-recommends \
    git-core tzdata imagemagick pkg-config \
    libxml2-dev libxslt-dev nodejs npm vi \
    libpq-dev shared-mime-info locales locales-all \
  && npm install -g yarn --force \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && truncate -s 0 /var/log/*log

WORKDIR $ROOT

# Setup bundle global config
RUN bundle config --global build.nokogiri --use-system-libraries \
  && bundle config --global build.charlock_holmes --with-icu-dir=/usr/include \
  && bundle config set --global path 'vendor'

# Copy directories that are needed to run decidim
# We copy one by one to take advantage of docker cache
COPY --from=builder /usr/local/bundle /usr/local/bundle
COPY --from=builder $ROOT/vendor ./vendor
COPY --from=builder /usr/share/mime  /usr/share/mime
COPY --from=builder $ROOT/config.ru $ROOT/Rakefile ./
COPY --from=builder $ROOT/public ./public
COPY --from=builder $ROOT/storage ./storage
COPY --from=builder $ROOT/lib ./lib
COPY --from=builder $ROOT/bin ./bin
COPY --from=builder $ROOT/db ./db
COPY --from=builder $ROOT/config ./config
COPY --from=builder $ROOT/Gemfile* ./
COPY --from=builder $ROOT/app ./app

COPY --chmod=0755 ./bin/* /usr/local/bin/
COPY ./templates /usr/local/share/decidim/templates
COPY ./docker-entrypoint.d /usr/local/share/docker-entrypoint.d
COPY ./crontab.d /usr/local/share/cronfiles

# Backup directories that will be mounted in volumes
# because several Docker infrastructure will clean the 
# directories on volumes mounts.
RUN mkdir -p ./tmp/pids ./log \
  && tar cfvz ./tmp/public.bak.tar.gz public \
  && tar cfvz ./tmp/config.bak.tar.gz config \
  && tar cfvz ./tmp/db.bak.tar.gz db

RUN bundle install

VOLUME db
VOLUME public
VOLUME config

ENTRYPOINT ["docker-entrypoint"]
