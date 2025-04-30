ARG UBUNTU_TAG

FROM ubuntu:${UBUNTU_TAG:-latest} AS rbenv
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
    HOME=/home/decidim  \
    PATH="/home/decidim/.rbenv/bin:/home/decidim/.rbenv/shims:/home/decidim/.cargo/bin:${PATH}"

WORKDIR $WORK_DIR

RUN apt-get update \ 
  && apt-get install -yq --no-install-recommends --no-upgrade \
    build-essential \
    curl \
    git \
    libssl-dev \
    zlib1g-dev \
    python3-pip \
    python3-setuptools \
    libicu-dev \
    libpq-dev \
    rustc \
    git \
    libjemalloc2 \
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
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /.root/cache /var/cache/apt/archives 


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
    PATH="/home/decidim/.rbenv/bin:/home/decidim/.rbenv/shims:/home/decidim/.cargo/bin:/home/decidim/bin:${PATH}" \
    BUNDLE_APP_CONFIG="/home/decidim/.bundle" \
    BUNDLE_PATH="/home/decidim/vendor" \
    BUNDLE_CACHE_ALL=false \
    BUNDLE_CLEAN=true \
    BUNDLE_DISABLE_SHARED_GEMS=true \
    DECIDIM_SPAM_DETECTION_BACKEND_RESOURCE=memory \
    DECIDIM_SPAM_DETECTION_BACKEND_USER=memory

SHELL ["/bin/bash", "-o", "pipefail", "-l", "-c"]

WORKDIR $WORK_DIR
COPY --from=rbenv $WORK_DIR/.rbenv $WORK_DIR/.rbenv
COPY --from=rbenv $WORK_DIR/.bashrc $WORK_DIR/.bashrc

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
      vim  \
      curl \
      git \
      cron \
      libssl-dev \
      zlib1g-dev \
      libvips-dev \
      nodejs \
      tzdata \
      libicu-dev \
      libpq-dev \
      libjemalloc2 \
      libyaml-dev \
    && (type rbenv || exit 1) \
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
    && rm -rf /var/lib/apt/lists /var/cache/apt/archives \
    && npm -g install yarn --force \
    # Clean installation clutters
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /.root/cache /var/cache/apt/archives .npm .local .bundle/cache
##
# Generator Image
# Generates a new Decidim Application at the right decidim branch
FROM ruby_base AS generator
ENV LD_PRELOAD="/usr/lib/x86_64-linux-gnu/libjemalloc.so.2" \
  MALLOC_CONF="dirty_decay_ms:1000,narenas:2,background_thread:true" \
  DECIDIM_VERSION=$DECIDIM_VERSION \
  NODE_MAJOR_VERSION=$NODE_MAJOR_VERSION \
  BUNDLER_VERSION=$BUNDLER_VERSION  \
  EDITOR=vim

