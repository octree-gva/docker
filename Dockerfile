ARG UBUNTU_TAG

##
# Ruby Base Image
# Define all dependencies required for Decidim
##
FROM ubuntu:${UBUNTU_TAG:-latest} AS ruby_base
ARG DECIDIM_VERSION
ARG DECIDIM_BRANCH
ARG NODE_MAJOR_VERSION
ARG BUNDLER_VERSION
ARG RUBY_VERSION

ENV DECIDIM_VERSION=$DECIDIM_VERSION \
    NODE_MAJOR_VERSION=$NODE_MAJOR_VERSION \
    BUNDLER_VERSION=$BUNDLER_VERSION \
    DECIDIM_BRANCH=$DECIDIM_BRANCH \
    RUBY_VERSION=$RUBY_VERSION \
    WORK_DIR=/home/decidim \
    HOME=/home/decidim \
    PATH="/home/decidim/.rbenv/bin:/home/decidim/.rbenv/shims:/home/decidim/.cargo/bin:${PATH}" \
    BUNDLE_APP_CONFIG="/home/decidim/.bundle" \
    BUNDLE_PATH="/home/decidim/vendor"
SHELL ["/bin/bash", "-o", "pipefail", "-l", "-c"]
WORKDIR $WORK_DIR
RUN apt-get update -yq \
  # Setup NodeJS and NPM
    && apt-get install -yq --no-install-recommends ca-certificates curl gnupg \
    && mkdir -p /etc/apt/keyrings \
    && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \
    && echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR_VERSION.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list \
    && apt-get update -yq \
    && apt-get purge -y nodejs npm \
  # Decidim Native Dependencies
    && apt-get install -yq --no-install-recommends --no-upgrade \
      build-essential \
      curl \
      git \
      libssl-dev \
      zlib1g-dev \
      libvips \
      python3-pip \
      python3-setuptools \
      nodejs \
      tzdata \
      libicu-dev \
      libpq-dev \
      rustc \
      git \
      libjemalloc2 \
      cron \
      vim \
      libxml2-dev \
      libxslt1-dev \
      libyaml-dev \
      libffi-dev \
  # Ruby through rbenv
    && echo "Installing rbenv and ruby $RUBY_VERSION" \
    && git clone https://github.com/rbenv/rbenv.git /home/decidim/.rbenv \
    && git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build \
    && echo 'export PATH="/home/decidim/.rbenv/bin:/home/decidim/.rbenv/shims:${PATH}"' >> /home/decidim/.bashrc \
    && echo 'eval "$(rbenv init -)"' >> /home/decidim/.bashrc \
    && eval "$(rbenv init -)" \
    && (type rbenv || exit 1) \
    && CONFIGURE_OPTS="--disable-install-rdoc --enable-shared --enable-yjit" rbenv install "$RUBY_VERSION" \
    && rbenv rehash  \
    && rbenv global "$RUBY_VERSION" \
    && rbenv shell "$RUBY_VERSION" \
    && echo "ruby $RUBY_VERSION installed" \
    && echo $(ruby -v) \
    # Configure bundler
    && echo "gem: --no-document" >> /etc/gemrc \
    && gem install bundler -v $BUNDLER_VERSION \
    # Remove CX flags on charlock_holmes, see https://github.com/brianmario/charlock_holmes/issues/173 
    && bundle config set build.charlock_holmes -- --with-cxxflags='#' --global \
    # Ensure NPM and Yarn are installed
    && if command -v npm >/dev/null 2>&1; then \
    echo "npm is already installed."; \
    else \
    echo "npm not found, installing npm..."; \
    apt-get install -yq --no-install-recommends npm; \
    fi \
    && npm -g install yarn --force \
    # Remove development dependencies
    && apt-get purge -y python3-pip python3-setuptools rustc build-essential \
    # Clean installation clutters
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /.root/cache /var/cache/apt/archives

##
# Generator Image
# Generates a new Decidim Application at the right decidim branch
FROM ruby_base AS generator
ENV LD_PRELOAD="/usr/lib/x86_64-linux-gnu/libjemalloc.so.2" \
  MALLOC_CONF="dirty_decay_ms:1000,narenas:2,background_thread:true" \
  DECIDIM_VERSION=$DECIDIM_VERSION \
  NODE_MAJOR_VERSION=$NODE_MAJOR_VERSION \
  BUNDLER_VERSION=$BUNDLER_VERSION 

# Instead of using published generator, we clone the repo and run an updated generator
# This way we are sure we run a working generator for the pinned DECIDIM_VERSION
RUN git clone --branch $DECIDIM_BRANCH --depth 1 https://github.com/decidim/decidim.git /home/decidim/generator \
  && cd /home/decidim/generator/decidim-generators \
  && bundle config set path "/home/decidim/generator/decidim-generators/vendor" --global \
  && bundle install \
  &&  if $DECIDIM_BRANCH == "develop"; then  \
        bundle exec exe/decidim --edge --skip_bundle $WORK_DIR/rails_app; \
      else \
        bundle exec exe/decidim --branch $DECIDIM_BRANCH --skip_bundle $WORK_DIR/rails_app; \
      fi \
  && bundle config unset path --global \
  && cd $WORK_DIR \
  && mv rails_app/* . \
  && rm -rf generator rails_app \
  && rm -rf vendor/** \
  && bundle config set without "development:test" \
  && bundle install \
  && bundle config set frozen true \
  && bundle config set deployment true \
  # Clean clutter
  && rm -rf vendor/ruby/*/cache/*.gem \
  && rm -rf vendor/ruby/*/bundler/gems/*/.git \
  && find vendor/ruby/*/gems/ -name "*.c" -delete \
  && find vendor/ruby/*/gems/ -name "*.o" -delete \
  && echo "ruby-$RUBY_VERSION" > $WORK_DIR/.ruby-version \
  && rm -rf .npm node_modules

##
# Assets
# Precompiles the assets in public/decidim-packs
FROM ruby_base AS assets
ENV SECRET_KEY_BASE_DUMMY=1 \
    NODE_ENV=development \
    RAILS_ENV=production \
    CI=1
COPY --from=generator $WORK_DIR $WORK_DIR
RUN npm ci \
  && bundle config set frozen false \
  && bundle config set deployment false \
  && bundle config set without "" \
  && bundle install \
  && bundle exec rails assets:precompile \
  && rm -rf node_modules .npmrc .yarnrc .yarn vendor

##
# Decidim
# Final image for Decidim
FROM ruby_base AS decidim
ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

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

# Create non-root user
RUN useradd -m decidim 
ENV RAILS_ENV=production \
    NODE_ENV=production
USER decidim
COPY --from=generator --chown=decidim $WORK_DIR $WORK_DIR
COPY --from=assets --chown=decidim $WORK_DIR/public/decidim-packs $WORK_DIR/public/decidim-packs

EXPOSE 3000
CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0"]
