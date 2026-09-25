# Shell archetype

!!! note
    Shell Darwin archetype based on Angular and Webpack Module Federation.

## Prerequisites

### Node.js and NPM

=== "Angular 20"
    Darwin needs Node.js, an active LTS version or greater or equal to **20.19.0**.

=== "Angular 18"
    Darwin needs Node.js, an active LTS version or greater or equal to **18.19.1**.

For checking your versión, execute `node -v` in a terminal or console.

The Darwin applications depends on Angular, Angular CLI and of the Darwin librarys availables as NPM packages. For being able to download and install all the packages required you must have installed npm.

For checking your version, execute `npm -v` in a terminal or console.

## How to generate a Shell archetype

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

In order to get the Microfront application, the Darwin generator should be used. Go to the following documentation, read all the sections carefully and generate a new _Shell application project_ to start working with a Shell archetype.

[Darwin Front CLI](../../cli/index.md)

!!! note
    Please note that a real and complete onboarding of any project must be done with an on boarding tool like [360](https://gluon.gs.corp/gluon){:target="_blank"}. This application will use the Darwin Front CLI Generator tool under the hood.

### Step 3: Install the dependencies

After doing the above configuration, execute the next command in the root of the project to install all the dependencies.

``` bash
npm install
```

### Step 4: Run the Darwin Fake API, serve and test the application

#### Fake API

It is an API REST based on [json-server](https://github.com/typicode/json-server){:target="_blank"} which is able to provide static files and JSON files, perfect for simulating responses from AJAX request to the backend.

Execute the following command to deploy it.

``` bash
npm run serve:api
```

!!! note
    **Important!** The Fake API is deployed by default in the port 3000. If you need to change it, you can achieve it in the file `api-server.js` found in the api folder. You will have to change it too in `proxy.conf.json` file with the redirections to the right port. <!-- markdownlint-disable MD013 -->

#### Serve the application locally

Execute the next command and go to [http://localhost:4200](http://localhost:4200). The application will refresh automatically if you do any change in the source files.

``` bash
npm run serve:app
```

!!! note
    **Important!** Keep in mind that the archetype is configured by default to deploy in the 4200 port. If you need to modify it, you can achieve it in the `angular.json` file.

If you want to execute the last two commands at the same time in only one console you can do it through:

``` bash
npm start
```

#### Running unit test

To run the unit tests via Karma run the following command.

```bash
npm run test
```

Please note that:

- For a Gluon architecture the archetype use Puppeteer 19.7.5 to have a binary Chrome, so it is not necessary to have a local installation of this browser on the machine where the tests are running.
- For a Darwin architecture is mandatory to have a Chrome browser installed on the machine where you run the test.

## Try the distribution locally

You can create the distributed application executing the next command.

``` bash
npm run build
```

It will created a folder named `dist`. It will contain the static files of the application, one per language configured.

Deploy the Fake API to provide the configuration file of the application locally.

``` bash
npm run serve:api
```

After this you can serve the generated distributiion in the `dist` folder if you have a local Nginx installed. Go to the directory where you have installed Nginx, and there, copy the content of the folder `nginx/local` of the archetype, in the `conf` installation folder of Nginx. The final result should be:

``` bash
<binary-path-nginx>/conf/nginx.conf
<binary-path-nginx>/conf.d/default-shell.conf
```

Now from the directory where is the binary of Nginx you can deploy the web server with the following command.

``` bash
./nginx.exe -c ./conf/nginx.conf
```

Try the next address:

[http://localhost:8000](http://localhost:8000)

!!! note
    **Important!** You have to modify certain properties in the file `default-shell.conf` found in the folder `nginx/local/conf.d`, like the `root` property, which must point the path where the distributed is located. Or also change the right ports in case you have configured them in a different way.

!!! note
    **Important!** The file `default.conf`, and the remaining files `.conf` located directly in Nginx folder, are the used ones for the deployment in OpenShift of the application.

## Internationalization and Localization

In development mode of Angular it only allows to provide a single language. When `npm start` is executed, by default it will use english language. If you want to provide the application in spanish you can use `npm run start:es`.

!!! note
    **Important!** When you are providing the application through `npm start` or `npm run start:es`, the language change through the menu is not functional as only one language is served simultaneously.

If you want to try the language chance locally, you will have to create the distribution of the Shell and serve it through Nginx. You can read [this section](#try-the-distribution-locally) of the documentation. Currently the Shell archetype simulates retrieve the language through a fake service that Darwin Fake API provides. (By default `en-US`).

Steps performed by the application regarding the language:

1. It access to a determined location (`ES` o `en-US`) of the application.
2. The application will retrieve the language of the user of the fake API, in this case `en-US`.
3. If you are not in the right location, automatically it will redirect to the right one, marked by the user language retrieve in the previous step.

Due to the previous, the application will be provided with the localization `en-US`. If you click in the language button (`ES`) of the menu, and whenever you are providing the Shell distribution, you will be able to check that the language change is not done, keeping the localization `en-US`, since that this is the preferred languaged of the user, according to the Fake API Service.

If actually you want to simulate the language change, perform these steps:

1. Provide the application through `npm run serve:app`.
2. Provide the Fake API through `npm run serve:api`.
3. Access to the application that will be provided in `en-US`.
4. Stop the Fake API.
5. Go to the `db.json` file and modify the attribute `preferredLanguage` setting the value `es`, simulating that the language of the user has ben modified.
6. Deploy again the Fake API with `npm run serve:api`.
7. Click `ES` to access that localization.

## `@santander` dependencies

!!! note
    This section **only applies** to Gluon Shell archetype.

The Microfront archetype depends on the following `@santander` libraries:

- `@santander/flame-ds`
- `@santander/flame-ui`
- `@santander/flame-ui-angular`
- `@santander/security-angular`
- `@santander/http-angular`

If you take a look at the `package.json` file you will notice the releases of all these dependencies are fixed. This is to avoid archetype issues when any of these libraries are updated.

!!! note
    **Important!** Please update the release of these `@santander` dependencies according to the needs of your project.

## Access to the Microfronts

If you try to access the Microfront through the navigation menu tabs, (included iframe access) you will notice that is loading an already deployed Microfront. This is used as an example, if you want to generate and integrate one Microfront you can read the following [documentation](../developer-guides/how-to-integrate-a-microfront-into-a-shell-application/index.md).
