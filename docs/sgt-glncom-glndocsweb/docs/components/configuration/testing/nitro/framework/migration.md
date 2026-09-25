## Release 5.2.3

Feature: nitrowebkit 5.2.3

**Why the change?**

- Added deque library for accessibility testing.
- Selenium 4 version upgraded to 4.13.0
- Appium version upgraded to 8.5.1
- Updated deprecated methods.
- Moved cucumber hook to Injection package

**[BUGFIX]** - Fixed issue with running test through feature file.

**[NEW FEATURE]** - Can run accessibility test using the library.

**How to use it?**

Project pom.xml file with the dependency

    <dependency>
        <groupId>com.test.santander.automation.framework</groupId>
        <artifactId>nitrowebkit</artifactId>
        <version>5.2.3</version>
    </dependency>

**Is there any impact?**

No impact.

---

## Release 5.1.8

Feature: nitrowebkit 5.1.8

**Why the change?**

- To make the current nitrowebkit compatible with selenium 4 and Appium 8.
- To integrate sauce lab with the current version of nitrowebkit.
- Selenium 4 version upgraded to 4.10.0
- Appium version upgraded to 8.5.1
- Updated deprecated methods.
- Added new properties to bootstrap file for country and screenshot at step level.
- Updated apache poi methods.

| Old value                        | New value                                  |
|----------------------------------|--------------------------------------------|
| case Cell.CELL_TYPE_NUMERIC      | case NUMERIC                               |
| case Cell.CELL_TYPE_STRING       | case STRING                                |
| case Cell.CELL_TYPE_BOOLEAN      | case BOOLEAN                               |
| case Cell.CELL_TYPE_FORMULA      | case FORMULA                               |
| case Cell.CELL_TYPE_BLANK        | case BLANK                                 |
| Row.CREATE_NULL_AS_BLANK         | Row.MissingCellPolicy.CREATE_NULL_AS_BLANK |

- Removed deprecated dependencies. {com.deque.axe-selenium}
- Updated pom.xml with latest version for all available dependencies.
- jayway.restAssured dependency change to io.restassured.

| Old value                                                         | New value                                  |
|-------------------------------------------------------------------|--------------------------------------------|
| import com.jayway.restassured.response.Response;                  | import io.restassured.response.Response;                               |
| import com.jayway.restassured.RestAssured;                        | import io.restassured.RestAssured;                               |
| import com.jayway.restassured.http.ContentType;                   | import io.restassured.http.ContentType;                               |
| import com.jayway.restassured.response.Response;                  | import io.restassured.response.Response;                              |
| import com.jayway.restassured.specification.RequestSpecification; | import io.restassured.specification.RequestSpecification;                                |
| import static com.jayway.restassured.RestAssured.given;           | import static io.restassured.RestAssured.given; |

- Change configuration for safari execution on grid.
- Updated dependency injection strategy as per latest release of cucumber-guice.

**[BUGFIX]** – Fixed Incompatibility of selenium 4 with Appium 7.

**[NEW FEATURE]** – Added feature to run test on mobile web using Sauce lab provider.

**How to use it?**

Project pom.xml file with the dependency

    <dependency>
        <groupId>com.test.santander.automation.framework</groupId>
        <artifactId>nitrowebkit</artifactId>
        <version>5.1.8</version>
    </dependency>

Changes required on TestRunner file, adding a glue for injection:

    classpath:com/test/injection

Changes required on cucumber.properties file:

    - remove: guice.injector-source=com.test.hooks.DI
    - add: cucumber.glue=com.test

**Is there any impact?**

Yes, team would require to update TestRunner and cucumber.properties file as per above mention changes to comprehend latest cucumber-guice changes and load configurations.

---
