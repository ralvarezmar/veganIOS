# Npm

[npm](https://docs.npmjs.com/) is the approved package manager used in F1rst projects. Its main benefits are installing and managing internal or external packages, executing commands through its scripts, and managing [mono repositories](https://blog.npmjs.org/post/186494959890/monorepos-and-npm.html).

## Npm 8

In its version 8, npm brings the following changes and improvements over the previous version:

## Node.js compatibility

Npm 8 is included and available from [Node.js](https://nodejs.org/) 16 and is expected to remain until Node.js 17.

## `package-lock.json` format

The purpose of the `package-lock.json` is to maintain the exact information of each installed package, including the dependencies of installed packages, ensuring the stability of the project.

This file is updated every time the `npm install` command is run and **should be versioned to the project**.

npm 8 uses the [v2](https://www.abrahamberg.com/blog/npm-package-json-lock-version-1-or-2/) format of `package-lock.json` by default and is backward compatible.

> For more information about ***lockfileVersion***, see the [package-lock.json release guide](https://www.abrahamberg.com/blog/npm-package-json-lock-version-1-or-2/)

### Dealing with the Error `npm WARN read-shrinkwrap error`

If the project is using v1 of `package-lock.json`, when you run the `npm install` command, npm will automatically update to v2.

If there is an attempt to run the project in an environment that does not support `lockfileVersion` v2, the following warning is displayed:

> npm WARN read-shrinkwrap This version of npm is compatible with lockfileVersion@1, but package-lock.json was generated for lockfileVersion@2. I’ll try to do my best with it!

It is recommended that the npm be updated so that the warning is no longer displayed.

## Custom configurations

The `--override` option has been introduced, which allows you to change the settings set by `.npmrc` or `package.json` files during the execution of a command.

```sh
npm install --override=<key>=<value>
```

### Strict Peer Dependencies

npm 7 introduced the automatic installation of [peer dependency](https://docs.npmjs.com/cli/v10/configuring-npm/package-json#peerdependencies) and kept it in version 8. However, npm 8 does the installation strictly.

If a package cannot be installed due to peer dependency conflicts, the installation will not complete, and manual remediation of the conflict will be required.

An example of a peer dependency conflict in this version occurs when a project dependency has in its own dependencies a package that is not compatible with another version already installed.

Whereas the project has the following dependencies:

``` JSON
{
  "dependencies": {
    "react": "^17.0.2",
    "react-dom": "^16.0.0"
  }
}
```

And the `react` dependency has the following dependency:

``` JSON
{
  "dependencies": {
    "react-dom": "^17.0.2"
  }
}
```

By running the `npm install` command, npm will attempt to install version `17.0.2` of the `react-dom` package and will fail because version `16.0.0` is already installed by the project. An error similar to the following will be displayed:

``` SH
npm ERR! code ERESOLVE
npm ERR! ERESOLVE unable to resolve dependency tree
npm ERR!
npm ERR! While resolving: project@1.0.0
npm ERR! Found: react-dom@16.0.0
npm ERR! node_modules/react-dom
npm ERR!   react-dom@"^16.0.0" from the root project
npm ERR!
npm ERR! Could not resolve dependency:
npm ERR! peer react-dom@"^17.0.2" from react@17.0.2
npm ERR! node_modules/react
npm ERR!   react@"^17.0.2" from the root project
npm ERR!
npm ERR! Fix the upstream dependency conflict, or retry
npm ERR! this command with --force, or --legacy-peer-deps
npm ERR! to accept an incorrect (and potentially broken) dependency resolution.
```

It is recommended to keep project dependencies up to date, but if this is not possible, an alternative is to use the `--legacy-peer-deps` option which will ignore all peer dependencies:

``` SH
npm install --legacy-peer-deps
```

It is an alternative to be used with caution, as it can cause unexpected behaviors in the project or total breakdown of it.

## New Commands

New commands such as `npm exec` and other `npm set-script`, `npm fund` and `npm diff` have been introduced. In addition, commands such as `npx` and `npm cache clean` have been deprecated.

### `npm exec`

It is an alias for the `npx` command and allows you to run commands from locally or globally installed packages.

``` SH
npm exec <package> [args...]
```

### `npm set-script`

Allows you to set scripts in the `package.json` without the need to manually add or edit it.

``` SH
npm set-script <name> <command>
```

### `npm fund`

Displays information about the project's funding, returning a list of packages that depend on the project and that have a form of financial contribution available.

``` SH
npm fund
npm fund <package>
```

### `npm diff`

Allows you to view the differences between two versions of a package.

``` SH
npm diff <package>@<version> <package>@<version>
```

## Depreciation

In npm 8, commands such as `npx` and `npm cache clean` have been deprecated.

## `npx`

As an alternative to `npx`, it is recommended to use `npm exec`.

## `npm cache clean`

The npm cache is designed to be able to retrieve information automatically in case of corruption issues or network errors, and manually clearing the cache causes npm to lose this ability.

Making it necessary to download all the packages again, slowing down the installation process.

In npm 8, the `npm cache verify` command was introduced as a more secure alternative. This command verifies the integrity of the cache and removes corrupted or unrecoverable entries.

## Updating

npm 8 is available from Node.js 16 and is automatically updated when you select version 16 or higher of Node.js. Make sure that NVS is installed and [configured correctly](./nvs/index.md), and then run the following command:

``` SH
nvs use 16
```
