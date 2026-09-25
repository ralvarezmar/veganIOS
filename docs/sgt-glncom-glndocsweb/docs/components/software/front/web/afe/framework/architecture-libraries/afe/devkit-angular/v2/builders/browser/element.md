# Project of type **_element_**

In projects of type **_element_** the builder **_[ngx-build-plus:browser](https://github.com/manfredsteyer/ngx-build-plus)_** is wrapped.

The Front-End Architecture tool **_@afe/devkit-angular:browser_** adds some processes such as **_prebuild_**, which consists of running **_lint_** referring to some standard rules of the architecture.

And also other routines that allow the project to be made available correctly.

## What is **[ngx-build-plus:browser](https://github.com/manfredsteyer/ngx-build-plus)** ?

**_[ngx-build-plus:browser](https://github.com/manfredsteyer/ngx-build-plus)_** is an external library that has some features that enable the project:

- Use custom webpack settings
- Decouple dependencies from the final bundle
- Bundle the **_main.js_**, **_vendor.js_** and **_runtime.js_** files generated in the build process into a single bundle

## Settings

In addition to the settings that the builder **_@angular-devkit/build-angular:browser_** has, the following settings have been added:

| Configuration | Description | Default Value |
| ------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------ |
| **_extraWebpackConfig_** | Configuration of Webpack that merges with Angular_Angular | **_null_** |
| **_singleBundle_** | Merges the **_main_**, **_vendor_** and **_runtime_** files generated in the **_build_** process to form a single **_bundle_** | **_false_** |
| **_keepPolyfills_** | Used in conjunction with the **_singleBundle_** property in the value **_true_**. Generates a **_bundle_** of **_polyfill_** piece. It is recommended to keep the value **_true_** | **_true_** |
| **_keepStyles_** | Used in conjunction with the **_singleBundle_** property in the value **_true_**. Generates a **_bundle_** of **_styles_** part | **_false_** |
| **keepScripts** | Used in conjunction with the **_singleBundle_** property in the value **_true_**. Generates a **_bundle_** of **_script_** part | **_false_** |

## Using Settings

The section below shows in detail how to use the available settings for the Front-End Architecture builder **_@afe/devkit-angular:browser_** builder.

### Using **_extraWebpackConfig_**

Configuration of Webpack that is merged with Angular.

```json
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
};
```

> important!
>
> It is necessary that the file is written in the extension **_.js_** and use **_module.exports_** as an example

### Using the **_singleBundle_** property

Merges the **_main_**, **_vendor_** and **_runtime_** files generated in the **_build_** process to form a single **_bundle_** file.

``` JSON
//angular.json
{
  "projects": {
    "exemplo": {
      "architect": {
        "build": {
          "builder": "@afe/devkit-angular:browser",
          "options": {
            "singleBundle": true
          }
        }
      }
    }
  }
}
```

> This property must always be set to **_true_** for all other properties to work correctly.

### Using the **_keepPolyfills_** property

Property used in conjunction with **_singleBundle_** when set to **_true_** (**_singleBundle: true_**). Generates a **_bundle_** of **_polyfill_** piece.

It is recommended that you always set this option to **_true_**.

``` JSON
//angular.json
{
  "projects": {
    "exemplo": {
      "architect": {
        "build": {
          "builder": "@afe/devkit-angular:browser",
          "options": {
            "singleBundle": true,
            "keepPolyfills": true
          }
        }
      }
    }
  }
}
```

> You need to set the **_singleBundle_** property to work.

### Using the **_keepStyles_** property

Used in conjunction with the **_singleBundle_** property in the value **_true_**.

Generates a **_bundle_** of **_styles_** part.

``` JSON
//angular.json
{
  "projects": {
    "exemplo": {
      "architect": {
        "build": {
          "builder": "@afe/devkit-angular:browser",
          "options": {
            "singleBundle": true,
            "keepStyles": true
          }
        }
      }
    }
  }
}
```

> You need to set the **_singleBundle_** property to **_true_** to work.

### Using the **_keepScripts_** property

Used in conjunction with the **_singleBundle_** property in the value **_true_**.

Generates a **_bundle_** of **_script_** part.

```json
{
  "projects": {
    "exemplo": {
      "architect": {
        "build": {
          "builder": "@afe/devkit-angular:browser",
          "options": {
            "singleBundle": true,
            "keepScripts": true
          }
        }
      }
    }
  }
}
```

> You need to configure the property **_singleBundle_** as **_true** to work.
