ARG OS_NAME=ubi9
ARG OS_MAJOR_VERSION=9
ARG OS_VERSION=9.8
ARG NODE_MAJOR_VERSION

# Single base with all dependencies
FROM redhat/${OS_NAME}:${OS_VERSION} AS base
ARG OS_MAJOR_VERSION
ARG DECIDIM_VERSION
ARG DECIDIM_BRANCH
ARG NODE_MAJOR_VERSION
ARG BUNDLER_VERSION
ARG RUBY_VERSION

ENV TZ=UTC \
    DECIDIM_VERSION=$DECIDIM_VERSION \
    NODE_MAJOR_VERSION=$NODE_MAJOR_VERSION \
    OS_MAJOR_VERSION=$OS_MAJOR_VERSION \
    BUNDLER_VERSION=$BUNDLER_VERSION \
    DECIDIM_BRANCH=$DECIDIM_BRANCH \
    RUBY_VERSION=$RUBY_VERSION \
    WORK_DIR=/home/decidim \
    HOME=/home/decidim \
    PATH="/home/decidim/.rbenv/bin:/home/decidim/.rbenv/shims:/usr/bin:${PATH}"

SHELL ["/bin/bash", "-o", "pipefail", "-l", "-c"]
WORKDIR $WORK_DIR

COPY version-deps/ /usr/local/share/version-deps/
COPY context/bin/apply-version-deps context/bin/install-vips context/bin/slim-runtime context/bin/configure-vips /usr/local/bin/
ENV VERSION_DEPS_ROOT=/usr/local/share/version-deps
RUN chmod +x /usr/local/bin/apply-version-deps /usr/local/bin/install-vips /usr/local/bin/slim-runtime /usr/local/bin/configure-vips

RUN dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-${OS_MAJOR_VERSION}.noarch.rpm \
  && /usr/bin/crb enable \
  && dnf config-manager --set-disabled epel-cisco-openh264 || true

RUN dnf install -y --setopt=skip_if_unavailable=True \
    gcc \
    gcc-c++ \
    make \
    pkg-config \
    which \
    file \
    ca-certificates \
    wget \
    lsof \
    ripgrep \
    git \
    gnupg2 \
    libffi-devel \
    libicu-devel \
    openssl-devel \
    libxml2-devel \
    libxslt-devel \
    libyaml-devel \
    python3-pip \
    python3-setuptools \
    rust \
    tzdata \
    vim \
    zlib-devel \
    cronie \
    jemalloc \
    libjpeg-turbo-devel \
    libpng-devel \
    libwebp-devel \
    libtiff-devel \
    libexif-devel \
    expat-devel \
    glib2-devel \
    meson \
    ninja-build \
    xz \
  && if [ "${OS_MAJOR_VERSION}" = "8" ]; then \
        dnf install -y libpq libpq-devel; \
     else \
        dnf install -y postgresql postgresql-devel; \
     fi \
  && EXTRA_PKGS="$(apply-version-deps list redhat)" \
  && if [ -n "$EXTRA_PKGS" ]; then dnf install -y $EXTRA_PKGS; fi \
  && so="$(find /usr/lib /usr/lib64 -name 'libjemalloc.so.2' -not -path '/usr/lib/libjemalloc.so.2' | head -1)" \
  && test -n "$so" \
  && ln -sfn "$so" /usr/lib/libjemalloc.so.2 \
  && install-vips \
  && dnf clean all

