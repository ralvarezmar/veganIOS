# How to Solve ***ERR! node-***

This error occurs when installing dependencies via the 'npm install' command and usually indicates that your project is misconfigured.

To resolve the issue, identify the causes by following the instructions below.

## 1. ***package.json*** file containing the ***node-sass*** dependency

The node-sass library should not be used explicitly by your project. The use of it causes erroneous behaviors in the installation process.

Remove it from your project via command:

```bash
npm uninstall node-sass
```

## 2. Misconfigured variable ***sass_binary_site***

The **sass_binary_site** or **SASS_BINARY_SITE** variable must be configured in the **.npmrc** file both at the root of your project and inside the **.ci/files/.npmrc** folder.

This configuration is essential so that in the process of installing dependencies, the bank's already approved dependency is used.

Add the following line of code to the root **.npmrc** file and also inside the **.ci/files/.npmrc** folder.

```diff
+ sass_binary_site=http://artifactory.santanderbr.corp/artifactory/github-sass/download
```

## 3. Duplicate dependencies in the **package.json** file

Duplicate dependencies, in addition to being a bad practice, many create problems in the project.

Remove these duplicate dependencies from the **package.json** file, leaving only one of them recorded.

```diff
  "dependencies": {
-   "minha-dependencia-duplicada": "x.x.x"
  }
  "devDependencies": {
    "minha-dependencia-duplicada": "x.x.x"
  }
```

Leave only one occurrence of each dependency!

Also pay attention to the location of each dependency. The **devDependencies** and **dependencies** properties should be used as per your responsibility.

The list below shows where to register each dependency:

- **devDependencies**: Used to record dependencies that are consumed in build processes or that consume NodeJS directly.
- **dependencies**: Used to register dependencies that are linked directly to your project's code. These dependencies are added to the final bundle of your application.

## 4. NodeJS version

In some scenarios, the version of NodeJS installed on your machine can cause the problem.

For example, NodeJS version 12 often causes the error described in this document.

To resolve the issue, update your NodeJS version to version 14.15 or higher.

Once you've made these changes, run the 'npm install' command again.

Probably the error will be corrected.
