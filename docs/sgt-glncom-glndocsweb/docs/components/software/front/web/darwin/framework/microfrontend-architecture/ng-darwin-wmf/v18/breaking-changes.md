# Breaking Changes

- `microfrontRef` is now a signal of type `Signal<ElementRef>`: `this.currentContainer.microfrontRef().nativeElement.<method>`.

Before

```ts
@Component({
  template: `
    <microfront-tag #microfrontRef></microfront-tag>
    <button (click)="callMicrofrontMethod()">Call Microfront Example Method</button>
`,
})
export class ExampleMicrofrontContainer extends MicrofrontContainerDirective {
  callMicrofrontMethod() {
    this.microfrontRef.nativeElement.buzz();
  }
  ...
}
```

After

```ts
  callMicrofrontMethod() {
    this.microfrontRef().nativeElement.buzz();
  }
```

- `isLoaded` is now a signal of type `WritableSignal<boolean>`: `@if (isLoaded()) { ... }`.

Before

```ts
@Component({
  template: '<microfront-tag *ngIf="isLoaded"></microfront-tag>',
})
export class ExampleMicrofrontContainer extends MicrofrontContainerDirective {
  ...
}
```

After

```html
<microfront-tag *ngIf="isLoaded()"></microfront-tag>

<!-- Or with Control flow -->
@if (isLoaded()) {
  <microfront-tag></microfront-tag>
}
```
