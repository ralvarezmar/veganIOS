# Change Log

## Version 4.3.1-RELEASE

<!tag:431>

- Fix the format of multipod JWT token.

<!end:431>

## Version 4.3.0-RELEASE

<!tag:430>

- Fix a bug in multipod where parent pod is not passing JWT token to child pods correctly.

<!end:430>

## Version 4.2.0-RELEASE

<!tag:420>

- Changed default Memory of worker pod to 1Gi. Added default Heap Size to worker pod and the possibility to customize the Heap Size of worker pod in multipod mode.
- Amend pom.xml to verify module in native mode.
- Add support for working without spring-integration-sftp, necessary for native image.
- Remove number of worker from ParallelStep annotation and add the possibility of customizing the number of worker pods in configMap.

<!end:420>

## Version 4.1.0-RELEASE

<!tag:410>

- Added the possibility to customize the CPU and Memory with which the developers can launch worker pods in multipod mode.
- Modified the prefix of the architecture's database based on the Darwin version we use.
- Adding new fields in functional patterns and technical patterns.
  These fields refer to the Job and Step ID and are only visible during the execution of a batch.

- Add boot version in functional, activity and technical patterns. It is injected through the MDC.

<!end:410>

## Version 4.0.0-RELEASE

<!tag:400>

- Update to Spring Boot 3.0.0.

- Migrated from JSCH to Apache MINA. This change should be transparent for the developers since nothing of the configuration changes.

- Deleted @EnabledBatchProcessing annotation in favor of Spring Boot autoconfiguration. The support for this annotation will be removed next version.

- Removed Step and Job Builder Factories due to being deprecated. Changed in favor of Step and Job Builder. Changed the infrastructure that inserted the listeners to such Jobs and Steps too.
and

- Now, after we check the Token JWT passed, we delete it from the Security Context,
  so in order to make third party calls that require authentication,
  developers must request a token first to add it to the call.

<!end:400>

## 3.2.0-RELEASE Version

<!tag:320>

- Added the SFTP Auto Configuration for its use in Batch Jobs.

- Added the SFTP Item Writer and Reader, for remote reading and writing in a SFTP Server, without downloading or uploading any file.

- Now `inputTimeStamp` from Batch Activity logs is the initial timeStamp of each "process" (Application, Job or Step) instead of the Application initial time

- Added the Multipod Step utility for executing steps in parallel

<!end:320>

## 3.1.2-RELEASE Version

<!tag:312>

- Added new mechanism for disabling the Authentication in Darwin Batch.

- Added new handling for the Authorization token, in order to erase the Bearer part of the token to be in the same page with all the online architecture.

- Modified the logs at the end of every job and step to give more significant information about the execution of these.

- Changed the Azure DB for an Oracle DB.

- Optimize Logging dependencies. Add darwin logging dependency and exclude **spring-boot-starter-logging** dependency.

<!end:312>

## 3.1.0-RELEASE Version

<!tag:310>

- Added the darwin-spring-boot-batch into the Darwin Framework.

<!end:310>
