ARG BASE_IMAGE 
FROM $BASE_IMAGE
ENV RUN_NGINX="1"
RUN \
  # Prepare apt-get
    apt-get update \
  # Install nginx
    && apt-get install -yq --no-install-recommends nginx \
  # Enforce essential directory structure
    && mkdir -p /var/nginx/tmp  /var/lib/nginx/body /var/log/nginx\
  # Remove clutter
    && apt-get clean \
    && apt-get autoremove -y 

# Copy our basic nginx configuration
COPY ./nginx/nginx.conf /etc/nginx/nginx.conf
# Add nginx and RUN_NGINX support
COPY ./nginx/nginx.supervisord.erb /usr/local/share/decidim/templates/supervisord.programs/nginx.erb
# Prepare to run nginx as non-root
RUN chown -R decidim:decidim /etc/nginx /var/log/nginx /var/nginx/tmp /var/lib/nginx /home/decidim/app/tmp

# Expose nginx port, see nginx.conf for more info.
EXPOSE 8080