# Depreciações no Angular 13

## ComponentFactoryResolver

The service [ComponentFactoryResolver](https://v13.angular.io/api/core/ComponentFactoryResolver) is **deprecated**, because [Ivy](https://v12.angular.io/guide/ivy)(new Angular compiler) does not need a **Component Factory** to create a component dynamically.

Previously, with **View Engine**, it was necessary to directly use the [ComponentFactoryResolver](https://v13.angular.io/api/core/ComponentFactoryResolver) service to dynamically render a component.

Before:

```ts
@Directive({ … })
export class MyDirective {
    constructor(
      private viewContainerRef: ViewContainerRef,
      private componentFactoryResolver: ComponentFactoryResolver
    ) {}

    createMyComponent() {
        const componentFactory = this.componentFactoryResolver.resolveComponentFactory(MyComponent);

        this.viewContainerRef.createComponent(componentFactory);
    }
}
```

Now, with [**Ivy**](https://v12.angular.io/guide/ivy), it is possible to achieve the same result using directly [ViewContainerRef.createComponent](https://v13.angular.io/api/core/ViewContainerRef#createComponent).

Now:

```ts
@Directive({ … })
export class MyDirective {
    constructor(private viewContainerRef: ViewContainerRef) {}

    createMyComponent() {
      this.viewContainerRef.createComponent(MyComponent);
    }
}
```

> The complete material can be found at [deprecations](https://v13.angular.io/guide/deprecations)
