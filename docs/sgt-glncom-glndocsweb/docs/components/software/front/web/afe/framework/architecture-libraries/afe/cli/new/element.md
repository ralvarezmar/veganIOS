# Command for MFE application generation

The 'afe new' command contemplates the generation of an **element** project. To take advantage of the feature, simply add the '--type=element' parameter to the command.

> For more information, please visit the official documentation on [Angular Elements](https://angular.io/guide/elements). ## Prerequisites - Installing [***@afe/cli***](../index.md)

## Creating new project

To start a new workspace with the structure of a SPA, run the command:

``` BASH
afe new <project-name> --type=element --prefix=<SIGLA_DO_PROJETO>
```

> After **all steps are successful**, a project will be generated according to the version of ***@angular/cli*** installed globally.

### Setting Parameters

You can also pass the parameters provided by ***Angular*** itself when generating a new project, the most common being:

| Parameter | Type | Description |
| --------- | ---- | --------- |
| ***--prefix*** | ***string*** | Application Acronym |
| ***--changeScripts*** | ***Boolean*** | Change ***package.json*** scripts from ***ng*** to 'afe' |
| ***--skip-install*** | ***Boolean*** | Sets whether the dependency installation process will be skipped |

> Go to the Angular documentation to view the [full table of parameters](https://v12.angular.io/cli/new#options) used when running the 'new' command.

## Running the application

To run the application, go to the folder you created:

``` BASH
cd application-name
```

And run the following command:

``` BASH
npm start
```

Finally, all you have to do is start the test application:

``` BASH
npm start:application
```

Once this is done, your ***element*** will be built and a server will become available in <http://localhost:4444/>.

The core files in this folder will be imported into the ***index.html*** page, located inside `projects/<project-name-app>/src`, as showed below:

File: `projects/<nome-do-projeto-app>/src/index.html`

``` HTML
<!doctype html>
<html lang="pt-br">
<head>
  <meta charset="utf-8">
  <title>ProjetoExemploApp</title>
  <base href="/">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="icon" type="image/x-icon" href="favicon.ico">
</head>
<body>
  <app-root></app-root>
  <script src="http://localhost:4444/polyfills.js"></script>
  <script src="http://localhost:4444/scripts.js"></script>
  <script src="http://localhost:4444/main.js"></script>>
</body>
</html>
```

Therefore, its self-contained application can be accessed in <http://localhost:4200/>, being called through its respective selector (Ex:`<NOME-DO-PROJETO-element></NOME-DO-PROJETO-element>`).

You will also find links that will help you develop your project! =)
