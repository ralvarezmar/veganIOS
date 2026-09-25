# Microfront archetype

!!! note
    Microfront Darwin archetype based on Angular and Webpack Module Federation

## Prerequisites

### Node.js and NPM

=== "Angular 20"

    Darwin needs Node.js, an active LTS version or greater or equal to **20.19.0**.

=== "Angular 18"

    Darwin needs Node.js, an active LTS version or greater or equal to **18.19.1**.

For checking your versión, execute `node -v` in a terminal or console.

The Darwin applications depends on Angular, Angular CLI and of the Darwin librarys availables as NPM packages. For being able to download and install all the packages required you must have installed npm.

For checking your version, execute `npm -v` in a terminal or console.

## How to generate a Microfront archetype

### Step 1: Configure NPM

The Darwin modules are located in Nexus, for this reason you must have NPM configured correctly. Make sure the namespaces of the Darwin modules are pointing to the Nexus registry, this step you can do it in two ways:

#### Command line

To perform this configuration through command line, execute the following commands in your terminal:

``` bash
npm config set strict-ssl false
npm config set registry https://nexus.alm.europe.cloudcenter.corp/repository/npm-public/
```

#### Manually

Go to the _.npmrc_ file, which is located at `C:\Users\<YOUR-USER>`. In case this file does not exist, you must create it and add the lines shown below. If it does exist, add them if you don't have them yet:

``` bash
registry=https://nexus.alm.europe.cloudcenter.corp/repository/npm-public/
strict-ssl=false
```

### Step 2: Install and run Darwin Front CLI Generator tool

In order to get the Microfront application, the Darwin generator should be used. Go to the following documentation, read all the sections carefully and generate a new _Microfront application project_ to start working with a Microfront archetype.

[Darwin Front CLI](../../cli/index.md)

