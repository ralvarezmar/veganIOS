# Best practices in string concatenation

Angular provides us with the possibility to link information from the component to the template, through string interpolation, used to concatenate component variables to our template.

## Why avoid string concatenation?

The concatenation of strings can be dangerous when used incorrectly, because if we do not perform a [sanitization of the data that will be rendered](./sanitization.md) and we do not use Angular resources.

Opting for the same way we would do in pure Javascript, we can allow the injection of malicious code into an application, leading to Cross-Site Scripting (XSS) attacks.

```ts
import { username } from '../services/user';

@Component({
  selector: 'app-error',
  template: `<p> Your username is: ${username} </p>`
})
```

In the example above, if a malicious script has been provided in the value of the 'username' variable, it will be executed in the context of the application due to the use of string interpolation.

## How to Avoid String Concatenation

To avoid string concatenation, always use Angular string interpolation, done by double curly braces '{{ }}'. This ensures that the value of the variable is treated as a text and not as a script to be executed.

```ts
import { username } from '../services/user';

@Component({
  selector: 'app-error',
  template: `<p> Your username is: {{ username }} </p>`
})
```
