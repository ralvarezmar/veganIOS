# Connectors

Connectors are a means by which the application is able to validate user authentication through the data sources available for querying, such as ***MBS*** and ***US***.

## Prerequisites

- Installing [@afe/authorization-manager](../index.md)

## Connectors-

| Connector | Objective |
|-------- | -------- |
| [***MBSConnector***](./mbs-connector.md) | Validate user authentication when attempting to access a feature through the **MBS** system. |
| [***USConnector***](./us-connector.md) | Validate user authentication when attempting to access a feature through the US system. |
| [***MockConnector***](./mock-connector.md) | Provide a mock of permissions used to validate access to features during application development. |

## Usage

The PermissionService is the service responsible for initializing all connectors configured by the application and retrieving the information needed to verify that the user has a certain permission.

## Methods

| Method | Parameters | Description |
| --------- | ---------- | -------------------------- |
| **initialize()**: ***`Observable<boolean>`*** | | initializes all configured connectors. |
| **canAccess()**: ***`Observable<boolean>`*** | transactionName: ***string*** <br> leanName?: ***string*** | checks if the user has a given permission. |
| **validateAccess()**: ***`Observable<boolean>`*** | transactionName: ***string*** | verifies that the permission is valid based on the result of the connectors. |

### Implementation

After configuring at least one connector, you need to call the ***initialize()*** method of the ***PermissionService*** to initialize the permissions retrieved through these connectors.

> When you run the ***canAccess()*** method, the result of **all** connectors is used to render the **permission**.

``` TS
//example.component.ts

import { Component } from '@angular/core';
import { PermissionService } from '@afe/authorization-manager';

@Component({
    // hidden code
})
export class AppComponent {
    constructor(
        private permissionService: PermissionService
    ) { }

    public initialize(): void {
        this.permissionService.initialize().subscribe( () => {
            // implementação omitida
        });
    }

    public canAccess(): void {
        this.permissionService.canAccess('<ID_PERMISSÃO>').subscribe( (result: boolean) => {
            // implementação omitida
        });
    }

    public validateAccess(): void {
        this.permissionService.validateAccess('<ID_PERMISSÃO>').subscribe( (result: boolean) => {
            // implementação omitida
        });
    }
}
```

> **Note**
>
> The variables in the following example must be replaced with the respective values of your project.
>
> `<ID_PERMISSÃO>`
