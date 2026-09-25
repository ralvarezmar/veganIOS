# How to Troubleshoot "Debugging in VSCode by Browser Not Working"

## Contextualization

When a project tries to debug its application through VSCode's own debugger, it may end up facing the scenario where breakpoints are not identified and consequently, it is not possible to debug the intended code.

This can occur if the project angular.json does not have a development property within project
> `<PROJECT-NAME>`
> -> architect
> -> build
> -> configurations which enables the ***sourceMap*** option, responsible for telling the browser which part of the **JavaScript** code corresponds to the **TypeScript** code.

## Solution

If it's the setting for your project, add the following code right after setting up ***production***

```json
{
  "build": {
    "configurations": {
      "production": {
        // código omitido
      },
      "development": {
        "sourceMap": true,
      }
    }
  }
}
```

And then, inside the ***serve*** property, add the following lines:

```json
{
  "projects": {
    "<NOME-DO-PROJETO>": {
      // código omitido
      "serve": {
        "development": {
          "browserTarget": "<PROJECT-NAME>:build:development"
        }
      },
      "defaultConfiguration": "development"
    }
    // código omitido
  }
}
```

> Where the variable `<PROJECT-NAME>` should be replaced with the project name.
