# Nomenclature

Adopting naming standards helps improve code readability and makes it easier to
understand. These patterns also make it possible for developers not only to find
artifacts faster, but also to understand the purpose of each one just by looking
at their names. This way, new developers can perform maintenance and add new
features more efficiently.

Below you will find all the naming standards that should be used when building
applications on the Arsenal Cloud Native architecture.

## Project

To facilitate the organization of several projects, we suggest naming them in
lowercase letters, according to the following pattern:

<span style="color:orange">***&lt;acronym>-&lt;application>***</span>, where:

* Acronym: Acronym responsible for the application (e.g. obk, edp, pe, bg, etc.)
* Application: name of the application itself, describing its functional domain
  or its purpose (e.g. card-acquisition, credit-risk, customer-onboarding)

### Example

Let's name the project after a fictitious <span style="color:orange">current
account</span> application, owned by the acronym <span
style="color:blue">BG</span>.

Following our pattern, the name of this project would look like this: <span
style="color:blue">bg</span>-<span style="color:orange">current-account</span>.

!!! tip "Note"

    Project names are only used for display and organization in the
    IDEs, and files describing projects in Eclipse (.project) and IntelliJ
    (.idea folder) are not stored in Git. Thus, the pattern suggested above is
    not mandatory, serving only to organize the developer's personal
    environment.

## Packages

Package names must be written in all lowercase letters and separated by a
hyphen, following the pattern below:

<span
style="color:orange">***com.santander.&lt;acronym>.&lt;application>.&lt;package>***</span>,
where:

* Acronym: Acronym responsible for the application (e.g. obk, edp, pe, bg, etc.)
* Application: name of the application itself, describing its functional domain
  or its purpose (e.g. card_acquisition, credit_risk, customer_onboarding)
* Package: name of the package, according to its function, as described in the
  [Application Structure](packages-structure.md) section.

### Example

Let's name the <span style="color:red">configuration</span> package of a fictitious <span style="color:green">card acquisition</span> application, owned by the initials <span style="color:blue">MP</span>.

Following our pattern, the name of this package would look like this:
<span style="color:orange">com.santander</span>.<span style="color:blue">mp</blue>.<span style="color:green">card_acquisition</span>.<span style="color:red">config</span>.

## Classes

Class names should be nouns, with the first letter of each word uppercase and
the rest lowercase (***UpperCamelCase***). The class name cannot contain spaces,
commas, dashes, accents, special characters, numbers, acronyms and/or
abbreviations.

| Package      | Class Suffix                |
|--------------|-----------------------------|
| client       | ClassName***Client***       |
| config       | ClassName***Config***       |
| exception    | ClassName***Exception***    |
| handler      | ClassName***Handler***      |
| mapper       | ClassName***Mapper***       |
| model        | ClassName                   |
| model.dto    | ClassName***DTO***          |
| provider     | ClassName***Provider***     |
| dataprovider | ClassName***ProviderImpl*** |
| repository   | ClassName***Repository***   |
| scheduler    | ClassName***Scheduler***    |
| service      | ClassName***Service***      |
| service.impl | ClassName***ServiceImpl***  |
| resource     | ClassName***Resource***     |
| usecase      | ClassName***UseCase***      |
| util         | ClassName***Util***         |

In the examples above, *ClassName* must be replaced by the actual name of the
class in question (eg Customer).

## Test Classes

In the test classes, it is necessary to include the Test suffix:

| Package       | Class Suffix                 |
|---------------|------------------------------|
| client        | ClassName***ClientTest***    |
| handler       | ClassName***HandlerTest***   |
| model         | ClassName***Test***          |
| scheduler     | ClassName***SchedulerTest*** |
| service       | ClassName***ServiceTest***   |
| util          | ClassName***UtilTest***      |

In ***integrated*** test classes, you must include the suffix
***IntegratedTest***. For example, CustomerServiceIntegratedTest.

In ***architectural test*** classes, you must include the ***ArchTest*** suffix.
For example, ServiceArchTest.

## Interfaces

Interface names follow the same naming pattern as Classes.

``` { .java .copy }
public interface Customer {}

public class Person implements Customer {}

public class Company implements Customer {}
```

