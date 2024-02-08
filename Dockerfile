ARG BASE_IMAGE\
    BUILD_DATE \
    # Commit reference
    VCS_REF \
    # Version of Decidim
    VERSION \
    DECIDIM_VERSION \
    GENERATOR_GEMINSTALL \
    # Node used
    NODE_MAJOR_VERSION \
    # Bundler used
    BUNDLER_VERSION \
    # Optional paramenters for the generator (ex: --edge)
    GENERATOR_PARAMS  \
    GROUP_ID \
    USER_ID

FROM $BASE_IMAGE as ruby_base
# An ARG instruction goes out of scope at the end of the build stage where it was defined. 
# To use an arg in multiple stages, each stage must include the ARG instruction.
ARG BASE_IMAGE BUILD_DATE VCS_REF VERSION DECIDIM_VERSION GENERATOR_GEMINSTALL NODE_MAJOR_VERSION BUNDLER_VERSION GENERATOR_PARAMS GROUP_ID USER_ID
ENV TERM="xterm" DEBIAN_FRONTEND="noninteractive" \
    DEBIAN_SUITE="stable"  ROOT="/home/decidim/app" HOME="/home/decidim/app" \
    DECIDIM_VERSION=${DECIDIM_VERSION} \
    GROUP_ID=${GROUP_ID} USER_ID=${USER_ID} \
    EDITOR="vim" \
    PATH="$PATH:/home/decidim/app/bin" \
    RAILS_ENV="production"  \
    NODE_ENV="production" \
    NODE_MAJOR_VERSION=${NODE_MAJOR_VERSION} \
    BUNDLER_VERSION=${BUNDLER_VERSION} \
    RUBY_YJIT_ENABLE="1" \
    LANG=C.UTF-8 \
    BUNDLE_JOBS=4 \
    BUNDLE_RETRY=3
    
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

RUN \
  # Update apt-get
    apt-get update -yq \
  # Prepare node installation
    && apt-get install -yq --no-install-recommends ca-certificates curl gnupg \
    && mkdir -p /etc/apt/keyrings \
    && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \
    && echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR_VERSION.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list \
    && apt-get update -yq \
    && apt-get purge -y nodejs npm \
  # Install native deps
    && apt-get install -yq --no-install-recommends \
      build-essential \
      python3-pip \
      python3-setuptools \
      nodejs \
      tzdata \
      imagemagick \
      libicu-dev \
      libpq-dev \
      git-core \
      libjemalloc2 \
      cron \
      vim \
  # Check if npm is installed, if not install it
    && if command -v npm >/dev/null 2>&1; then \
         echo "npm is already installed."; \
       else \
         echo "npm not found, installing npm..."; \
         apt-get install -yq --no-install-recommends npm; \
       fi  \
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
    && bundle config --global app_config ".bundle" 

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
  # Setup crontab (work only if image is run as root)
    && touch /var/run/crond.pid \
    && crontab /etc/crontab.d/crontab \
    && bundle config set clean false \
    && bundle config set path "vendor" \
    && bundle config set app_config ".bundle"

ENTRYPOINT "./bin/docker-entrypoint"
CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0"]

##########################################################################
# GENERATOR
# Generate a new Rails app with the decidim generator.
##########################################################################
FROM ruby_base as generator
# An ARG instruction goes out of scope at the end of the build stage where it was defined. 
# To use an arg in multiple stages, each stage must include the ARG instruction.
ARG BASE_IMAGE BUILD_DATE VCS_REF VERSION DECIDIM_VERSION GENERATOR_GEMINSTALL NODE_MAJOR_VERSION BUNDLER_VERSION GENERATOR_PARAMS GROUP_ID USER_ID
ENV GENERATOR_GEMINSTALL=${GENERATOR_GEMINSTALL} \
  GENERATOR_PARAMS=${GENERATOR_PARAMS}
WORKDIR $ROOT

RUN \
  # Install the decidim generator with bundle, 
  # it resolves better than `gem install` for older rubies.
    echo "\n\
      source 'https://rubygems.org'\n\
      ruby '$RUBY_VERSION'\n\
      gem 'decidim', $GENERATOR_GEMINSTALL\n\
    " > $ROOT/Gemfile.tmp \
    && bundle install --gemfile Gemfile.tmp --quiet \
  # Generates the rails application at /home/decidim/app ($ROOT)
  # pass GENERATOR_PARAMS="--edge" to generate a decidim app for develop
    && bundle exec --gemfile Gemfile.tmp decidim . $GENERATOR_PARAMS  --skip_bundle --skip_bootsnap   \
    && truncate -s 0 /var/log/*log \
    && rm -rf $ROOT/vendor \
       $ROOT/Gemfile.tmp* \
       $ROOT/node_modules $ROOT/.git \
       $ROOT/.gem $ROOT/.npm \
       $ROOT/.local \
       $ROOT/.bundle $ROOT/tmp/*
COPY ./bin* $ROOT/bin/

##########################################################################
# PRODUCTION_BUNDLE
# Installation of application gems for production
##########################################################################
FROM ruby_base as production_bundle
COPY --from=generator $ROOT/Gemfile $ROOT/Gemfile.lock .
RUN bundle config set without "development:test" \
  && bundle install --quiet \
  && rm -rf vendor/cache .bundle/cache

##########################################################################
# DEVELOPMENT_BUNDLE
# Installation of application gems for development
##########################################################################
FROM ruby_base as development_bundle
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
FROM ruby_base as assets
ENV NODE_ENV="development" \
  RAILS_ENV="development"
COPY --from=generator $ROOT .
RUN npm ci
COPY --from=development_bundle $ROOT/vendor ./vendor
COPY --from=development_bundle $ROOT/Gemfile.lock .
RUN bundle exec rails assets:precompile

##########################################################################
# DECIDIM PRODUCTION ONBUILD
# Onbuild production image, to help other to create their own decidim
# customized application.
##########################################################################
FROM ruby_base as decidim-production-onbuild
COPY --from=generator $ROOT .
COPY --from=production_bundle $ROOT/Gemfile.lock .

##########################################################################
# DECIDIM PRODUCTION 
# To run a fresh Decidim application (non-root mode).
##########################################################################
FROM ruby_base as decidim-production
ENV BUNDLE_APP_CONFIG="/home/decidim/app"
# Symlink logs to a common linux place
RUN ln -s $ROOT/log /var/log/decidim \
    && truncate -s 0 /var/log/*log \
  # Create non-root user and group with the given ids.
    && groupadd -r -g $GROUP_ID decidim && useradd -r -u $USER_ID -g decidim decidim

USER decidim

COPY --from=generator $ROOT .
COPY --from=assets $ROOT/public/decidim-packs ./public/decidim-packs
COPY --from=production_bundle $ROOT/vendor ./vendor
COPY --from=production_bundle $ROOT/Gemfile.lock .


##########################################################################
# DECIDIM DEVELOPMENT 
# To run Decidim in development mode (root mode).
##########################################################################
FROM ruby_base as decidim-development
ENV NODE_ENV="development" \
  RAILS_ENV="development"

COPY --from=generator $ROOT .
COPY --from=assets $ROOT/public/decidim-packs ./public/decidim-packs
COPY --from=assets $ROOT/package-lock.json ./
COPY --from=assets $ROOT/node_modules ./node_modules
COPY --from=development_bundle $ROOT/Gemfile.lock ./

RUN bundle config set without "" \
# Symlink logs to a common linux place
  && ln -s $ROOT/log /var/log/decidim 
