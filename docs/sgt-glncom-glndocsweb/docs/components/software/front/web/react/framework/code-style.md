# Code Style

## Language - Typescript

We strongly recommend using **TypeScript** with JSX for React projects. TypeScript
provides static typing that increases code reliability, maintainability, and
scalability. It enhances developer productivity by catching errors early in the
development phase.

```Javascript title="eslint.config.js"
import js from '@eslint/js'
import globals from 'globals'
import reactHooks from 'eslint-plugin-react-hooks'
import reactRefresh from 'eslint-plugin-react-refresh'
import tseslint from 'typescript-eslint'

export default tseslint.config(
  { ignores: ['dist'] },
  {
    extends: [js.configs.recommended, ...tseslint.configs.recommended],
    files: ['**/*.{ts,tsx}'],
    languageOptions: {
      ecmaVersion: 2020,
      globals: globals.browser,
    },
    plugins: {
      'react-hooks': reactHooks,
      'react-refresh': reactRefresh,
    },
    rules: {
      ...reactHooks.configs.recommended.rules,
      'react-refresh/only-export-components': [
        'warn',
        { allowConstantExport: true },
      ],
    },
  },
)
```

## Linter - ESLint

Recommended linter is **ESLint** due to high community usage and presence in most
projects. Gluon React projects will be using this ESLint plugins:

- typescript-eslint (Monorepo for the tooling that enables ESLint and Prettier
  to support TypeScript )
- eslint-plugin-react-hooks (Official react plugin for hooks usage)
- eslint-plugin-react-refresh (Validate that your components can safely be updated with fast refresh)

If you want to dig deeper, you can take a look the [TypeScript + ESLint docs](https://github.com/typescript-eslint/typescript-eslint){:target="_blank"}
