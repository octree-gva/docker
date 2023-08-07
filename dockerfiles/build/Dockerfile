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
    BUNDLE_PATH="vendor"

WORKDIR /home/app/generator

RUN apt-get upgrade -yq \
  && apt-get update -yq \
  # Install node and yarn
  && curl -sL https://deb.nodesource.com/setup_${NODE_MAJOR_VERSION}.x | bash - \
  # Install native deps
  && apt-get install -yq \
    build-essential vim \
    python3-pip python3-setuptools \
    nodejs tzdata \
    imagemagick libpq-dev \
  && npm -g install yarn --force \
  && gem install bundler -v $BUNDLER_VERSION \
  # Clean installation clutters
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /.root/cache \
  && truncate -s 0 /var/log/*log \
  # Setup local bundle configurations
  && bundle config --global build.nokogiri --use-system-libraries \
  && bundle config --global build.charlock_holmes --with-icu-dir=/usr/include \
  # Generates the application to $ROOT
  && if [ -z "$DECIDIM_VERSION" ]; then gem install decidim --no-document; else gem install decidim -v $DECIDIM_VERSION --no-document; fi \
  && decidim $ROOT --queue sidekiq $GENERATOR_PARAMS \
  && gem uninstall decidim -a -x -I

# Switch back to ROOT and install deps.
WORKDIR $ROOT

RUN rm -rf /home/app/generator \
  && rm -rf /usr/local/bundle/**/* \
  && rm -rf vendor Gemfile.lock \
  && bundle clean --force \
  && bundle config --local without "test:development" \
  && bundle install --jobs "$(nproc)" --retry 3 \
  && truncate -s 0 /var/log/*log