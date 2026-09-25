# Authorization Manager Update

By the end of this session, you will have upgraded the @afe/authorization-manager to a Angular 10 and 8 compatible version.

## Prerequisites

- Have the ***1.x.x*** version of ***@afe/authorization-manager*** installed in your project;
- Commit the project files before starting the update process.
- Perform typing of the configuration object passed in ***forRoot()***

```diff
  import { AuthorizationManagerModule, PermissionerType } from '@afe/authorization-manager';
+ import { RootConfig } from '@afe/authorization-manager/lib/models/root-config';

-  const authorizationManagerConfig = {
+  const authorizationManagerConfig: RootConfig = {
      appCode: "system_code",
      permissioner: {
          "permissionerType": PermissionerType.MBS,
          "urlPermissions": "url_user_permissions",
          "urlProfile": "url_consulta_perfil"
      },
      encryptData: true,
  }

  @NgModule({
      imports: [
        AuthorizationManagerModule.forRoot(authorizationManagerConfig),
      ],
  })
  export class AppModule { }
  ```

## Run the Update Command

Through the command below, you will install the new version of the structuring:

```bash
ng update @afe/authorization-manager@^3 --force
```

> If your project has files that have not yet been committed, the update will not be completed. To disregard this validation, add the '--allow-dirty' parameter in the update command.

## Configure the connectors

The connectors (***mbsConnector*** and ***usConnector***) configured in the ***connectors.config.ts*** file expect to receive two parameters in their configuration: ***YOUR_APP_CODE*** and ***YOUR_APP_KEY***.

Replace in the ***connectors.config.ts*** file with the application data.

```diff
export function connectorsFn(): Array<Connector> {
    return [
        mbsConnector({
-            appCode: 'YOUR_APP_CODE',
-            appKey: 'YOUR_APP_KEY',
+            appCode: 'AFE',
+            appKey: 'f2d73920u36ed', // app-key fictícia
        }),
    ];
}

export const connectorsConfig = connectorsFn;
```

## Configure your application to make requests to APIs

The ***HubConnectorComponent*** of the ***@afe/general-base*** is no longer used to make requests to APIs. Use the ***HttpClient*** module from the ***@angular/common/http*** library instead.

### Configure ***@afe/encryption*** to encrypt the data

***EncryptionService*** of ***@afe/generalbase*** used to perform data encryption and decryption has been deprecated in favor of ***EncryptionService*** of ***@afe/encryption***.

## Remove the ***refresh*** method from ***PermissionService***

**Please remove any references** to the ***refresh*** method of the ***PermissionService***, which was previously used as a means of initializing the permissions of the ***permissioner*** and re-executing the permissions API call.

As it has been removed in this new version.

## Initialize permissions via the ***initialize method***

To initialize the user's permissions or perform the following methods, implement the ***initialize*** method of the ***PermissionService***, right after the user authenticates to the application:

- ***canAccess()***;
- ***PermissionService()***;
- ***getUserPermissions()***;
- ***getUserSinglePermission()***.

> The process of calling the initialize method should occur only once.

```diff
import { Component } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { MbsService } from '@afe/authorization-manager/mbs-connector';

@Component()
export class ExampleComponent {
    constructor(
        private permissionService: PermissionService,
        private httpClient: HttpClient
    ) { }

    public getUserPermissions(): void {
        this.httpClient.get('/hub-sso-url/sso/authenticate/internal-front?gw-app-key=<YOUR_APP_KEY>')
            .subscribe((data) => {
+                this.permissionService.initialize().subscribe((data) => {
+                  // código omitido
+                });
           });
    }
}
```

## Remove the ***getUserProfile*** and ***getUserProfiles*** methods

The ***getUserProfile*** and ***getUserProfiles*** methods of the ***PermissionService*** that were previously used to retrieve data from authenticated user profiles have been removed and have no replacements.
As there is no longer a need to use this data for permission seeking.

If it's a channel need, make the manual call to the Profiles API.

## Remove the ***getUserPermissions*** and ***getSinglePermission*** methods

The ***getUserPermissions*** and ***getSinglePermission*** methods of the ***PermissionService***, previously used to retrieve data from the configured **permissioner** permissions** have been removed.

Replace the ***PermissionService*** references with the methods of the configured connector classes (if the application has any).

In the case of the MBS Connector, the ***MbsService*** class of the ***@afe/authorization-manager/mbs-connector*** has the ***getUserPermissions*** and ***getUserSinglePermission*** methods.

That can be called after calling the ***initialize*** method of the ***PermissionService*** to retrieve the required data.

```diff
import { Component } from '@angular/core';
- import { PermissionService } from '@afe/authorization-manager';
+ import { MbsService } from '@afe/authorization-manager/mbs';

@Component()
export class ExampleComponent {
    constructor(
-        private permissionService: PermissionService,
+        private mbsService: MbsService
    ) { }

    /**
    * @deprecated method
    */
    public getUserPermissions(): void {
-        this.permissionService.getUserPermissions()
-            .subscribe((data) => {
-                // código omitido
-            });

+        this.mbsService.getUserPermissions()
+        .subscribe((data) => {
+            // código omitido
+        });
    }

    /**
    * @deprecated
    */
    public getSinglePermission(): void {
-        this.permissionService.getSinglePermission('SPA-PAG_INICIAL')
-            .subscribe((data) => {
-                // código omitido
-            });

+        this.mbsService.getSinglePermission('SPA-PAG_INICIAL')
+        .subscribe((data) => {
+            // código omitido
+        });
      }
  }
```

## Remove deprecated content in previous version

The ***PermissionerService*** class has been removed, along with the **permissioners** configuration. As a result, the following interfaces are no longer exported:

```typescript
export { Profile } from './lib/models/profile';
export { MbsPermission } from './lib/permissioner/mbs/models/mbs-permission.model';
export { PermissionerType } from './lib/models/permissioner-type';
export { Permissioner } from './lib/models/permissioner';
```

Remove the above references from your project.

> **Congratulations ✅!**
>
> You have successfully updated the version of ***@afe/authorization-manager*** 😎
