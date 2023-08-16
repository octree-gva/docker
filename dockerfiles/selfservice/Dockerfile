ARG BASE_IMAGE 
FROM $BASE_IMAGE
ENV RUN_NGINX="1"
RUN apt-get update \
  && apt-get install -yq --no-install-recommends nginx \
  && mkdir -p /var/nginx/tmp  /var/lib/nginx/body /var/log/nginx
COPY ./nginx/nginx.conf /etc/nginx/nginx.conf
COPY ./nginx/nginx.supervisord.erb /usr/local/share/decidim/templates/supervisord.programs/nginx.erb
RUN chown -R decidim:decidim /etc/nginx /var/log/nginx /var/nginx/tmp /var/lib/nginx /home/decidim/app/tmp
