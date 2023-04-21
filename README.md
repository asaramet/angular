# Angular CLI Development Docker Image

Build and serve your Angular application in development mode with ease, using this Docker image that comes with the Angular CLI tool and all necessary dependencies and tools.

- tag 1.1 - Angular 15.2.8
- tag 1.0 - Angular 14.2.10

## Key Features

- Pre-installed with the following software, libraries, and tools:
  - Ubuntu
  - Node
  - tini
  - bash
  - tslib
  - rxjs
  - zone.js
  - @angular/common
  - angular-google-charts
  - @angular-devkit/build-angular
  - @angular/animations
  - @angular/cdk
  - @angular/cli
  - @angular/compiler
  - @angular/compiler-cli
  - @angular/core
  - @angular/forms
  - @angular/material
  - @angular/platform-browser-dynamic
  - @angular/platform-browser
  - @angular/router
- Exposes the default `ng serve --watch` port `4200`.
- Uses two nested volumes:
  - `/app/node_modules` - where the necessary modules are already installed and linked, saving you from having to create an extra `node_modules` folder.
  - `/app` - mount your local app folder here.

## Getting Started

1. Download the image using the following command:

    ```bash
    docker image pull asaramet/angular
    ```

2. Start the container, publishing port `4200` to your local port of your choice (e.g. `80`), and mount your local folder to the container using the `-v` option.

    For example, to mount the current working directory:

    ```bash
    docker container run --rm -p 80:4200 -v $(pwd):/app asaramet/angular
    ```

    Or, to mount the local folder `/path/to/local/folder` to the container's `/app` directory:

    ```bash
    docker container run --rm -p 80:4200 -v /path/to/local/folder:/app asaramet/angular
    ```

3. To enter a running container, use these commands:

    ```bash
    # Get the container ID
    docker container ls -a

    # Start the container interactively
    docker container exec -it <CONTAINER_ID> bash 

    # Run build or compile commands from your 'package.json', for example:
    npm run compile
    ```
  