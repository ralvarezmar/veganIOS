# Multiple modules importing the ***HttpClient***

If you have more than one module in your application, the ideal is that only the ***AppModule*** or the main module imports the ***HttpClientModule***.

Otherwise this will end up generating **multiple instances** of ***HttpClient*** and causing problems with the interceptors that add the headers for integration with ZUP.
