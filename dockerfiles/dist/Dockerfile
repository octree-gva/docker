ARG BASE_IMAGE \
    FROM_IMAGE \
    BUILD_DATE \
    VCS_REF \
    VERSION \
    RAILS_ENV="production" \
    BUNDLER_VERSION \
    USER_ID="1001" \
    GROUP_ID="1001" \
    NODE_MAJOR_VERSION
FROM $FROM_IMAGE as builder
ENV RAILS_ENV=${RAILS_ENV}

# If we want to run rails under something else than production, 
# we need to install first the dependancies
RUN if [ "$RAILS_ENV" != "production" ]; then \
    bundle config --global without "" \
    && bundle install \
;fi

# Backup directories that can be in volumes
# As some infrastructures will erase volumes on mount
RUN tar cfvz tmp/public.bak.tar.gz public \ 
  tar cfvz tmp/storage.bak.tar.gz storage \
  tar cfvz tmp/db.bak.tar.gz db \
  tar cfvz tmp/config.bak.tar.gz config

FROM $BASE_IMAGE
ARG BASE_IMAGE \
    FROM_IMAGE \
    BUILD_DATE \
    VCS_REF \
    VERSION \
    RAILS_ENV="production" \
    BUNDLER_VERSION \
    USER_ID="1001" \
    GROUP_ID="1001" \
    NODE_MAJOR_VERSION

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

ENV TERM="xterm" DEBIAN_FRONTEND="noninteractive" DEBIAN_RELEASE="slim-buster" \
    DEBIAN_SUITE="oldstable" ROOT="/home/decidim/app" BUNDLER_VERSION=${BUNDLER_VERSION} \
    DECIDIM_VERSION=${VERSION} GROUP_ID=${GROUP_ID} USER_ID=${USER_ID}

# Decidim specifics environments variables
ENV DATABASE_HOST="localhost" DATABASE_PASSWORD="" DATABASE_PORT="5432" \
    DATABASE_USERNAME="" DATABASE_URL="" RAILS_ENV=${RAILS_ENV} \
    SECRET_KEY_BASE="" SMTP_ADDRESS="" SMTP_DOMAIN="" SMTP_PASSWORD="" \
    SMTP_USERNAME="" DECIDIM_APPLICATION_NAME="My Application Name" \
    DECIDIM_MAILER_SENDER="change-me@example.org" SMTP_PORT="587" \
    SMTP_STARTTLS_AUTO="true" SMTP_AUTHENTICATION="plain" \
    QUEUE_ADAPTER="async" SIDEKIQ_CONCURRENCY="5" \
    DECIDIM_RUN_RAILS="1" DECIDIM_RUN_SIDEKIQ="1" DECIDIM_RUN_CRON="1" \
    NODE_MAJOR_VERSION=${NODE_MAJOR_VERSION:-"16"}

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

WORKDIR $ROOT

RUN apt-get upgrade -yq \
  && apt-get update -yq \

  && curl -sL "https://deb.nodesource.com/setup_${NODE_MAJOR_VERSION}.x" | bash - \
  && apt-get install -yq --no-install-recommends \
    build-essential libpq-dev \
    tzdata imagemagick \
    nodejs \
    # Vim the editor
    # Supervisor the program manager
    # Cron... to run cron
    # Git to fetch gemfile from git.
    vim supervisor cron git-core \
  # Re-install yarn on the newer version
  # needed to pre-compile assets
  && npm install -g yarn --force \
  # Clean installation files
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc /usr/share/man \
  && for x in `gem list --no-versions`; do gem uninstall $x -a -x -I; done \
  && gem install bundler -v $BUNDLER_VERSION \
  && truncate -s 0 /var/log/*log \
  # Add User
  && groupadd -g $GROUP_ID decidim \
  && useradd -u $USER_ID -g $GROUP_ID -r -s /bin/sh decidim \

# Add docker scripts
COPY ./bin /usr/local/bin/
# Add erb templates that will be populated at start
COPY ./templates /usr/local/share/decidim/templates
# Add scripts to run alphabetically for entrypoints
COPY ./docker-entrypoint.d /usr/local/share/docker-entrypoint.d
# Copy directories that are needed to run decidim
COPY --from=builder --chown=decidim /usr/local/bundle /usr/local/bundle
COPY --from=builder --chown=decidim $ROOT/vendor ./vendor
# Copy the shared-mime-info database
COPY --from=builder --chown=decidim /usr/share/mime  /usr/share/mime
COPY --from=builder --chown=decidim $ROOT/Gemfile* ./

# Setup bundle global config
RUN bundle config --global build.nokogiri --use-system-libraries \
  && bundle config --global build.charlock_holmes --with-icu-dir=/usr/include \
  && bundle config set --global path 'vendor' \
  # Prepare binaries and structural folders.
  && chmod +x /usr/local/bin/* \
  && mkdir -p tmp/pids log \
  && touch /etc/motd /var/run/crond.pid \
  && chown -R decidim:decidim /etc/motd $ROOT/tmp /var/run/crond.pid

USER decidim
# Copy application
COPY --from=builder --chown=decidim $ROOT ./
COPY ./crontab.d /usr/local/share/cronfiles
COPY ./crontab /etc/crontab
# Copy docker-compose and dockerfile that got
# generated by the update-registry script
COPY ./docker-compose.yml docker-compose.yml
COPY ./Dockerfile Dockerfile

ENTRYPOINT ["docker-entrypoint"]
CMD ["start"]