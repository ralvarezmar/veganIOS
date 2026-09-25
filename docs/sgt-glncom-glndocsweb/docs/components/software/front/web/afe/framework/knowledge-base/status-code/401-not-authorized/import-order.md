# Import order of modules

If your application has been migrated and still uses the ***hubConnector*** from the ***@afe/general-base*** package together with ***@afe/http-interceptors***.
It is possible that the order in which the imports were performed in the main module interferes with the operation of the interceptors.

For more information, please refer to our documentation on [HubConnector and HubConnectorInterceptor coexistence](https://confluence.santanderbr.corp/pages/viewpage.action?pageId=193733145)
