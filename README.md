# Drupal 8 docker image based on Google PHP base image 

This project uses the [PHP base image](https://gcr.io/google-appengine/php:latest) to build a Drupal 8 container.
 
This project can also be used as a reference on how to containerize your own Drupal 8 sites, 
documented [here](#build-your-own-docker-image).

If you want to use this image you can download it from docker hub

    docker pull giteshk/drupal8-gcp-docker

## Running this setup locally
<a id="run-this-setup"></a>
1. Install [docker-compose](https://docs.docker.com/compose/install/)
2. To build this image locally run
    ```
    docker-compose build
    ``` 
3. To run this setup locally
    ```
    docker-compose up
    ```
   This will create the required volumes and setup a mariadb server
4. Open a browser and go to [http://localhost:5000](http://localhost:5000)

## Remove your docker containers and volumes

    docker-compose down
    docker volume rm drupal8-gcp-docker_drupal-db-volume
    docker volume rm drupal8-gcp-docker_drupal-public-files
    docker volume rm drupal8-gcp-docker_drupal-private-files
    docker volume rm drupal8-gcp-docker_drupal-backups

## Want to build your own docker image
<a id="build-your-own-docker-image"></a>
If you want to build your own Drupal 8 project copy the files listed below to your project :
- Dockerfile
- nginx-app.conf
- php.ini
- settings.php
- Make sure that you have the following dependencies in your composer.json
  You will need to specify the php version.
    ``` 
        "ext-date": "*",
        "ext-dom": "*",
        "ext-filter": "*",
        "ext-gd": "*",
        "ext-hash": "*",
        "ext-json": "*",
        "ext-pcre": "*",
        "ext-pdo": "*",
        "ext-session": "*",
        "ext-simplexml": "*",
        "ext-spl": "*",
        "ext-tokenizer": "*",
        "ext-xml": "*",
        "php": ">=7.2.0"
    ```    
- cloudbuild.xml - Copy this file if you plan to use [Cloud Build](https://cloud.google.com/cloud-build/docs/)


## Building this docker image locally
To build the docker image on your instance run the following:
    
    docker build -t my-drupal8 .

Follow the instructions [above](#run-this-setup) to run this container

## Implementation details

### Dockerfile
    We based this image on the PHP Google App Engine image. 
    We did to leverage all security patches that base image would get from Google team.
    *** As of the writing of this project the PHP base image only supports php 7.1 and 7.2 ***
### nginx-app.conf
    This is a modified version of the nginx drupal 8 receipe
### php.ini
    The default 128M was not sufficient for Drupal so we bumped the php memory limit to 512M
### settings.php
    The Database configuration has been parameterized. Define the following environment variables
        - DB_NAME
        - DB_USER
        - DB_PASSWORD
        - DB_HOST
        - DB_PORT
        - DB_PREFIX
    The Drupal Hash salt is also passed as an environment variable.
        - DRUPAL_HASH_SALT
### composer.json 
    Make sure you have the above mentioned extentions in the require section of your composer.json
    When the docker image is build it uses this information to enable php extensions
### cloudbuild.xml
    Use this to build your docker images using Cloud build and publish to Google container registry.

# Disclaimer
    This is not an official Google Product

