# Angular 12's Breaking Changes

## Typescript

Added support for version 4.2 of ***TypeScript***. The supported range of versions is from **4.2.3** to **4.2.x**.

> Versions of TypeScript lower than 4.2.3 are no longer supported.

## Sass

The ***node-sass*** package used by Angular CDK and Angular Material has been deprecated and replaced by the ***sass*** package.

## Webpack

- The use and support of Webpack 4 has been removed. The Angular tool now uses Webpack 5 to build applications.

## Inline Critical CSS

Inline critical CSS is now enabled by default. To turn this off, set 'inlineCritical' to false in the property and the style preprocessor options section of the angular workspace configuration.

```json
{
    "some-project": {
        "architect": {
            "build": {
                "configurations": {
                    "production": {
                        "optimization": {
                            "styles": {
                                "inlineCritical": false
                            },
                        }
                    }
                }
            }
        }
    },
}
```
