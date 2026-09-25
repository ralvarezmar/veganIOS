# How to upgrade a library to Angular 12

## Update your project

Follow the following guide to upgrade your Library to Angular version 12:

- [How to upgrade a Single Page Application (SPA) to Angular 12](./spa.md)

> **Warning!**
>
> Be sure to update your library before taking the next steps.

## Equalize dependencies on the library's built-in **package.json**

**After upgrading your project to Angular 12,** it is necessary to **equalize the version of the packages** that will be installed by the projects that **will install your library**, via the 'npm install<LIBRARY_NAME>' command:

Go to ***projects → '<LIBRARY_NAME>' → package.json*** and enter the new version of the Angular 12 compatible packages that were installed during the project update.

```diff title='projects/<LIBRARY_NAME>/package.json'
{
  "peerDependencies": {
-     "@angular/common": "^10.2.5",
-     "@angular/core":"^10.2.5",
-     "@angular/platform-browser": "^10.2.5",
-     "@angular/platform-browser-dynamic": "^10.2.5",
-     "@angular/router": "^10.2.5",
-     "@afe/encryption": "2.0.0",
-     "@afe/http-interceptors": "2.0.0",
+     "@angular/common": "^12.2.17",
+     "@angular/core": "^12.2.17",
+     "@angular/platform-browser": "^12.2.17",
+     "@angular/platform-browser-dynamic": "^12.2.17",
+     "@angular/router": "^12.2.17",
+     "@afe/encryption": "^2.5.0",
+     "@afe/http-interceptors": "^3.1.1",
  },
}
```

> Replace '<LIBRARY_NAME>' with the name of your project.
