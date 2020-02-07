FROM gcr.io/google-appengine/php:latest

# set the document root to web/ folder
ENV DOCUMENT_ROOT /app/web

# Database environment variables
ENV MYSQL_DB_NAME ""
ENV MYSQL_DB_USER ""
ENV MYSQL_DB_PASSWORD ""
ENV MYSQL_DB_HOST "127.0.0.1"
ENV MYSQL_DB_PORT "3306"

# Drupal hash salt
ENV DRUPAL_HASH_SALT ""

#create the file system for public and private files
RUN mkdir -p /drupal-files/public
RUN mkdir -p /drupal-files/private
RUN chown -R www-data.www-data /drupal-files/private \
    && chmod -R 775 /drupal-files/private
RUN chown -R www-data.www-data /drupal-files/public \
    && chmod -R 775 /drupal-files/public

# Volumes for public and private files
VOLUME /drupal-files/public
VOLUME /drupal-files/private

WORKDIR /app

COPY . .

RUN composer install

# Use the settings file which has been parameterized using Environment variables
RUN mv -f settings.php web/sites/default/settings.php

# fix permissions
RUN chown -R www-data.www-data /app/web/sites/default/settings.php \
    && chmod -R 775 /app/web/sites/default/settings.php

# symlink to the public files directory
RUN ln -s /drupal-files/public web/sites/default/files