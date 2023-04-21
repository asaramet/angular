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
RUN npm install -g npm@9.6.5
RUN npm install -g \
		tslib@2.5.0 rxjs@7.8.0 zone.js@0.13.0 \
		@angular/common@15.2.8 angular-google-charts@2.2.3 \
		@angular-devkit/build-angular@15.2.6 @angular/animations@15.2.8 @angular/cdk@15.2.8 @angular/cli@15.2.6 \
		@angular/compiler@15.2.8 @angular/compiler-cli@15.2.8 @angular/core@15.2.8 @angular/forms@15.2.8 \
		@angular/material@15.2.8 @angular/platform-browser-dynamic@15.2.8 @angular/platform-browser@15.2.8 \
		@angular/router@15.2.8

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
