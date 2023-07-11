ARG BASE_IMAGE
FROM $BASE_IMAGE
ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
ARG DECIDIM_VERSION
ARG NODE_MAJOR_VERSION
ARG GENERATOR_PARAMS

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

ENV LANG="en_US.UTF-8" LANGUAGE="en_US.UTF-8" LC_ALL="en_US.UTF-8" \
    TERM="xterm" DEBIAN_FRONTEND="noninteractive" DEBIAN_RELEASE="buster" \
    DEBIAN_SUITE="oldstable"  ROOT="/home/decidim/app" HOME="/home/decidim/app" \
    DECIDIM_VERSION=${DECIDIM_VERSION} GENERATOR_PARAMS=${GENERATOR_PARAMS} \
    RAILS_ENV="production" NODE_MAJOR_VERSION=${NODE_MAJOR_VERSION}
RUN apt-get upgrade -yq \
  && apt-get update -yq \
  && apt-get install -yq gnupg2 
RUN curl -sL https://deb.nodesource.com/setup_${NODE_MAJOR_VERSION}.x | bash - \
  && apt-get install -yq \
    build-essential yarn git-core vim \
    tmux unzip python3 python3-pip python3-setuptools \
    nodejs tzdata \
    imagemagick shared-mime-info file libpq-dev \
  && npm install -g yarn --force \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && truncate -s 0 /var/log/*log


# Setup global bundle configurations
RUN bundle config --global build.nokogiri --use-system-libraries \
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
  && bundle install --jobs "$(nproc)" --retry 3 \
  && bundle clean --force \
  && truncate -s 0 /var/log/*log
