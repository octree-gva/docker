ARG BASE_IMAGE 
FROM $BASE_IMAGE
ENV DECIDIM_RUN_NGINX="1"
RUN apt-get update \
  && apt-get install -yq --no-install-recommends nginx restic \
  && mkdir -p /var/nginx/tmp \
  && chown -R decidim:decidim /etc/nginx /var/log/nginx /var/nginx/tmp /var/lib/nginx /home/decidim/app/tmp
ADD ./nginx/nginx.conf /etc/nginx/nginx.conf
