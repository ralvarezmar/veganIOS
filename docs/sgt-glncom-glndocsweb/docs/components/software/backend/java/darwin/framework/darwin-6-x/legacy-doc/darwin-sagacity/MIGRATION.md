# Darwin-spring-boot-sagacity Migration guide

## Version 3.0.0-RELEASE

<!tag:300>

This is the first version of the *Darwin Framework* that incorporates the *Sagacity* library, in previous versions it was used directly through a *Sagacity* archetype. Here is a breakdown of the changes needed to use *Sagacity* with version 3.0.0:

### Changes in the `pom.xml` file

* Update parent to 3.0.0-RELEASE

        <parent>
            <groupId>com.santander.darwin</groupId>
            <artifactId>darwin-spring-boot-starter-parent</artifactId>
            <version>3.1.2-RELEASE</version>
        </parent>

* Delete the following dependencies:

        <dependency>
            <groupId>com.santander.saga</groupId>
            <artifactId>sagacity-darwin-starter</artifactId>
            <version>3.2.0</version>
        </dependency>
        <dependency>
            <groupId>com.santander.darwin</groupId>
            <artifactId>technical-validations</artifactId>
            <version>2.1.0</version>
        </dependency>
        <dependency>
            <groupId>es.santander.darwin</groupId>
            <artifactId>darwin-spring-boot-common</artifactId>
        </dependency>
        <dependency>
            <groupId>es.santander.darwin</groupId>
            <artifactId>darwin-spring-boot-core</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-dependencies</artifactId>
            <version>Hoxton.SR9</version>
            <type>pom</type>
        </dependency>
        <dependency>
            <groupId>org.projectlombok</groupId>
            <artifactId>lombok</artifactId>
        </dependency>
        <dependency>
            <groupId>org.apache.commons</groupId>
            <artifactId>commons-dbcp2</artifactId>
        </dependency>

* Update groupId to `com.santander.darwin` of the following dependencies:

        <dependency>
            <groupId>com.santander.darwin</groupId>
            <artifactId>darwin-spring-boot-starter-authentication</artifactId>
        </dependency>
        <dependency>
            <groupId>com.santander.darwin</groupId>
            <artifactId>darwin-spring-boot-starter-logging</artifactId>
        </dependency>

* Add the following dependencies:

        <!-- Servlet WebApp starter	-->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
        <!-- Cache dependency -->
        <dependency>
            <groupId>com.santander.darwin</groupId>
            <artifactId>darwin-spring-boot-starter-cache</artifactId>
        </dependency>
        <!-- Omnichannel dependency -->
        <dependency>
            <groupId>com.santander.darwin</groupId>
            <artifactId>darwin-spring-boot-starter-omnichannel</artifactId>
        </dependency>
        <!-- Sagacity Library -->
        <dependency>
            <groupId>com.santander.darwin</groupId>
            <artifactId>darwin-spring-boot-starter-sagacity</artifactId>
        </dependency>
        <!-- End Sagacity Library -->

### Changes in the microservice controller

We show an example to indicate the necessary changes in the microservice controller to be migrated.

    /**
     * Controller class to expose the transfer saga as a REST operation
     */
    @RestController
    public class MoneyTransferController  { // (1)
      /**
       * Transfer saga definition
       */
      private final ObjectFactory<SagaWorkflow> moneyTransferSagaWorkflow;
      /**
       * Saga service
       */
      private final SagaService sagaService;
      /**
       * Used to map response
       */
      private final SagaResultMapper sagaResultMapper;
      /**
       * Constructor
       *
       * @param sagaService Service to run sagas
       * @param sagaResultMapper Utility to transform common Sagacity's objects
       * @param moneyTransferSagaWorkflow Money Transfer Saga
       */
      public MoneyTransferController(SagaService sagaService, SagaResultMapper sagaResultMapper, // (2)
                                     ObjectFactory<SagaWorkflow> moneyTransferSagaWorkflow) {
        this.sagaService # sagaService;
        this.sagaResultMapper # sagaResultMapper;
        this.moneyTransferSagaWorkflow # moneyTransferSagaWorkflow;
      }
      /**
       * Exposed transfer operation
       *
       * @param request - the HttpServletRequest
       * @param response - the HttpServletResponse
       * @param transferData - the Transfer input
       * @return Transfer output
       */
      @PostMapping(value # "/transfers", consumes # {"application/json"}, produces # {"application/json"})
      public ResponseEntity<SagaExecutionResult> startSetUpAccount(HttpServletRequest request,
          HttpServletResponse response, @RequestBody TransferDataDTO transferData) {
          SagaResult result # sagaService.startSaga(moneyTransferSagaWorkflow.getObject(), // (3)
              MoneyTransferSaga.MoneyTransferInput.builder()
                      .originAccount(transferData.getSourceAccount()).originBank("abbey")
                      .destinationAccount(transferData.getTargetAccount()).destinationBank("santander")
                      .amount(transferData.getAmount()).build());
          return new ResponseEntity<>(sagaResultMapper.map(result), httpStatusCodeFilter(result)); // (4)
      }
      /**
       * Default behavior of previous versions
       * @param sagaResult saga result
       * @return HttpStatus
       */
      private HttpStatus httpStatusCodeFilter(SagaResult sagaResult) { // (4)
        switch (sagaResult.getSagaStatus()) {
          case RUN_COMPLETED:
          case COMPENSATION_COMPLETED:
          case CANCELED:
            return HttpStatus.OK;
          default:
            return HttpStatus.INTERNAL_SERVER_ERROR;
        }
      }
    }

1. It is not necessary that the controller where Saga is executed extends DarwinArchitectureController.
2. It is no longer necessary to inject the *TranslateService* into the controller.
3. To start the Saga, instead of calling the _startSaga_ method of the *controller*, call the _startSaga_ method of *SagaService*
4. The library no longer forces a specific http code depending on the final state of the Saga, if you want to keep the behavior of the previous versions you have to add a method like the one shown.

### Handle errors

It is no longer mandatory to return a *SagaExecutionResult* as a response from the controller and the application is free to decide the format of the response.
If you want to keep the error format that was automatically returned before, you must add the next *@ControllerAdvice* shown below.

WARNING: Our recommendation is to always return a Darwin error, only the following code is displayed to maintain backward compatibility with the previous version of Sagacity

    /**
     * ControllerAdvice class to always return a Saga error instead a Darwin error
     */
    @ControllerAdvice
    public class SagacityControllerAllExceptionHandler extends SagacityControllerExceptionHandler {
        public SagacityControllerAllExceptionHandler(BiFunction<String, DarwinContext, String> darwinErrorsPropertiesAccessor) {
            super(darwinErrorsPropertiesAccessor);
        }
    }

<!end:300>
