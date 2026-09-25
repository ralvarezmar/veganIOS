### Q1. How to use extent report?

Step 1. First add extent report plugin to TestRunner file

    "com.aventstack.extentreports.cucumber.adapter.ExtentCucumberAdapter:"

Step 2. Add below dependency

    <dependency>
        <groupId>com.aventstack</groupId>
        <artifactId>extentreports</artifactId>
        <version>5.0.9</version>
    </dependency>

Step 3. After running the test you will see extent report is generated inside target folder.

### Q2. How can I pass the report folder name at runtime?

You can use below terminal cmd

```CommandLine
mvn test -Dcucumber.plugin="pretty, html:target/OneWeb/cucumber.html -s settings.xml -Djavax.net.ssl.trustStore=nexus.jks -Djavax.net.ssl.trustStorePassword=changeit"
```
