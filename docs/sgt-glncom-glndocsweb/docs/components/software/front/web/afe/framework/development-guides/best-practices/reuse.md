# Best practices in code reuse

During software development, code repetition is common, either due to the need to perform the same operation in different parts of the program or due to lack of knowledge of the project. However, this practice can cause maintenance and efficiency issues.

Therefore, it is crucial to learn and apply code reuse techniques to improve **quality**, **maintainability**, **scalability**, and **delivery efficiency.**

We'll cover some best practices in this guide to code reuse.

## When to reuse the code?

Code repurposing is a practice that should be used sparingly.

[DRY (Don't Repeat Yourself)](https://pt.wikipedia.org/wiki/Don%27t_repeat_yourself) is a famous software development principle that says **you shouldn't repeat the same code in more than one place.**

But before we apply DRY, we should follow the [WET (Write Everything Twice)](https://dev.to/urielsouza29/wet-e-aha-18bi) principle, which says that you should **write the same code twice before reusing it**.

Only from there do we start thinking about reusing the code, because if you reuse too much code, you can end up creating a dependency between the parts of your code. This can make the code difficult to read, maintain, and test.

Angular provides us with a number of features for reusing code. Let's see some of them:

### Components

Components are the most basic unit of an Angular application. It's the smallest chunk of an application. They encapsulate presentation logic for a portion of the user interface.

Imagine you want one search field on every page and another search field only on the product listing page. The same component can be used to perform the search in both cases.

That way, instead of replicating the same HTML and CSS code in multiple places, you can create a search component and reuse it throughout your application.

File: search.component.ts

``` TS
import { Component } from '@angular/core';
import { SearchService } from './search.service';

@Component({
  selector: 'app-search',
  template: `
    <input [(ngModel)]="query" (keyup.enter)="search()" placeholder="Buscar por nome do produto...">
  `
})
export class SearchComponent {
  query: string;

  public search(): void {
    // executa a lógica para buscar os produtos
  }
}
```

And to reuse it in your application, simply add the selector `<app-search></app-search>` where you want the search field to appear.

``` HTML
<app-search></app-search>
```

### Services

Services are classes responsible for encapsulating the business logic of the application, such as API calls, validations, user session control. In this way, you can create features that can be used throughout your application.

Continuing the example above from the search field, imagine that you need to make an API call to fetch the products. You can create a search service that encapsulates this logic and reuse it throughout your application.

File: search.service.ts

``` TS
export class SearchService {
  private url = 'https://api.com/products';

  constructor(private http: HttpClient) { }

  search(query: string): Observable<any> {
    return this.http.get(`${this.url}?search=${query}`});
  }
}

```

### Directives

Directives encapsulate presentation logic to add behavior to certain elements of the DOM. They allow you to create functionality that can be used throughout your application, just by adding an attribute to an HTML element.

In the example below we have a directive that changes the background color of an element to yellow:

``` TS
import { Directive, ElementRef, Renderer2 } from '@angular/core';

@Directive({
  selector: '[backgroundAsYellow]'
})
export class backgroundAsYellowDirective {
  constructor(private el: ElementRef, private renderer: Renderer2) {
    renderer.setStyle(el.nativeElement, 'background-color', 'yellow');
  }
}
```

A directive can be reused throughout your application, just by adding its selector as an attribute to an HTML element:

``` HTML
<p backgroundAsYellow>This text will have a yellow background</p>
```

### Modules

Modules encapsulate all other Angular features, such as components, directives, pipes, and services to reuse in various parts of the application.

They can import functionality from other modules and export their own so that it can also be used by other modules.

Modules can also be loaded on demand. This means that you can load only the modules you need for the current page and the rest according to the user's navigation through the application.

### Libraries

Finally, we have libraries which are sets of features encapsulated in reusable packages. They can be published through tools such as 'npm' and installed in other applications.

Reusing code through libraries has several advantages:

- **Efficiency**: You don't need to rewrite the same code in multiple applications. This saves time and effort.
- **Maintenance**: If you find a bug or want to add a new feature, you only need to do it once in the library and install a new version of it on the projects that use it, instead of changing all the applications that use that code.
- **Consistency**: Using the same library across multiple applications ensures that the behavior is consistent across all applications.

The front-end architecture offers structuring libraries that solve certain problems and address common scenarios across channels. Check to see if the functionality you need isn't already available in an existing framework.

This can be done by referring to the [Architecture Libraries] section. /.. /libraries/afe.md).

If you can't find an AFE library that meets your needs, you can:

- **Search the community:** Make sure there isn't already one in the open source community that meets your needs. This can be done by referring to the **[Best Practices in Choosing Third-Party Libraries](./third-party-libraries.md)** section.

- **Create your own library**: If there is no library that meets your needs, you can create your own.
