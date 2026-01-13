ARG OS_NAME=plucky
ARG OS_VERSION=25.04
ARG DECIDIM_VERSION
ARG DECIDIM_BRANCH
ARG NODE_MAJOR_VERSION
ARG BUNDLER_VERSION
ARG RUBY_VERSION

# Single base with all dependencies
FROM ubuntu:${OS_NAME} AS base
ARG DECIDIM_VERSION
ARG DECIDIM_BRANCH  
ARG NODE_MAJOR_VERSION
ARG BUNDLER_VERSION
ARG RUBY_VERSION

ENV DEBIAN_FRONTEND=noninteractive \
    TZ=UTC \
    DECIDIM_VERSION=$DECIDIM_VERSION \
    NODE_MAJOR_VERSION=$NODE_MAJOR_VERSION \
    BUNDLER_VERSION=$BUNDLER_VERSION \
    DECIDIM_BRANCH=$DECIDIM_BRANCH \
    RUBY_VERSION=$RUBY_VERSION \
    WORK_DIR=/home/decidim \
    HOME=/home/decidim \
    PATH="/home/decidim/.rbenv/bin:/home/decidim/.rbenv/shims:${PATH}"

SHELL ["/bin/bash", "-o", "pipefail", "-l", "-c"]
WORKDIR $WORK_DIR

# Single comprehensive package installation
RUN apt-get update -yq \
  && apt-get install -yq --no-install-recommends \
    build-essential \
    ca-certificates \
    wget \
    git \
    gnupg \
    libffi-dev \
    libgdbm-dev \
    libicu-dev \
    libncurses-dev \
    libpq-dev \
    libreadline-dev \
    libssl-dev \
    libvips-dev \
    libxml2-dev \
    libxslt1-dev \
    libyaml-dev \
    libjemalloc2 \
    python3-pip \
    python3-setuptools \
    cargo \
    rustc \
    tzdata \
    vim \
    zlib1g-dev \
    cron 
  # Install Node.js from NodeSource
RUN wget -qO- https://deb.nodesource.com/setup_${NODE_MAJOR_VERSION}.x | bash - \
  && apt-get install -yq --no-install-recommends nodejs \
  # Install rbenv and Ruby
  && git clone --depth 1 https://github.com/rbenv/rbenv.git ~/.rbenv \
  && git clone --depth 1 https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build \
  && echo 'eval "$(rbenv init -)"' >> ~/.bashrc 
RUN  eval "$(rbenv init -)" \
  && rbenv install "${RUBY_VERSION}" \
  && rbenv global "${RUBY_VERSION}" \
  && rbenv rehash \
  # Configure gems and bundler
  && echo "gem: --no-document" >> /etc/gemrc \
  && gem install bundler -v $BUNDLER_VERSION \
  && bundle config set build.charlock_holmes -- --with-cxxflags='#' --global \
  # Install Yarn 
  && npm install -g yarn \
  # Cleanup
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* ~/.cache

##
# Generator Image 
##
FROM base AS generator
ENV LD_PRELOAD="/usr/lib/x86_64-linux-gnu/libjemalloc.so.2" \
    MALLOC_CONF="dirty_decay_ms:1000,narenas:2,background_thread:true" \
    BUNDLE_APP_CONFIG="/home/decidim/.bundle" \
    BUNDLE_DISABLE_SHARED_GEMS=true \
    DECIDIM_SPAM_DETECTION_BACKEND_RESOURCE=memory \
    DECIDIM_SPAM_DETECTION_BACKEND_USER=memory \
    RAILS_ENV=development \
    PATH="/home/decidim/bin:${PATH}" \
    WORKDIR=/home/decidim

SHELL ["/bin/bash", "-o", "pipefail", "-l", "-c"]

# Clone decidim to run generator from the good branch
RUN git clone --branch $DECIDIM_BRANCH --depth 1 https://github.com/decidim/decidim.git /home/generator
WORKDIR /home/generator/decidim-generators

RUN bundle config set path "vendor" --global \
  && echo "gem 'commonmarker'" >> Gemfile \
  && (bundle update commonmarker || bundle install) \
  && bundle exec exe/decidim --branch $DECIDIM_BRANCH --skip-gemfile rails_app \
  && cp Gemfile Gemfile.lock rails_app/ \
  && cp -r rails_app/. $WORK_DIR  \
  && bundle config unset path --global \
  && rm -rf /home/generator

WORKDIR $WORK_DIR
ENV BUNDLE_PATH="/home/decidim/vendor"
# Clean up generated app
RUN rm -rf .git node_modules .npm  .npmrc .yarnrc .yarn \
    config/master.key config/credentials.yml.enc \
  && mkdir -p tmp/pids tmp/sockets \
  && npm cache clean --force \
  && yarn cache clean --force 

COPY ./context .

# Install app dependencies
RUN bundle config set without "development:test" \
  && bundle config set path "/home/decidim/vendor" \
  && echo "ruby-$RUBY_VERSION" > $WORK_DIR/.ruby-version \
  # Remove decidim-conferences, decidim-initiatives, decidim-templates gems from Gemfile
  && sed -i "s|path: \"..\"|git: 'https://github.com/decidim/decidim.git', branch: '$DECIDIM_BRANCH'|" Gemfile \
  && bundle remove decidim-design \
  && echo "eval_gemfile 'Gemfile.modules' if File.exist?('Gemfile.modules')" >> Gemfile \
  && bundle update \
  && bundle config set frozen true \
  && bundle config set deployment true

