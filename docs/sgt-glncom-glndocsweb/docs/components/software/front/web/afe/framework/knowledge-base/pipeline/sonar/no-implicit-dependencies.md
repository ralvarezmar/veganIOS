# How to solve the "no-implicit-dependencies" pointing

## Contextualization

Some projects, such as an Element(MFE) or a Library, may have an absolute import pointing to the `src` property in the ***tsconfig.json***, and therefore not have the `src` folder but a ***projects*** folder.

Which will result in a ***"no-implicit-dependencies"*** error, because when pointing to the `src` folder, it will not be located.

```bash
{

  // hidden code

    "paths": {
      "src/"*:[
        "projects/<YOUR_PROJECT_NAME>/src/*"
      ]
    }
  "include":[
    "**/*"
  ]
}
```

## Architecture Guidelines

Avoid the use of **absolute imports** and prefer **relative imports**, as they make it easier to maintain the project.

## Solution

Remove the absolute import used to create an alias for the projects folder:

```bash
// remove this code from tsconfig.json
"paths": {
"src/*":[ "projects/<YOUR_PROJECT_NAME>/src/*" ]
}
```

> Where the `<YOUR_PROJECT_NAME>` variable should be replaced with the name of your project.