RUN for attempt in 1 2 3; do \
      curl -fsSL "https://rpm.nodesource.com/setup_${NODE_MAJOR_VERSION}.x" | bash - && break; \
      sleep 5; \
    done \
  && dnf install -y nodejs \
  && git clone --depth 1 https://github.com/rbenv/rbenv.git ~/.rbenv \
  && git clone --depth 1 https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build \
  && echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc \
  && echo 'eval "$(rbenv init -)"' >> ~/.bashrc \
  && RUBY_CONFIGURE_OPTS="--disable-install-rdoc --enable-shared" rbenv install "$RUBY_VERSION" \
  && rbenv global "$RUBY_VERSION" \
  && rbenv rehash \
  && echo "gem: --no-document" >> /etc/gemrc \
  && if [ "${OS_MAJOR_VERSION}" = "8" ]; then bundle config set force_ruby_platform true; fi \
  && ~/.rbenv/shims/gem install bundler -v $BUNDLER_VERSION \
  && ~/.rbenv/shims/bundle config set build.charlock_holmes -- --with-cxxflags='#' --global \
  && npm install -g yarn \
  && dnf clean all \
  && rm -rf /tmp/* /var/tmp/* ~/.cache

##
# Generator Image
##
FROM base AS generator
ENV LD_PRELOAD="/usr/lib/libjemalloc.so.2" \
    MALLOC_CONF="dirty_decay_ms:1000,muzzy_decay_ms:1000,narenas:2,background_thread:true,abort_conf:true" \
    BUNDLE_APP_CONFIG="/home/decidim/.bundle" \
    BUNDLE_DISABLE_SHARED_GEMS=true \
    DECIDIM_SPAM_DETECTION_BACKEND_RESOURCE=memory \
    DECIDIM_SPAM_DETECTION_BACKEND_USER=memory \
    RAILS_ENV=development \
    PATH="/home/decidim/bin:${PATH}" \
    WORKDIR=/home/decidim

SHELL ["/bin/bash", "-o", "pipefail", "-l", "-c"]

RUN git clone --branch $DECIDIM_BRANCH --depth 1 https://github.com/decidim/decidim.git /home/generator
WORKDIR /home/generator/decidim-generators

RUN bundle config set path "vendor" --global \
  && apply-version-deps append-gemfile Gemfile \
  && bundle install \
  && DISABLE_BOOTSNAP=1 bundle exec exe/decidim --branch $DECIDIM_BRANCH --skip-gemfile rails_app \
  && cp Gemfile Gemfile.lock rails_app/ \
  && cp -r rails_app/. $WORK_DIR  \
  && bundle config unset path --global \
  && rm -rf /home/generator

WORKDIR $WORK_DIR
ENV BUNDLE_PATH="/home/decidim/vendor"
RUN rm -rf .git node_modules .npm  .npmrc .yarnrc .yarn tmp \
    config/master.key config/credentials.yml.enc \
  && rm -f bin/spring config/spring.rb \
  && find bin -maxdepth 1 -type f -exec sed -i '/load File.expand_path("spring"/d' {} + \
  && mkdir -p tmp/pids tmp/sockets \
  && npm cache clean --force \
  && yarn cache clean --force

COPY ./context .

RUN bundle config set without "development:test" \
  && bundle config set path "/home/decidim/vendor" \
  && echo "ruby-$RUBY_VERSION" > $WORK_DIR/.ruby-version \
  && sed -i "s|path: \"..\"|git: 'https://github.com/decidim/decidim.git', branch: '$DECIDIM_BRANCH'|" Gemfile \
  && bundle remove decidim-design \
  && echo "eval_gemfile 'Gemfile.modules' if File.exist?('Gemfile.modules')" >> Gemfile \
  && apply-version-deps append-gemfile Gemfile \
  && bundle update \
  && bundle config set frozen true \
  && bundle config set deployment true \
  && configure-vips \
  && chmod +x entrypoint.sh bin/check bin/check.d/* docker-entrypoint.d/* bin/wait-for-it

##
# Assets
##
FROM generator AS assets
ENV SECRET_KEY_BASE=assets \
    NODE_ENV=development \
    RAILS_ENV=production \
    DISABLE_SPRING=1 \
    DECIDIM_SERVICE_WORKER_ENABLED=true

RUN bundle config set frozen false \
  && bundle config set deployment false \
  && bundle check || bundle install \
  && npm install \
  && NPM_LINES="$(apply-version-deps list npm)" \
  && if [ -n "$NPM_LINES" ]; then while read -r args; do npm install $args; done <<< "$NPM_LINES"; fi \
  && bin/rails assets:precompile \
  && test -n "$(find public/decidim-packs -type f -print -quit)" \
  && mkdir -p public/assets \
  && rm -rf node_modules .npmrc .yarnrc .yarn

##
# Final Decidim Image
##
FROM base AS decidim
ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
ARG OS_NAME
ARG NODE_MAJOR_VERSION
ARG RUBY_VERSION
ARG BUNDLER_VERSION
ARG DECIDIM_BRANCH
ARG DECIDIM_VERSION

LABEL org.label-schema.build-date=${BUILD_DATE} \
      org.label-schema.name="decidim" \
      org.label-schema.description="Decidim application on Redhat ${OS_NAME}" \
      org.label-schema.url="https://github.com/decidim/docker" \
      org.label-schema.vcs-ref=${VCS_REF} \
      org.label-schema.vcs-url="https://github.com/decidim/decidim" \
      org.label-schema.vendor="Decidim" \
      org.label-schema.version=${VERSION} \
      org.label-schema.schema-version="1.0.0-rc.1" \
      org.opencontainers.image.created=${BUILD_DATE} \
      org.opencontainers.image.title="decidim" \
      org.opencontainers.image.description="Decidim application on Redhat ${OS_NAME}" \
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
    RAILS_ENV=production \
    RAILS_LOG_TO_STDOUT=true \
    WEB_CONCURRENCY=2 \
    RAILS_MIN_THREADS=1 \
    RAILS_MAX_THREADS=5 \
    DATABASE_MAX_POOL_SIZE=10 \
    WORK_DIR=/home/decidim \
    HOME=/home/decidim \
    PATH="/home/decidim/.rbenv/bin:/home/decidim/.rbenv/shims:/home/decidim/bin:${PATH}" \
    LD_PRELOAD=/usr/lib/libjemalloc.so.2 \
    MALLOC_CONF=dirty_decay_ms:1000,muzzy_decay_ms:1000,narenas:2,background_thread:true,abort_conf:true

RUN rm -rf $WORK_DIR \
    && groupadd -g 1000 decidim \
    && useradd -m -u 1000 -g decidim -d $WORK_DIR -s /bin/bash decidim

WORKDIR $WORK_DIR

COPY --chown=decidim:decidim --from=generator /home/decidim .
COPY --chown=decidim:decidim --from=assets /home/decidim/public/decidim-packs public/decidim-packs
COPY --chown=decidim:decidim --from=assets /home/decidim/public/assets public/assets
COPY ./scripts/write_motd bin/write_motd
RUN bundle exec bin/write_motd && rm bin/write_motd \
  && crontab -u decidim /home/decidim/crontab.d/crontab \
  && slim-runtime
USER decidim
RUN bundle check \
  && bundle exec bootsnap precompile --gemfile app config lib

EXPOSE 3000
ENTRYPOINT ["/home/decidim/entrypoint.sh"]
CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0"]
