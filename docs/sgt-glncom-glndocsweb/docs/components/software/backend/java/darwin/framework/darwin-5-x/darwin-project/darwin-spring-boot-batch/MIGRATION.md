# Darwin-spring-boot-batch Migration guides

## Version 5.0.0

<!tag:500>

- `SftpFlatFileItemWriter` don't extend AbstractItemStreamItemWriter because is deprecate, now implement `ItemStreamWriter`
- `LoggingChainProcessor` simplify constructor from `LoggingService<Void> loggingServiceImpl, int defaultOrder` to `int defaultOrder`.

<!end:500>

## Version 4.0.0-RELEASE

<!tag:400>

- At the moment, the architecture is in line with the recent changes in Spring Boot 3 and Spring Batch 5. However, the Spring Cloud Dataflow tool that launches the job in Openshift does not support yet these changes. If you want to create a Job
    and deploy it, we recommend doing it with the latest Darwin 3 version, and only upgrading for testing purposes.

- The **`@EnabledBatchProcessing`** annotation support is getting removed in favor of Spring Boot's autoconfiguration for Spring Batch. We strongly advise to remove said annotation.

- The classes **`JobFactoryBuilder`** and **`StepFactoryBuilder`** are being substituted by the **`JobBuilder`** and **`StepBuilder`** classes. You will now have to provide also the **`JobRepository`** bean in the method's creation of the
    Job/Step. An example of this should be as follows:

For the configuration class that will create the bean:

    import org.springframework.batch.core.repository.JobRepository;

    public class ApplicationAutoConfig {

        @Bean
        public Job job (//JobBuilderFactory jobBuilderFactory, we remove this class since it's deprecated
                Step customerActivityLogStep,
                Step customerCollectorStep,
                Step customerViabilityStep,
                JobRepository jobRepository/*And we add this new class that we're going to inject for the JobBuilder constructor*/) {
            CustomerJob customerJob = new CustomerJob();
            return customerJob.job(customerActivityLogStep, customerCollectorStep, customerViabilityStep, jobRepository);
        }
    }

For the class that creates the actual job bean:

    import org.springframework.batch.core.repository.JobRepository;
    import org.springframework.batch.core.job.builder.JobBuilder;

    public class CustomerJob {

    public Job job(//JobBuilderFactory jobBuilderFactory, we eliminate this class, since we no longer need it.
        Step customerActivityLogStep,
        Step customerCollectorStep,
        Step customerViabilityStep,
        JobRepository jobRepository /* We add this parameter to use in the JobBuilder constructor */
        ) {
            return new JobBuilder("customerJob", jobRepository)
                    //For each time we launch a job, we increment the ID
                    .incrementer(new RunIdIncrementer())
                    //First step that will be executed
                    .flow(customerCollectorStep)
                    //Second step that will be executed
                    .next(customerActivityLogStep)
                    //Third step that will be executed
                    .next(customerViabilityStep)
                    .end()
                    .build();
        }
    }

<!end:400>
