# Repository pattern

Repository is a design pattern whose goal is to isolate domain objects (our
model package) from database access logic.

Conceptually, a Repository encapsulates a collection of objects persisted in a
database and the operations that can be performed on them. The application can
query, insert, remove and update objects in this collection without having to
worry about database details such as connections, commands, cursors and SQL
queries.

Utilizing this pattern helps promote decoupling, standardization, and
centralization of code.

## Spring Data

In Arsenal Cloud Native applications we use the Spring Data framework. It not
only offers different Repository interfaces that can be implemented by our
application, but is also able to derive queries directly from method names. To
use Spring Data, add its dependency in your application's pom.xml file, along
with the database driver that will be used:

``` { .xml .copy }
<!-- Spring Data -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-jpa</artifactId>
</dependency>

<!-- Driver PostgreSQL -->
<dependency>
    <groupId>org.postgresql</groupId>
    <artifactId>postgresql</artifactId>
    <version>${postgresql.version}</version>
</dependency>

<!-- Driver Oracle -->
<dependency>
    <groupId>com.oracle.jdbc</groupId>
    <artifactId>ojdbc8</artifactId>
    <version>${oracle-jdbc.version}</version>
</dependency>
```

!!! tip "Attention!"

    Indicating the driver version as in the example above
    causes Arsenal to choose a version that has already been tested and is
    compatible.

    If necessary, you can change and specify the version you want to use, but it is not possible to guarantee that this version will be available in Artifactory (mainly in the case of Oracle).

## Types of Repositories

Spring Data provides 3 ready-made types of repositories, which only need to be
implemented by our application classes. Each type of repository adds more
functionality over the previous one, as we will see in the examples below.
Remember that according to our Application Framework pattern, repository classes
must be placed in the package of the same name!

## CrudRepository

It is an interface that provides the basic methods necessary for building CRUD
operations (Create, Read, Update, Delete), namely:

| Method | Description |
|---|---|
| count() | Counts the number of records in the database. |
| delete(entity) | Removes the entity from the database. |
| exists(entity_id) | Checks if an entity exists based on its primary key. |
| findAll() | Retrieve all records from the database. |
| findById(entity_id) | Retrieves a single record based on its primary key. |
| save(entity) | Insert the entity into the database. |

## PagingAndSortingRepository

It is an interface that has the same methods as the CrudRepository interface, in
addition to adding two more methods that allow paging and sorting the records:

| Method | Description |
|---|---|
| findAll(pageable) | Retrieves all records according to the pagination condition given by the Pageable object. |
| findAll(sort) | Retrieves all records sorted by the conditions given by the Sort object. |

Below we illustrate an example implementation of this type of repository:

``` { .java .copy }
@Repository
public interface CustomerRepository extends PagingAndSortingRepository<Customer, Long> {
    List<Customer> findByName(String name, Pageable pageable);
}
```

!!! tip "Attention!"

    When creating a repository we need to specify the type of
    object it works on and its primary key, hence the:

    ```java
    PagingAndSortingRepository<Customer,Long>
    ```

## JpaRepository

It is the most complete interface, providing the methods of the other two and
increasing them with a few more specializations for processing entities in
batches. The implementation follows the same model as shown above:

``` { .java .copy }
@Repository
public interface CustomerRepository extends JpaRepository<Customer, Long> {}
```

## Creating Queries

### Method Nomenclature

In addition to the basic methods already provided by the repository as seen
above, we can add our own methods without the need to write the query associated
with them. Following some naming conventions, Spring Data is able to derive
queries directly from method names.

So that Spring can derive the queries, we must follow the following naming
convention:

```xml
<prefix><attributename><condition>
```

with "condition" being optional.

For example, the methods below fetch all customers:

``` { .java .copy }
// Get all customers whose name is not NULL
List<Customer> findByNameIsNotNull();
// Gets all customers whose name is equal to the "name" parameter
List<Customer> findByName(String name);
```

In addition to findBy, you can use other prefixes like countBy, deleteBy,
removeBy, existsBy and getBy. Consult the official documentation in the
references section to get to know them all.

Below we detail the keywords that can be used to define conditions:

| Key-word | Example |
|---|---|
| And, Or | findByFirstNameAndLastName(String firstName, String lastName) |
| Is, Equals | findByLastNameEquals(String lastName) |
| After, Before | findByBirthdateAfter(Date birthdate) |
| Between | findByBirthdateBetween(Date startDate, Date endDate) |
| LessThan, LessThanEqual, GreaterThan, GreaterThanEqual | findByAgeLessThanEqual(Integer age) |
| IsNull, NotNull, IsNotNull | findByNameIsNotNull(String name) |
| Like, NotLike, Not | findByFirstNameLike(String firstName) |
| StartingWith, EndingWith | findByLastNameEndingWith(String endingLastName) |
| OrderBy | findByAgeOrderByFirstName(Integer age) |
| In, NotIn | findByAgeIn(List \<Age> ages) |
| True, False | findByActiveFalse() |
| IgnoreCase | findByLastNameIgnoreCase(String lastName) |

!!! tip "Attention"

    See that it's really not necessary to provide any kind of
    implementation when we create methods following the Spring Data convention!

### Custom Queries

We know that in many cases it will not be possible to create queries using only
the Spring Data naming convention. For these cases, custom queries can be
created in the repository using the @Query annotation. Custom queries are
written in JPQL (Java Persistence Query Language) notation, that is, we use the
names of classes and their attributes instead of table and column names. One of
the advantages of this approach is that our queries become agnostic to the
database being used, which facilitates any future migrations.

Below is an example of creating a custom query for querying customers based on
their name and age:

``` { .java .copy }
@Query("SELECT c FROM Customer c WHERE c.name LIKE %:name% AND c.age = :age")
Customer findCustomerByNameAndAge(@Param("name") String name, @Param("age") int age);
```

!!! tip "Attention"

    __Remember:__ custom queries are written in JPQL notation,
    not SQL!

### Native Queries

As we saw earlier, the JPQL notation is independent of the database being used,
which means that it is not possible to use functions that are only supported by
some databases in a JPQL query. For example, the RANK() and DENSE_RANK()
functions cannot be expressed in a JPQL query.

When it is strictly necessary to use such functions, the queries must be written
directly in SQL and must have the nativeQuery parameter set to true, as in the
example below:

!!! tip "Attention"

    Native queries are often not portable between different
    databases, which means they will have to be rewritten if the database is
    migrated.

### References

[Spring
Data](https://docs.spring.io/spring-data/jpa/docs/current/reference/html/)

[Spring Boot - Data
Access](https://docs.spring.io/spring-boot/docs/current/reference/html/howto.html#howto.data-access)
