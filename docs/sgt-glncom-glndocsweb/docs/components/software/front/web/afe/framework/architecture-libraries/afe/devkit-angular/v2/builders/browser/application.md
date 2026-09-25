# Project of type ***application***

In projects of type ***application*** the builder ***@angular-devkit/build-angular:browser*** is encapsulated. The Front-End Architecture tool adds a pre-build process that consists of running lint for some standard architecture rules.

## Settings

In addition to the settings that builder ***@angular-devkit/build-angular:browser*** has, the following settings have been added:

| Configuration | Description | Default Value |
| ------------ | ---------- | ------------ |
|***extraWebpackConfig*** | Configuration of Webpack that is merged with Angular: Angular | null*** |

## Using ***extraWebpackConfig***

The code below shows an example of how to use the ***extraWebpackConfig*** property

``` JSON
//title=angular.json
{
    "projects": {
        "exemplo": {
            "architect": {
                "build": {
                    "builder": "@afe/devkit-angular:browser",
                    "options": {
                      "extraWebpackConfig": "./webpack-custom.config.js"
                    }
                }
            }
        }
    }
}
```

``` JS
//webpack-custom.config.js
module.exports = {
  // propriedades de configuração de Webpack
}
```

> important!
>
> It is necessary that the file is written in the extension ***.js*** and use ***module.exports*** as an example.
