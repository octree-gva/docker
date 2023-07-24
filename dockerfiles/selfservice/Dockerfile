ARG BASE_IMAGE 
FROM $BASE_IMAGE
ENV DECIDIM_RUN_NGINX="1"

RUN apt-get install -yq --no-install-recommends nginx restic
ADD ./nginx/nginx.conf /etc/nginx/nginx.conf
RUN chown -R decidim:decidim /etc/nginx /var/log/nginx /var/nginx/tmp /var/lib/nginx /home/decidim/app/tmp
USER decidim
