# Wrong registry configuration

Run the install command with drill-down parameter `npm install —-verbose`.

This way, you'll be able to see what NPM is doing.

With this, it could probably be that requests are occurring to the ***artifactory*** of the ***produbanbr*** domain, which was discontinued years ago.

Considering that dependency publications currently occur in the ***santanderbr*** domain (correct domain), NPM will be on hold until it gives ***timeout*** in the download attempt for some non-existent package.

This is due to the fact that the ***.npmrc*** file located at the root of the project is configured with the old domain instead of the current one (this can also happen during the publishing process in some environment.

The difference is that the ***.npmrc*** file will be located in the ***.ci/files*** folder instead of the root of the project).

## Wrong

```conf
registry=http://artifactory.produbanbr.corp/artifactory/api/npm/npm-all
```

## Correct

```conf
registry=http://artifactory.santanderbr.corp/artifactory/api/npm/npm-all
```
