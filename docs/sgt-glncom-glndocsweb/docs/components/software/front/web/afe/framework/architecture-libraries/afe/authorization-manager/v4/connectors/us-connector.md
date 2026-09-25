# Us Connector

The US Connector provides a guard responsible for validating the user's authentication when attempting to access a feature through the ***US*** system.

## Prerequisites

- Installation and configuration of [@afe/authorization-manager](../../index.md)
- Implementation of [in-app authentication](../../../../../development-guides/authentication/index.md)

## Configuration

The US connector is a function that receives an object of type UsConfig, containing the following properties:

| Property | Description |
| ----------- | --------- |
| **appCode** | application acronym |
| **appKey** | Project APP_KEY |

First, let's create a folder called ***config*** (if you don't have one). Inside it will be the settings of the connectors used by ***Authorization Manager***.

So we'll create a ***connectors.config.ts***, where we'll import the ***mbsConnector*** and export a constant that will return a ***`Array<Connector>`.***

``` TS
//config/connectors.config.ts
import { Connector } from '@afe/authorization-manager';
import { usConnector } from '@afe/authorization-manager/us-connector';

export function connectorsFn(): Array<Connector> {

    return [
        usConnector({
            appCode: '<YOUR_APP_CODE>',
            appKey: '<YOUR_APP_KEY>',
        }),
    ];
}

export const connectorsConfig = connectorsFn;
```

In the application main module where the ***AuthorizationManagerModule*** is being configured, we'll import the ***US*** connector.

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

Methods available through the **usService** class.

| Method | Parameters | Description |
| --------- | ------------ | ----------- |
| **getUserPermissions()**: ***`Observable<Array<UsPermission>>`*** | N/A | Returns the user's permissions. |
| **getUserSinglePermission()**: ***`Observable<UsPermission>`*** | transactionName: ***string*** | returns a single user permission. |
| **filterPermissionsByTransactionName()**: ***UsPermission*** | usPermissions: `Array<UsPermission>`, transactionName: ***string*** | filters permissions by transaction name. |
| **canAccessByPath()**: ***boolean***| urlPath: string*** | Verifies that the permission is valid by the URL of the route to be accessed. |

### Implementation

To start the connector(s) you need to call the **initialize()** method of the ***PermissionService***. This procedure must be performed **after authentication and encryption have been performed.**

>**These steps must be performed each time the application is loaded/reloaded**
>
> **Note**
>
> The variables in the following example must be replaced with the respective values of your project.
>
> *\<ID_PERMISSÃO>;*

``` TS
//example.component.ts
import { Component, OnInit } from '@angular/core';
import { PermissionService } from '@afe/authorization-manager/';
import { UsService } from '@afe/authorization-manager/us-connector';

@Component({
    templateUrl: './example.component.html',
})
export class ExampleComponent implements onInit {
    constructor(
        private usService: UsService,
        private permissionService: PermissionService,
    ) {}

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
        // implementa autenticação e executa a troca de chaves
    }

    public canAccess(): void {
        this.permissionService.canAccess('<ID_PERMISSÃO>').subscribe( (result: boolean) => {
            // implementação omitida
        });
    }

    public usGetUserPermissions(): void {
        this.usService.getUserPermissions()
        .subscribe( (data) => {
            // implementação omitida
        });
    }

    public usGetSinglePermission(): void {
        this.usService.getUserSinglePermission('<ID_PERMISSÃO>')
        .subscribe( (data) => {
            // implementação omitida
        });
    }
}
```

> **Notes**
>
> If other connectors are configured, the **canAccess()** method will also look up their permissions.
