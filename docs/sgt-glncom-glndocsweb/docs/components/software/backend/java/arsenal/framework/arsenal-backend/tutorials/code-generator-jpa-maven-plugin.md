# Arsenal JPA Code Generator Maven Plugin {!include-markdown '../../snippets/versions.md' start='<!tag:back-version-schema>' end='<!end:back-version-schema>'!}

{!include-markdown '../../snippets/versions.md' start='<!tag:back-current>' end='<!end:back-current>'!}

Arsenal JPA Code Generator is a code generator project that parses DDL (Data
Definition Language) commands from SQL (Structured Query Language) and
translates them into JPA Java classes. Furthermore, it generates the repository
layer for each entity that meets the JPA specification for relational databases.

The main goal is to help the developer with a code start of the application's
persistence layer, doing the boring and repetitive work of creating entities,
associating Hibernate annotations, simple data conversion and creation of the
repository layer.

## Prerequisites

To compile and run the generated code you will need:

- JDK 17+
- Lombok 1.28+
- Spring Data JPA 3+

For the code generation process, some points need attention:

- Must be an SQL file (*.sql)
- SQL file that contains the DDL commands
- All SQL statements should terminate with a semicolon (;)
- The name of database tables and columns cannot contain double quotes
- All configuration and characteristics of the `Entity` must be in the `CREATE
  TABLE` statement

> We would like to recommend writing portable, standard compliant SQL in
> general.

## Limitations

- Compatible with Oracle, Postgres, MS SQL Server, MySQL and MariaDB
- All commands must be compatible with the SQL 2016 Standard compliant Queries
- Only supports `CREATE TABLE` statements
- If any SQL Data Type has not been mapped, it will be generated as the Java
  `Object` data type.

## Installation

Arsenal JPA Code Generator is a maven plugin. To use it, just declare it in your
pom.xml file:

```xml
<plugin>
  <groupId>com.santander.ars</groupId>
  <artifactId>gln-back-arsenal-jpa-codegen-maven-plugin</artifactId>
  <version>{!include-markdown '../../snippets/versions.md' start='<!tag:back-version>' end='<!end:back-version>'!}</version>
  <executions>
    <execution>
      <phase>generate-sources</phase>
      <goals>
        <goal>generate</goal>
      </goals>
    </execution>
  </executions>
  <configuration>
    <sqlScript>path/to/my/sqlfile</sqlScript>
    <entityPackage>com.package.myentities</entityPackage>
    <repositoryPackage>com.package.myrepositories</repositoryPackage>
    <fileOverride>false</fileOverride> <!-- This property is false by default, change to true when you want to override the files generated -->
  </configuration>
</plugin>
```

After that, you can execute the `generate-sources` maven lifecycle to generate
the source code:

```bash
mvn genenate-sources
```

The source code will be generated within the `src/main/java` directory, and test
code in `src/test/java` by default. You will be able to make the necessary
adjustments and customizations in your entities, repositories and tests.

The plugin is responsible for generating the following:

- Entities for all tables specified in the sql file with annotations `@Entity`,
  `@Table` and `@Column`
- Some jakarta validation constraints like `@NotNull` for columns that are `NOT
  NULL` and so on.
- For composite primary keys will be generate `@Embeddable` classes and
  `@EmbeddedId` references
- Repositories for each entity properly configured with `@Repository` annotation
  and inheritance for `JpaRespository<Entity, ID>`
- Unit tests for each entity properly generated, using JUnit.

### What about Foreign Keys?

We understand that mapping to foreign keys often needs to reflect business needs
as well as be adapted for performance improvements. Inferring this as well as
unidirectional and bidirectional mapping would be significantly risky.
Therefore, relationship mapping can be done by the developer in the best
possible way and according to their needs.
