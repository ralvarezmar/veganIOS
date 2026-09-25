# ESLint Devkit Lint Plugin for Javascript

Setting [***ESLint***](https://eslint.org/) to be added to projects containing recommended rules for ***JavaScript*** files

## Prerequisites

- Installing and configuring [eslint-plugin-devkit-lint](../../index.md)

## Usage

### Configuration

To take advantage of the rules defined in this configuration, it is necessary to add in the configuration file ***.eslintrc.json*** in the ***extends*** property the identifier ***plugin:@afe/devkit-lint/javascript*** as an example

```json
{
    "extends": [
        "eslint:recommended",
        "plugin:@afe/devkit-lint/javascript"
    ],
    "plugins": [
        "@afe/devkit-lint"
    ],
    "rules": {}
}
```

One way to ensure that this setting only validates ***.js*** files is to use the following syntax:

```json
{
    "plugins": [
        "@afe/devkit-lint"
    ],
    "overrides": [
        {
            "files": ["**/*.js"],
            "extends": [
                "eslint:recommended",
                "plugin:@afe/devkit-lint/javascript"
            ],
        }
    ],
    "rules": {}
}
```

With this, the following rules will be validated in your project:

- [Bugs](./bugs.md): Rules that prevent potential bugs in the project
- [Best Practices](./best-practices.md): Rules that promote good code practices
- [Code Smells](./code-smells.md): Rules that promote code standardization
