# Breadcrumbs

## Introduction

The Breadcrumb is a visual element that helps the user in knowing where he is exactly and allowing him to go back to each previous step.
This implementation should be addressed carefully because its possible getting a mix of information from the container application and the Microfront.

In a multichannel architecture the independency of Shell and Microfront must be kept , avoiding couplings between these applications. For that reason we offer the following recommendations about the breadcrumbs.

## Where should be placed the breadcrumbs?

The decision about if the breadcrumb should be placed inside or outside the Microfront should be taken by each team,
addressing the UX/UI and keeping in consideration if its going to be used the same Microfront in another channel, the breadcrumb should stay or change.

Another consideration is the semantics of the web application, specially when reading through a screen reader, since it could enter into inconsistencies if the information displayed holds a senseless order.

Whenever possible, its recommended to position the breadcrumb in the container application (Shell), since it is common for most Microfronts of a channel and can hold cross-functionality.
With this solution only a single point has to be modified in order to implement new features or modifications of the design.

For a better integration with third-party Microfronts, the breadcrumb of the container application should be optional, in order of having a better flexibility with third-party developments that later want to integrate and they have their own.
It is a small effort that can ease the integrations.

## Implementation

The Microfront should emit the `breadcrumb` event each time that wants to report an update to the Shell.

### Breadcrumb event type

The payload that will be sent in the `breadcrumb` event has a certain typing, in order to indistinctly of the Microfront emitting, the container application will know that it will have the same structure.

The event of the payload will be an `array` of `BreadcrumbLink` .

``` ts
type BreadcrumbLink = {
  title: string,
  path?: string
};
```

| Property | Description |  |
|---|---|---|
| *title* | `string` that can be used to show to the user the information of the trace |  |
| *path* | `string` optional that will indicate the **relative path to the Microfront** |  |

### Microfront

Whenever the Microfront wants to report to the Shell a modification in the breadcrumb, the Microfront should emit the **breadcrumb event** with an array of the type `BreadcrumbLink`.
Remember that the only information exposed should be the corresponding links to the Microfront, never external link as it would be compromising their independency.

For example, if you want a breadcrumb like the next one, where the first breadcrumb is a link to the home page of the containing application and the rest are links owned by the Microfront:

- The microfront should inform only about the available links in its area through the **breadcrumb event.**  
- The container application should handle how to show the received links of the Microfront through the **breadcrumb event**, in addition to their own.

``` ts
this.breadcrumb.emit([
  {
    title: 'Microfront',
    path: ''
  },
  {
    title: 'First Child',
    path: 'first-child'
  },
  {
    title: 'Second Child'
    path: 'first-child/second-child'
  },
  {
    title: 'Third Child'
    // If the `path` is not defined, this breadcrumb should not be clickable
  }
]);
```

Any Microfront that wants to make its internal routes accessible from the exterior, should have available a method named `navigateTo` , for that, any Microfront that extends from the directive `MicrofrontDirective` will have this method exposed by default.

The Shell application should use this method in order to navigate to internal routes of the Microfront.

```ts
microfrontReference().nativeElement.navigateTo('first-child/second-child');
```

### Shell

The container application should develop the way that wants to be handle the view of the breadcrumb, might be with a specific layout,
through configuration in the routing file, allowing it to be always visible, or the way decided by the Shell development team.

In order to collect the **breadcrumb event** that will emit the Microfront, the only step required is listening the event as any other event.

``` html
<microfront-tag
  (breadcrumb)="breadcrumbHandler($event)">
</microfront-tag>
```

Probably the DOM reference of the Microfront should be stored in order to call his method `navigateTo`. An easy way to retrieve it will be using the `target` property of the `breadcrumb` event.

``` ts
breadcrumbHandler({ detail, target }: CustomEvent) {
  // Logic.
  this.$currentMicrofront = target;
  this.breadcrumbLinks = detail;
}
```

!!! note
    Keep in mind that the Microfront will only report about its links if the container application has multiple steps before reaching him. This will have to be considered in order to show the breadcrumb.

An example implementation would be this:

```html
<ul>
  <li><a routerLink="/">Home</a></li> <!--Shell's own link -->
  @for (item of breadcrumbLinks()) {
    <li>
      <a (click)="clickHandler(item.path)"> <!--Microfront links -->
        {{item.title}}
      </a>
    </li>
  }
</ul>
```

``` ts
clickHandler(path: string) {
  this.$currentMicrofront?.navigateTo?.(path);
}
```
