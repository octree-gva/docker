ARG BASE_IMAGE
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
      org.label-schema.description="Build image for decidim" \
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
      build-essential vim \
      python3-pip python3-setuptools \
      nodejs tzdata \
      imagemagick libpq-dev \
  # Update yarn to a more recent version
    && npm -g install yarn --force \
  # Install bundler
    && gem install bundler -v $BUNDLER_VERSION \
  # Clean installation clutters
    && apt-get clean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /.root/cache \
    && truncate -s 0 /var/log/*log \
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
    && rm -rf /usr/local/bundle/cache

# Switch back to ROOT and install deps.
WORKDIR $ROOT

RUN \
  # Remove old saved stuff
    rm -rf /home/app/generator \
  # Remove old vendors and lock files, to 
  # keep only production gems and node packages.
    && rm -rf vendor Gemfile.lock package-lock.json node_modules \
    && bundle config --local without "test:development" \
    && bundle config --local path "$BUNDLE_PATH" \
    && bundle install \
    && npm install --production \
  # Cleanup
    && bundle clean --force  \
    && rm -rf ./.bundle/cache ./vendor/cache /usr/local/bundle/* \
    && truncate -s 0 /var/log/*log