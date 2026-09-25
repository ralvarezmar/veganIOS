# What's New in @afe/authorization-manager version 3.x.x

With its new version **3.x.x** released, **Authorization Manager** now supports **Angular 8 and 10**.

## Prerequisites

- Be using ***3.x.x*** version of ***@afe/authorization-manager***

## What's New

### Add public method ***canAccessByPath***

The added method is available through the ***MbsService*** and ***UsService*** classes and verifies that the permission is valid through the ***url*** of the route to be accessed.

And is architected to be used in conjunction with the implementation of the CanActivate(<https://angular.io/api/router/CanActivate>) interface of ***@angular/router***.

> To use the ***canAccessByPath*** method, it is necessary that the ***initialize*** method of the ***PermissionService*** has been successfully called and returned the user's permissions, otherwise it will not be possible to validate access to the route.

| Parameter | Description |
|------------- | ------------- |
| ***urlPath: string*** | Path of the route to be accessed |

```typescript
import { Injectable } from '@angular/core';
import { CanActivate, ActivatedRouteSnapshot, RouterStateSnapshot, UrlTree } from '@angular/router';
import { MbsService } from '@afe/authorization-manager/mbs-connector';
import { Observable } from 'rxjs';


@Injectable({
  providedIn: 'root'
})
export class AuthGuard implements CanActivate {

    constructor(
        private mbsService: MbsService
    ){ }

    canActivate(
        route: ActivatedRouteSnapshot,
        state: RouterStateSnapshot): Observable<boolean | UrlTree> | Promise<boolean | UrlTree> | boolean | UrlTree {
            return this.mbsService.canAccessByPath(route.routeConfig);
    }
}
```

### Add public method ***isInitilized***

The added method is available through the ***PermissionService*** class and returns a ***boolean***, indicating whether the connectors' permissions have already been loaded

```typescript
import { Component, OnInit, OnDestroy } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { MbsService } from '@afe/authorization-manager/mbs-connector';
import { Subscription } from 'rxjs';

@Component({
  selector: 'app-example',
  templateUrl: './example.component.html',
  styleUrls: ['./example.component.scss'],
})
export class ExampleComponent implements OnInit, OnDestroy {
    public subscription = new Subscription();
    constructor(
        private permissionService: PermissionService,
    ) { }

    public OnInit(): void {
        if (this.permissionService.isInitilized()) {
            this.subscription.add(
                this.permissionService.canAccess('TELA_SPA')
                .subscribe((data: boolean) => {
                    // implementação omitida
                })
            );
        }
    }

    public OnDestroy(): void {
        this.subscription.unsubscribe();
    }
}
```
