# ESLint Devkit Lint Plugin for Typescript

Setting [***ESLint***](https://eslint.org/) to be added to projects containing recommended rules for ***TypeScript*** files

## Prerequisites

- Installing and configuring [eslint-plugin-devkit-lint](../../index.md)
- Install ***@typescript-eslint/parser*** and ***@typescript-eslint/eslint-plugin*** dependencies

```bash title='Terminal'
npm install @typescript-eslint/parser @typescript-eslint/eslint-plugin --save-dev
```

- Configuring ***.eslintrc.json*** to suit ***TypeScript projects***

```json
{
    "parser": "@typescript-eslint/parser",
    "parserOptions": {
        "project": "./tsconfig.json" // path to compilation typescript configuration file
    },
    "extends": [
        "eslint:recommended",
        "plugin:@typescript-eslint/recommended" // recommended rules
    ],
    "plugins": [
        "@afe/devkit-lint",
        "@typescript-eslint" // plugin with specific rules to typescript
    ],
    "rules": {}
}
```

- Enable the configuration ***compilerOptions.strictNullChecks*** in ***tsconfig.json***

```json
{
  "compilerOptions": {
    // hidden information
    "strictNullChecks": true,
  }
}
```

## Usage

### Configuration

To take advantage of the rules defined in this configuration, it is necessary to add in the configuration file ***.eslintrc.json*** in the ***extends*** property the identifier ***plugin:@afe/devkit-lint/typescript*** as an example

```json
{
    "parser": "@typescript-eslint/parser",
    "parserOptions": {
        "project": "./tsconfig.json"
    },
    "extends": [
        "eslint:recommended",
        "plugin:@typescript-eslint/recommended",
        "plugin:@afe/devkit-lint/typescript"
    ],
    "plugins": [
        "@typescript-eslint",
        "@afe/devkit-lint"
    ],
    "rules": {}
}
```

One way to ensure that this setting only validates ***.ts*** files is to use the following syntax:

```json
{
    "parser": "@typescript-eslint/parser",
    "parserOptions": {
        "project": "./tsconfig.json"
    },
    "plugins": [
        "@typescript-eslint",
        "@afe/devkit-lint"
    ],
    "overrides": [
        {
            "files": ["**/*.ts"],
            "extends": [
                "eslint:recommended",
                "plugin:@typescript-eslint/recommended",
                "plugin:@afe/devkit-lint/typescript"
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
