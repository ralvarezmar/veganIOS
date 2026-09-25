# Project of type ***application***

Builder responsible for providing a development server for projects of type ***application***.

## Settings

In addition to the settings that builder ***@angular-devkit/build-angular:dev-server*** has, the following settings have been added:

| Configuration | Description | Default Value |
| ------------ | ---------- | ------------ |
| **extraWebpackConfig** | Additional webpack configuration to be merged with the internal one that Angular uses | null*** |

## Using ***extraWebpackConfig***

The code below shows an example of how to use the ***extraWebpackConfig*** property

``` JSON
//angular.json
{
    "projects": {
        "exemplo": {
            "architect": {
                "build": {
                    "builder": "@afe/devkit-angular:dev-server",
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

> It is necessary that the file is written in the extension ***.js*** and use ***module.exports*** as an example.
