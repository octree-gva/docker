ARG BASE_IMAGE 
FROM $BASE_IMAGE
ENV DECIDIM_RUN_NGINX="1"

RUN apt-get install -yq --no-install-recommends nginx restic
ADD ./nginx/nginx.conf /var/nginx/nginx.conf
