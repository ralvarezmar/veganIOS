# TSLint Depreciation

Angular 10 has deprecated support for [TSLint](https://palantir.github.io/tslint/) in projects. As a substitute tool, the use of the [**ESLint**](https://eslint.org/) library for the following versions of the framework was guided.

In this session, you'll learn how to migrate the [**TSLint**](https://palantir.github.io/tslint/) library to [**ESLint**](https://eslint.org/) in an Angular project.

## Migration from TSLint to ESLint

To perform the migration, the [Angular ESLint](https://github.com/angular-eslint/angular-eslint) library will be used.

> Only projects using Angular 10+ can be migrated.

Inside the Angular project, run the following command:

```bash
ng add @angular-eslint/schematics
```

> The above command adds the '@angular-lint' library to the project.

Next, run the command that will perform the migration:

```bash
ng g @angular-eslint/schematics:convert-tslint-to-eslint [name-of-application]
```

> Replace [application-name] with the name used to reference the application in the **angular.json** file

## Project migrated to ESLint

If all goes well, you'll find a new file called '.eslintrc.json' in the root of the project and also in the application given in the previous command.

This new file contains all the rules that were stored in the file 'tslint.json'. Thus, it will hardly be necessary to make any modification to the created '.eslintrc.json' file.

## Run the linter

To make sure lint is working fine, run the following command in your project:

```bash
npx ng lint [name-of-application]
```

The following output should appear on your terminal:

```bash
Linting "[name-of-application]"...
All files pass linting.
```

> Congratulations ✅
>
> You migrated your project from [**TSLint**](https://palantir.github.io/tslint/) to [**ESLint**](https://eslint.org/) :)

## References

If you need any more specific information about the migration, please visit the [official Angular ESLint documentation](https://github.com/angular-eslint/angular-eslint#migrating-an-angular-cli-project-from-codelyzer-and-tslint).