# Instead of using published generator, we clone the repo and run an updated generator
# This way we are sure we run a working generator for the pinned DECIDIM_VERSION
RUN git clone --branch $DECIDIM_BRANCH --depth 1 https://github.com/decidim/decidim.git /home/decidim/generator \
  && cd /home/decidim/generator/decidim-generators \
  # Setup bundle path while generating decidim, to avoid polluting the final vendor
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
  && rm -rf vendor/** config/master.key config/credentials.yml.enc

COPY ./context .

RUN  bundle config set without "development:test" \
  && echo "eval_gemfile 'Gemfile.modules' if File.exist?('Gemfile.modules')" >> Gemfile \
  && bundle install \
  && bundle config set frozen true \
  && bundle config set deployment true \
  && echo "ruby-$RUBY_VERSION" > $WORK_DIR/.ruby-version \
  && rm -rf vendor .npm node_modules tmp/cache /tmp/* /var/tmp/* /.root/cache .npm .local
  
##
# Gems
# Install required GEMS
FROM generator AS gems
RUN bundle config set without "development:test" \
  && bundle config set frozen true \
  && bundle config set deployment true \
  && bundle install \
  # Make vendor slimmer
  && rm -rf $BUNDLE_PATH/ruby*/cache $BUNDLE_PATH/ruby*/bundler/gems/*/.git \
  && find $BUNDLE_PATH -name "*.c" -delete \
  && find $BUNDLE_PATH -name "*.o" -delete

##
# Assets
# Precompiles the assets in public/decidim-packs
FROM generator AS assets
ENV SECRET_KEY_BASE_DUMMY=1 \
    NODE_ENV=development \
    RAILS_ENV=production \
    CI=1 
COPY --from=gems $WORK_DIR/vendor $WORK_DIR/vendor
RUN npm ci \
  && bundle exec rails assets:precompile \
  && rm -rf node_modules .npmrc .yarnrc .yarn

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
      org.label-schema.vendor="Decidim" \
      org.label-schema.version=${VERSION} \
      org.label-schema.schema-version="1.0.0-rc.1" \
      org.opencontainers.image.created=${BUILD_DATE} \
      org.opencontainers.image.title="decidim" \
      org.opencontainers.image.description="Decidim base image" \
      org.opencontainers.image.url="https://github.com/decidim/decidim" \
      org.opencontainers.image.revision=${VCS_REF} \
      org.opencontainers.image.source="https://github.com/decidim/decidim" \
      org.opencontainers.image.vendor="Decidim" \
      org.opencontainers.image.version=${VERSION} \
      org.opencontainers.image.licenses="GPL-3.0" \
      maintainer="Decidim Product Team <https://meta.decidim.org/profiles/product/members>"

# SMTP Configuration
ENV SMTP_ADDRESS="" \
    SMTP_DOMAIN="" \
    SMTP_USERNAME="" \
    SMTP_PASSWORD="" \
    SMTP_PORT=587 \
    SMTP_STARTTLS_AUTO=true \
    SMTP_AUTHENTICATION=plain 
# Maps Configuration  
ENV MAPS_PROVIDER="" \
    MAPS_API_KEY="" 
# Storage Configuration
ENV STORAGE_PROVIDER=local 
# Rails Configuration
ENV RAILS_ENV=production \
    RAILS_LOG_LEVEL=debug \
    RAILS_MAX_THREADS=5 \
    RAILS_LOG_TO_STDOUT=true \
    RAILS_SERVE_STATIC_FILES=false \
    PORT=3000 \
    EDITOR=vim
# Decidim Core Configuration
ENV DECIDIM_APPLICATION_NAME="My Application Name" \
    DECIDIM_MAILER_SENDER="change-me@example.org" \
    DECIDIM_AVAILABLE_LOCALES="en" \
    DECIDIM_DEFAULT_LOCALE=en \
    DECIDIM_FORCE_SSL=auto \
    DECIDIM_TRACK_NEWSLETTER_LINKS=true \
    DECIDIM_ADMIN_PASSWORD_STRONG=true \
    DECIDIM_SERVICE_WORKER_ENABLED=false 
# Decidim Spam Detection
ENV DECIDIM_SPAM_DETECTION_BACKEND_RESOURCE=memory \
    DECIDIM_SPAM_DETECTION_BACKEND_USER=memory

# Create non-root user
RUN rm -rf /home/* \
  && groupadd -g 1001 decidim \
  && useradd -u 1001 -g decidim -m decidim \
  && touch /etc/motd \
  && mkdir -p /home/decidim/tmp/pids \
  && chown -R decidim:decidim /etc/motd 

ENV RAILS_ENV=production \
    NODE_ENV=production

USER decidim:decidim
COPY --from=generator --chown=decidim:decidim $WORK_DIR $WORK_DIR
COPY --from=assets --chown=decidim:decidim $WORK_DIR/public/decidim-packs $WORK_DIR/public/decidim-packs
COPY --from=gems --chown=decidim:decidim $WORK_DIR/vendor $WORK_DIR/vendor

EXPOSE 3000
ENTRYPOINT ["/home/decidim/entrypoint.sh"]
CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0"]
