---
title: Gluon Customization and Scaling Request
hide:
    - toc
---

In the Gluon team we aim to adjust to the needs of our clients, that is why we always try to add customizable configurations.

You can request to change the following configurations for one or all flavor runner you use in your organization using this link to service now:

[TECHNICAL CATALOG -> Cloud -> Gluon -> Gluon Tools Request](https://santander.service-now.com/nav_to.do?uri=%2Fcom.glideapp.servicecatalog_category_view.do%3Fv%3D1%26sysparm_parent%3D257db34f1bf2a510e4909753b24bcb38%26sysparm_ck%3Da49421c987fe39104cedea030cbb35f424a3bdc6e2efad83e7317a21ff2d380888b4a989%26sysparm_processing_hint%3Dsetfield:request.parent%3D%26sysparm_catalog%3D719aafd0db031f448c6c7cde3b9619f8%26sysparm_catalog_view%3Dcatalog_technical_catalog)

## Runner Autoscaling

- minReplicas: 1              ( Runner pod waiting when there is no workflow executing yet )
- scaleUpThreshold: '0.75'    ( The percentage of busy runners at which the number of desired runners are re-evaluated to scale up )
- scaleDownThreshold: '0.3'   ( The percentage of busy runners at which the number of desired runners are re-evaluated to scale down )
- scaleUpAdjustment: 2        ( The scale up runner count added to desired count )
- scaleDownAdjustment: 1      ( The scale down runner count subtracted from the desired count )

### Example

There is a deployed runner occupied, so the number of runners occupied is greater than 75% (scaleUpThreshold 0.75), so it will scale, 1 deployed runner multiplied by 2 scaleUpAdjustment.
Once the runners are free, they will de-escalate one by one.

### Example 2

There are 5 deployed runner and 4 occupied, so the number of runners occupied is greater than 75% (scaleUpThreshold 0.75), so it will scale, 5 deployed runner multiplied by 2 (scaleUpAdjustment).
Once the runners are free, they will de-escalate one by one (scaleDownAdjustment: 1).

## Use particular Proxy

- http_proxy ( http proxy to be used by workflows host:port )
- https_proxy ( https proxy to be used by workflows host:port )
- no_proxy ( specifies URLs that should be excluded from proxy )

### Other sections in Gluon Infrastructure adoption process

<div class="cards row-1" markdown>

- #### Gluon Infrastrcture Request

    ---
    Request new infrastructure in Gluon

    [:computer: Gluon Request New](./request-new.md/)

</div>
