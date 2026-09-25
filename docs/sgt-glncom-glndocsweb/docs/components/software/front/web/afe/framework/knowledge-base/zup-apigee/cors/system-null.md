# Application System Null

## Contextualization

Even after we perform the [header configurations](../../../development-guides/deployment/headers/index.md) required for production environments.

A project can continue to suffer ***cors*** errors if the ***system***, containing the application's acronym, is being sent as empty, even more so if the application authenticates via login and password form.

## Solution

It will be necessary to revisit the application logic and make the appropriate arrangements so that the value of ***system*** is not sent as ***null*** in the ***payload*** of the request to the ***endpoint*** that is being blocked by ***CORs***.
