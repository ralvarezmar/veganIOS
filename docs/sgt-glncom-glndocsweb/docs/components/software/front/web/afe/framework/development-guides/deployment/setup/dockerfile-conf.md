# How to set up the dockerfile***

The Dockerfile is a file that contains all the instructions needed to mount the server image at the time of deployment.

It is automatically created by the treadmill when launching a new **SPA** or **Angular Elements** application using the **developer portal** [Blaze](https://blaze.paas.santanderbr.corp/#/login).

This file is responsible for containing all the commands typed on the command line to mount the server image, at the time of ***deploy***.

There are two images in the structure of the code statements contained in the Dockerfile:

- The first is the ***node*** image, which is used for running the tests and generating the ***build*** of the application, it is located in line **6** of the Dockerfile example below.
- The second is the ***nginx*** image, which is used to run the application itself, it's located on line **50** of the Dockerfile example below.

The **current** image of **nginx** **used** by **bank** is updated on the 10th of each month and can be consulted through the page [official base images](http://artifactory.santanderbr.corp/artifactory/raw-downloads/paas/changelog_image_base/imagem_base_paas.txt).

> **❗ Information**
>
> At the time of publishing this tutorial the most up-to-date image is: ***artifactory.santanderbr.corp/docker-base/rhel8/nginx-1.21:latest***.

There is a difference in the configuration of the Dockerfile for the Angular 16 versions compared to the Angular 12 or earlier versions.

- In Angular 16, the configuration of the node is done directly in the Dockerfile.

***Dockerfile example***

``` BASH
#################
# DEPENDENCIES  #
#################
#################
# Pipeline SPA Trigger
FROM artifactory.santanderbr.corp/docker-base/nodejs-16-google-chrome:1.0.0.RELEASE AS dependencies
#################
ARG BUILD_ARGS
ENV APP_HOME "/opt/app"

WORKDIR ${APP_HOME}

COPY .ci/files/.npmrc ./package-lock.json ./package.json ./afe.json ./

USER root

RUN node -v
RUN npm -v

RUN export NODE_ENV=development \
  && npm cache clean -f && npm ci --verbose

################
## UNIT TESTS ##
################
#################
# Pipeline SPA Trigger
FROM dependencies as unit_tests
#################

COPY . ./

RUN npm run test

#################
# BUILD/PACKAGE #
#################
#################

FROM unit_tests as build
#################

RUN npm run build

###############
##APPLICATION##
###############
FROM artifactory.santanderbr.corp/docker-base/rhel8/nginx-1.21:latest
ARG NAME
ARG VERSION
LABEL VENDOR=Santander
LABEL NAME=$NAME
LABEL VERSION=$VERSION
LABEL MAINTAINER="developer@santander.com.br"
ENV APP_HOME "/usr/share/nginx/html"

ENV PORT 8080
EXPOSE $PORT

USER root

COPY ./conf.d/ /etc/nginx/conf.d/
COPY --from=BUILD /opt/app/dist/ $APP_HOME/
COPY ./entrypoint.sh $APP_HOME/

RUN chown -R nginx:nginx $APP_HOME
RUN chmod -R 777 /etc/nginx/

USER nginx
WORKDIR $APP_HOME

#############
#   PASS    #
#############

COPY Dockerfile $IMAGE_SCRIPTS_HOME/Dockerfile
COPY nginx.conf /etc/nginx/

RUN echo $(date) > /etc/nginx/build
ENTRYPOINT [ "/bin/sh", "entrypoint.sh" ]
```

***Angular 12*** or below

***Dockerfile example***

``` BASH

#################
# DEPENDENCIES  #
#################
#################
FROM artifactory.santanderbr.corp/docker-base/spa-10:1.0.0 AS dependencies
#################
ARG BUILD_ARGS
ENV APP_HOME "/opt/app"

WORKDIR ${APP_HOME}

COPY .ci/files/.npmrc ./package-lock.json ./package.json ./afe.json ./

USER root

RUN npm install @afe/cli@^3 -g
RUN afe setup --nvs

RUN export NODE_ENV= \
  && afe exec 'npm install --verbose'

################
## UNIT TESTS ##
################
#################
FROM dependencies as unit_tests
#################
COPY . ./

RUN afe exec 'npm run test'

#################
# BUILD/PACKAGE #
#################
#################

FROM unit_tests as build
#################
RUN afe exec 'npm run build'

###############
##APPLICATION##
###############
FROM artifactory.santanderbr.corp/docker-base/rhel8/nginx-1.21:latest
ARG NAME
ARG VERSION
LABEL VENDOR=Santander
LABEL NAME=$NAME
LABEL VERSION=$VERSION
LABEL MAINTAINER="developer@santander.com.br"
ENV APP_HOME "/usr/share/nginx/html"

ENV PORT 8080
EXPOSE $PORT

USER root

COPY ./conf.d/ /etc/nginx/conf.d/
COPY --from=BUILD /opt/app/dist/ $APP_HOME/
COPY ./entrypoint.sh $APP_HOME/

RUN chown -R nginx:nginx $APP_HOME
RUN chmod -R 777 /etc/nginx/

USER nginx
WORKDIR $APP_HOME

#############
#   PASS    #
#############

COPY Dockerfile $IMAGE_SCRIPTS_HOME/Dockerfile
COPY nginx.conf /etc/nginx/

RUN echo $(date) > /etc/nginx/build

ENTRYPOINT [ "/bin/sh", "entrypoint.sh" ]
```
