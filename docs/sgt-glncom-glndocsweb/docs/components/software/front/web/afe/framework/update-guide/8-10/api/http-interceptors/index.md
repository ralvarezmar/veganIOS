# HTTP Interceptors Update

By the end of this session, you will have upgraded ***@afe/http-interceptors*** to a **version compatible with Angular 8 and 10**.

## Prerequisites

- Have the ***1.x.x*** version of ***@afe/http-interceptors*** installed in your project;
- Commit the project files before starting the update process.

## Run the Update Command

Through the command below, you will install the new version of the structuring:

```bash
ng update @afe/http-interceptors@^2 --force
```

> If your project has files that have not yet been committed, the update will not be completed. To disregard this validation, add the '--allow-dirty' parameter in the update command.

## Remove the use of the TokenService

The TokenService was compatible with the HubConnectorComponent of the @afe/generalbase and should be removed.

```diff
- import { TokenService } from '@afe/base-geral';
```

## Remove references to tokens from ***forRoot()*** settings

To maintain compatibility with ***@afe/general-base***, some *injection tokens* were exported that are no longer needed.

Remove any references in your code to the following *injection tokens*:

- ***URLS_TO_INTERCEPT_TOKEN***
- ***URLS_TO_IGNORE_TOKEN***
- ***STORAGE_KEYS_TOKEN***
- ***STORAGE_TYPE_TOKEN***
- ***STORAGE_TOKEN***

> **Congratulations ✅!**
>
> You have successfully updated the version of ***@afe/http-interceptor*** 😎
