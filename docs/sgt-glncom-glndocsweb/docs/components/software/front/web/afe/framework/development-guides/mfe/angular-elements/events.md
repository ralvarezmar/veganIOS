# Events and Communication between Angular Elements and Base

During application development using the Micro Front-End (MFE) architecture, communication between a channel base and a particular business module may be required to exchange data or listen for events with each other.

The following will cover the two possible communication scenarios between a base and an Angular Element:

## Data Passing

Passing data between **base** and **angular elements** works through two native Angular features, ***@Input()*** and ***@Output()***.

### Input

The decorator ***@Input()*** allows the element to receive the data sent by the **base** via attribute.

To do this, it is necessary to declare a property in the **angular elements** with the same name as the attribute that will be passed by the ***tag*** ***HTML*** and implement a ***setter*** and ***getter***.

Which allows the execution of logic when the value of the variable is changed.

``` TS

import { Component, Input } from '@angular/core';

@Component({
  selector: 'mfe-element',
  templateUrl: './mfe-element.component.html',
  styleUrls: ['./mfe-element.component.scss']
})
export class MfeElementComponent {

  private _myText: string = 'Text awesome!';

  @Input()
  public set myText(value: string) {
    this._myText = value;
  }

  public get myText(): string {
    return this._myText;
  }
}
```

This way, whenever the ***my-text*** attribute is changed in the ***tag*** ***HTML*** of the **angular elements**, the ***myText*** property will be updated with the new value.

### Base Implementation

In order for the base application to be able to send data to an angular elements.

You need to use the property bind resource in the angular element's ***tag*** with the same name as the property that is with the decorator ***@Input()*** in the web component, such as following:

```html
<mfe-element-element my-text="New text awesome!"></mfe-element-element>
```

In this example, the text "Text awesome!" in ***myText*** will be replaced with "New text awesome!".

> Note that we declare the ***my-text*** attribute in the ***tag*** ***HTML*** of the **angular elements**.
>
> This is necessary for Angular to be able to make the correct association between the **web component** property and the ***tag*** ***HTML***, due to the fact that the ***HTML*** attributes are always written in ***kebab-case***.

### Output

The ***decorator*** ***@Output()*** makes it possible to pass data from an **angular elements** to the **base** application. And this happens through events. Next, we'll look at how to implement it.

### Implementation in Angular Element

In the angular elements you will need to have a property that receives the instance of a ***EventEmitter*** and that makes use of the ***decorator*** ***@Output()*** in the component where you want to send data to the **base**.

With it it is possible to emit events through a function called ***emit()***, putting as a parameter the information that must be transferred.

``` TS
import { Component, EventEmitter, Output } from '@angular/core';

@Component({
  selector: 'mfe-element',
  templateUrl: './mfe-element.component.html',
  styleUrls: ['./mfe-element.component.scss']
})
export class MfeElementComponent {

  @Output() public readonly message = new EventEmitter<string>();

  public sendMessage(message: string): void {
    this.message.emit(message);
  }
}
```

In this implementation example, whenever the ***sendMessage()*** function is called, the ***EventEmitter*** will emit an event, through the ***emit()***.

With the information that will be passed per parameter and if the base application is prepared it will receive the event.

### Base Implementation

In order for ***base*** to receive the events from ***angular elements***, it is necessary to place a ***event binding*** in the ***tag*** ***HTML*** that represents the ***web component*** in question.

With the name of the variable that is decorated with the ***@Output()***. After that, all you have to do is call a function to handle the received event.

``` HTML
Message: {{ messageReceived }}

<mfe-element-element (message)="getMessage($event)"></mfe-element-element>
```

In this example, whenever angular elements emits an event, the base-based application will be notified via event binding and call getMessage() to handle it.

``` TS
import { Component } from '@angular/core';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss']
})
export class AppComponent {

  public messageReceived: string;

  public getMessage(message: CustomEvent): void {
    this.messageReceived = message.detail;
  }
}
```

## Event Listening

### Prerequisites

- Install and configure the architecture part [***@afe/event-handler***](https://confluence.santanderbr.corp/display/AFE/Event+Handler), used to **log and trigger events**.

### Usage

#### Setting up the ***listener***

First, it is necessary to call the ***listen()*** method in the main module of the project, which will be responsible for listening to the events emitted by the **Angular Element**. In the example, we'll use **base** as the ***listener***.

> We wrap the ***listen()*** method call in the ***eventHandlerInit()*** function so that it is available before the application starts, via [***APP_INITIALIZER***](https://angular.io/api/core/APP_INITIALIZER).

``` TS
// base-front.module.ts
export function eventHandlerInit() {
    return () => {
        eventHandler.listen("ABRIR_INTRANET", {}, (data, resolve, reject) => {
          // lógica baseada no valor recebido
          resolve(data);
          reject();
      });
  }
}

@NgModule({
  declarations: [BaseFrontComponent],
  imports: [
    // imports omitidos
  ],
  providers: [
    { provide: APP_INITIALIZER, useFactory: eventHandlerInit, deps: [], multi: true },
  ],
  schemas: [
    CUSTOM_ELEMENTS_SCHEMA
  ]
})
export class BaseFrontModule { }
```

### Emitter Configuration

To emit the events that will be listened to by **base**, simply call the ***emit()*** method of the **eventHandler**, passing the **name of the event** to be emitted and its **value** (the ***callback*** function is optional).

```typescript
openIntranet(): void {
  eventHandler.emit('ABRIR_INTRANET', { urlPagina: 'https://santander.com.br/' }, (err) => {
      console.error(err);
  });
}
```

> The ***afe/event-handler*** part does not need to be instantiated by the ***constructor***, as it is angular agnostic.
