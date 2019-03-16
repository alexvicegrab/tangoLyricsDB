# Based on https://itnext.io/docker-rails-puma-nginx-postgres-999cd8866b18

# Base image
FROM nginx

# Install dependencies
RUN apt-get update -qq && apt-get -y install apache2-utils

# establish where Nginx should look for files
ENV APP_PATH /var/www/ttdb

# Set our working directory inside the image
WORKDIR $APP_PATH

# create log directory
RUN mkdir log

# copy over static assets
COPY public public

# Copy Nginx config template
COPY ./nginx.conf /tmp/docker.nginx

# Substitute variable references in the Nginx config template for real values from the environment
# put the final config in its place
RUN envsubst '$APP_PATH' < /tmp/docker.nginx > /etc/nginx/conf.d/default.conf

EXPOSE 80

# Use the "exec" form of CMD so Nginx shuts down gracefully on SIGTERM (i.e. `docker stop`)
CMD [ "nginx", "-g", "daemon off;" ]
