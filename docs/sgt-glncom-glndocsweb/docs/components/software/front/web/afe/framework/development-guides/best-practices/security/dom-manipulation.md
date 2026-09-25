# Best practices in the manipulation of the DOM

DOM manipulation is a common practice in front-end development to add to or change the structure, style, and content of a web page. However, direct manipulation of the DOM can be a dangerous practice.

As it can open up loopholes for code injection or Cross-Site Scripting (XSS) attacks.

## How to avoid direct manipulation of the DOM?

Avoid using the `ElementRef` to manipulate the DOM directly. Angular itself discourages its use, as it can open up loopholes for code injection or Cross-Site Scripting (XSS) attacks if it is dealing with a user input.

```ts
import { Component, ElementRef, AfterViewInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';

export class ExampleComponent {
  constructor(
    private elRef: ElementRef,
    private route: ActivatedRoute
  ) { }

  ngAfterViewInit() {
    const dataBox: HTMLElement = this.elRef.nativeElement.querySelector("#dataBox");
    this.route.queryParams.subscribe(params => {
        dataBox.innerHTML = params["data"]; // "<script>document.location.href = 'https://evil.com/'</script>"
    })
  }
}
```

In the example above, the value of the 'data' parameter is injected directly into the DOM, which can be dangerous as the user can inject a script and redirect the user to a malicious website.

## How to handle the DOM securely?

Prefer to use other Angular features, such as template interpolation to display data in the DOM.

If it is extremely necessary to manipulate it, prefer to use ['Renderer2'](https://angular.io/api/core/Renderer2) in conjunction with [user input sanitization](./sanitization.md).

Using the built-in [DomSanitizer](https://angular.io/api/platform-browser/DomSanitizer) class.

```ts
import { Renderer2, AfterViewInit, ViewChild } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { DomSanitizer, SecurityContext } from '@angular/platform-browser';

@Component({
  template: `<div #dataBox></div>`,
})
export class ExampleComponent implements AfterViewInit {
  @ViewChild('dataBox') dataBox;

  constructor(
    private route: ActivatedRoute,
    private sanitizer: DomSanitizer,
    private renderer: Renderer2
  ) { }

  ngAfterViewInit() {
    this.route.queryParams.subscribe(params => {
        const sanitizedData = this.sanitizer.sanitize(SecurityContext.HTML, params["data"]) as string;
        this.renderer.setProperty(this.dataBox.nativeElement, 'innerHTML', sanitizedData);
    })
  }
}
```
