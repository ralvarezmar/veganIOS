# Comparison between Angular 14 and 15

The main differences between the versions are:

| ***Angular 14*** | ***Angular 15*** |
| --------- | ---------- |
| NodeJS versions **14.15.x** and **16.10.x** are supported. |   Versions **14.20.x**, **16.13.x** and **18.10.x** are supported. Versions **14.15** to **14.19** and **16.10** to **16.12** are no longer supported. |
| Support for TypeScript version **4.7.2**. |   Support for TypeScript version **4.8.2**. |
| ***setDisabledState*** method of ***ControlValueAccessor*** is called only when the control is disabled. | ***setDisabledState*** method of ***ControlValueAccessor*** is called when the class is initialized by Angular.   |

And regarding your ecosystem compatibility:

| ***Angular 14*** | ***Angular 15*** |
| --------------- | ---------- |
| ***Webpack***: 5.81.0 | ***Webpack***: 5.75.0 |
| ***TypeScript***: ~4.7.2 | ***TypeScript***: ~4.8.2 |
| ***RxJs***: ~7.5.0 | ***RxJs***: ~7.5.0 |
| ***jasmine***: ~4.6.0 | ***jasmine***: ~4.6.0 |
| ***karma***: ~6.4.0 |  ***karma***: ~6.4.0 |
| ***node***: 14.15.x/16.10.x | ***node***: 14.20.x/16.13.x/18.10.x |
