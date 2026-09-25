# What's New in @afe/pipes version 3.x.x

With its new version **3.x.x** released, Pipes now supports Angular 8 and 10.

## Prerequisites

- Be using the ***2.x.x*** version of ***@afe/pipes***

## Breaking Changes

### Change pipe usage ***productStatusFormat***

The ***productStatusFormat***, due to the internal standardizations of the architecture, has been renamed to ***afeProductStatusFormat***.

```diff
-  <span>{{ status | productStatusFormat }}</span>
+  <span>{{ status | afeProductStatusFormat }}</span>
```

### Remove class ***PercentualPipe***

In previous versions, the ***PercentualPipe*** class was used and now, because there is already a class with this function of Angular itself, this pipe has been removed.

Use the ***PercentPipe*** pipe from the ***@angular/common*** library instead.

```diff
- import { ProductStatusPipe, PercentualPipe } from '@afe/pipes';
+ import { PercentPipe } from '@angular/common';

- const percent: PercentualPipe;
+ const percent: PercentPipe;
```
