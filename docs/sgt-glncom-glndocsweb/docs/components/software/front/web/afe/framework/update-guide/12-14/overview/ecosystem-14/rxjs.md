# RxJS 7

## The **_add()_** method of a **_Subscription_** now returns **_void_**

Method [add](https://rxjs.dev/api/index/class/Subscription#add) of class [Subscription](https://rxjs.dev/api/index/class/Subscription) returns `void`, and no longer an instance of [Subscription](https://rxjs.dev/api/index/class/Subscription).

The code below shows how to adapt your code.

```ts
const subscription = new Subscription();

const timerSubscription = timer.subscribe(() => {});
const timerSubscription2 = timer.subscribe(() => {});

subscription.add(timerSubscription);
subscription.add(timerSubscription2);
```

> For more information, access the [official add method documentation.](https://rxjs.dev/6-to-7-change-summary#subscription)

## Change in the return of the **_pipe()_** function

When the function [pipe](https://rxjs.dev/api/index/class/Observable#pipe) is called with **9** or **more** parameters, the return will be `Observable<unknown>` instead of `Observable<{}>`.

```ts
const observable: Observable<unknown> = of([])
   .pipe(
     tap(() => {}),
     tap(() => {}),
     tap(() => {}),
     tap(() => {}),
     tap(() => {}),
     tap(() => {}),
     tap(() => {}),
     tap(() => {}),
     tap(() => {}),
   );

// variable "observable" is typed as Observable<unknown>
```

## The **_toPromise()_** function is deprecated

The [toPromise](https://rxjs.dev/api/index/class/Observable#topromise) function is deprecated and should be removed in future versions of RxJS.

The functions [lastValueFrom](https://rxjs.dev/api/index/function/lastValueFrom) and [firstValueFrom](https://rxjs.dev/api/index/function/firstValueFrom) should be used as replacements.

### **_firstValueFrom()_**

The function [firstValueFrom](https://rxjs.dev/api/index/function/firstValueFrom) returns a:

[Promise](https://developer.mozilla.org/pt-BR/docs/Web/JavaScript/Reference/Global_Objects/Promise) _resolved_ as soon as the informed [Observable](https://rxjs.dev/api/index/class/Observable) emits its **first value**.

If the [Observable](https://rxjs.dev/api/index/class/Observable) entered is completed without issuing a value, a [Promise](https://developer.mozilla.org/pt-BR) is returned **_rejected_**.

```ts
import { interval, firstValueFrom } from 'rxjs';

async function execute() {
   const source$ = interval(2000); // first value is 0
   const firstNumber = await firstValueFrom(source$);
   console.log(`Final number is ${firstNumber}`);
}

execute();

// Log:
// "Final number is 0"
```

### **_lastValueFrom()_**

The function [lastValueFrom](https://rxjs.dev/api/index/function/lastValueFrom) returns a:

[Promise](https://developer.mozilla.org/pt-BR/docs/Web/JavaScript/Reference/Global_Objects/Promise) _resolved_ when the informed [Observable](https://rxjs.dev/api/index/class/Observable) emits its **last value**.

If the [Observable](https://rxjs.dev/api/index/class/Observable) entered is completed without issuing a value, a [Promise](https://developer.mozilla.org/pt-BR) is returned **_rejected_**.

```ts
import { interval, take, lastValueFrom } from 'rxjs';

async function execute() {
   const source$ = interval(2000).pipe(take(10)); // first value is 0
   const finalNumber = await lastValueFrom(source$);
   console.log(`Final number is ${finalNumber}`);
}

execute();

// Log:
// "Final number is 9"
```

> For more information, visit [official RxJS documentation on migrating from version 6 to 7.](https://rxjs.dev/6-to-7-change-summary)
