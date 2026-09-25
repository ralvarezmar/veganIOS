# How to Resolve Error 'component-name' is not a known element

After running the 'npm run test' command, it is possible that the tests fail and you will encounter the following error in the terminal:

```bash
ERROR: 'component-name' is not a known element
```

> The component-name is the name of the component being tested.

## Reason

This error occurs when the component being tested has not been declared in the testing module.

## Architecture Guidelines

To ensure that components are being declared correctly, it is important to check the ***HTML*** file of the component being tested. Make sure that all components used in the component template are being declared correctly.

If the component is from a library, you need to import the corresponding module from that library into the test's ***imports*** array.

On the other hand, if the component is from the application itself, it is necessary to import it into the test's array of declarations.

## Solution

Declare the components used by the component being tested in the test module.

``` TS
import { ComponentFixture, TestBed } from '@angular/core/testing';
import { ModalComponent } from './modal.component';
import { ModalHeaderComponent } from './modal-header.component';


describe('AuthComponent', () => {
    let component: ModalComponent;
    let fixture: ComponentFixture<ModalComponent>;

    beforeEach(async () => {
        await TestBed.configureTestingModule({
            declarations: [ModalComponent, ModalHeaderComponent],

        }).compileComponents();
    });
});
```
