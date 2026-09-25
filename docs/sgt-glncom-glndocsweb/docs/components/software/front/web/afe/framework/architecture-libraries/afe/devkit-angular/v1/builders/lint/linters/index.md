# Linters - ESLint

## Specific Settings

| Configuration | Description | Default Value |
| ----------------- | ------------------------------------------------------------------------------------------------------------------------------ | ----------------------------------- |
| **eslintConfig** | ESLint Configuration File Location | ***.eslintrc.json*** or ***.eslintrc.js*** |
| **ignorePath** | Configuration File Location of Files to Ignore in lint validation | ***.eslintignore*** |
| **format** | ESLint Output Formatting for More Details [Access Here](https://eslint.org/docs/user-guide/formatters) | ***stylish*** |
| **cache** | Indicates whether to cache lint executions to only validate changed files | ***false*** |
| **cacheLocation** | Location of the file or cache storage directory. Required if the ***cache*** property is set to ***true*** | ***null*** |

### eslintConfig

In this example, we will use the ***ESLint*** settings in the ***eslint-config.json*** file

```json
{
    "projects": {
        "exemplo": {
            "architect": {
                "build": {
                    "builder": "@afe/devkit-angular:lint",
                    "options": {
                      "linters": ["eslint"],
                        "eslint": {
                            "eslintConfig": "./eslint-config.json"
                        }
                    }
                }
            }
        }
    }
}
```

### ignorePath

In this example, we will use the settings for ignoring lint validation defined in the ***eslint-ignore.json*** file

```json
{
    "projects": {
        "exemplo": {
            "architect": {
                "build": {
                    "builder": "@afe/devkit-angular:lint",
                    "options": {
                      "linters": ["eslint"],
                        "eslint": {
                            "ignorePath": "./eslint-ignore.json"
                        }
                    }
                }
            }
        }
    }
}
```

### format

In this example, the ***ESLint*** lint report will be displayed in the terminal in the format ***HTML***

```json
{
    "projects": {
        "exemplo": {
            "architect": {
                "build": {
                    "builder": "@afe/devkit-angular:lint",
                    "options": {
                      "linters": ["eslint"],
                        "eslint": {
                            "format": "html"
                        }
                    }
                }
            }
        }
    }
}
```

### cache e cacheLocation

In this example, each time the ***lint*** process runs, the ***eslint-cache*** directory will be updated with the validation result

```json
{
    "projects": {
        "exemplo": {
            "architect": {
                "build": {
                    "builder": "@afe/devkit-angular:lint",
                    "options": {
                      "linters": ["eslint"],
                        "eslint": {
                            "cache": true,
                            "cacheLocation": "./eslint-cache/"
                        }
                    }
                }
            }
        }
    }
}
```
