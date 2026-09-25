# Command for SPA application generation

The `afe new` command contemplates the generation of an **application** project. To take advantage of the feature, simply add the parameter `--type=application` to the command.

## Prerequisites

- Installing [***@afe/cli***](../index.md)

## Creating new project

To start a new workspace with the structure of a SPA, simply run the command:

``` BASH
afe new <PROJECT_NAME> --prefix=<SIGLA_DO_PROJETO>
```

> After **all steps are successful**, a project will be generated according to the version of ***@angular/cli*** installed globally.

### Setting Parameters

You can also pass the parameters provided by ***Angular*** itself when generating a new project, the most common being:

| Parameter | Type | Description |
| --------- | ---- | --------- |
| ***--prefix*** | ***string*** | Application Acronym |
| ***--changeScripts*** | ***Boolean*** | Changes the scripts of the ***package.json*** from ***ng*** to ***afe*** |
| ***--skip-install*** | ***Boolean*** | Sets whether the dependency installation process will be skipped |

> Go to the Angular documentation to view the [full table of parameters](https://v12.angular.io/cli/new#options) used when running the 'new' command.

## Running the application

To run the application, go to the folder you created:

``` BASH
cd application-name
```

Finally, just start the application using the command:

``` BASH
npm start
```

Your test application will be available in <http://localhost:4200/>.

You will also find links that will help you develop your project! =)
