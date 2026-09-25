# Darwin-spring-boot-test Migration guides

## Version 6.0.0

<!tag:600>

- `AbstractLoggingServiceConfig` class has been deprecated. If you were using this class, you should use `AutoConfigureDarwinLogging` annotation instead.

<!end:600>

## Version 3.0.0-RELEASE

<!tag:300>

- Refactor the security properties that allow to improve user properties readability:

| Old                                 | New                                      |
|-------------------------------------|------------------------------------------|
| darwin.test.security.consulUserId   | darwin.test.security.user.consultative   |
| darwin.test.security.operUserId     | darwin.test.security.user.operative      |
| darwin.test.security.consulUserPass | darwin.test.security.user.consultivePass |
| darwin.test.security.operUserPass   | darwin.test.security.user.operativePass  |
| darwin.test.security.codConsultUser | darwin.test.security.user.codConsultive  |
| darwin.test.security.codOperUser    | darwin.test.security.user.codOperative   |
| darwin.test.security.contractId     | darwin.test.security.user.contractId     |

<!end:300>
