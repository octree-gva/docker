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

ENV TERM="xterm" DEBIAN_FRONTEND="noninteractive" DEBIAN_RELEASE="slim-buster" \
    DEBIAN_SUITE="oldstable"  ROOT="/home/decidim/app" HOME="/home/decidim/app" \
    DECIDIM_VERSION=${DECIDIM_VERSION} GENERATOR_PARAMS=${GENERATOR_PARAMS} \
    RAILS_ENV="development" NODE_MAJOR_VERSION=${NODE_MAJOR_VERSION} \
    BUNDLER_VERSION=${BUNDLER_VERSION} \
    BUNDLE_PATH="vendor" NODE_ENV="development"

WORKDIR /home/app/generator

RUN \
  # Update apt-get
    mkdir -p $ROOT \
    && apt-get update -yq \
  # Prepare node installation
    && apt-get install -yq ca-certificates curl gnupg \
    && mkdir -p /etc/apt/keyrings \
    && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \
    && echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR_VERSION.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list \
    && apt-get update -yq \
  # Install native deps
    && apt-get install -yq \
      build-essential \
      python3-pip \
      python3-setuptools \
      nodejs \
      tzdata \
      imagemagick \
      libicu-dev \
      libpq-dev \
      git-core \
  # Update yarn to a more recent version
    && npm -g install yarn --force \
  # Install bundler
    && gem install bundler -v $BUNDLER_VERSION \
  # Clean installation clutters
    && apt-get clean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /.root/cache \
  # Setup global bundle configurations
  # Will use /usr/local/bundle/.bundle directory
    && bundle config --global build.nokogiri --use-system-libraries \
    && bundle config --global build.charlock_holmes --with-icu-dir=/usr/include \
    && bundle config --global path "vendor" \
    && bundle config --global clean true \
  # Install the decidim generator
    && if [ -z "$DECIDIM_VERSION" ]; then \
      gem install decidim --no-document \
    ;else \
      gem install decidim -v $DECIDIM_VERSION --no-document \
    ;fi \
  # Generates the rails application at /home/decidim/app ($ROOT)
  # pass GENERATOR_PARAMS="--edge" to generate a decidim app for develop
    && decidim $ROOT --queue sidekiq $GENERATOR_PARAMS \
  # Done, remove the decidim generator.
    && gem uninstall decidim -a -x -I \
    && rm -rf /usr/local/bundle/* \
    && truncate -s 0 /var/log/*log \
    && rm -rf $ROOT/vendor $ROOT/Gemfile.lock $ROOT/package-lock.json $ROOT/yarn.lock $ROOT/node_modules $ROOT/.git $ROOT/.gem $ROOT/.npm

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
      org.opencontainers.image.title="decidim-onbuild" \
      org.opencontainers.image.description="Onbuild image for decidim, use it at base for building your images." \
      org.opencontainers.image.url="https://github.com/decidim/decidim" \
      org.opencontainers.image.revision=${VCS_REF} \
      org.opencontainers.image.source="https://github.com/decidim/decidim" \
      org.opencontainers.image.vendor="Decidim Community" \
      org.opencontainers.image.version=${VERSION} \
      org.opencontainers.image.licenses="GPL-3.0" \
      maintainer="Hadrien Froger <hadrien@octree.ch>"

ENV TERM="xterm" DEBIAN_FRONTEND="noninteractive" DEBIAN_RELEASE="slim-buster" \
    DEBIAN_SUITE="oldstable"  ROOT="/home/decidim/app" HOME="/home/decidim/app" \
    DECIDIM_VERSION=${DECIDIM_VERSION} \
    RAILS_ENV="production"  NODE_MAJOR_VERSION=${NODE_MAJOR_VERSION} \
    BUNDLER_VERSION=${BUNDLER_VERSION} \
    BUNDLE_PATH="vendor" NODE_ENV="production" \
    LD_PRELOAD="/usr/lib/x86_64-linux-gnu/libjemalloc.so.2" MALLOC_CONF="dirty_decay_ms:1000,narenas:2,background_thread:true" \
    RUBY_YJIT_ENABLE="1"

RUN \
  # Update apt-get
    mkdir -p $ROOT \
    && apt-get update -yq \
  # Prepare node installation
    && apt-get install -y ca-certificates curl gnupg \
    && mkdir -p /etc/apt/keyrings \
    && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \
    && echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR_VERSION.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list \
    && apt-get update -yq \
  # Install native deps
    && apt-get install -yq \
      build-essential \
      nodejs \
      libjemalloc2 \
      libicu-dev \
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
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /.root/cache

WORKDIR $ROOT

# COPY files from generator
COPY --from=generator /home/decidim/app /home/decidim/app/

ONBUILD RUN \
  # Be sure we are on the current workdir
    cd $ROOT \
  # Setup local bundle configurations
    && bundle config --local build.nokogiri --use-system-libraries \
    && bundle config --local build.charlock_holmes --with-icu-dir=/usr/include \
    && bundle config --local path "vendor" \
    && bundle config --local clean true