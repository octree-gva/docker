ARG BASE_IMAGE\
    BUILD_DATE \
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
    GENERATOR_PARAMS  \
    GROUP_ID \
    USER_ID

##########################################################################
# GENERATOR
# Generate a new Rails app with the decidim generator.
##########################################################################
FROM $BASE_IMAGE as generator
# An ARG instruction goes out of scope at the end of the build stage where it was defined. 
# To use an arg in multiple stages, each stage must include the ARG instruction.
ARG BASE_IMAGE BUILD_DATE VCS_REF VERSION DECIDIM_VERSION NODE_MAJOR_VERSION BUNDLER_VERSION GENERATOR_PARAMS GROUP_ID USER_ID

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
    && rm -rf $ROOT/vendor \
       $ROOT/package-lock.json $ROOT/yarn.lock \
       $ROOT/node_modules $ROOT/.git \
       $ROOT/.gem $ROOT/.npm \
       $ROOT/.local \
       $ROOT/.bundle $ROOT/tmp/* 

##########################################################################
# BASE
# A docker base image, with no code, but all the dependancies
# and common configuration needed
##########################################################################
FROM $BASE_IMAGE as base
ARG BASE_IMAGE BUILD_DATE VCS_REF VERSION DECIDIM_VERSION NODE_MAJOR_VERSION BUNDLER_VERSION GENERATOR_PARAMS GROUP_ID USER_ID
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
    DECIDIM_VERSION=${DECIDIM_VERSION} GROUP_ID=${GROUP_ID} USER_ID=${USER_ID} EDITOR="vim"\
    PATH="$PATH:/home/decidim/app/bin" \
    RAILS_ENV="production"  NODE_MAJOR_VERSION=${NODE_MAJOR_VERSION} \
    BUNDLER_VERSION=${BUNDLER_VERSION} \
    NODE_ENV="production" \
    RUBY_YJIT_ENABLE="1" 

RUN \
  # Update apt-get
    apt-get update -yq \
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
      libpq-dev \
      imagemagick \
      git-core \
      vim \
      cron \
  # Update yarn to a more recent version
    && npm -g install yarn --force \
  # Install bundler
    && gem install bundler -v $BUNDLER_VERSION \
  # Clean installation clutters
    && gem cleanup bundler \
    && apt-get clean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc /usr/share/man /.root/cache   \
    && for x in `gem list --no-versions`; do gem uninstall $x -a -x -I; done \
  # Add a non-root user
    && groupadd -g $GROUP_ID decidim \
    && useradd -u $USER_ID -g $GROUP_ID -d $ROOT -r -s /bin/sh decidim \
  # Configure bundler
    && bundle config set build.nokogiri --use-system-libraries \
    && bundle config set build.nokogiri --use-system-libraries \
    && bundle config set build.charlock_holmes --with-icu-dir=/usr/include \
    && bundle config set cache_all false \
    && bundle config set clean false \
    && bundle config set path "vendor"

# libjemalloc2 is installed, can set the env.
ENV LD_PRELOAD="/usr/lib/x86_64-linux-gnu/libjemalloc.so.2" \
  MALLOC_CONF="dirty_decay_ms:1000,narenas:2,background_thread:true"

WORKDIR $ROOT

COPY ./imagetragick.xml $ROOT/tmp/
COPY ./Dockerfile ./docker-compose.yml ./
COPY ./docker-entrypoint.d /usr/local/share/docker-entrypoint.d
# Templates used by our `45_template` docker-entrypoint script. 
COPY ./templates /usr/local/share/decidim/templates
# Copy cron files
COPY ./crontab.d /etc/crontab.d

RUN \
  # Add imagemagick's policy to avoid 
  #   CVE-2016-3714
  #   CVE-2016-3718 - SSRF
  #   CVE-2016-3716
  #   CVE-2016-3717
  # There is no simple way to get the policy.xml path, so we need some magics:
    IMAGEMAGIC_POLICY=$(convert -list policy | grep Path: | awk '{print $2}' | head -n 1) && mv $ROOT/tmp/imagetragick.xml $IMAGEMAGIC_POLICY \
  # Allow motd to be written by our docker-entrypoint script
    && touch /etc/motd  \
    && chown decidim:decidim /etc/motd \
  # Setup crontab (need to run image as root)
    && touch /var/run/crond.pid \
    && crontab /etc/crontab.d/crontab \
  # Symlink logs to a common linux place
    && ln -s $ROOT/log /var/log/decidim \
    && truncate -s 0 /var/log/*log


##########################################################################
# PRODUCTION_BUNDLE
# Installation of application gems for production
##########################################################################
FROM base as production_bundle
COPY --from=generator $ROOT/Gemfile $ROOT/Gemfile.lock .
RUN bundle config set without "development:test" \
  && bundle install --quiet \
  && rm -rf vendor/cache .bundle/cache

##########################################################################
# DEVELOPMENT_BUNDLE
# Installation of application gems for development
##########################################################################
FROM base as development_bundle
ENV NODE_ENV="development" \
  RAILS_ENV="development"
COPY --from=generator $ROOT/Gemfile $ROOT/Gemfile.lock .
RUN bundle config set without "" \
  && bundle install --quiet \
  && rm -rf vendor/cache .bundle/cache

##########################################################################
# ASSETS
# Precompile assets
##########################################################################
FROM base as assets
ENV NODE_ENV="development" \
  RAILS_ENV="development"
COPY --from=generator $ROOT/package.json .
RUN npm install
COPY --from=generator $ROOT .
COPY --from=development_bundle $ROOT/vendor ./vendor
COPY --from=development_bundle $ROOT/Gemfile.lock .
RUN bundle exec rails assets:precompile

##########################################################################
# DECIDIM PRODUCTION ONBUILD
# Onbuild production image, to help other to create their own decidim
# customized application.
##########################################################################
FROM base as decidim-production-onbuild
CMD ["bundle", "exec", "puma"]
COPY --from=generator --chown=decidim:decidim $ROOT .
COPY --from=production_bundle --chown=decidim:decidim $ROOT/vendor ./vendor
COPY --from=production_bundle --chown=decidim:decidim $ROOT/Gemfile.lock .
COPY ./bin/* bin/

# Onbuild image will probably have they own gem, no need to ship
# vendors.
RUN rm -rf $ROOT/vendor 
ENTRYPOINT "./bin/docker-entrypoint"

##########################################################################
# DECIDIM PRODUCTION 
# To run a fresh Decidim application (non-root mode).
##########################################################################
FROM base as decidim-production
ENV BUNDLE_APP_CONFIG="/home/decidim/app" 
USER decidim
COPY --from=generator $ROOT .
COPY --from=assets $ROOT/public/decidim-packs ./public/decidim-packs
COPY --from=production_bundle $ROOT/vendor ./vendor
COPY --from=production_bundle $ROOT/Gemfile.lock .
COPY ./bin/* bin/
ENTRYPOINT "./bin/docker-entrypoint"
CMD ["bundle", "exec", "puma"]

##########################################################################
# DECIDIM DEVELOPMENT 
# To run Decidim in development mode (root mode).
##########################################################################
FROM base as decidim-development
ENV NODE_ENV="development" \
  RAILS_ENV="development"
COPY ./bin/* bin/
COPY --from=generator $ROOT .
COPY --from=assets $ROOT/public/decidim-packs ./public/decidim-packs
COPY --from=assets $ROOT/package-lock.json ./
COPY --from=assets $ROOT/node_modules ./node_modules
COPY --from=development_bundle $ROOT/Gemfile.lock ./
COPY --from=development_bundle $ROOT/vendor ./vendor
RUN bundle config set without "" \
    bundle binstubs webpack-dev-server
ENTRYPOINT "./bin/docker-entrypoint"
CMD ["bundle", "exec", "puma"]