!!! note
    Please note that a real and complete onboarding of any project must be done with an on boarding tool like [360](https://gluon.corp/gluon). This application will use the Darwin Front CLI Generator tool under the hood.

### Step 3: Install the dependencies

After generate the Microfront archetype, execute the next command in the root of the project to install all the dependencies.

``` bash
npm install
```

### Step 4: Run the Darwin Fake API, serve and test the application

#### Fake API

It is an API REST based on [json-server](https://github.com/typicode/json-server) which is able to provide static files and JSON files, perfect for simulating responses from AJAX request to the backend.

Execute the following command to deploy it.

``` bash
npm run serve:api
```

!!! note
    **Important!** The Fake API is deployed by default in the port 3000. If you need to change it, you can achieve it in the file `api-server.js` found in the api folder. You will have to change it too in `proxy.conf.json` file with the redirections to the right port. <!-- markdownlint-disable MD013 -->

#### Serve the application locally

Execute the next command. Automatically it will be deployed in the browser in the next address [http://localhost:4201/](http://localhost:4201/). The application will refresh automatically if you do any changes in the source files.

``` bash
npm run serve:app
```

!!! note
    **Important!** Keep in mind that the archetype is configured by default to deploy in the 4200 port. If you need to modify it, you can achieve it in the `angular.json` file.

If you want to simulate the Microfront deploying up for a specific channel, you can optionally send the `dw-channel` parameter with a value.

Example. [http://localhost:4201/?dw-channel=mychannel](http://localhost:4201/?dw-channel=mychannel)

If you want to execute the last two commands at the same time in only one console you can do it through:

``` bash
npm start
```

#### Running unit test

To run the unit tests via Karma run the following command.

``` bash
npm run test
```

Please note that:

- For a Gluon architecture the archetype use Puppeteer 19.7.5 to have a binary Chrome, so it is not necessary to have a local installation of this browser on the machine where the tests are running.
- For a Darwin architecture is mandatory to have a Chrome browser installed on the machine where you run the test.

## Starting to use the archetype

### Standalone mode

When the application is deployed, open the developer tools and you will be able to see that there are to main entities rendered.

- The **Microfront** itself.
- A component named **Shell Lite** which function is allowing the Microfront to work in an isolated way or standalone.

Deploy a microfront in standalone mode is very useful for being able to develop it and allowing it to be consumed from an iframe. technically what the Shell Lite does is initialize and handle the session,
getting a token that will be saved in the Session Storage in the browser being able the Microfront to use it, as any SPA monolitic application will do. Also it will handle when the session should end, deleting the token in the process.

!!! note
    Keep in mind that the tokens that are being retrieved locally are fake tokens. If you want real tokens you have to configure correctly the Shell Lite as is explained in the [Darwin Angular Framework](../../ng-darwin/index.md) documentation.

!!! note
    When the Microfront is deployed in a channel, and is not rendered in a standalone way, the Shell Lite will not be loaded and the Shell tasks will be done by the channel application itself (the real Shell), handling the initialization of the session and keeping the token in the Session Storage, as is required the Darwin security.

In order to deploy the Microfront in standalone mode just try [http://localhost:4201/](http://localhost:4201/). The queryparam _dw-init-mode-shell_ is no longer needed.

### Functionalities (Classic flavor archetype only)

In the Microfront archetype deployed in standalone mode you can try:

- The routes of the Microfront itself (Route First-child and Route Second-child).
- Create a log fake record and see how in the request the security token is sent.
- Read the log fake record and see how in the request the security token is sent.
- Throw a functional error, that is not gonna be anything else than a controlled error from the Microfront itself.

In order to see the rest of the functionalities, the most interesting option is to integrate the Microfront in a Shell archetype in a local mode and being able to see what happens. For that you can read the following documentation:

- [Shell](shell.md)
- [Functionalities](functionalities.md)
- [How to integrate a Microfront into a Shell application](../developer-guides/how-to-integrate-a-microfront-into-a-shell-application/index.md)

Now that you have everything deployed, in the top navigation menu you can click `Angular WMF` and load the Microfront that you are providing locally and take advantage of the benefits of Webpack Module Federation.

Open the developer tools and try playing with the archetypes. You can try the Microfront routes again, you will see how they work despite being inside a shell.

In addition, as you navigate through the Microfront, a `breadcrumb` belonging to Shell will be created.
Also try the communication component, both from Shell to Microfront and from Microfront to Shell, you will see how the messages will appear in the visual consoles.

It is also possible to load the Microfront through an iframe (this way is limited for now). For this, in the top navigation menu, click on `Angular Iframe`. Note that inside the iframe the Shell Lite will be loaded in addition to the Microfront itself.

### Try the distribution locally

You can create the distributed application executing the next command.

``` bash
npm run build
```

It will created a folder named `dist`. It will contain the static files of the application, one per language configured.

Deploy the Fake API to provide the configuration file of the application locally.

``` bash
npm run serve:api
```

After this you can serve the generated distribution in the `dist` folder if you have a local Nginx installed. Go to the directory where you have installed Nginx, and there, copy the content of the folder `nginx/local` of the archetype, in the `conf` installation folder of Nginx. The final result should be:

``` bash
<binary-path-nginx>/conf/nginx.conf
<binary-path-nginx>/conf.d/default-shell.conf
```

Now from the directory where is the binary of Nginx you can deploy the web server with the following command.

``` bash
./nginx.exe -c ./conf/nginx.conf
```

Try the following address:

- [http://localhost:8001/es/](http://localhost:8001/es/)
- [http://localhost:8001/en-US/](http://localhost:8001/en-US/)

!!! note
    **Important!** You have to modify certain properties in the file `default-mcf.conf` found in the folder `nginx/local/conf.d` like the `root` property, which must point the path where the distributed is located. Or also change the right ports in case you have configured them in a different way.

!!! note
    **Important!** The file `default.conf` and the remaining files `.conf` located directly in Nginx folder, are the used ones for the deployment in OpenShift of the application.

### Internationalization and Localization

In development mode Angular only allows serving a single language. When executing `npm start` the default language will be English. If you want to serve the application in Spanish you can use `npm run start:es`.

!!! note
    **Important!** When you are serving the app via `npm start` or `npm run start:es`, changing the language via the menu is not functional, as only one language is served at a time.

If you want to access the two configured languages ​​simultaneously, you must create the Microfront distribution and through Nginx try the distributions generated in standalone mode. You can read [this section](#try-the-distribution-locally) of the documentation for the Microfront.

When you run a Microfront archetype built into a shell archetype, and the shell make the request to the Microfront, it will retrieve it in the same language that the shell started. If you want to try and run a Microfront archetype built into a shell, you will need to create the shell distribution and serve it through Nginx. We recommend you read these two sections regarding the Shell:

- [Try the Shell distribution locally](shell.md#try-the-distribution-locally)
- [Shell Internationalization and Localization](shell.md#internationalization-and-localization)
- [Internationalization and Location](../developer-guides/internationalization-and-location.md)

## Developing the Microfront project

The archetype is ready to deploy the example standalone component named `Example`. You can check this in the `bootstrap-mfe.ts` file.

When you want to start developing your project and you are no longer interested in the example provided by the archetype, go to the `bootstrap-mfe.ts` file and do the following:

- Replace the `Example` component with the `App`.
- Check the `app.config.ts` file, by default some example routes and several good practices are given, such as [error handlers](../developer-guides/error-handling.md).
- You can delete everything related to the example under the `example` folder.

For more information follow the next documentation: [Getting Started with Microfront Development](../developer-guides/getting-started-with-microfront-development/index.md).

## `@santander` dependencies

!!! note
    This section **only applies** to Gluon Microfront archetype.

The Microfront archetype depends on the following `@santander` libraries:

- `@santander/flame-ds`
- `@santander/flame-ui`
- `@santander/flame-ui-angular`
- `@santander/security-angular`
- `@santander/http-angular`

If you take a look at the `package.json` file you will notice the releases of all these dependencies are fixed. This is to avoid archetype issues when any of these libraries are updated.

!!! note
    **Important!** Please update the release of these `@santander` dependencies according to the needs of your project.

## Links of interest

We advise you to fully read the Shell Archetype [documentation](shell.md) to get an overview of the entire Shell and Microfront ecosystem.
