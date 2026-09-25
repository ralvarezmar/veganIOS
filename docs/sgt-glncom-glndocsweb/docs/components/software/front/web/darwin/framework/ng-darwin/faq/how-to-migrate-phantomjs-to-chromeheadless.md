# How to migrate from PhantomJS to ChromeHeadless for unit test execution

PhantomJS is an open source headless browser, which due to active lack of contributions, on March 8, 2018 its main developer has decided to [archive](https://github.com/ariya/phantomjs/issues/15344#issue-302015362) until further notice. PhantomJS lags far behind other browsers in support for ECMAScript 6 features, and according to its main maintainer, PhantomJS *"eats memory like crazy"*. He himself makes mention of other browsers as a superior alternative. <!-- markdownlint-disable MD013 -->

> I think people will switch to it, eventually. Chrome is faster and more stable than PhantomJS. And it doesn't eat memory like crazy.  
I don’t see any future in developing PhantomJS. Developing PhantomJS 2 and 2.5 as a single developer is a bloody hell. Even with recently released 2.5 Beta version with new and shiny QtWebKit, I can't physically support all 3 platforms at once (I even bought the Mac for that!). We have no support. From now, I am stepping down as maintainer.  
Source: [YCombinator](https://news.ycombinator.com/item?id=14101233), [Headless Chrome is coming](https://chromestatus.com/feature/5678767817097216).

Because of this we need to dispense with its use in current projects, but not before thanking all the developers who have worked on the PhantomJS project for years.

A very good replacement option is to use the *ChromeHeadless* browser itself. To have the headless version you just need to have *Chrome* itself installed.

## Requirements

- Chrome. This will allow you to run the tests on your local machine.
- Node.js® [current release, LTS, or maintenance LTS >= 10.18.0](https://nodejs.org/en/about/previous-releases)
- npm package manager

## Remove PhantomJS from your project

To remove any reference to PhantonJS from the project, run the following command in a console

``` bash
npm uninstall phantomjs phantomjs-prebuilt karma-phantomjs-launcher
```

## Install the launcher for Chrome

To install the Chrome launcher, run the following command in a console

```bash
npm install --save-dev karma-chrome-launcher
```

## Configure *karma.conf.js* file

We have to make some small configurations in the karma.conf.js file, to tell Karma that we want to run our tests with ChromeHeadless. A few lines below, you can see what the final karma.conf.js file of your project should look like.

Changes are made to the following properties:

- `plugins`  
    The `karma-phantomjs-launcher` is removed in favor of `karma-chrome-launcher`.

- `customLauncher`  
  The `ChromeHeadlessNoSandbox` launcher is created, which uses the `ChromeHeadless` browser as a base and adds the `--no-sandbox` flag. (necessary to be able to run the tests in the continuous integration).

- `browsers`  
  Where you specify the value of `ChromeHeadlessNoSandbox`, to indicate that you want to use the `customLauncher` created earlier, and remove any reference to phantomjs.

### *karma.conf.js*

``` js
// Karma configuration file, see link for more information
// https://karma-runner.github.io/1.0/config/configuration-file.html

module.exports = function (config) {
  config.set({
    basePath: '',
    frameworks: ['jasmine', '@angular-devkit/build-angular'],
    plugins: [
      require('karma-jasmine'),
      require('karma-chrome-launcher'),
      require('karma-jasmine-html-reporter'),
      require('karma-coverage-istanbul-reporter'),
      require('@angular-devkit/build-angular/plugins/karma')
    ],
    client: {
      clearContext: false // leave Jasmine Spec Runner output visible in browser
    },
    coverageIstanbulReporter: {
      dir: require('path').join(__dirname, './coverage/my-darwin-project'),
      reports: ['html', 'lcovonly', 'text-summary'],
      fixWebpackSourcePaths: true
    },
    files: [
      { pattern: './src/assets/**', watched: false, included: false, nocache: false, served: true }
    ],
    proxies: {
      "/assets/": "/base/src/assets/"
    },
    reporters: ['progress', 'kjhtml'],
    port: 9876,
    colors: true,
    logLevel: config.LOG_INFO,
    autoWatch: true,
    browsers: ['ChromeHeadlessNoSandbox'],
    customLaunchers: {
      ChromeHeadlessNoSandbox: {
          base: 'ChromeHeadless',
          flags: [
            '--no-sandbox', // required to run without privileges in docker
          ]
      }
    },
    singleRun: false,
    restartOnFileChange: true
  });
};
```

## Configure *package.json* file

Possibly if you were using PhantomJS, you already have in the package.json file of your project a script to run the tests. Check that you activate the `--noWatch` and `--codeCoverage` flags, either as shown in the following snippet, or through the `angular.json` file, as you will see in the next section.

### *package.json*

``` json
  "scripts": {
  ...
    "test": "ng test --noWatch --codeCoverage",
  ...
  }
```

## Configure *angular.json* file

To be aligned in the continuous integration with Sonar, it is convenient to exclude specific files from the coverage. In the `angular.json` file look for the path:

``` TEXT
projects.<nombre-de-tu-proyecto>.architect.test.options
```

and add the `codeCoverageExclude` key as shown below (do not add more files than indicated, as the alignment with Sonar will be lost).

The `--noWatch` and `--codeCoverage` flags can also be set through the `angular.json` file, and not only in the package.json, but note that the settings in the *package.json* file will always prevail.

### *angular.json*

```json
"options": {
  ...
  "codeCoverageExclude": [
    "src/test.ts",
    "src/polyfills.ts",
    "src/polyfills/index.ts",
    "src/polyfills/header-api.ts"
  ],
  "watch": false,
  "codeCoverage": true,
  ...
}
```
