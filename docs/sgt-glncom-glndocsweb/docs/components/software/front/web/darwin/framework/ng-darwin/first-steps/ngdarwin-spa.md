# SPA archetype

## Welcome to the Darwin archetype for Angular

### Prerequisites

Before you start to work, make sure your development environment includes Node.js® and the npm package manager.

#### Node.js

Darwin requires Node.js, an active LTS version or higher depending on the version of Angular you are developing on. **Please take a look at this [table](../../cli/index.md#node-and-angular-version) to check you have the right Node version installed.**

To check your version, run `node -v` in a terminal or console.

#### NPM

Darwin applications depend on Angular, Angular CLI and Darwin's own libraries available as npm packages. In order to download and install all the necessary packages you must have npm installed.

To check your version, run npm -v in a terminal or console.

#### Angular CLI

It is not mandatory to have it installed globally, but it is highly recommended if you want to use it later for component scaffolding.

Depending on the version of Angular that you have selected for your application, the archetype will have been generated with one or another version of the Angular CLI.
Therefore, it is convenient to install the same major version of the Angular CLI, which corresponds to the selected version of Angular. If you selected Angular version 20, install version 20 of the CLI.

``` bash
npm install -g @angular/cli@20
```

## Starting to use the archetype

### Step 1: Configure NPM

Darwin modules are hosted in Nexus, for this reason you must have NPM configured correctly. Make sure that the namespaces of the Darwin modules point to the Nexus registry correctly, this step can be done in two ways:

#### Command line

To perform the configuration through the command line, execute the following commands in your terminal:

``` bash
npm config set strict-ssl false
npm config set registry https://nexus.alm.europe.cloudcenter.corp/repository/npm-public/
```

#### Manual

To make the configuration manually you have to edit the .npmrc file, which is located in `C:\Users<YOUR-USER>`.
In case the file doesn't exist, you must create it and add the lines shown below. In case it exists check that you don't have them and add them if you don't have them yet:

``` bash
strict-ssl=false
registry=https://nexus.alm.europe.cloudcenter.corp/repository/npm-public/
```

### Step 2: Install dependencies

Having done the above, run the following command in the root of your project to install all dependencies:

``` bash
npm install
```

If you are having issues with the installation of the dependencies, check the [Troubleshooting](#troubleshooting) section.

### Step 3: Up and run Darwin Fake API and serve the application

#### Fake API

It is a REST API based on [json-server](https://github.com/typicode/json-server) capable of serving static files and JSON files, perfect for simulating AJAX request responses to the backend.

Execute the following command to run the API

``` bash
npm run serve:api
```

#### Serves the application

Run the following command and navigate to the address `http://localhost:4200/?token=fake_token`. The application will automatically reload if you make any changes to the source files.

``` bash
npm run serve:app
```

If you want to execute the two previous commands simultaneously and in a single console, you can do so through

``` bash
npm start
```

## Developing your project

!!! note
    Once the archetype has been bootstrapped, carefully read the information displayed in your browser.

### Scaffolding

If you have installed [Angular CLI](https://github.com/angular/angular-cli) globally you can run the following command to generate a new component.

``` bash
ng generate component component-name
```

You can also use:

``` bash
ng generate directive|pipe|service|class|guard|interface|enum|module
```

### Build

Run `ng build` or `npm run build` to build the project. The artifacts will be generated in the `dist/` directory. The `build` will be run with the `--configuration=production` parameter. This way it will be built in production mode.

### Running unit tests

To run the unit tests via Karma run the following command.

``` bash
npm run test
```

Please note that:

- For a Gluon architecture the archetype use Puppeteer 19.7.5 to have a binary Chrome, so it is not necessary to have a local installation of this browser on the machine where the tests are running.
- For a Darwin architecture is mandatory to have a Chrome browser installed on the machine where you run the test.

#### To take into account for unit tests

> Unit tests make use of the configureTestingModule utility that Angular provides in order to configure the module to be tested.
Modules such as HttpClientTestingModule from Angular, and ConfigTestingModule, SecurityTestingModule and LoggerTestingModule from NgDarwin are imported.
These modules create mocked providers of the services provided in each real module, so that they can be injected and tests can be run without the compiler complaining.

 The `ConfigTestingModule` service has a `forRoot` configuration method, used to mock the configuration properties of your app. Take a look at how the archetype uses it with the following example:

``` js
ConfigTestingModule.forRoot({
  appKey: 'appKey_mock',
  appName: 'appName_mock',
  app: {
    docRoutes: {
      dw: 'dw_url_mock',
      jsonServer: 'jsonServer_url_mock',
      ng: 'ng_url_mock',
      ngCli: 'ngCli_url_mock'
    }
  }
```

If you do not use the `forRoot` method, the configuration properties when you run your tests will take the following default value:

``` json
{
  appKey: 'appKey_mock',
  appName: 'appName_mock',
  app: {}
}
```

### Execute end-to-end tests

From version 12 of Angular, the use of Protractor is discouraged. For more information you can have a look [here](https://testing-angular.com/end-to-end-testing/#introducing-protractor).

In case you want to perform e2e testing, from architecture, we recommend the use of [Cypress](https://www.cypress.io/) tool. In order to provide the project with this testing capability, it is necessary to add the schematic `@cypress/schematic`.
You can have a look [here](https://testing-angular.com/end-to-end-testing/#introducing-cypress) for more information.

### Darwin Fake API

Everything that has to do with Darwin Fake API is located under the `<root>/api` folder of the project. The goal of this tool is to provide a REST API to developers who need a fast backend to mock services.
It will be in charge of serving the static `config.json` configuration file, as well as other JSON format responses needed for the playground.

It is based on [json-server](https://github.com/typicode/json-server), so check its Github repository to know how to use it and get all the benefits you need.

Execute the following command to up the API on port 3000 under the following path `http://localhost:3000/api`

``` bash
npm run serve:api
```

Darwin Fake API is composed of:

- `api-server.js`. It is the most important file of the fake API, where all your code is located. You can modify it at your disposal to simulate requests, as long as a real API is not available.
- The `db.json` file simulates a small database in JSON format, where the payload of the POST requests will be stored. To check its complete content you can access to `http://localhost:3000/api/db`
- Static files served by the API are located in the public folder and you can access them through `http://localhost:3000/<file_name.extension>`. For example `http://localhost:3000/config.json`

The following _endpoints_ have been configured:

``` text
POST /api/security/tokens/refresh   # Refresh a fake token

GET  /api/logger/logs               # list of logs
GET  /api/logger/logs/:id           # log by id
POST /api/logger/log                # creates a log in the database (db.json)
```

!!! note
    Remember that you can modify the file `api-server.js` to be able to simulate real API calls, as long as the microservices are not developed.

### Proxying to a backend server. The `proxy.conf.json` file

The archetype has a configured proxy to forward certain requests to URLs or _endpoints_, to a specific backend server.
This is a feature that can be [configured](https://angular.io/guide/build#proxying-to-a-backend-server) within an Angular project via the `proxy.conf.json`
 file and it is provided through [Webpack](https://webpack.js.org/configuration/dev-server/#devserverproxy), the bundler that Angular uses inside.

Specifically, it has been configured so that any request to an _endpoint_ of type:

- `http://localhost:4200/api/**` are redirected to `http://localhost:3000/api/**`
- `http://localhost:4200/config/**` be redirected to `http://localhost:3000/**`

This provides the benefit of being able to make requests to the same address and port where the app is being served and have them redirected to where you want them to go while the app is being developed.

You will be able to configure the _[endpoint](#endpoint-property)_ property that certain modules have, with relative URLs, as well as absolute URLs, whenever you are interested.

A small example is shown. It will make a request to `http://localhost:4200/api/security/tokens/**` and will be redirected to `http://localhost:3000/api/security/tokens/**`

``` json
"security": {
   "endpoint": "/api/security/tokens"
 }
```

In this other example, the request will be made directly to `http://localhost:3000/api/security/tokens/**` without any redirections

``` json
"security": {
   "endpoint": "http://localhost:3000/api/security/tokens"
 }
```

!!! note
    Remember that these redirects are only active while you are developing the app and serving it with npm start or npm run serve.

### Archetype configuration for a real token

As the development of your project evolves you will need to configure it to obtain a real token, and it can be used to call the services that need authorization. For this, you will make use of a Common Service called SCC (backend service).

Open the file `config.json`. You need to configure the _security.endpoint_ property with an appropriate path.

The routes of common services, including those of the SCC service, can be found [here](https://sanes.atlassian.net/wiki/spaces/SANACLOUD/pages/16524083406){:target="_blank"}. Make sure you use the appropriate one for your project.

For example, to obtain a token in the CERT (development) environment for the Intranet channel, you should configure the following _endpoint_:

``` json
"security": {
  "endpoint": "https://sccnuar.santander.dev.corp/scc"
}
```

This configuration to attack directly to the endpoints of the common services,
can be valid to work locally, but when the SPA is deployed in a PaaS, the [CORS](https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS) policy problems will start to affect you. To solve them, it is best to attack the common services through a Web Gateway.
This Gateway will be deployed in your PaaS with the same domain, and therefore, will not be affected by [CORS](https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS)  policies.
For more information on how to configure the Web Gateway for common services, access [here](https://santandernet.sharepoint.com/sites/darwin-community/SitePages/How%2Bdo%2BI%2Bset%2Bup%2BCommon%2BServices%2Bin%2Bmy%2Bproject.aspx).

#### Endpoint property

This property is present in the configuration of certain modules that need to make AJAX requests, such as _Security Module_ or _Logger Module_ and must comply with a rather strict regular expression:

- The protocol is optional. If present, it must be _http_ or _https_.
- If a protocol is specified, both a domain and a subdomain must be specified (except _localhost_ which is allowed).
- May contain a port number up to 65535.
- It cannot end with a slash.
- Can be a relative path (no protocol) and start with a slash.
- Cannot start with a double slash.

Correct examples:

``` text
http://endpoint.com/path
https://endpoint.com/path
https://end-point.com/path
https://endpoint.com/path/subpath/morepath
https://localhost:3000/path
/api/path/subpath
```

Incorrect examples:

``` text
https://endpoint.com/path/      # note that the end slash is not allowed
https://endpoint/path
https://end-point/path
//endpoint.com/path
api/path/subpath
```

### `@santander` dependencies

!!! note
    This section **only applies** to Gluon SPA archetype.

The Gluon SPA archetype depends on the following `@santander` libraries:

- `@santander/flame-ds`
- `@santander/flame-ui`
- `@santander/flame-ui-angular`
- `@santander/security-angular`
- `@santander/http-angular`

If you take a look at the `package.json` file you will notice the releases of all these dependencies are fixed. This is to avoid archetype issues when any of these libraries are updated.

!!! note
    **Important!** Please update the release of these `@santander` dependencies according to the needs of your Gluon SPA project.

### Legacy browsers

Internet Explorer 11 is a legacy browser and luckily support for it in Angular 13 has being dropped officially.

[Angular Browser Support](https://angular.io/guide/browser-support)

## Troubleshooting

Issues during the whole process and possible solutions

### Issues with the installation of Darwin modules

If you find any issue when installing the Darwin modules, because of a certain version is not found, it is possible that the Nexus registry has not yet refreshed its metadata, and has not realized that there are new versions of the libraries.
Normally, the registry is configured as follows:

``` bash
registry=https://nexus.alm.europe.cloudcenter.corp/repository/npm-public/
```

But as a workaround we can tell the @darwin and @ng-darwin namespaces to download directly from Nexusmaster, as shown in the example below. **Once the Nexus proxy is working the right way again, put back the previous configuration**.

``` bash
strict-ssl=false
registry=https://nexus.alm.europe.cloudcenter.corp/repository/npm-public/
@darwin:registry=https://nexusmaster.alm.europe.cloudcenter.corp/repository/npm-releases/
@ng-darwin:registry=https://nexusmaster.alm.europe.cloudcenter.corp/repository/npm-releases/
```

### Issues when checking for vulnerabilities in Fortify

It is possible that you have vulnerabilities in your project's dependencies.

To check for vulnerabilities in your project's dependencies just run the following command:

``` bash
npm audit --registry <https://registry.npmjs.org>
```

If you want to omit the development dependencies  add the `--omit dev` flag.

``` bash
npm audit --registry <https://registry.npmjs.org> --omit dev
```

In case you have vulnerabilities only in the development dependencies, you can skip them from the [Fortify](https://fortify-ssc.isban.gs.corp/ssc/) tool itself.
You can review the documentation provided by the Secure Development team [here](https://sanes.atlassian.net/wiki/spaces/ESXSEGINFO/pages/24763302652/Base+de+Conocimiento+-+Fortify#6.-Dependencias---Darwin-Angular-Framework-(Ng-Darwin){:target="_blank"}).