##
# Assets
##
FROM generator AS assets
ENV SECRET_KEY_BASE=assets \
    NODE_ENV=development \
    RAILS_ENV=development \
    DISABLE_SPRING=1 \
    DECIDIM_SERVICE_WORKER_ENABLED=true

RUN bundle config set frozen false \
  && bundle config set deployment false \
  && bundle config set without '' \
  && bundle check || bundle install \
  && npm install

RUN bundle exec rails assets:precompile \
  && rm -rf node_modules .npmrc .yarnrc .yarn

##
# Final Decidim Image
##
FROM base AS decidim
ARG BUILD_DATE
ARG VCS_REF  
ARG VERSION
ARG OS_NAME
ARG OS_VERSION
ARG NODE_MAJOR_VERSION
ARG RUBY_VERSION
ARG BUNDLER_VERSION
ARG DECIDIM_BRANCH
ARG DECIDIM_VERSION

LABEL org.label-schema.build-date=${BUILD_DATE} \
      org.label-schema.name="decidim" \
      org.label-schema.description="Decidim application on Ubuntu ${OS_NAME} v${OS_VERSION}" \
      org.label-schema.url="https://github.com/decidim/docker" \
      org.label-schema.vcs-ref=${VCS_REF} \
      org.label-schema.vcs-url="https://github.com/decidim/decidim" \
      org.label-schema.vendor="Decidim" \
      org.label-schema.version=${VERSION} \
      org.label-schema.schema-version="1.0.0-rc.1" \
      org.opencontainers.image.created=${BUILD_DATE} \
      org.opencontainers.image.title="decidim" \
      org.opencontainers.image.description="Decidim application on Ubuntu ${OS_NAME} v${OS_VERSION}" \
      org.opencontainers.image.url="https://github.com/decidim/decidim" \
      org.opencontainers.image.revision=${VCS_REF} \
      org.opencontainers.image.source="https://github.com/decidim/decidim" \
      org.opencontainers.image.vendor="Decidim" \
      org.opencontainers.image.version=${VERSION} \
      org.opencontainers.image.licenses="GPL-3.0" \
      maintainer="Decidim Product Team <https://meta.decidim.org/profiles/product/members>"

ENV BUNDLE_APP_CONFIG="/home/decidim/.bundle" \
    BUNDLE_PATH="/home/decidim/vendor" \
    BUNDLE_DISABLE_SHARED_GEMS=true \
    NODE_MAJOR_VERSION=$NODE_MAJOR_VERSION \
    RUBY_VERSION=$RUBY_VERSION \
    BUNDLER_VERSION=$BUNDLER_VERSION \
    DECIDIM_BRANCH=$DECIDIM_BRANCH \
    DECIDIM_VERSION=$DECIDIM_VERSION \
    DECIDIM_SPAM_DETECTION_BACKEND_RESOURCE=memory \
    DECIDIM_SPAM_DETECTION_BACKEND_USER=memory \
    RAILS_ENV=production \
    WORK_DIR=/home/decidim \
    HOME=/home/decidim \
    PATH="/home/decidim/.rbenv/bin:/home/decidim/.rbenv/shims:${PATH}"
  
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
    EDITOR=vim \
    PATH="/home/decidim/bin:${PATH}"
# Decidim Core Configuration
ENV DECIDIM_APPLICATION_NAME="My Application Name" \
    DECIDIM_MAILER_SENDER="hello@example.org" \
    DECIDIM_AVAILABLE_LOCALES="en" \
    DECIDIM_DEFAULT_LOCALE=en \
    DECIDIM_FORCE_SSL=auto \
    DECIDIM_TRACK_NEWSLETTER_LINKS=false \
    DECIDIM_ADMIN_PASSWORD_STRONG=true \
    DECIDIM_SERVICE_WORKER_ENABLED=false 
  
# Decidim Spam Detection
ENV DECIDIM_SPAM_DETECTION_BACKEND_RESOURCE=memory \
    DECIDIM_SPAM_DETECTION_BACKEND_USER=memory

# Decidim custom configuration 
ENV DECIDIM_CRON_ENABLED=true \
    DECIDIM_SYSTEM_EMAIL=system@example.org \
    DECIDIM_SYSTEM_PASSWORD=my_insecure_password

RUN rm -rf $WORK_DIR \
    && groupadd -g 1001 decidim \
    && useradd -m -u 1001 -g decidim -d $WORK_DIR -s /bin/bash decidim
    
WORKDIR $WORK_DIR

COPY --from=generator /home/decidim .
COPY --from=assets /home/decidim/public/decidim-packs public/decidim-packs
COPY ./scripts/write_motd bin/write_motd

RUN bundle exec bin/write_motd && rm bin/write_motd \
    && crontab -u decidim /home/decidim/crontab.d/crontab

USER decidim
RUN bundle check || bundle install 

EXPOSE 3000
ENTRYPOINT ["/home/decidim/entrypoint.sh"]
CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0"]
