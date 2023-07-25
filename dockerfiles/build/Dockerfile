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
    GENERATOR_PARAMS \
    # System locale
    LOCALE="en_US.UTF-8" \
    # Build 
    BUILD_WITHOUT

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

ENV LANG=${LOCALE} LANGUAGE=${LOCALE} LC_ALL=${LOCALE} \
    TERM="xterm" DEBIAN_FRONTEND="noninteractive" DEBIAN_RELEASE="buster" \
    DEBIAN_SUITE="oldstable"  ROOT="/home/decidim/app" HOME="/home/decidim/app" \
    DECIDIM_VERSION=${DECIDIM_VERSION} GENERATOR_PARAMS=${GENERATOR_PARAMS} \
    RAILS_ENV="development" NODE_MAJOR_VERSION=${NODE_MAJOR_VERSION} BUNDLER_VERSION=${BUNDLER_VERSION} \
    BUILD_WITHOUT=${BUILD_WITHOUT}

RUN apt-get upgrade -yq \
  && apt-get update -yq \
  && apt-get install -y locales \
  && locale-gen $LANGUAGE \
  # Install node and yarn
  && curl -sL https://deb.nodesource.com/setup_${NODE_MAJOR_VERSION}.x | bash - \
  # Install native deps
  && apt-get install -yq \
    build-essential yarn git-core vim \
    tmux unzip python3-pip python3-setuptools \
    nodejs yarn tzdata \
    imagemagick libpq-dev \
  && npm -g install yarn --force \
  && gem install bundler -v $BUNDLER_VERSION \
  # Clean installation clutters
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && truncate -s 0 /var/log/*log \
  # Setup global bundle configurations
  && bundle config --global build.nokogiri --use-system-libraries \
  && bundle config --global build.charlock_holmes --with-icu-dir=/usr/include \
  && bundle config set --global path 'vendor'

WORKDIR /home/app/generator
# Generates the application to $ROOT
RUN if [ -z "$DECIDIM_VERSION" ]; then gem install decidim --no-document; else gem install decidim -v $DECIDIM_VERSION --no-document; fi \
  && decidim $ROOT --queue sidekiq $GENERATOR_PARAMS \
  && gem uninstall decidim

# Switch back to ROOT and install deps.
WORKDIR $ROOT

RUN rm -rf /home/app/generator \
  && rm -rf /usr/local/bundle/**/* \
  && bundle clean --force \
  &&  if [ -z "$BUILD_WITHOUT" ]; then bundle config --global without "$BUILD_WITHOUT"; fi\
  && bundle install --jobs "$(nproc)" --retry 3 \
  && truncate -s 0 /var/log/*log