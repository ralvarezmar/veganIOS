# Mock Connector

The Mock Connector provides a mock of permissions used to validate access to features during the development of SPA applications.

In this way, it is possible to avoid bureaucracy when developing locally, while waiting for the release of accesses and the like.

The ***Mock*** connector works in such a way that, after the development phase is finished, it is possible to add new connectors without the need for additional modifications.

## Prerequisites

- Installation and configuration of [@afe/authorization-manager](../../index.md)
- Implementation of [in-app authentication](../../../../../development-guides/authentication/index.md)

## Configuration

The ***Mock*** connector takes as a parameter a ***`Array<Permission>`***, containing a single property:

| Property | Description |
| ----------- | --------- |
| **transactionName** | name of the transaction. |

> You can extend the ***model*** **Permission** by adding new properties to the object.

First, create a folder called ***config***, because inside it will be the settings of the connectors used by ***Authorization Manager***.

In the folder create a file called ***mock-list-permissions.ts***, where our ***mock*** of permissions will be created.

``` JS
//config/mock-list-permissions.ts
import { Permission } from '@afe/authorization-manager';

export const MOCK_LIST_PERMISSIONS: Array<Permission> = [
    { transactionName: 'SPA-TELA-1' },
    { transactionName: 'SPA-TELA-2' },
    { transactionName: 'SPA-TELA-3' },
    { transactionName: 'SPA-TELA-4' },
];
```

The next step is to create a file called ***connectors.config.ts***, where we'll import the ***MockConnector and MOCK_LIST_PERMISSIONS*** and export a constant that will return an `Array<Connector>`, passing as a parameter the list of permissions created.

``` TS
//config/connectors.config.ts
import { Connector } from '@afe/authorization-manager';
import { mockConnector } from '@afe/authorization-manager/mock-connector';
import { MOCK_LIST_PERMISSIONS } from './mock-list-permissions';

export function connectorsFn(): Array<Connector> {
    return [
        mockConnector(MOCK_LIST_PERMISSIONS),
    ];
}

export const connectorsConfig = connectorsFn;
```

In the main application module, where the ***AuthorizationManagerModule*** is being configured, we'll import the ***Mock*** connector.

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

Available methods through **mockService*** class.

| Method    | Parameters   |  Description |
| --------- | ------------ | ----------- |
| **getUserPermissions()**: ***`Observable<Array<Permission>`*** | ***null*** | Search for user permissions
| **getPermissionByName()**: ***`Observable<Permission>`*** | name: ***string*** | Returns the permissions use through the name of the permission |
| **listPermissionIsValid()**: ***boolean*** | permissions: ***`Array<Permission>`*** | verify if the permissions list is valid |
| **findPermissionInList()**: ***Permission*** | permissions: ***`Array<Permission>`*** | search for a permission through the name inside of a permission list |

## Implementation

> To initialize the connectors is necessary to call the method **initialize()** from ***PermissionService***.

``` TS
//example.component.ts
import { Component } from '@angular/core';
import { MockConnectorService } from '@afe/authorization-manager/mock-connector';

@Component({
    templateUrl: './example.component.html',
})
export class ExampleComponent {
    constructor(
        private permissionService: PermissionService,
        private mockConnectorService: MockConnectorService,
    ) { }

    ngOnInit(): void {
        this.permissionService.initialize().subscribe( () => {
            console.log('Initialize executado!');
        });
    }

    public canAccess(): void {
        this.permissionService.canAccess('<ID_PERMISSÃO>').subscribe( (result: boolean) => {
            console.log(result);
        });
    }

    public getUserPermissions(): void {
        this.mockConnectorService.getUserPermissions()
        .subscribe( (data) => {
            console.log(data);
        });
    }

    public getPermissionByName(): void {
        this.mockConnectorService.getPermissionByName('<ID_PERMISSÃO>')
        .subscribe( (data) => {
            console.log(data);
        });
    }
}
```

> **Notes**
>
> If other connectors are configured, the **canAccess()** method will also look up their permissions.
