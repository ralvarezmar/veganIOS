# How to solve the problem: "the library is expected to be compatible with Ivy"

## Contextualization

Since version 9 of Angular, the new build engine for projects was introduced, [Ivy](https://v12.angular.io/guide/ivy).

This introduction brought with it issues related to the compatibility of libraries built so far with the old engine (**View Engine**) with the compilation of applications already with the new ***engine***.

> More details can be found in Angular's own documentation:
>
> - [Ivy and libraries + Maintaining library compatibility](https://v12.angular.io/guide/ivy#ivy-and-libraries)

From version 13 of Angular onwards, this issue of library compatibility is no longer necessary.

However, in projects still between versions 9 and 12 of Angular, it may be that at some point you will come across problems using a third-party library used in the project, where the following failure message may happen:

```shell
ModuleXYZ has not been processed correctly by ngcc, or is not compatible with Angular Ivy. Check if a newer version of the library is available, and update if so. Also consider checking with the library's authors to see if the library is expected to be compatible with Ivy.
```

## Architecture Guidelines

To solve the problem, we followed Angular's own guidance by adding the ***ngcc*** command to the "***postinstall***" script in the project.

This is so that after the step of installing the dependencies in the repository, the Angular compatibility compiler (NGCC) goes into action to try to compile and make compatible the libraries that were not built with the new ***engine***.

To do this, add the following ***script***** to your project's ***package.json*** file:

```json
{
    "scripts": {
        "postinstall": "ngcc"
    }
}
```

Once that's done, just run ***npm install***.

> As a recommendation, since this impacts operations on the project's dependencies, delete the ***node_modules*** folder and the ***package-lock.json*** file so that the entire process occurs as close to a clean environment as possible.
