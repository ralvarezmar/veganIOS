# Configuring ***NPM***

In addition to the programs mentioned it is necessary to change a configuration file (***.npmrc***), located in the user folder on your machine, use the following command to change it.

```bash
npm config set registry http://artifactory.santanderbr.corp/artifactory/api/npm/npm-all/
npm config set PUPPETEER_SKIP_CHROMIUM_DOWNLOAD true
npm config set SASS_BINARY_SITE http://artifactory.santanderbr.corp/artifactory/github-sass/download/
```

Once this is done, we can check the settings with the command:

```bash
npm config list
```

The return of the command should display a structure with the same values as provided above. If not, repeat the process.
