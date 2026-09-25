# Lint Builder

Builder responsible for carrying out the ***lint*** process in the projects based on the ***Linters*** configured in order to improve the quality of the code considering pre-defined rules

## Settings

| Configuration | Description | Default Value |
| -------------------- | ------------------------------------------------------------------------------------ | ------------ |
| **linters** | Defining Which Linters Will Run | ***N/A*** |
| **lintFilePatterns** | Defining which files will be validated by linters | ***[]*** |
| **fix** | Corrects all possible rule notes | ***false*** |
| **force** | Forces the execution to end in success even with error notes or warnings | ***false*** |
| **silent** | Run ***lint*** without feedback in the terminal | ***false*** |
| **quiet** | Report only errors, hiding warnings | ***false*** |
| **maxWarnings** | Maximum number of warning notes that can occur in the project | ***null*** |
| **eslint** | Linter Specific Settings ***ESLint***... | ***null*** |

### linters

The linters currently available are:

- [***eslint***](https://eslint.org/)

Example of using the property

```json
{
    "projects": {
        "exemplo": {
            "architect": {
                "build": {
                    "builder": "@afe/devkit-angular:lint",
                    "options": {
                      "linters": ["eslint"]
                    }
                }
            }
        }
    }
}
```

> This property is required

### lintFilePatterns

In this example, the validation will be done only in files with ***.ts*** extension. If you don't pass any item in this property no file will be validated.

```json
{
    "projects": {
        "exemplo": {
            "architect": {
                "build": {
                    "builder": "@afe/devkit-angular:lint",
                    "options": {
                      "linters": ["eslint"],
                      "lintFilePatterns": ["**/*.ts"]
                    }
                }
            }
        }
    }
}
```

### fix

In this example, when you run the ***lint*** process, all notes that have a correction logic will be automatically fixed.

```json
{
    "projects": {
        "exemplo": {
            "architect": {
                "build": {
                    "builder": "@afe/devkit-angular:lint",
                    "options": {
                      "linters": ["eslint"],
                      "fix": true
                    }
                }
            }
        }
    }
}
```

### force

Example of using the property

```json
{
    "projects": {
        "exemplo": {
            "architect": {
                "build": {
                    "builder": "@afe/devkit-angular:lint",
                    "options": {
                      "linters": ["eslint"],
                      "force": true
                    }
                }
            }
        }
    }
}
```

### silent

Example of using the property

```json
{
    "projects": {
        "exemplo": {
            "architect": {
                "build": {
                    "builder": "@afe/devkit-angular:lint",
                    "options": {
                      "linters": ["eslint"],
                      "silent": true
                    }
                }
            }
        }
    }
}
```

### quiet

Example of using the property

```json
{
    "projects": {
        "exemplo": {
            "architect": {
                "build": {
                    "builder": "@afe/devkit-angular:lint",
                    "options": {
                      "linters": ["eslint"],
                      "quiet": true
                    }
                }
            }
        }
    }
}
```

### maxWarnings

In this example, if the project has more than 100 ***warning*** severity notes, the ***lint*** process will end with failure.

```json
{
    "projects": {
        "exemplo": {
            "architect": {
                "build": {
                    "builder": "@afe/devkit-angular:lint",
                    "options": {
                      "linters": ["eslint"],
                      "maxWarnings": 100
                    }
                }
            }
        }
    }
}
```
