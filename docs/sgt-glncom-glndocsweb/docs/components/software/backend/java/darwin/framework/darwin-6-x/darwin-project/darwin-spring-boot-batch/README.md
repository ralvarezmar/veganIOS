# Darwin Spring Boot Batch ![6.3.4](https://img.shields.io/badge/6.3.4-FF073D)

![Current](https://img.shields.io/badge/CURRENT-30FF24) ![GA](https://img.shields.io/badge/GA-C81D11)

## Description

The **darwin-spring-boot-batch** module allows the use of the **Spring Batch** and **Spring Cloud Task** libraries, which will allow us to develop batch microservices with ease, contributing with custom configuration for the databases, custom logs
for improved tracking and metrics, and a chain of responsibility, which will cover the authentication, logging and core part of the microservice, making it easy to perform the same functionalities the Filters does in the online flavors.

!!! info "Important"

    Batch library is only available to use in Spain infrastructure.

!!! warning

    Since 4.0.0, the SecurityContext is cleared after validating the JWT Token provided by the SCDF. For calling third party services that needs of a JWT Token, you need to obtain and provide it by using the darwin authentication
    module and its utilities.

## Functionality

This module incorporates the **Spring Batch** and **Spring Cloud Task** library and makes compatible **Darwin** with the batch flavor, for the ***NotWeb*** variant.

This library works with ***NotWeb*** type applications, and these kind of applications have their own archetype.

### BatchApplicationRunner

This is one of the main components that this module add. This BatchApplicationRunner decorates the main JobApplicationRunner that executes the Job and Steps logic. With this, we are able to create a previous DarwinInfo with all the information
necessary for the Logging and Authentication functionalities, as we do in the Servlet and Reactive Flavors with the filters and interceptors.

This information is accessible through configuration and environment variables, so it can be changed as needed.

### Chain of Responsibility

This is the other main component of the Batch adaptation. This chain of responsibility is the equivalent of the Filter Chain that is present in Web environments.

As such, it has the following functionalities:

- A link for including the DarwinInfo in the DarwinContextHolder, for header propagation. This is the first link in the chain, the CoreChainProcessor.

- Another link for activity logging purposes, which is the second one in the chain, the LoggingChainProcessor.

- And a final one, with the authentication mechanisms of Darwin, to check whether the job should be executed or not, which is the final link in the chain, the AuthenticationChainProcessor.

It could be expanded by adding new ChainProcessor's classes to the configuration, making it possible for developers to add more links to the chain if needed.

All they'll have to do is implement the ChainProcessor in a class and expose the bean in a configuration file.

### Custom Listeners for Jobs and Steps

This module also adds custom Job and Step Listeners for activity logging, without the developer having to add them, and without having conflicts with the ones that they want to add, ensuring the execution of these architecture listeners.

These listeners will create activity logs after each Job and Step execution. They will provide some useful information, such as if an error occurred during the execution of the job, the names of the Jobs and Steps executed and their Id's to be
included in the [Activity Log pattern](../darwin-spring-boot-logging/LOGGING-PATTERNS.md#activity-pattern):

#### Global Format

    {"timestamp":"2022-12-20T16:39:31.785Z","environment":"TEST","userId":"myself","logLevel":"INFO","log":"sampleJob  ","appKey":"appKey","serviceName":"DARWIN","region": "BOAE","entity":"ESP","error":"false","platform":"Darwin","traceId":"000462d53c8abac0","spanId":"4f8d780fadf3c913","parentSpanId":"000462d53c8abac0","trace_id":"","span_id":"","parent_id":"","tracestate":"","customLog":{"paasProject":"PaasProject","sessionId":"","platformLog":"","paasAppVersion":"1.0.0","appInit":"foo","serverId":"FOOHOST","channel":"INT","contactPoint":"","threadId":"main","clientId":"","responseTime":"17","jobExecutionId":"1","jobInstanceId":"1","stepExecutionId":""},"inputTimeStamp":"2022-12-20T16:39:31.766Z","method":"JobListener.afterJob","url": "test-activity-logger","returnCode":"COMPLETED","logType":"activity"}

#### Spain Format

    {"timestamp":"2022-12-20T16:39:31.785Z","environment":"TEST","userId":"myself","logLevel":"INFO","log":"sampleJob ","appKey":"appKey","serviceName":"DARWIN","region": "BOAE","entity":"ESP","error":"false","platform":"Darwin","traceId":"000462d53c8abac0","spanId":"4f8d780fadf3c913","parentSpanId":"000462d53c8abac0","trace_id":"","span_id":"","parent_id":"","tracestate":"","customLog":{"paasProject":"PaasProject","sessionId":"","platformLog":"","paasAppVersion":"1.0.0","appInit":"foo","serverId":"FOOHOST","channel":"INT","contactPoint":"","threadId":"main","clientId":"","responseTime":"17","jobExecutionId":"1","jobInstanceId":"1","stepExecutionId":"","bootVersion":"BOOT3"},"inputTimeStamp":"2022-12-20T16:39:31.766Z","method":"JobListener.afterJob","url": "test-activity-logger","returnCode":"COMPLETED","logType":"activity"}

#### Technical and Functional traces

It is also possible to add technical and functional traces manually. Additionally, these traces include the instance, execution, step IDs that are generated during the execution of a job. The boot version is also included on both traces.

##### Technical console trace

      [INFO ] 2023-10-17 17:30:30.080 [main] 000462d53c8abac0 000462d53c8abac0 BatchJobListener - Starting Job sampleJob "jobExecutionId":"0","jobInstanceId":"0","stepExecutionId":"","bootVersion":"BOOT3"

##### Functional trace

      {"timestamp":"2023-09-28T10:38:28.251Z","environment":"TEST","userId":"","logLevel":"INFO","log":"End of endpoint '/test-functional-logger' ","appKey":"appKey","serviceName":"DARWIN","region": "BOAE","entity":"ESP","error":"","platform":"Darwin","traceId":"","spanId":"","parentSpanId":"","trace_id":"","span_id":"","parent_id":"","tracestate":"","customLog":{"paasProject":"PaasProject","sessionId":"","platformLog":"","paasAppVersion":"1.0.0","appInit":"","serverId":"FOOHOST","jobExecutionId":"15","jobInstanceId":"9","stepExecutionId":"34","bootVersion":"BOOT3"},"logType":"functional","businessLog":{"input":{},"output":{"returnCode": "200"}}}

### Spring Batch and Spring Cloud Task Database Configuration

This module adds support for configuring via application.yml the databases for Spring Batch and Spring Cloud Task without having to add the datasources by hand or via config class.

## Installation and configuration

To add the library to any project you will have to include the maven dependency of your starter in the `pom.xml` file:

    <dependency>
        <groupId>com.santander.darwin</groupId>
        <artifactId>darwin-spring-boot-starter-batch</artifactId>
    </dependency>

### Configuration

The **darwin-spring-boot-batch** module incorporates the following configuration parameters for the application.yml file of the project:

#### DarwinInfo, LoggingContext and FilteredOrder properties

In order to configure the DarwinInfo and LoggingContext properties for the propagation of this information to the possible third party calls, the following configuration must be added into the application.yml:

```yaml
    darwin:
      batch:
        darwin-info-properties:
          locale: esES
          channel: FOOCHANNEL
          entity: FOOENTITY
          thirdParty: FOOTHIRDPARTY
          appInit: FOOAPPINIT
        logging-context-properties:
          platform-log: platformlog
          user-agent: useragent
        filter-order:
          core-filter-order: 1
          authentication-filter-order: 2
          log-filter-order: 3
```

there's no need to modify the FilterOrder properties, unless it is necessary and a new Chain processor must be ahead of the chain.

<!tag:properties>

| Property                                                | Description                                                          | Required | Value                 | Environment |
|---------------------------------------------------------|----------------------------------------------------------------------|----------|-----------------------|-------------|
| *darwin.batch.darwin-info-properties.locale*            | Indicates the locale value used to populate the DarwinContext.       | Yes      | esES                  | Any         |
| *darwin.batch.darwin-info-properties.channel*           | Indicates the channel value used to populate the DarwinContext.      | Yes      | channel               | Any         |
| *darwin.batch.darwin-info-properties.entity*            | Indicates the entity value used to populate the DarwinContext.       | Yes      | entity                | Any         |
| *darwin.batch.darwin-info-properties.thirdParty*        | Indicates the thirdParty value used to populate the DarwinContext.   | Yes      | thirdParty            | Any         |
| *darwin.batch.darwin-info-properties.appInit*           | Indicates the appInit value used to populate the DarwinContext.      | Yes      | appInit               | Any         |
| *darwin.batch.logging-context-properties.platform-log*  | Indicates the platformLog value used to populate the LoggingContext. | Yes      | platformLog           | Any         |
| *darwin.batch.logging-context-properties.user-agent*    | Indicates the userAgent value used to populate the LoggingContext.   | Yes      | userAgent             | Any         |
| *darwin.batch.filter-order.core-filter-order*           | Indicates the order for the Core chain processor.                    | No       | HIGHEST_PRECEDENCE    | Any         |
| *darwin.batch.filter-order.log-filter-order*            | Indicates the order for the Log chain processor.                     | No       | HIGHEST_PRECEDENCE+5  | Any         |
| *darwin.batch.filter-order.authentication-filter-order* | Indicates the order for the Authentication chain processor.          | No       | HIGHEST_PRECEDENCE+10 | Any         |

<!end:properties>

This will be the properties that'll fulfill the DarwinInfo properties (darwin-info-properties) and the information that will log when tracing the activity logs (logging-context-properties).

On the other end, we have the database configuration for Spring Batch and Spring Cloud Task. Since they are the same database with the same schema, they'll be configured with the same prefixes

It's important to keep this configuration as it is, and modify if needed the values through the application-{environment}.properties files:

    spring:
      batch:
        datasource:
          jdbc-url: ${env.spring-batch-datasource.jdbc-url}
          username: ${env.spring-batch-datasource.username}
          password: ${env.spring-batch-datasource.password}
          driver-class: ${env.spring-batch-datasource.driver-class}

| Property                               | Description                                                                      | Required | Value                                       | Environment |
|----------------------------------------|----------------------------------------------------------------------------------|----------|---------------------------------------------|-------------|
| *spring.batch.datasource.jdbc-url*     | Indicates the jdbc-url value used to connect to the architecture's database.     | Yes      | ${env.spring-batch-datasource.jdbc-url}     | Any         |
| *spring.batch.datasource.username*     | Indicates the username value used to connect to the architecture's database.     | Yes      | ${env.spring-batch-datasource.username}     | Any         |
| *spring.batch.datasource.password*     | Indicates the password value used to connect to the architecture's database.     | Yes      | ${env.spring-batch-datasource.password}     | Any         |
| *spring.batch.datasource.driver-class* | Indicates the driver-class value used to connect to the architecture's database. | Yes      | ${env.spring-batch-datasource.driver-class} | Any         |

#### Autoconfiguration class guidelines

>**IMPORTANT guidelines for autoconfiguration**
>
> 1. **AVOID** **GENERIC** bean names like `transactionManager` or `dataSource` and **ALWAYS** name your beans in a **DESCRIPTIVE** way like `businessDataTransactionManager` or `oracleDataSource`
> 2. To avoid potential ambiguity, use `@Qualifier("yourDescriptiveBeanName")` when injecting your beans (see example below)
> 3. If you're using Darwin Batch with Spring JPA, when you're creating the steps where JPA will be used, you need to explicitly inject your custom transaction manager into the steps using `@Qualifier("...")`. See example below.

Here is an example of an autoconfiguration class that follow the guidelines described above and uses Spring JPA as well:

```java
@Configuration
@EnableJpaRepositories(entityManagerFactoryRef = "businessDataEntityManagerFactory",
        transactionManagerRef = "businessDataTransactionManager")
public class ApplicationAutoConfig {

    // Example of naming your beans in a descriptive way
   @Bean
   @ConfigurationProperties("my-project.datasource.business-data")
   public DataSource businessDataDataSource() {
      return DataSourceBuilder.create().build();
   }

   // Example of naming your beans in a descriptive way
   @Bean
   public PlatformTransactionManager businessDataTransactionManager(
           @Qualifier("businessDataEntityManagerFactory") EntityManagerFactory emf) {
      return new JpaTransactionManager(emf);
   }

   @Bean
   public LocalContainerEntityManagerFactoryBean businessDataEntityManagerFactory(
           @Qualifier("businessDataDataSource") DataSource dataSource) {

      LocalContainerEntityManagerFactoryBean em = new LocalContainerEntityManagerFactoryBean();
      em.setDataSource(dataSource);
      em.setPackagesToScan("com.organization.appkey.mybatch.model");
      em.setJpaVendorAdapter(new HibernateJpaVendorAdapter());

      Map<String, Object> properties = new HashMap<>();
      properties.put("hibernate.dialect", "org.hibernate.dialect.OracleDialect");
      properties.put("hibernate.hbm2ddl.auto", "none");
      em.setJpaPropertyMap(properties);

      return em;
   }

   @Bean
   public JpaItemWriter<Customer> customerJpaItemWriter(
           @Qualifier("businessDataEntityManagerFactory") EntityManagerFactory emf) {
      JpaItemWriter<Customer> writer = new JpaItemWriter<>();
      writer.setEntityManagerFactory(emf);
      return writer;
   }

   // Example of injecting your custom transaction manager to the step that uses Spring JPA
   @Bean
   public Step flatFileToJpaChunkStep (FlatFileItemReader<Customer> customerItemReader, CustomerItemProcessor processor,
                          @Qualifier("customerJpaItemWriter") JpaItemWriter<Customer> writer, JobRepository jobRepository,
                          @Qualifier("businessDataTransactionManager") PlatformTransactionManager transactionManager) {
      var step = new CustomerChunkStep();
      return step.chunkStep(customerItemReader, processor, writer, jobRepository, transactionManager);
   }

}
```

#### Trace ID propagation

This feature is implemented through the `@Bean` class `BatchTaskTraceListener` and it is executed before Sleuth to check for the existing trace ID. The idea of that is to propagate the trace id of the job caller.

Once the trace ID is added to the tracer, this property is displayed by the current trace. The logic is the following:

1. If there's no previous traceid, sleuth will generate a new one.

2. If a traceid already exists, it is added to the TraceContext by the `BatchTaskTraceListener`.

The trace ID is received from the environment variable as a string and then it evaluates the length of the value only with two possible variants: 16 or 32 bytes. Therefore, the process is prepared to support both formats.

### Sftp utility

In order to configure the SFTP utility, the following configuration must be added into the application.yml:

    darwin:
      batch:
        sftp:
          enabled: true
          sftp-connection-info:
            sftpUser: foouser
            sftpPaswd: foopswd
            sftpDomain: foodomain
            sftpPort: 22
            allowUnknownKeys: true

Each of these properties correspond to the following description and values.

| Property                                                  | Description                                                                          | Required       | Value   | Environment |
|-----------------------------------------------------------|--------------------------------------------------------------------------------------|----------------|---------|-------------|
| *darwin.batch.sftp.enabled*                               | Indicates whether the SFTP Utility must be loaded. Default: False                    | No             | Boolean | Any         |
| *darwin.batch.sftp.sftp-connection-info.sftpUser*         | Indicates the user which will authenticate against the SFTP Server we configure.     | Yes if enabled | String  | Any         |
| *darwin.batch.sftp.sftp-connection-info.sftpPaswd*        | Indicates the password used for authenticating against the SFTP Server we configure. | Yes if enabled | String  | Any         |
| *darwin.batch.sftp.sftp-connection-info.sftpDomain*       | Indicates the URL of the SFTP server.                                                | Yes if enabled | String  | Any         |
| *darwin.batch.sftp.sftp-connection-info.sftpPort*         | Indicates the port of the SFTP Server.                                               | Yes if enabled | Int     | Any         |
| *darwin.batch.sftp.sftp-connection-info.allowUnknownKeys* | Indicates whether unknown SFTP server keys should be trusted.                        | Yes if enabled | Boolean | Any         |

This will be the properties that'll fulfill the SftpConnectionInfo properties for further configuration of the SftpRemoteTemplate, which will be the key piece to call and manage the SFTP Server.

### Multipod support

In order to configure the Multipod utility, the following configuration must be added into the application.yml:

    darwin:
      batch:
        multipod:
          enabled: true
          multipod-info:
            dockerResource: foodockerimage

Each of these properties correspond to the following description and values.

| Property                                                            | Description                                                                                                                                                                                                                                                                                              | Required | Value   | Environment |
|---------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------|---------|-------------|
| *darwin.batch.multipod.enabled*                                     | Indicates whether the Multipod Utility must be loaded. Default: False                                                                                                                                                                                                                                    | Yes      | Boolean | Any         |
| *darwin.batch.multipod.multipod-info.dockerResource*                | Indicates the docker image of the application that has to be launched.                                                                                                                                                                                                                                   | Yes      | String  | Any         |
| *darwin.batch.multipod.multipod-info.workerKrbConfigMap*            | Name of the Openshift configMap that contains Kerberos configuration used for Kafka logging for workers. The default value is cm-[projectName]-krb, with projectName being the middle part of the Openshift namespace. For example if the namespace is sanes-dwbtch-dev the projectName would be dwbtch  | No       | String  | Any         |
| *darwin.batch.multipod.multipod-info.workerKrbKeytab*               | Name of the Openshift secret that contains the Kerberos keytab used for Kafka logging for workers. The default value is secret-[projectName]-keytab, with projectName being the middle part of the Openshift namespace. For example if the namespace is sanes-dwbtch-dev the projectName would be dwbtch | No       | String  | Any         |
| *darwin.batch.multipod.multipod-info.secretWithJaasConfigForWorker* | Name of the Openshift secret that contains JAAS configuration used for Kafka logging for workers. The default value is the task name of the Darwin Batch job.                                                                                                                                            | No       | String  | Any         |
| *darwin.batch.multipod.multipod-info.jaasConfigDataKeyForWorker*    | Name of the data key used to reference the JAAS configuration in the secret file. The default value is `jaas.config`                                                                                                                                                                                     | No       | String  | Any         |

This will be the properties that'll fulfill the MultipodInfo properties, which will create the necessary beans for the multipod management.

!!! WARNING

    Make sure that you create the necessary resources for Kerberos in Openshift and provide the correct name and data key for those resources in your application.yaml as explained in the table above, otherwise, the multipod workers will fail.

#### How it works

This partitioning method works as follows:

1. Job launches normally, executing the job flow as the developer specified (usually in sequential mode, one after the other).

2. There will be a moment in the job flow that the step we want to partition (the one we annotated with @ParallelStep) is going to execute.

3. The master will now deploy as many partitions as we specified in the annotation. One pod per partition we want. (We will have to consider the quota available for these pods).

4. Once deployed, the pods will execute the Read-Process-Write of the step specified. This pods will not communicate with the master pod to know where to begin or where to end, they will have the data already split in equal loads.

5. Once all pods finish, the master, via Spring Batch Database, will know that the steps ended, resuming the execution of the job flow from where it was.

For a better example, imagine we have a job with 3 steps, and the second one is a partitioned step with 2 workers.

In such case:

- The master pod will execute step 1.

- Deploy the 2 workers for step 2.

- And once they finish, will resume the execution with the step 3.

This method deploys independent workers that don't need the master in order to split, process or write the data. This is important, since the deployed pods will need access to both reading and writing data.

#### Customizing the number of workers

By default, the number of worker pods is 2. If you want to customize the number of worker for all steps, you will have to provide the following environment variable in your application configmap:

      enviromentvariables: >
       ...

       scdf.variables.env.darwin.batch.multipod.maxWorkers=3

       ...

If present, the default value will be overridden and all the steps will have the number of worker you provided.

Furthermore, if you want to customize the number of workers for a specific step, you will have to provide the following environment variable in your application configmap:

      enviromentvariables: >
       ...

       scdf.variables.env.darwin.batch.multipod.maxWorkers.stepName=4

       ...

This will override the default value for the step with `stepName`.
Steps that don't have a specific `maxWorkers` value for them will either be using `scdf.variables.env.darwin.batch.multipod.maxWorkers` if present or the default value.

#### Use case

This use case is very useful for when you have a great amount of information that you have to process in a very specific and restrictive window of time, with not a great processing load. This is due to the possibility of idle time in the deployed
pods, while some finished, the others are still processing.

For the cpu-intensive batch processing, the remote chunking is a better approach, since the deployed pods are only processing data, not managing which part of the data are reading, just processing. This method is not yet supported by the
architecture.

!!! note

    This multipod step case **should not be the default solution**. The default solution should be all steps executed sequentially with no parallelism. This parallelization should be used only in very specific cases, where the
    window of time is very narrow and the data is very large, and every other performer enhancer has been implemented (better queries, better complexity in the processing, etc).

#### Partitioning the data

In order to split the data correctly, the idea is to distribute the load as equally as possible throughout all the deployed pods. It's important that the query used for partitioning the data is idempotent, meaning that every time we look for the
data, the results are the same. This assures a correct split of the data.

If this requirement is not met, it could affect the output of the processing, or even the relaunch possibility.

#### Customizing the CPU and Memory of the worker pods

By default, the worker pods are deployed with 1 core and 2 Gi of memory.

In order to customize such values if necessary, you will have to provide the following environment variables in your application configmap:

      enviromentvariables: >
       ...

       scdf.variables.env.darwin.batch.multipod.cpu=1

       scdf.variables.env.darwin.batch.multipod.memory=1Gi

       ...

If present, these values will override the default ones.

!!! warning

    The max CPU value is 1. Assigning more CPU will result in an error that will not deploy any worker and fail the job.

Furthermore, please keep in mind that the default heap size of the worker pod is 50% of the total memory. This amount is set by adding
`-XX:MaxRAMPercentage=50.0 -XX:InitialRAMPercentage=50.0` to the `JAVA_OPTS_EXT` environment variable. If you want to change this value, you can do so by adding the following environment variable to your application configmap:

```yaml
enviromentvariables: >
 ...

 scdf.variables.JAVA_OPTS_EXT=-XX:MaxRAMPercentage=25.0 -XX:InitialRAMPercentage=25.0

 ...
```

Note that the change will also be applied to the master pod. The variable `scdf.variables.JAVA_OPTS_EXT` is for both master and worker pods.

## Native compilation support

This module is not compatible with the native compilation.

## Use cases

### Include in batch microservices

The clear use case of this module is for those application batch services in which we want to include the Darwin Framework.

Once included, it'll work with almost no additional configuration needed, just the pom dependency and the yml configuration showed above.

### Create a new Link in the Chain

Another case of use would be the necessity of adding a new link to the chain.

In order to create a new link for the chain, we will create a new class that will implement the interface **ChainProcessor**

    public class NewChainProcessor implements ChainProcessor, Ordered {

        private int default_order;

        @Override
        public void doFilterInternal(DarwinContext darwinContext, ChainExecutor chainExecutor) throws Exception {

            ...

        }

        @Override
        public int getOrder() {
            return default_order;
        }
    }

Once we have implemented that, we can assign a new order for our NewChainProcessor thanks to the **getOrder()** method that we will need to implement.

Finally, in order to make the new link available, we will have to expose the bean in a @Configuration class.

### Change your default Customer database for another

In order to change your default H2 database that comes with the sample for the Customer data, you will have to follow the next steps:

1. Add a new dependency for the selected database that you want in the pom.xml.

2. Change the connect data for your new database, replacing the values in the ApplicationAutoConfig.java class. The values to replace are the following:

<!-- -->

    /**
     * Bean that will provide the info for the business database.
     *
     * @return DataSource the configured Datasource for its access.
     * @throws SQLException sqlException for database errors.
     */
    @Bean
    public DataSource H2DataSource() throws SQLException {
        final DriverManagerDataSource dataSource = new DriverManagerDataSource();
        dataSource.setDriverClassName("org.h2.Driver");
        dataSource.setUrl("jdbc:h2:mem:mydb;DB_CLOSE_DELAY=-1;DATABASE_TO_UPPER=false");
        dataSource.setUsername("sa");
        dataSource.setPassword("sa");
        return dataSource;
    }

Here, we can change the Customer data datasource, instead of having a H2 database, we could change it for a PostgreSQL or a MSSQL by changing the values in the setters.

### Change your default Batch and Task database for another

In order to change the default Batch and Task database (due to the need of a different database connector) that is provided by the architecture, you will have to follow the next steps:

1. Add a new dependency for the selected database that you want in the pom.xml.

2. Change the connect data for your new database. To do so, you will need to create a DataSource bean with the Qualifier "DarwinBatchDatasource".

3. Create the new DataSource with the DataSource class of your choice. For example, PostgreSQL.

<!-- -->

    /**
     * Bean for the Spring Batch Datasource
     * @return DataSource the configured DataSource
     * @throws SQLException sqlException for database errors.
     */
    @Bean
    @Qualifier("DarwinBatchDatasource")
    @ConfigurationProperties("spring.batch.datasource")
    public PGSimpleDataSource dataSource() throws SQLException {
        return DataSourceBuilder.create().type(PGSimpleDataSource.class).build();
    }

By doing this, we will change the kind of Datasource used for the Batch and Task connections, instead of having the HikariDataSoruce that comes by default.

### Change the default order of the Architecture Links

In order to change the default order of the links in the chain, there's a **filter-order** property that allows us to change the order.

To do so, we will have to add the following configuration to our application.yml

    darwin:
      batch:
        darwin-info:
          ...
        logging-context:
          ...
        filter-order:
           coreFilterOrder: n
           logFilterOrder: n+1
           authenticationFilterOrder: n+2

By doing this, we will assign a new order for the existing chain links.

Beware that the correct order is CoreFilter first, then Logging and then Authentication. Take this into account when changing the order of the links.

### MultiThread Execution mode

In order to make use of the Multithread feature that Spring provides when executing steps, we will perform the next steps:

1. We will inject the Executor bean that's declared in the core package of Darwin. In order for that bean to be injected, it's important to check the `darwin.core.async.enabled` property, which should be `true`.

2. Once we've checked the property, we will inject the Executor bean.

3. Once injected, we will cast the bean from Executor to TaskExecutor:

        TaskExecutor taskExecutor = (TaskExecutor) executor;

4. And finally, add a new property to the Step declaration with the taskExecutor we've created before:

        //Creates the bean with the following name
        return new StepBuilder("customerCollectorStep", jobRepository)
            // Assigns to this step a chunk of 10 entries
            .<Customer, Customer>chunk(collectorChunk, transactionManager)
            // Assigns the reader for the entries
            .reader(customerItemReader)
            // Assigns the processor for the entries the reader passed.
            .processor(processor)
            // Finally, assigns the writer for the already processed entries.
            .writer(writer)//Finally, assigns the writer for the already processed entries.
            .taskExecutor(taskExecutor)// Add the taskExecutor for the multithread execution
            .throttleLimit(2)// Limit of threads that will be executed. By default it's set to 4.
            .build();

With these steps, the Step will be ready for MultiThread execution. This will take as many chunks as threads are declared in the ThrottleLimit section, (which should be the same or less than the Executor bean declares) and execute them in parallel,
with all the Thread information propagated to each one of the threads.

### SFTP Utility

This utility is the one that allows us to interact with SFTP servers and its files. It is based in the Spring Integration utility that Spring provides, which configures and interact for us with the SFTP Server, and making the transfer of files much
more easier. Underneath, it uses the JSCH library, which is the basic library for such tasks. With this modules and libraries, we will be able to download and send files over SFTP with ease.

In order to make use of the SFTP Utility feature that Spring Integration provides and that we configure, we will perform the next steps:

1. We inject the SftpRemoteFileTemplate class from Spring Integration.

2. Once injected, the class is ready to use. For example, if we would like to download a file from the SFTP Server, we would use the method like this:

<!-- -->

       SftpRemoteFileTemplate template;

        String downloadWhat;

        String toWhere;

        @Override
        public RepeatStatus execute(StepContribution contribution, ChunkContext chunkContext) throws Exception {

            Session<DirEntry> session = template.getSession(); (1)

            InputStream is = session.readRaw(downloadWhat); (2)

            FileUtils.copyInputStreamToFile(is, new File(toWhere)); (3)

            is.close(); (4)

            session.close();

            return RepeatStatus.FINISHED;
        }

1. Here, we first get the session from the StpRemoteFileTemplate.

2. Then, we use the readRaw to create an InputStream.

3. And finally, with FileUtils, copy the content from the InputStream to the desired file.

4. Lastly, we close all the resources we needed for the download, and finish the step with Finished status.

### SFTP Item Writer and Reader

This utility is the one that allows us to interact with SFTP servers and its files without having to download or upload any file. It is based in the Spring Integration utility that Spring provides, which configures and interact for us with the SFTP
Server. Underneath, it uses the JSCH library, which is the basic library for such tasks. With this modules and libraries, we will be able to write and read remotely over SFTP with ease.

In order to make use of the SFTP Utility feature that Spring Integration provides and that we configure, we will perform the following steps:

1. We will create an ItemReader class that will create the SftpFlatFileItemReader.

2. Inside this class, we will create the SftpFlatFileItemReader as follows:

<!-- -->

    ...
    import com.santander.darwin.batch.SftpFlatFileItemReaderBuilder;
    import com.santander.darwin.batch.SftpFlatFileItemReader;
    ...

    public class CustomerCollectorItemReader {

    public SftpFlatFileItemReader<Customer> reader(String inputFile, SftpRemoteFileTemplate template) {

        SftpFlatFileItemReader<Customer> reader = new SftpFlatFileItemReaderBuilder<Customer>()
            .name("customerItemReader")    (1)
            .delimited()    (2)
            .names(new String[] {"firstName", "lastName", "balance", "profession" })    (3)
            .fieldSetMapper(new BeanWrapperFieldSetMapper<Customer>() {    (4)
                {
                    setTargetType(Customer.class);    (5)
                }
            })
            .setRemoteFile(inputFile)    (6)
            .setTemplate(template)    (7)
            .build();

            return reader;
        }
    }

Everything is just as like the FlatFileItemReader:

1. First, we set a name to the reader that we're creating.

2. We set to the builder that the data will be delimited.

3. With this, we set the names of each column of the file that we're reading that will map later with the name of the parameters of the target class type.

4. Here, we set the FieldSetMapper to read the data of the file and transform it in a Customer object.

5. Here, we set the TargetType of the FieldSetMapper so it can create the object we want.

6. We need to set the remoteFile that we will be reading. Note that the route is the one that the file follows inside the SFTP Server.

7. We need to give the ItemReader a template, so it can obtain the session and can connect with the SFTP Server.

And with this, it is ready to use and assign to a Step.

For the SftpFlatFileItemWriter, we follow the same steps:

1. We will create an ItemWriter class that will create the SftpFlatFileItemWriter.

2. Inside this class, we will create the SftpFlatFileItemWriter as follows:

<!-- -->

    ...
    import com.santander.darwin.batch.SftpFlatFileItemWriterBuilder;
    import com.santander.darwin.batch.SftpFlatFileItemWriter;
    ...

    public class CustomerCollectorItemWriter {

    public SftpFlatFileItemWriter<Customer> writer(String outputFile, SftpRemoteFileTemplate template) {

        SftpFlatFileItemWriter<Customer> writer = new SftpFlatFileItemWriterBuilder<Customer>()
            .name("customerItemWriter")    (1)
            .remoteFile(outputFile)    (2)
            .template(template)    (3)
            .shouldDeleteIfExists(true)    (4)
            .lineAggregator(new DelimitedLineAggregator<Customer>() {    (5)
                {
                    setDelimiter(",");    (6)
                    setFieldExtractor(new BeanWrapperFieldExtractor<Customer>() {    (7)
                        {
                            setNames(new String[] { "firstName", "lastName", "balance", "profession" });    (8)
                        }
                    });
                }
            }).build();

        return writer;
        }
    }

1. First, we set a name to the writer that we're creating.

2. We set the outputFile to write to in the SFTP Server.

3. We need to give the ItemWriter a template, so it can obtain the session and can connect with the SFTP Server.

4. We set the flag of 'shouldDeleteIfExists' so the content that's written is not appended to an existing file. (Note that this will not take effect if we are restarting a stopped job).

5. We set a LineAggregator, that will take the objects that are passed to the writer and transforms them into readable data

6. We set the delimiter between data for the file we are writing to.

7. We set the FieldExtractor so it can be able to extract the data from the object and transform it into text.

8. We set the names of the parameters of the Customer class, so the FieldExtractor can match them.

And finally, we build and return it so we can assign it to a Step.

### Multipod Steps

This utility is the one that allows us to parallelize step execution across several pods without having to configure it by hand. It uses the Spring Cloud Deployer to deploy such pods in the cloud. This utility is recommended to be used when we have
expensive cpu batch steps, that relies heavily on the processing part. This way, we can split the processing load in a few steps and accelerate the execution.

It is important that this will affect on the order the chunks are executed. If your steps or the result of your step depends on the order of processing, it may affect your results.

In order to make use of this utility, we will have to configure the application.yml as follows:

    darwin:
      batch:
        multipod:
          enabled: true
          multipod-info:
            dockerResource: foodockerimage

By default, the number of worker is 2. Optionally, we can also customize it. In order to do so, configure the following environment variable in your application configmap and the default value will be overridden:

      enviromentvariables: >
       ...

       scdf.variables.env.darwin.batch.multipod.maxWorkers.customerViabilityStep=4

       ...

The step name in this case is `customerViabilityStep`, you will have to provide the name of your step after `scdf.variables.env.darwin.batch.multipod.maxWorkers.`

Once we have that, then, in the step we want to parallelize, we will make use of the following annotation:

    package com.santander.myapps.demobatch.config;

    ...
    import org.springframework.batch.core.Step;
    import org.springframework.batch.item.database.JdbcBatchItemWriter;
    import org.springframework.batch.item.database.JdbcPagingItemReader;
    import org.springframework.batch.item.file.FlatFileItemReader;
    import org.springframework.batch.item.file.FlatFileItemWriter;

    import com.santander.darwin.batch.multipod.ParallelStep; (1)
    import com.santander.darwin.batch.multipod.RecordCounter; (2)
    ...

        private class DefaultRecordCounter implements RecordCounter {  (3)
            public int getMaxRecords() {
                { Here we implement
                either the query or the linecounter for the resource we will read }
            }
        }

        @Bean
        public RecordCounter counter () {     (4)
            return new DefaultRecordCounter();
        }


        /**
         * ...
         */
        @Bean
        @ParallelStep(recountCounterBean = "counter", extraCommandLineArgs = { "my.custom.property=true" })  (5)
        public Step customerViabilityStep (JdbcPagingItemReader<Customer> customerViabilityItemReader,
                CustomerViabilityItemProcessor customerViabilityItemProcessor,
                FlatFileItemWriter<Viability> customerViabilityItemWriter,
                StepBuilderFactory stepBuilderFactory) {

            CustomerViabilityStep step = new CustomerViabilityStep();

            return step.chunkStep(customerViabilityItemReader,
                    customerViabilityItemProcessor,
                    customerViabilityItemWriter,
                    stepBuilderFactory,
                    collectorChunk);
        }

1. First, we import the ParallelStep annotation.

2. Then we import the RecordCounter interface, which we will use to implement a custom RecordCounter that returns us the number of registries we will process.

3. Here we can see how we created a DefaultRecordCounter, which contains the query that returns the amount of registries that will be split between the readers of the deployed pods in the parallel step. For example, if we are iterating over a
    database with 10000 of registries, this method will execute the COUNT query for that database, and will return the number of registries so the architecture can split them evenly throughout the pods.

4. After creating the RecordCounter implementation, we create the bean that exposes such method for the architecture to execute it and be able to split the records evenly.

5. Then, we configure given annotation with the following parameters:

    - maxWorkers: the number of pods that will be deployed once the application is uploaded to the cloud. Default: 2

    - extraCommandLineArgs: the extra commandLine arguments we want to pass to the pods that will be deployed. Default: null

When creating the step, in the StepBuilderFactory, the name of the bean we are creating in the ApplicationConfig class will have to be named as the step itself. This means, that when providing a name to the StepBuilderFactory, it has to be the bean
name also, like in this example:

    public class CustomerChunkStep {

        /**
         */
        public Step chunkStep(FlatFileItemReader<Customer> customerItemReader, CustomerItemProcessor processor,
                FlatFileItemWriter<Customer> writer,
                StepBuilderFactory stepBuilderFactory) {

            //Creates the bean with the following name
            return stepBuilderFactory.get("chunkStep")
                    //Assigns to this step a chunk of 10 entries
                    .<Customer, Customer>chunk(10)
                    //Assigns the reader for the entries
                    .reader(customerItemReader)
                    //Assigns the processor for the entries the reader passed.
                    .processor(processor)
                    //Finally, assigns the writer for the already processed entries.
                    .writer(writer)
                    .build();
        }
    }

This concludes the basic configuration for the step. Now, in terms of the readers, we need to obtain the 'startFrom' and 'endIn' parameters that the architecture places inside the stepExecutionContext of the deployed steps.

In order to do so, we will do the following:

```java
    package com.santander.myapps.demobatch.config;

    ...
    import org.springframework.batch.core.Step;
    import org.springframework.batch.item.database.JdbcBatchItemWriter;
    import org.springframework.batch.item.database.JdbcPagingItemReader;
    import org.springframework.batch.item.file.FlatFileItemReader;
    import org.springframework.batch.item.file.FlatFileItemWriter;
    ...

        /**
         * Customer Collector
         *
         * The FlatFileItemReader that will read the data from the csv
         *
         * @param resourceLoader the resource loader that will load the csv
         * @return the FlatFileItemReader bean
         */
        @StepScope   (1)
        @Bean
        public FlatFileItemReader<Customer> customerCollectorItemReader (ResourceLoader resourceLoader,
                @Value("#{stepExecutionContext['startFrom'] ?: 0}") int startFrom,  (2)
                @Value("#{stepExecutionContext['endIn'] ?: 0}") int endIn) {   (3)
            CustomerCollectorItemReader reader = new CustomerCollectorItemReader();
            return reader.reader(resourceLoader, sourceFile, startFrom, endIn);
        }
```

1. Annotate the reader bean with a StepScope annotation, so it can access the stepExecutionContext data.

2. Get the 'startFrom' data, which will tell us how many registers to skip.

3. Get the 'endIn' data, which will tell us the last registry that we will read in terms of positioning.

Once we have this information, we will pass it to the reader builder like this:

```java
    public class CustomerCollectorItemReader {

        /**
         * FlatFileItemReader bean that will read and transform the csv entries into Person Objects.
         * @param endIn
         * @param startFrom
         *
         * @return FlatFileItemReader the FlatFileItemReader to read the csv entries
         */
        public FlatFileItemReader<Customer> reader(ResourceLoader resourceLoader, String sourceFile, int startFrom, int endIn) {

            return new FlatFileItemReaderBuilder<Customer>().name("customerItemReader")
                    .resource(new InputStreamResource(this.getClass().getClassLoader().getResourceAsStream(sourceFile))).delimited()
                    .names(new String[] {"firstName", "lastName", "balance", "profession" })
                    .linesToSkip(startFrom)   (1)
                    .maxItemCount(endIn - startFrom)     (2)
                    .fieldSetMapper(new BeanWrapperFieldSetMapper<Customer>() {
                        {
                            setTargetType(Customer.class);
                        }
                    }).build();
        }
    }
```

In the creation of the actual reader, we will specify how many lines will be skipped (1) and how many will be read before it stops to read registries (2).

This is the specific case for the FlatFileItemReader. For a JdbcPagingItemReader, we will use the same data but added to the search query:

```java
    public JdbcBatchItemWriter<Customer> writerH2(DataSource dataSource) {
        return new JdbcBatchItemWriterBuilder<Customer>().itemSqlParameterSourceProvider(
        new BeanPropertyItemSqlParameterSourceProvider<>() {
            @Override
            public SqlParameterSource createSqlParameterSource(Customer customer) {
                return new BeanPropertySqlParameterSource(customer) {

                    @Override
                    public int getSqlType(String paramName) {
                        if(paramName.equalsIgnoreCase("profession")) {
                            return Types.VARCHAR;
                        }
                        return super.getSqlType(paramName);
                    }
                };
            }
        })
        .sql("INSERT INTO customers (first_name, last_name, balance, profession)" +
            "VALUES (:firstName, :lastName, :balance, :profession)" +
            "ORDER BY balance OFFSET " startFrom +
            "ROWS FETCH NEXT " + (endIn - startFrom) + " ONLY;")
        .dataSource(dataSource) (1)
        .build();
    }
```

As you can see (1), we can play around with these values to determine how many registries will be read in a Jdbc query.

Finally, once we have this configured with the correct application.yml and the correct Steps annotated with the annotation, we can deploy our application, and it will automatically deploy as many pods as we specified, executing in parallel.

The master will execute the steps sequentially until there's an annotated step, in which case, it will recognize it and deploy it as a multipod step.

### Dual Run Configuration Setup

In this section we are going to explain how to use Dual Run library alongside Darwin Batch.

Go to this [GitHub repository](https://github.alm.europe.cloudcenter.corp/sanes-darwin-poc/darwin-samples/tree/develop/spring-batch/spring-batch-dual-run-sample), if you're looking for a sample Darwin Batch project with Dual Run.

#### Add the necessary dependencies for Dual Run

```xml
<!-- For DualRun -->
<dependencies>

   <dependency>
       <groupId>com.gruposantander.enablers.dualrun</groupId>
       <artifactId>mds-dualrun-lib</artifactId>
   </dependency>

   <!-- DB2 -->
   <dependency>
       <groupId>com.ibm.db2.jcc</groupId>
       <artifactId>db2jcc4</artifactId>
       <version>{suitable-version-to-use}</version>
   </dependency>
   <dependency>
       <groupId>com.ibm.db2.jcc</groupId>
       <artifactId>db2jcc_license_cisuz</artifactId>
       <version>{suitable-version-to-use}</version>
   </dependency>
   <dependency>
       <groupId>com.ibm.db2.jcc</groupId>
       <artifactId>db2jcc_license_cu</artifactId>
       <version>{suitable-version-to-use}</version>
   </dependency>

   <!-- For JPA -->
   <dependency>
       <groupId>org.springframework.boot</groupId>
       <artifactId>spring-boot-starter-data-jpa</artifactId>
   </dependency>
</dependencies>
```

For reference, the versions of DB2 dependencies used in our Dual Run sample are:

- db2jcc4: 4.27.25
- db2jcc_license_cisuz: 4.22.29
- db2jcc_license_cu: 4.15.82

#### Configure application.yml

In this section we are going to explain how to implement Dual Run alongside Spring Data JPA in a batch project.

First you need to add the necessary properties in your `application.yml` file:

`app.dual-run.*`: properties for the dual run feature.

```yaml
  dual-run:
    option: ${env.gravity.sql.dual-run.option} # Required
    datasource:
      autoconfiguration:
        enabled: true # Required
      mainframe: # Configuration for the mainframe database
        jdbcUrl: ${env.datasource.url}
        Username: ${env.datasource.user}
        Password: ${env.datasource.pass}
        DriverClassName: ${env.datasource.driver}
        Schema: ${env.jpa.default-schema}
      gravity: # Configuration for the oracle database with gravity
        jdbcUrl: ${env.gravity.sql.oracle.jdbcUrl}
        Username: ${env.gravity.sql.oracle.userName}
        Password: ${env.gravity.sql.oracle.password}
        DriverClassName: ${env.gravity.sql.oracle.driverClassName}
        Schema: ${env.gravity.sql.oracle.schema}
```

`app.configmanager.*`: properties for the gravity administration console.

```yaml
  # Required. Gravity administration console
  configmanager:
    artifactName: ${env.PROJECT_NAME}-${env.console.gravity.environment}_${spring.application.name}
    service:
      url: ${env.console.gravity.uri.config}
      sts:
        url: ${env.console.gravity.sts}
        clientId: ${env.console.gravity.clientId}
        clientSecret: ${env.console.gravity.clientSecret}
```

#### Configure your Application class

Since the version 4.X of the framework, the `@EnableBatchProcessing` annotation was removed in favor of Spring Boot's AutoConfiguration for the Spring Batch projects.

But this creates a conflict when using the Dual Run feature, since Spring Boot mixes up all the beans created in the configuration, making the application impossible to launch.

So, in order to be able to launch an application with the Dual Run feature, we will need to do the following changes to the application:

1. We will add again the `@EnableBatchProcessing` annotation to the `Application.java` as follows:

```java
package com.santander.myapps.demobatch;

import org.springframework.batch.core.configuration.annotation.EnableBatchProcessing;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.WebApplicationType;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.cloud.task.configuration.EnableTask;

import lombok.extern.slf4j.Slf4j;

@SpringBootApplication
@EnableTask
@EnableBatchProcessing(tablePrefix = "${env.spring.batch.tablePrefix:BOOT3_BATCH_}")
/** The Constant log. */
@Slf4j
public class Application {

   ...

}
```

This annotation will ensure that the Spring Batch projects we deploy and execute in Openshift use Darwin Batch Architecture's transaction manager and data source, so the metadata of batch executions will be saved in the correct database.

There is no need to set this `env.spring.batch.tablePrefix` property in any configMap or properties file when executing in the cloud, since the default value is already set in the annotation.

For Local Testing purposes, you can set this variable to `BATCH_` only in the `application-local.properties` file.

#### Set up our configuration class for Dual Run

After adding the dependencies we need to define the beans and annotations that are required for setting up Dual Run and JPA in our configuration class as shown below:

```java
// Mark the class as a configuration class
@Configuration
/* Enable the creation of Spring Data JPA repositories for database access
and specify the entityManagerFactory and transactionManager that will be used.
 */
@EnableJpaRepositories(entityManagerFactoryRef = "db2EntityManager", transactionManagerRef = "businessDataJpaTransactionManager")
public class ApplicationAutoConfig {

    /**
     * The dialect.
     */
    @Value("${spring.jpa.database-platform}")
    private String dialect;

    /**
     * Db2 entity manager.
     *
     * @param dualRunDataSource the Dual Run data source
     * @return the local container entity manager factory bean
     */
    @Bean(name = "db2EntityManager")
    public LocalContainerEntityManagerFactoryBean db2EntityManager(
            @Qualifier("dualRunDataSource") DualrunDataSource dualRunDataSource) {
        // Create EntityManager
        LocalContainerEntityManagerFactoryBean em = new LocalContainerEntityManagerFactoryBean();
        // Setting datasource on entity manager
        em.setDataSource(dualRunDataSource);
        // Find repositories
        em.setPackagesToScan("com.santander");
        // Setting hibernate adapter
        HibernateJpaVendorAdapter vendorAdapter = new HibernateJpaVendorAdapter();
        // Setting JPA Vendor adapter
        em.setJpaVendorAdapter(vendorAdapter);
        HashMap<String, Object> properties = new HashMap<>();
        // Setting Dialect
        properties.put("hibernate.dialect", dialect);
        em.setJpaPropertyMap(properties);
        // Returning entity manager
        return em;
    }

    /**
     * JPA transaction manager for business data.
     *
     * @param db2EntityManager the db2 entity manager
     * @return the JPA transaction manager
     */
    @Bean(name = "businessDataJpaTransactionManager")
    public JpaTransactionManager jpaTransactionManager(@Qualifier("db2EntityManager") LocalContainerEntityManagerFactoryBean db2EntityManager) {
        return new JpaTransactionManager(Objects.requireNonNull(db2EntityManager.getObject()));
    }

  ...
}
```

> IMPORTANT  
> Name ALL your beans with a DESCRIPTIVE NAME instead of a generic one to avoid any potential problems
