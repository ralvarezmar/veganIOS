# MBS Connector

The MBS Connector is responsible for connecting to the MBS system and returning valid user permissions to access certain functionality in an application.

## Prerequisites

### Functional

- Installation and configuration of [@afe/authorization-manager](../../index.md)
- Implementation of [in-app authentication](../../../../../development-guides/authentication/index.md)
- Follow the necessary procedure to perform the [MBS registration](https://confluence.santanderbr.corp/display/SOLSEG/Procedimento+Cadastro+MBS).

### Non-functional

- Reading the documentation about [MBS](https://confluence.santanderbr.corp/pages/viewpage.action?pageId=15666823) of the security team.

## Configuration

The MBS connector is a function that receives an object of type MbsConfig, containing the following properties:

| Property | Description |
| ----------- | --------- |
| **appCode** | application acronym |
| **appKey** | Project APP_KEY |

First, let's create a folder called ***config*** (if you don't have one). Inside it will be the settings of the connectors used by ***Authorization Manager***.

So we'll create a ***connectors.config.ts***, where we'll import the ***mbsConnector*** and export a constant that will return a ***Array`<Connector>`.***

``` TS
//config/connectors.config.ts
import { Connector } from '@afe/authorization-manager';
import { mbsConnector } from '@afe/authorization-manager/mbs-connector';

export function connectorsFn(): Array<Connector> {

    return [
        mbsConnector({
            appCode: '<YOUR_APP_CODE>',
            appKey: '<YOUR_APP_KEY>',
        }),
    ];
}

export const connectorsConfig = connectorsFn;
```

In the main application module, where the ***AuthorizationManagerModule*** is being configured, we'll import the ***MBS*** connector.

``` TS
//app.module.ts
import { AuthorizationManagerModule } from '@afe/authorization-manager';

import { connectorsConfig } from './config/connectors.config';

@NgModule({
    imports:[
        AuthorizationManagerModule.forRoot({
            connectors: connectorsConfig,
        }),
    ],
    // restante do código omitido
})
export class AppModule { }
```

## Methods

Methods available through the ***mbsService*** class.

| Method | Parameters | Description |
| --------- | ------------ | ----------- |
| **getUserPermissions()**: ***`Observable<Array<MbsPermission>>`*** | ***N/A*** | returns the user's permissions. |
| **getUserSinglePermission()**: ***`Observable<MbsPermission>`*** | ***transactionName: string*** | returns a single user permission. |
| **filterPermissionsByTransactionName()**: ***MbsPermission***| mbsPermissions: `Array<MbsPermission>`, ***transactionName: string*** | filters permissions by transaction name. |
| **canAccessByPath()**: ***boolean***| urlPath: ***string*** | Verifies that the permission is valid by the URL of the route to be accessed. |

### Implementation

To start the connector(s) you need to call the **initialize()** method of the ***PermissionService***. This procedure must be performed **after authentication and encryption have been performed.**

> **Note**
>
> The variables in the following example must be replaced with the respective values of your project.
>
> *\<ID_PERMISSÃO>;*

``` TS
//example.component.ts
import { Component, OnInit } from '@angular/core';
import { PermissionService } from '@afe/authorization-manager/';
import { MbsService } from '@afe/authorization-manager/mbs-connector';

@Component({
    // código omitido
})
export class ExampleComponent implements onInit {

    constructor(
        private mbsService: MbsService,
        private permissionService: PermissionService,
    ) { }

    ngOnInit(): void {
        this.doLoginAndChangeKeys().subscribe( (response) => {
            this.permissionService.initialize().subscribe( () => {
                // implementação omitida
            });
        }, (error) => {
            // implementação omitida
        });
    }

    public doLoginAndChangeKeys(): Observable<HttpResponse> {
        // implementação omitida da autenticação e troca de chaves
    }

    public canAccess(): void {
        this.permissionService.canAccess('<ID_PERMISSÃO>').subscribe( (result: boolean) => {
            // implementação omitida
        });
    }

    public mbsGetUserPermissions(): void {
        this.mbsService.getUserPermissions().subscribe( (data) => {
            // implementação omitida
        });
    }

    public mbsGetSinglePermission(): void {
        this.mbsService.getUserSinglePermission('<ID_PERMISSÃO>').subscribe( (data) => {
            // implementação omitida
        });
    }
}
```

> **Note**
>
> If other connectors are configured, the **canAccess()** method will also look up their permissions.
