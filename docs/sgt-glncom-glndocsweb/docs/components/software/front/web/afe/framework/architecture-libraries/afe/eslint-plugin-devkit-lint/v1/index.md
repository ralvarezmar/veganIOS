# ESLint Plugin Devkit Lint

## Prerequisites

Installing [***eslint***](https://eslint.org/) in the project through the command:

```bash title='Terminal'
npm install eslint@^7.18.0 --save-dev
```

## Installing

```bash title='Terminal'
npm install @afe/eslint-plugin-devkit-lint@^1 --save-dev
```

## Use

### Configuration

To configure ***ESLint*** in the project, the ***.eslintrc.json*** file must be created at the root of the project with the following contents:

```json
{
    "extends": [
        "eslint:recommended"
    ],
    "plugins": [
        "@afe/devkit-lint"
    ],
    "rules": {}
}
```

Through this base configuration you can add more ***plugins*** and extend other settings in the ***extends*** property. When adding the plugin ***@afe/devkit-lint*** the following settings will be available to be added in ***extends***:

- [***plugin:@afe/devkit-lint/javascript***](./settings/javascript/index.md): Recommended for projects using ***.js*** files
- [***plugin:@afe/devkit-lint/typescript***](./settings/typescript/index.md): Recommended for projects using ***.ts*** files

> For more configuration details, go to [official ESLint documentation](https://eslint.org/docs/user-guide/configuring)

### Project Validation

To validate the potential notes that the project will have with the configured rules, it is possible to use the [ESLint CLI](https://eslint.org/docs/user-guide/command-line-interface)

For ***Angular*** projects, another option is to use the builder [***@afe/devkit-angular:lint***](../../devkit-angular/v1/builders/lint/index.md)

### Override Rule Settings

If necessary, you can override the rule settings by adding the configuration that makes sense for the project to the ***rules*** property

```json
{
    "extends": [
        "eslint:recommended"
    ],
    "rules": {
        "eqeqeq": ["off"], // disable the regra
        "no-caller": ["warn"], // change the severity
        "quotes": ["warn", "double"], // change the configuration options
    }
}
```

### Other Recommended Plugins

In addition to the settings available on the part, there are other recommended plugins that can be added

- [***eslint-plugin-jasmine***](https://github.com/tlvince/eslint-plugin-jasmine): Validate unit test implementations using [***Jasmine***](https://jasmine.github.io/)
- [***eslint-plugin-jest***](https://www.npmjs.com/package/eslint-plugin-jest): Validate unit test implementations using [***Jest***](https://jestjs.io/)

### Extensions for Text Editors

In order to speed up development, it is possible to install the following extensions in the text editor:

- VSCode
  - [ESLint](https://marketplace.visualstudio.com/items?itemName=dbaeumer.vscode-eslint)
