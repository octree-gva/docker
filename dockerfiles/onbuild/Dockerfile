ARG BASE_IMAGE
##########################################################################
# STEP 1: GENERATOR
##########################################################################
FROM $BASE_IMAGE as generator
ARG BUILD_DATE \
    # Commit reference
    VCS_REF \
    # Version of Decidim
    VERSION \
    DECIDIM_VERSION \
    # Node used
    NODE_MAJOR_VERSION \
    # Bundler used
    BUNDLER_VERSION \
    # Optional paramenters for the generator (ex: --edge)
    GENERATOR_PARAMS 

ENV TERM="xterm" DEBIAN_FRONTEND="noninteractive" DEBIAN_RELEASE="buster" \
    DEBIAN_SUITE="oldstable"  ROOT="/home/decidim/app" HOME="/home/decidim/app" \
    DECIDIM_VERSION=${DECIDIM_VERSION} GENERATOR_PARAMS=${GENERATOR_PARAMS} \
    RAILS_ENV="development" NODE_MAJOR_VERSION=${NODE_MAJOR_VERSION} \
    BUNDLER_VERSION=${BUNDLER_VERSION} BUNDLE_USER_HOME="/home/decidim/app/.bundle"\
    BUNDLE_PATH="vendor" NODE_ENV="development"

WORKDIR /home/app/generator

RUN \
  # Update apt-get
    mkdir -p $ROOT \
    && apt-get upgrade -yq \
    && apt-get update -yq \
  # Prepare node installation
    && curl -sL https://deb.nodesource.com/setup_${NODE_MAJOR_VERSION}.x | bash - \
  # Install native deps
    && apt-get install -yq \
      build-essential \
      python3-pip \
      python3-setuptools \
      nodejs \
      tzdata \
      imagemagick \
      libpq-dev \
  # Update yarn to a more recent version
    && npm -g install yarn --force \
  # Install bundler
    && gem install bundler -v $BUNDLER_VERSION \
  # Clean installation clutters
    && apt-get clean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /.root/cache \
  # Setup local bundle configurations
    && bundle config --global build.nokogiri --use-system-libraries \
    && bundle config --global build.charlock_holmes --with-icu-dir=/usr/include \
    && bundle config --local path "$BUNDLE_PATH" \
  # Install the decidim generator
    && if [ -z "$DECIDIM_VERSION" ]; then gem install decidim --no-document; else gem install decidim -v $DECIDIM_VERSION --no-document; fi \
  # Generates the rails application at /home/decidim/app ($ROOT)
  # pass GENERATOR_PARAMS="--edge" to generate a decidim app for develop
    && decidim $ROOT --queue sidekiq $GENERATOR_PARAMS \
  # Done, remove the decidim generator.
    && gem uninstall decidim -a -x -I \
    && rm -rf /usr/local/bundle/* \
    && truncate -s 0 /var/log/*log \
    && rm -rf $ROOT/vendor $ROOT/Gemfile.lock $ROOT/package-lock.json $ROOT/node_modules

##########################################################################
# STEP 2: Base image
##########################################################################
FROM $BASE_IMAGE
ARG BUILD_DATE \
    # Commit reference
    VCS_REF \
    # Version of Decidim
    VERSION \
    DECIDIM_VERSION \
    # Node used
    NODE_MAJOR_VERSION \
    # Bundler used
    BUNDLER_VERSION \
    # Optional paramenters for the generator (ex: --edge)
    GENERATOR_PARAMS 

LABEL org.label-schema.build-date=${BUILD_DATE} \
      org.label-schema.name="decidim" \
      org.label-schema.description="Decidim base image" \
      org.label-schema.url="https://github.com/decidim/docker" \
      org.label-schema.vcs-ref=${VCS_REF} \
      org.label-schema.vcs-url="https://github.com/decidim/decidim" \
      org.label-schema.vendor="Decidim Community" \
      org.label-schema.version=${VERSION} \
      org.label-schema.schema-version="1.0.0-rc.1" \
      org.opencontainers.image.created=${BUILD_DATE} \
      org.opencontainers.image.title="decidim-build" \
      org.opencontainers.image.description="Build image for decidim" \
      org.opencontainers.image.url="https://github.com/decidim/decidim" \
      org.opencontainers.image.revision=${VCS_REF} \
      org.opencontainers.image.source="https://github.com/decidim/decidim" \
      org.opencontainers.image.vendor="Decidim Community" \
      org.opencontainers.image.version=${VERSION} \
      org.opencontainers.image.licenses="GPL-3.0" \
      maintainer="Hadrien Froger <hadrien@octree.ch>"


ENV TERM="xterm" DEBIAN_FRONTEND="noninteractive" DEBIAN_RELEASE="buster" \
    DEBIAN_SUITE="oldstable"  ROOT="/home/decidim/app" HOME="/home/decidim/app" \
    DECIDIM_VERSION=${DECIDIM_VERSION} \
    RAILS_ENV="production" NODE_MAJOR_VERSION=${NODE_MAJOR_VERSION} \
    BUNDLER_VERSION=${BUNDLER_VERSION} BUNDLE_USER_HOME="/home/decidim/app/.bundle"\
    BUNDLE_PATH="vendor" NODE_ENV="production"

RUN \
  # Update apt-get
    mkdir -p $ROOT \
    && apt-get upgrade -yq \
    && apt-get update -yq \
  # Prepare node installation
    && curl -sL https://deb.nodesource.com/setup_${NODE_MAJOR_VERSION}.x | bash - \
  # Install native deps
    && apt-get install -yq \
      build-essential \
      nodejs \
      tzdata \
      imagemagick \
      libpq-dev \
  # Update yarn to a more recent version
    && npm -g install yarn --force \
  # Install bundler
    && gem install bundler -v $BUNDLER_VERSION \
  # Clean installation clutters
    && apt-get clean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /.root/cache \

WORKDIR $ROOT

# COPY files from generator
COPY --from=generator /home/decidim/app /home/decidim/app/

RUN \
  # Setup local bundle configurations
    bundle config --local build.nokogiri --use-system-libraries \
    && bundle config --local build.charlock_holmes --with-icu-dir=/usr/include \
    && bundle config --local path "$BUNDLE_PATH" 

ONBUILD RUN \
  # Check the current environment, if we are in dev or test, 
  # install everything
    if [ "$RAILS_ENV" = "development" ] || [ "$RAILS_ENV" = "test" ]; then \
        rm -rf $ROOT/vendor $ROOT/package-lock.json node_modules \
        && bundle config --local without "" \
        && bundle install \
        && NODE_ENV=development npm install \
    else \
      bundle config --local without "test:development" \
      && bundle install \
      && NODE_ENV=production npm install --production \
    ;fi \
  # Cleanup
    && bundle clean --force  \
    && rm -rf ./.bundle/cache ./vendor/cache /usr/local/bundle/* \
    && truncate -s 0 /var/log/*log
  # Precompile the application with bootsnap.
  # Check tmp/cache/bootsnap*
    && bundle exec bootsnap precompile --gemfile app/ lib/ || true \
  # In many infrastructures, volumes might remove
  # bounded directories. Keep a copy of essentials 
  # files in tmp/ directory can save some lifes
    && mkdir -p $ROOT/tmp \
    && tar cfvz tmp/public.bak.tar.gz public \ 
    && tar cfvz tmp/storage.bak.tar.gz storage \
    && tar cfvz tmp/db.bak.tar.gz db \
    && tar cfvz tmp/config.bak.tar.gz config