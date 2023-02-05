# Angular-CLI in "watch" mode

# Create an Ubuntu based image from the official node image on Debian
FROM node:19.6.0-buster-slim as node 
FROM ubuntu:jammy-20230126 as base
COPY --from=node /usr/local /usr/local/

# fix simlinks for npx, Yarn and PnPm
RUN corepack disable && corepack enable 

# replace npm in CMD with tini for better kernel signal handling 
RUN apt update \
		&& apt -qq install -y --no-install-recommends \
		tini bash \
		&& rm -rf /var/lib/aps/lists

# set entrypoint to always run (CMD) commands with tini
ENTRYPOINT ["/usr/bin/tini", "--"]

# install node packages
RUN npm install -g\
		tslib@2.5.0 rxjs@7.8.0 zone.js@0.12.0 \
		@angular/common@14.2.12 angular-google-charts@2.2.3 \
		@angular-devkit/build-angular@14.2.10 @angular/animations@14.2.12 @angular/cdk@14.2.7 @angular/cli@14.2.10 \
		@angular/compiler@14.2.12 @angular/compiler-cli@14.2.12 @angular/core@14.2.12 @angular/forms@14.2.12 \
		@angular/material@14.2.7 @angular/platform-browser-dynamic@14.2.12 @angular/platform-browser@14.2.12 \
		@angular/router@14.2.12

# Link globally installed modules to WORKDIR
RUN	mkdir -p /app/node_modules 
WORKDIR /app
RUN npm link tslib rxjs zone.js @angular/common angular-google-charts \
		@angular-devkit/build-angular @angular/animations @angular/cdk @angular/cli \
		@angular/compiler @angular/compiler-cli @angular/core @angular/forms \
		@angular/material @angular/platform-browser-dynamic @angular/platform-browser @angular/router

RUN rm -rf /root/.npm 

# Define volumes 
VOLUME /app/node_modules
VOLUME /app


# Default ng testing port exposed
EXPOSE 4200

# Run ng serve in watch mode
CMD ["ng", "serve", "--host", "0.0.0.0", "--watch"]