!!! tip

    Note that the I prefix and the Interface suffix are not used! The
    development environments (IDEs) suggested in the Developer's Kit already make it
    clear through visual symbols which project elements are an interface, class,
    enum, etc.

## Enumerations (Enums)

The names of the Enumerations must follow the same pattern as the Classes.
Values must be written in capital letters, without spaces, and may contain the _
character to separate compound values, such as the HUMAN_RESOURCES item in the
example below.

``` { .java .copy }
public enum Department {
    ACCOUNTING,
    MARKETING,
    HUMAN_RESOURCES
}
```

## Variables

Variables must always be named in lower case. If it is a compound name, the
first word is always written in lowercase, and the others with only the first
letter in uppercase, following the ***lowerCamelCase*** pattern.

!!! warning

    Following the Java language specification, we do not use numbers
    and/or special characters (such as _, $ and @) at the beginning of variable
    names.

The name of the variable must be written according to its responsibility within
its context (class or method), so that it is easy to understand what it refers
to and what role it is intended to play.

``` { .java .copy }
public class Customer {
    private String var1; // WRONG: variable that does not represent something related to the customer
    private String _age; // WRONG: variable with special character at the beginning of the name
    private String firstName; // CORRECT: variable representing the customer's first name
}
```

## Constants

The name of the constants must be written with all letters in capital letters,
and cases of compound names can be separated with the character _. Again, the
name should be descriptive of what the constant represents in that context.

!!! tip "Tip"

    Numeric constants can also use the _ character to separate
    thousands, making it easier to read very large numbers.

``` { .java .copy }
public static final int DAYS_PER_WEEK = 7;
public static final long BRAZILIAN_POPULATION = 209_300_000;
```

### Why use constants?

* Improved code readability: numbers or words thrown into the code gain meaning
  when replaced with correctly named and commented constants;
* Immutability: constants use Java's final keyword, which guarantees that they
  cannot be modified at runtime;
* Avoid the repetition of values ​​directly (hardcoded) by the application code;
* Changing the value of a constant becomes trivial because it is declared in
  only one place.

## Methods

Methods must be named the same as variables, following the ***lowerCamelCase***
pattern. However, methods declare actions or operations and therefore must
contain verbs as part of their name. In addition, the name of the method must
clearly express its sole responsibility/function (SRP: Single Responsibility
Principle), so that it is clear when reading the code what the purpose of that
operation is.

``` { .java .copy }
public String parseName(String input) {
    String name = removeTrailingSpaces(input);
    name = keepLettersOnly(name);

    return name;
}
```

### Methods in test classes

Test class methods must follow the naming model below:

should_\<expectedBehavior>*when*\<stateUnderTest>

* expectedBehavior: must be replaced by a description of the expected behavior
  in the test;
* stateUnderTest: must be replaced by a description of the scenario being tested
  and which causes the behavior declared in expectedBehavior.

``` { .java .copy }

public class ExampleTestCases {

    // should_<throw an exception>_when_<age is less than 18>
    @Test
    public void should_throwException_when_ageLessThan18() {}


    // must_<fail to transfer between accounts>_when_<insufficient balance>
    @Test
    public void should_failToTransferBetweenAcconts_when_insufficientFunds() {}
}
```

See in the examples above that it is easy to understand what the test does just
by reading the name of the method.

## Recommended Readings

1. [Clean Code, por Robert C.
   Martin](https://books.google.com.br/books?id=hjEFCAAAQBAJ&source=gbs_book_other_versions)

## References

1. [Oracle - Naming
   Conventions](https://www.oracle.com/java/technologies/javase/codeconventions-namingconventions.html)
2. [Oracle - The Java Tutorials:
   Package](https://docs.oracle.com/javase/tutorial/java/package/namingpkgs.html)
3. [Oracle - The Java Tutorials:
   Classes](https://docs.oracle.com/javase/tutorial/java/javaOO/classdecl.html)
4. [Oracle - The Java Tutorials:
   Variables](https://docs.oracle.com/javase/tutorial/java/nutsandbolts/variables.html#naming)
5. [Spring Coding
   Standards](https://github.com/47deg/coding-guidelines/tree/master/java/spring)
6. [Spring Framework - Coding
   Style](https://github.com/spring-projects/spring-framework/wiki/Code-Style)
