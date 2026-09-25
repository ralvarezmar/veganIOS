# `BreadcrumbLink`

## Description

Breadcrumb link info containing the title and the optional path.
This type is used to define a standard for the application to be able to achieve breadcrumb functionality.

## Properties

``` ts
export declare type BreadcrumbLink = {
  title: string;
  path?: string;
};
```

## Usage notes

In order to use this functionality, first in the routing of the microfronts the breadcrumb data should be defined.

``` ts
export const routes: Routes = [
  {
    path: 'first-child',
    component: FirstChildComponent,
    data: {
      breadcrumb: {
        title: 'First Child',
        path: 'first-child'
      }
    }
  ...
}
```

For each route, we indicate the title of the component among the path

!!! note
    This path inside breadcrumb is only visual, is not the path of the routing. The value of this property should be the result path that you will see in the application.  
    Example: For a component that is inside a module, the value of the path should be **myModule/myComponent**

After that, in the Shell implementation that loads a microfront, we have to collect the **breadcrumb** event and store where we want.

### Example implementation

Shell implementation of the Microfront

``` html
@if (isLoaded()) {
<f-ng-00000000-pg-microfront
  #microfrontRef
  (breadcrumb)="changeBreadcrumb($event)"
  (externalNavigate)="navigate($event)"
  [mountPath]="mountPath" >
</f-ng-00000000-pg-microfront>
}
```

``` ts
/**
 * Method to update breadcrumb
 *
 * @param event Event captured in the DOM
 */
changeBreadcrumb(event: Event): void {
  const { detail } = <CustomEvent>event;
  this._communicationService.breadcrumbLinks.set(detail);
}

// Communication service in Shell implementation
@Injectable()
export class CommunicationService {
  public readonly breadcrumbLinks = signal<BreadcrumbLink[]>([]);
}
```

Now, if every Microfront wrapper [MicrofrontContainerDirective](../microfrontcontainerdirective.md) implements this, the Shell has control of the current **Breadcrumb** in that service.

Now the only remaining thing is displaying the breadcrumb to the user, for that a component can be used, should be subscribed to the breadcrumb observable.

Breadcrumb component:

``` ts
export class BreadcrumbComponent {
  protected readonly breadcrumbLinks = inject(CommunicationService).breadcrumbLinks;

  @Output() clickLink = new EventEmitter<string>();
}
```

Html implementation

``` html
<ul>
  <li><a id="breadcrumb-0" routerLink="/">Index</a></li>
  @for (item of breadcrumbLinks(); track $index) {
  <li>
    <a
      id="breadcrumb-{{$index + 1}}"
      [attr.disabled]="item.path === undefined ? true : null"
      (click)="clickLink.emit(item.path)"
    >
      {{ item.title }}
    </a>
  </li>
  }
</ul>
```

When the method **clickLink** is clicked, we emit this value to the root of the shell, that will be waiting for this event and execute the following method:

``` ts
// App.component.ts of the shell
/**
  * This method is calling for the update microfront internal router.
  *
  * @param path Path whitout mountPath to navigate
  */
navigateTo(path: string): void {
  this._currentContainer.microfrontRef()?.nativeElement?.navigateTo?.(path);
}
```

It will result in performing the navigation inside the microfront that hosted the data of the actual breadcrumb. This navigation will include in runtime the mountPath.

<iframe src="https://santandernet.sharepoint.com/sites/gluonacademycommunity/_layouts/15/embed.aspx?UniqueId=628783f6-fa91-4c29-9f73-2299fa881879&embed=%7B%22ust%22%3Atrue%2C%22hv%22%3A%22CopyEmbedCode%22%7D&referrer=StreamWebApp&referrerScenario=EmbedDialog.Create" width="640" height="360" frameborder="0" scrolling="no" allowfullscreen title="breadcrumb-implementation.mp4"></iframe> <!-- markdownlint-disable MD013 -->
