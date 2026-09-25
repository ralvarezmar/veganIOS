# Schema/Database Migration

During the lifecycle of an application, it is very common for its database to
undergo changes such as the inclusion of new tables and columns, changes in
types, among others. Schema Migration is the capability that allows us to manage
this evolution, in the same way that we use a tool like Git to control the
evolution of our code.

This capability is also useful during development as it allows new developers to
quickly and easily recreate the necessary database structure locally.

## Liquibase

Schema Migration is implemented using a set of scripts that describe changes to
the database, but we still need a specialized tool that knows what order to run
these scripts in, identify errors and rollback, and keep a history of which
scripts have already been executed in the past. Here at Santander, this tool is
Liquibase!

## Settings

Liquibase is a tool that must be run on a server, so that it can keep the
history of the changes that have already been made in each database. This way,
database changes in the official environments (dev, hk and production) are
performed in a central Liquibase installation, which is shared by the projects.

On the other hand, developers can run Liquibase locally for the purposes of
building and configuring their local workbench. To do so, you need to configure
a Maven plugin in your application's pom.xml file, as shown below:

``` { .java .copy }
<pluginManagement>
    <plugins>
        <plugin>
            <groupId>org.liquibase</groupId>
            <artifactId>liquibase-maven-plugin</artifactId>
            <version>${liquibase.version}</version>
            <configuration>
                <changeLogFile>src/main/resources/db/changelog/db.changelog-master.yaml</changeLogFile>
                <!-- For Postgres, use org.postgresql.Driver -->
                <driver>oracle.jdbc.driver.OracleDriver</driver>
            </configuration>
        </plugin>
    </plugins>
</pluginManagement>
```

!!! tip "Attention!"

    In the sections ahead we will show how to run Liquibase
    scripts both locally and through Santander's DevOps treadmill.

## Changelogs and Changesets

Changelogs and changesets are Liquibase-specific terms. In a simplified way,
they are the way the tool organizes the changes that will be applied to the
database. Changelogs are sets (or groups) of changes to be applied to the
database, while changesets are the changes themselves, that is, the SQL commands
that will be executed in the database such as CREATE, INSERT, ALTER, DROP,
SELECT, etc...

## Naming and Organization Standards

### Folders

The scripts and the Liquibase configuration file must be stored in a structure
below the resources folder, according to the pattern below:

``` { .json .copy }
+ src/main/resources
|
|-- + db
    |
    |-- + changelog
        |-- db.changelog-master.yaml
        |-- + scripts
```

The scripts folder must be organized into subfolders that make it easier to
group scripts that are related to each other and that will later need to be
executed together in official environments. Some suggestions are to organize
these subfolders by functionality, date, version or release. Below we show some
examples:

``` { .json .copy }
+ scripts
|
|-- + funcionalidadeA (scripts de uma determinada funcionalidade)
|-- + 2019_07 (scripts de um determinado ano/mês)
|-- + versao1_5_3 (scripts de uma determinada versão)
|-- + release4 (scripts de uma determinada release)
```

The db.changelog-master.yaml file must be configured as follows:

``` { .json .copy }
databaseChangeLog:
    - includeAll:
        path: db/changelog/scripts
```

#### Changelogs (Scripts)

Liquibase uses the alphabetical order of changelog filenames to determine their
execution order. For this reason, we recommend naming the files following a
date/time pattern such as
\<year>-\<month>-\<day>_\<hour>-\<minute>_\<description>.sql, as in the example below:

``` { .json .copy }
2019-07-25_16-54_table-customer.sql
```

We need to inform Liquibase that we are using the SQL standard to define
changelogs, for this reason, the first line of each script must contain the
following statement:

``` { .json .copy }
--liquibase formatted sql
```

#### Changesets (Commands)

The changesets represent the SQL commands that will be executed in the database
as part of a changelog. Before each SQL statement, we need to inform that it is
a changeset through an identifier that contains the author of the changeset and
a sequential number, as in the example below:

``` { .json .copy }
--changeset joao_silva:1
```

Below we show an example of a changelog composed of two changesets for creating
a table and inserting a record in it:

``` { .sql .copy }
--liquibase formatted sql

--changeset joao_silva:1
create table customer (
    id int not null primary key,
    firstname varchar(80),
    lastname varchar(80) not null
);

--changeset joao_silva:2
insert into customer values (1, 'Joao', 'Silva');
insert into customer values (2, 'Jose', 'Augusto');
```

#### Commit and Rollback

By default Liquibase commits at the end of each changeset, and also rolls it
back in case of errors. However, most databases interfere with this behavior by
performing a commit for each DDL statement (CREATE, ALTER, DROP, etc.), and a
single commit for multiple sequential DML statements (INSERT, UPDATE, DELETE).

For this reason, we recommend that each DDL instruction be isolated in its own
changeset, and when there is a need to execute multiple DML instructions in
sequence, that they be grouped in the same changeset.

#### Best Practices

To find out about other standards and good practices for using Liquibase in
Santander, consult the official page of PRODUBAN on Automated Deployment in a
Database.

### Running the Scripts

#### Official Environments

Santander already has a specialized DevOps track for executing Liquibase scripts
in the bank's official environments.

Consult the PRODUBAN pages on Creating a DB project in Jenkins and on Automated
Deployment in a Database for more details.

#### Local Environment

To run the scripts in your local environment, use the Maven command below,
replacing ${URL}, ${USERNAME} and ${PASSWORD} with the URL, user and password of
your local database, respectively.

``` { .bash .copy }
mvn -Dliquibase.url=${URL} -Dliquibase.username=${USERNAME} -Dliquibase.password=${PASSWORD} liquibase:update
```
