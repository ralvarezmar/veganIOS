
# Dependency Tree

All dependencies of this project will be documented in this file.

## Log Result

```text
+- org.projectlombok:lombok:jar:1.18.34:compile
\- org.mapstruct:mapstruct:jar:1.4.2.Final:compile
+- org.springframework.boot:spring-boot-starter-web:jar:3.4.11:compile
|  +- org.springframework.boot:spring-boot-starter:jar:3.4.11:compile
|  |  +- org.springframework.boot:spring-boot:jar:3.4.11:compile
|  |  +- org.springframework.boot:spring-boot-autoconfigure:jar:3.4.11:compile
|  |  +- org.springframework.boot:spring-boot-starter-logging:jar:3.4.11:compile
|  |  |  +- ch.qos.logback:logback-classic:jar:1.5.20:compile
|  |  |  |  \- ch.qos.logback:logback-core:jar:1.5.20:compile
|  |  |  +- org.apache.logging.log4j:log4j-to-slf4j:jar:2.24.3:compile
|  |  |  |  \- org.apache.logging.log4j:log4j-api:jar:2.24.3:compile
|  |  |  \- org.slf4j:jul-to-slf4j:jar:2.0.17:compile
|  |  +- jakarta.annotation:jakarta.annotation-api:jar:2.1.1:compile
|  |  \- org.yaml:snakeyaml:jar:2.3:compile
|  +- org.springframework.boot:spring-boot-starter-json:jar:3.4.11:compile
|  |  +- com.fasterxml.jackson.core:jackson-databind:jar:2.18.4:compile
|  |  |  +- com.fasterxml.jackson.core:jackson-annotations:jar:2.18.4:compile
|  |  |  \- com.fasterxml.jackson.core:jackson-core:jar:2.18.4.1:compile
|  |  +- com.fasterxml.jackson.datatype:jackson-datatype-jdk8:jar:2.18.4:compile
|  |  +- com.fasterxml.jackson.datatype:jackson-datatype-jsr310:jar:2.18.4:compile
|  |  \- com.fasterxml.jackson.module:jackson-module-parameter-names:jar:2.18.4:compile
|  +- org.springframework.boot:spring-boot-starter-tomcat:jar:3.4.11:compile
|  |  +- org.apache.tomcat.embed:tomcat-embed-core:jar:10.1.48:compile
|  |  +- org.apache.tomcat.embed:tomcat-embed-el:jar:10.1.48:compile
|  |  \- org.apache.tomcat.embed:tomcat-embed-websocket:jar:10.1.48:compile
|  +- org.springframework:spring-web:jar:6.2.12:compile
|  |  +- org.springframework:spring-beans:jar:6.2.12:compile
|  |  \- io.micrometer:micrometer-observation:jar:1.14.12:compile
|  |     \- io.micrometer:micrometer-commons:jar:1.14.12:compile
|  \- org.springframework:spring-webmvc:jar:6.2.12:compile
|     +- org.springframework:spring-aop:jar:6.2.12:compile
|     +- org.springframework:spring-context:jar:6.2.12:compile
|     \- org.springframework:spring-expression:jar:6.2.12:compile
+- org.apache.commons:commons-lang3:jar:3.18.0:compile
+- org.projectlombok:lombok:jar:1.18.42:compile
+- org.junit.jupiter:junit-jupiter-api:jar:5.11.4:test
|  +- org.opentest4j:opentest4j:jar:1.3.0:test
|  +- org.junit.platform:junit-platform-commons:jar:1.11.4:test
|  \- org.apiguardian:apiguardian-api:jar:1.1.2:test
+- org.junit.jupiter:junit-jupiter-engine:jar:5.11.4:test
|  \- org.junit.platform:junit-platform-engine:jar:1.11.4:test
+- org.mockito:mockito-junit-jupiter:jar:5.14.2:test
|  \- org.mockito:mockito-core:jar:5.14.2:test
|     +- net.bytebuddy:byte-buddy:jar:1.15.11:test
|     +- net.bytebuddy:byte-buddy-agent:jar:1.15.11:test
|     \- org.objenesis:objenesis:jar:3.3:test
+- org.springframework.boot:spring-boot-starter-test:jar:3.4.11:test
|  +- org.springframework.boot:spring-boot-test:jar:3.4.11:test
|  +- org.springframework.boot:spring-boot-test-autoconfigure:jar:3.4.11:test
|  +- com.jayway.jsonpath:json-path:jar:2.9.0:test
|  |  \- org.slf4j:slf4j-api:jar:2.0.17:compile
|  +- jakarta.xml.bind:jakarta.xml.bind-api:jar:4.0.4:test
|  |  \- jakarta.activation:jakarta.activation-api:jar:2.1.4:test
|  +- net.minidev:json-smart:jar:2.5.2:test
|  |  \- net.minidev:accessors-smart:jar:2.5.2:test
|  |     \- org.ow2.asm:asm:jar:9.7.1:test
|  +- org.assertj:assertj-core:jar:3.26.3:test
|  +- org.awaitility:awaitility:jar:4.2.2:test
|  +- org.hamcrest:hamcrest:jar:2.2:test
|  +- org.junit.jupiter:junit-jupiter:jar:5.11.4:test
|  |  \- org.junit.jupiter:junit-jupiter-params:jar:5.11.4:test
|  +- org.skyscreamer:jsonassert:jar:1.5.3:test
|  |  \- com.vaadin.external.google:android-json:jar:0.0.20131108.vaadin1:test
|  +- org.springframework:spring-core:jar:6.2.12:compile
|  |  \- org.springframework:spring-jcl:jar:6.2.12:compile
|  +- org.springframework:spring-test:jar:6.2.12:test
|  \- org.xmlunit:xmlunit-core:jar:2.10.4:test
\- org.mapstruct:mapstruct:jar:1.4.2.Final:compile
+- jakarta.servlet:jakarta.servlet-api:jar:6.0.0:compile
+- org.springframework:spring-web:jar:6.2.12:compile
|  +- org.springframework:spring-beans:jar:6.2.12:compile
|  +- org.springframework:spring-core:jar:6.2.12:compile
|  |  \- org.springframework:spring-jcl:jar:6.2.12:compile
|  \- io.micrometer:micrometer-observation:jar:1.14.12:compile
|     \- io.micrometer:micrometer-commons:jar:1.14.12:compile
+- org.springframework:spring-webmvc:jar:6.2.12:compile
|  +- org.springframework:spring-aop:jar:6.2.12:compile
|  +- org.springframework:spring-context:jar:6.2.12:compile
|  \- org.springframework:spring-expression:jar:6.2.12:compile
+- org.springframework.cloud:spring-cloud-starter-openfeign:jar:4.2.2:compile
|  +- org.springframework.cloud:spring-cloud-starter:jar:4.2.2:compile
|  |  +- org.springframework.cloud:spring-cloud-context:jar:4.2.2:compile
|  |  \- org.bouncycastle:bcprov-jdk18on:jar:1.78.1:compile
|  +- org.springframework.cloud:spring-cloud-openfeign-core:jar:4.2.2:compile
|  |  +- org.springframework.boot:spring-boot-autoconfigure:jar:3.4.11:compile
|  |  \- io.github.openfeign:feign-form-spring:jar:13.5:compile
|  |     +- io.github.openfeign:feign-form:jar:13.5:compile
|  |     \- commons-fileupload:commons-fileupload:jar:1.6.0:compile
|  +- org.springframework.cloud:spring-cloud-commons:jar:4.2.2:compile
|  |  \- org.springframework.security:spring-security-crypto:jar:6.4.12:compile
|  +- io.github.openfeign:feign-core:jar:13.5:compile
|  \- io.github.openfeign:feign-slf4j:jar:13.5:compile
+- commons-io:commons-io:jar:2.16.1:compile
+- org.springdoc:springdoc-openapi-starter-webmvc-ui:jar:2.8.6:compile
|  +- org.springdoc:springdoc-openapi-starter-webmvc-api:jar:2.8.6:compile
|  |  \- org.springdoc:springdoc-openapi-starter-common:jar:2.8.6:compile
|  |     \- io.swagger.core.v3:swagger-core-jakarta:jar:2.2.29:compile
|  |        +- org.apache.commons:commons-lang3:jar:3.18.0:compile
|  |        +- io.swagger.core.v3:swagger-annotations-jakarta:jar:2.2.29:compile
|  |        +- io.swagger.core.v3:swagger-models-jakarta:jar:2.2.29:compile
|  |        +- jakarta.xml.bind:jakarta.xml.bind-api:jar:4.0.4:compile
|  |        |  \- jakarta.activation:jakarta.activation-api:jar:2.1.4:compile
|  |        +- jakarta.validation:jakarta.validation-api:jar:3.0.2:compile
|  |        \- com.fasterxml.jackson.dataformat:jackson-dataformat-yaml:jar:2.18.4:compile
|  +- org.webjars:swagger-ui:jar:5.20.1:compile
|  \- org.webjars:webjars-locator-lite:jar:1.0.1:compile
|     \- org.jspecify:jspecify:jar:1.0.0:compile
+- org.springframework.boot:spring-boot-starter-actuator:jar:3.4.11:compile
|  +- org.springframework.boot:spring-boot-starter:jar:3.4.11:compile
|  |  +- org.springframework.boot:spring-boot:jar:3.4.11:compile
|  |  +- org.springframework.boot:spring-boot-starter-logging:jar:3.4.11:compile
|  |  |  +- ch.qos.logback:logback-classic:jar:1.5.20:compile
|  |  |  |  \- ch.qos.logback:logback-core:jar:1.5.20:compile
|  |  |  +- org.apache.logging.log4j:log4j-to-slf4j:jar:2.24.3:compile
|  |  |  |  \- org.apache.logging.log4j:log4j-api:jar:2.24.3:compile
|  |  |  \- org.slf4j:jul-to-slf4j:jar:2.0.17:compile
|  |  +- jakarta.annotation:jakarta.annotation-api:jar:2.1.1:compile
|  |  \- org.yaml:snakeyaml:jar:2.3:compile
|  +- org.springframework.boot:spring-boot-actuator-autoconfigure:jar:3.4.11:compile
|  |  +- org.springframework.boot:spring-boot-actuator:jar:3.4.11:compile
|  |  +- com.fasterxml.jackson.core:jackson-databind:jar:2.18.4:compile
|  |  |  +- com.fasterxml.jackson.core:jackson-annotations:jar:2.18.4:compile
|  |  |  \- com.fasterxml.jackson.core:jackson-core:jar:2.18.4.1:compile
|  |  \- com.fasterxml.jackson.datatype:jackson-datatype-jsr310:jar:2.18.4:compile
|  \- io.micrometer:micrometer-jakarta9:jar:1.14.12:compile
|     \- io.micrometer:micrometer-core:jar:1.14.12:compile
|        +- org.hdrhistogram:HdrHistogram:jar:2.2.2:runtime
|        \- org.latencyutils:LatencyUtils:jar:2.0.3:runtime
+- org.apache.maven:maven-model:jar:3.9.4:compile
|  \- org.codehaus.plexus:plexus-utils:jar:3.5.1:compile
+- io.github.resilience4j:resilience4j-spring-boot2:jar:2.2.0:compile
|  +- io.github.resilience4j:resilience4j-spring:jar:2.2.0:compile
|  |  +- io.github.resilience4j:resilience4j-annotations:jar:2.2.0:compile
|  |  +- io.github.resilience4j:resilience4j-consumer:jar:2.2.0:compile
|  |  |  +- io.github.resilience4j:resilience4j-core:jar:2.2.0:compile
|  |  |  \- io.github.resilience4j:resilience4j-circularbuffer:jar:2.2.0:runtime
|  |  \- io.github.resilience4j:resilience4j-framework-common:jar:2.2.0:compile
|  +- org.slf4j:slf4j-api:jar:2.0.17:compile
|  \- io.github.resilience4j:resilience4j-micrometer:jar:2.2.0:compile
|     +- io.github.resilience4j:resilience4j-bulkhead:jar:2.2.0:compile
|     +- io.github.resilience4j:resilience4j-circuitbreaker:jar:2.2.0:compile
|     +- io.github.resilience4j:resilience4j-retry:jar:2.2.0:compile
|     +- io.github.resilience4j:resilience4j-ratelimiter:jar:2.2.0:compile
|     \- io.github.resilience4j:resilience4j-timelimiter:jar:2.2.0:compile
+- org.springframework.boot:spring-boot-starter-aop:jar:3.4.11:compile
|  \- org.aspectj:aspectjweaver:jar:1.9.24:compile
+- org.junit.jupiter:junit-jupiter-api:jar:5.11.4:compile
|  +- org.opentest4j:opentest4j:jar:1.3.0:compile
|  +- org.junit.platform:junit-platform-commons:jar:1.11.4:compile
|  \- org.apiguardian:apiguardian-api:jar:1.1.2:compile
+- org.junit.jupiter:junit-jupiter-engine:jar:5.11.4:compile
|  \- org.junit.platform:junit-platform-engine:jar:1.11.4:compile
+- org.mockito:mockito-core:jar:5.14.2:compile
|  +- net.bytebuddy:byte-buddy:jar:1.15.11:compile
|  +- net.bytebuddy:byte-buddy-agent:jar:1.15.11:compile
|  \- org.objenesis:objenesis:jar:3.3:runtime
+- org.mockito:mockito-junit-jupiter:jar:5.14.2:compile
+- org.springframework:spring-test:jar:6.2.12:compile
+- org.projectlombok:lombok:jar:1.18.34:compile
\- org.mapstruct:mapstruct:jar:1.4.2.Final:compile
+- jakarta.servlet:jakarta.servlet-api:jar:6.0.0:compile
+- org.springframework:spring-web:jar:6.2.12:compile
|  +- org.springframework:spring-beans:jar:6.2.12:compile
|  +- org.springframework:spring-core:jar:6.2.12:compile
|  |  \- org.springframework:spring-jcl:jar:6.2.12:compile
|  \- io.micrometer:micrometer-observation:jar:1.14.12:compile
|     \- io.micrometer:micrometer-commons:jar:1.14.12:compile
+- org.junit.jupiter:junit-jupiter-api:jar:5.11.4:compile
|  +- org.opentest4j:opentest4j:jar:1.3.0:compile
|  +- org.junit.platform:junit-platform-commons:jar:1.11.4:compile
|  \- org.apiguardian:apiguardian-api:jar:1.1.2:compile
+- org.junit.jupiter:junit-jupiter-engine:jar:5.11.4:compile
|  \- org.junit.platform:junit-platform-engine:jar:1.11.4:compile
+- org.junit.jupiter:junit-jupiter:jar:5.11.4:compile
|  \- org.junit.jupiter:junit-jupiter-params:jar:5.11.4:compile
+- org.junit.vintage:junit-vintage-engine:jar:5.11.4:compile
|  \- junit:junit:jar:4.13.2:compile
+- net.bytebuddy:byte-buddy:jar:1.15.11:compile
+- net.bytebuddy:byte-buddy-agent:jar:1.15.11:compile
+- org.mockito:mockito-core:jar:5.14.2:compile
|  \- org.objenesis:objenesis:jar:3.3:runtime
+- org.mockito:mockito-junit-jupiter:jar:5.14.2:compile
+- org.hamcrest:hamcrest-library:jar:2.2:compile
|  \- org.hamcrest:hamcrest-core:jar:2.2:compile
+- com.tngtech.archunit:archunit-junit5-api:jar:1.3.0:compile
|  \- com.tngtech.archunit:archunit:jar:1.3.0:compile
|     \- org.slf4j:slf4j-api:jar:2.0.17:compile
+- com.tngtech.archunit:archunit-junit5-engine:jar:1.3.0:compile
|  \- com.tngtech.archunit:archunit-junit5-engine-api:jar:1.3.0:compile
+- org.springframework.boot:spring-boot-starter-test:jar:3.4.11:compile
|  +- org.springframework.boot:spring-boot-starter:jar:3.4.11:compile
|  |  +- org.springframework.boot:spring-boot:jar:3.4.11:compile
|  |  |  \- org.springframework:spring-context:jar:6.2.12:compile
|  |  |     +- org.springframework:spring-aop:jar:6.2.12:compile
|  |  |     \- org.springframework:spring-expression:jar:6.2.12:compile
|  |  +- org.springframework.boot:spring-boot-autoconfigure:jar:3.4.11:compile
|  |  +- org.springframework.boot:spring-boot-starter-logging:jar:3.4.11:compile
|  |  |  +- ch.qos.logback:logback-classic:jar:1.5.20:compile
|  |  |  |  \- ch.qos.logback:logback-core:jar:1.5.20:compile
|  |  |  +- org.apache.logging.log4j:log4j-to-slf4j:jar:2.24.3:compile
|  |  |  |  \- org.apache.logging.log4j:log4j-api:jar:2.24.3:compile
|  |  |  \- org.slf4j:jul-to-slf4j:jar:2.0.17:compile
|  |  +- jakarta.annotation:jakarta.annotation-api:jar:2.1.1:compile
|  |  \- org.yaml:snakeyaml:jar:2.3:compile
|  +- org.springframework.boot:spring-boot-test:jar:3.4.11:compile
|  +- org.springframework.boot:spring-boot-test-autoconfigure:jar:3.4.11:compile
|  +- com.jayway.jsonpath:json-path:jar:2.9.0:compile
|  +- jakarta.xml.bind:jakarta.xml.bind-api:jar:4.0.4:compile
|  |  \- jakarta.activation:jakarta.activation-api:jar:2.1.4:compile
|  +- net.minidev:json-smart:jar:2.5.2:compile
|  |  \- net.minidev:accessors-smart:jar:2.5.2:compile
|  |     \- org.ow2.asm:asm:jar:9.7.1:compile
|  +- org.awaitility:awaitility:jar:4.2.2:compile
|  +- org.hamcrest:hamcrest:jar:2.2:compile
|  +- org.skyscreamer:jsonassert:jar:1.5.3:compile
|  |  \- com.vaadin.external.google:android-json:jar:0.0.20131108.vaadin1:compile
|  \- org.xmlunit:xmlunit-core:jar:2.10.4:compile
+- org.springframework:spring-test:jar:6.2.12:compile
+- io.cucumber:cucumber-java:jar:7.21.0:compile
|  \- io.cucumber:cucumber-core:jar:7.21.0:compile
|     +- io.cucumber:cucumber-gherkin:jar:7.21.0:compile
|     +- io.cucumber:cucumber-gherkin-messages:jar:7.21.0:compile
|     |  \- io.cucumber:gherkin:jar:31.0.0:compile
|     +- io.cucumber:messages:jar:27.2.0:compile
|     +- io.cucumber:testng-xml-formatter:jar:0.3.1:compile
|     |  \- io.cucumber:query:jar:13.6.0:compile
|     +- io.cucumber:tag-expressions:jar:6.1.2:compile
|     +- io.cucumber:cucumber-expressions:jar:18.0.1:compile
|     +- io.cucumber:datatable:jar:7.21.0:compile
|     +- io.cucumber:cucumber-plugin:jar:7.21.0:compile
|     +- io.cucumber:docstring:jar:7.21.0:compile
|     +- io.cucumber:html-formatter:jar:21.9.0:compile
|     +- io.cucumber:junit-xml-formatter:jar:0.7.1:compile
|     \- io.cucumber:ci-environment:jar:10.0.1:compile
+- io.cucumber:cucumber-spring:jar:7.21.0:compile
+- io.cucumber:cucumber-junit:jar:7.21.0:compile
+- commons-io:commons-io:jar:2.16.1:compile
+- org.assertj:assertj-core:jar:3.26.3:test
+- org.projectlombok:lombok:jar:1.18.34:compile
\- org.mapstruct:mapstruct:jar:1.4.2.Final:compile
+- org.hibernate.orm:hibernate-core:jar:6.6.33.Final:compile
|  +- jakarta.persistence:jakarta.persistence-api:jar:3.1.0:compile
|  +- jakarta.transaction:jakarta.transaction-api:jar:2.0.1:compile
|  +- org.jboss.logging:jboss-logging:jar:3.6.1.Final:compile
|  +- org.hibernate.common:hibernate-commons-annotations:jar:7.0.3.Final:runtime
|  +- io.smallrye:jandex:jar:3.2.0:runtime
|  +- com.fasterxml:classmate:jar:1.7.1:compile
|  +- net.bytebuddy:byte-buddy:jar:1.15.11:compile
|  +- jakarta.xml.bind:jakarta.xml.bind-api:jar:4.0.4:runtime
|  |  \- jakarta.activation:jakarta.activation-api:jar:2.1.4:runtime
|  +- org.glassfish.jaxb:jaxb-runtime:jar:4.0.6:runtime
|  |  \- org.glassfish.jaxb:jaxb-core:jar:4.0.6:runtime
|  |     +- org.eclipse.angus:angus-activation:jar:2.0.3:runtime
|  |     +- org.glassfish.jaxb:txw2:jar:4.0.6:runtime
|  |     \- com.sun.istack:istack-commons-runtime:jar:4.1.2:runtime
|  +- jakarta.inject:jakarta.inject-api:jar:2.0.1:runtime
|  \- org.antlr:antlr4-runtime:jar:4.13.0:runtime
+- org.springframework:spring-messaging:jar:6.2.12:compile
|  +- org.springframework:spring-beans:jar:6.2.12:compile
|  \- org.springframework:spring-core:jar:6.2.12:compile
|     \- org.springframework:spring-jcl:jar:6.2.12:compile
+- jakarta.validation:jakarta.validation-api:jar:3.0.2:compile
+- jakarta.annotation:jakarta.annotation-api:jar:2.1.1:compile
+- org.hibernate.validator:hibernate-validator:jar:8.0.3.Final:compile
+- org.hibernate.validator:hibernate-validator-annotation-processor:jar:8.0.3.Final:compile
+- org.springframework.security:spring-security-core:jar:6.4.12:compile
|  +- org.springframework.security:spring-security-crypto:jar:6.4.12:compile
|  +- org.springframework:spring-aop:jar:6.2.12:compile
|  +- org.springframework:spring-context:jar:6.2.12:compile
|  +- org.springframework:spring-expression:jar:6.2.12:compile
|  \- io.micrometer:micrometer-observation:jar:1.14.12:compile
|     \- io.micrometer:micrometer-commons:jar:1.14.12:compile
+- org.springframework:spring-web:jar:6.2.12:compile
+- org.springframework.boot:spring-boot-starter-web:jar:3.4.11:compile
|  +- org.springframework.boot:spring-boot-starter:jar:3.4.11:compile
|  |  +- org.springframework.boot:spring-boot:jar:3.4.11:compile
|  |  +- org.springframework.boot:spring-boot-autoconfigure:jar:3.4.11:compile
|  |  +- org.springframework.boot:spring-boot-starter-logging:jar:3.4.11:compile
|  |  |  +- ch.qos.logback:logback-classic:jar:1.5.20:compile
|  |  |  |  \- ch.qos.logback:logback-core:jar:1.5.20:compile
|  |  |  +- org.apache.logging.log4j:log4j-to-slf4j:jar:2.24.3:compile
|  |  |  |  \- org.apache.logging.log4j:log4j-api:jar:2.24.3:compile
|  |  |  \- org.slf4j:jul-to-slf4j:jar:2.0.17:compile
|  |  \- org.yaml:snakeyaml:jar:2.3:compile
|  +- org.springframework.boot:spring-boot-starter-json:jar:3.4.11:compile
|  |  +- com.fasterxml.jackson.core:jackson-databind:jar:2.18.4:compile
|  |  |  +- com.fasterxml.jackson.core:jackson-annotations:jar:2.18.4:compile
|  |  |  \- com.fasterxml.jackson.core:jackson-core:jar:2.18.4.1:compile
|  |  +- com.fasterxml.jackson.datatype:jackson-datatype-jdk8:jar:2.18.4:compile
|  |  +- com.fasterxml.jackson.datatype:jackson-datatype-jsr310:jar:2.18.4:compile
|  |  \- com.fasterxml.jackson.module:jackson-module-parameter-names:jar:2.18.4:compile
|  +- org.springframework.boot:spring-boot-starter-tomcat:jar:3.4.11:compile
|  |  +- org.apache.tomcat.embed:tomcat-embed-core:jar:10.1.48:compile
|  |  +- org.apache.tomcat.embed:tomcat-embed-el:jar:10.1.48:compile
|  |  \- org.apache.tomcat.embed:tomcat-embed-websocket:jar:10.1.48:compile
|  \- org.springframework:spring-webmvc:jar:6.2.12:compile
+- org.junit.jupiter:junit-jupiter-api:jar:5.11.4:compile
|  +- org.opentest4j:opentest4j:jar:1.3.0:compile
|  +- org.junit.platform:junit-platform-commons:jar:1.11.4:compile
|  \- org.apiguardian:apiguardian-api:jar:1.1.2:compile
+- org.junit.jupiter:junit-jupiter-engine:jar:5.11.4:compile
|  \- org.junit.platform:junit-platform-engine:jar:1.11.4:compile
+- org.mockito:mockito-core:jar:5.14.2:compile
|  +- net.bytebuddy:byte-buddy-agent:jar:1.15.11:compile
|  \- org.objenesis:objenesis:jar:3.3:runtime
+- org.mockito:mockito-junit-jupiter:jar:5.14.2:compile
+- io.github.resilience4j:resilience4j-bulkhead:jar:2.2.0:compile
|  +- io.github.resilience4j:resilience4j-core:jar:2.2.0:compile
|  \- org.slf4j:slf4j-api:jar:2.0.17:compile
+- io.github.resilience4j:resilience4j-circuitbreaker:jar:2.2.0:compile
+- io.github.resilience4j:resilience4j-retry:jar:2.2.0:compile
+- io.github.resilience4j:resilience4j-ratelimiter:jar:2.2.0:compile
+- io.github.resilience4j:resilience4j-timelimiter:jar:2.2.0:compile
+- org.projectlombok:lombok:jar:1.18.34:compile
\- org.mapstruct:mapstruct:jar:1.4.2.Final:compile
+- org.projectlombok:lombok:jar:1.18.34:compile
+- org.junit.jupiter:junit-jupiter:jar:5.9.1:test
|  +- org.junit.jupiter:junit-jupiter-api:jar:5.9.1:test
|  |  +- org.opentest4j:opentest4j:jar:1.2.0:test
|  |  +- org.junit.platform:junit-platform-commons:jar:1.9.1:test
|  |  \- org.apiguardian:apiguardian-api:jar:1.1.2:test
|  +- org.junit.jupiter:junit-jupiter-params:jar:5.9.1:test
|  \- org.junit.jupiter:junit-jupiter-engine:jar:5.9.1:test
|     \- org.junit.platform:junit-platform-engine:jar:1.9.1:test
\- org.mapstruct:mapstruct:jar:1.4.2.Final:compile
+- org.xerial.snappy:snappy-java:jar:1.1.10.7:compile
+- org.apache.kafka:kafka-clients:jar:3.9.1:compile
|  +- com.github.luben:zstd-jni:jar:1.5.6-4:runtime
|  +- org.lz4:lz4-java:jar:1.8.0:runtime
|  \- org.slf4j:slf4j-api:jar:2.0.17:runtime
+- ch.qos.logback:logback-classic:jar:1.2.13:provided
|  \- ch.qos.logback:logback-core:jar:1.5.20:provided
+- org.apache.kafka:kafka_2.13:jar:3.9.1:test
|  +- org.scala-lang:scala-library:jar:2.13.15:test
|  +- org.apache.kafka:kafka-server-common:jar:3.8.1:test
|  |  \- org.pcollections:pcollections:jar:4.0.1:test
|  +- org.apache.kafka:kafka-group-coordinator-api:jar:3.9.1:test
|  +- org.apache.kafka:kafka-group-coordinator:jar:3.9.1:test
|  +- org.apache.kafka:kafka-transaction-coordinator:jar:3.9.1:test
|  +- org.apache.kafka:kafka-metadata:jar:3.8.1:test
|  +- org.apache.kafka:kafka-storage-api:jar:3.8.1:test
|  +- org.apache.kafka:kafka-tools-api:jar:3.9.1:test
|  +- org.apache.kafka:kafka-raft:jar:3.8.1:test
|  +- org.apache.kafka:kafka-storage:jar:3.8.1:test
|  |  \- com.github.ben-manes.caffeine:caffeine:jar:3.1.8:test
|  |     +- org.checkerframework:checker-qual:jar:3.37.0:test
|  |     \- com.google.errorprone:error_prone_annotations:jar:2.21.1:test
|  +- org.apache.kafka:kafka-server:jar:3.8.1:test
|  +- net.sourceforge.argparse4j:argparse4j:jar:0.7.0:test
|  +- commons-validator:commons-validator:jar:1.7:test
|  |  +- commons-beanutils:commons-beanutils:jar:1.9.4:test
|  |  +- commons-digester:commons-digester:jar:2.1:test
|  |  +- commons-logging:commons-logging:jar:1.2:test
|  |  \- commons-collections:commons-collections:jar:3.2.2:test
|  +- com.fasterxml.jackson.core:jackson-databind:jar:2.18.4:test
|  |  +- com.fasterxml.jackson.core:jackson-annotations:jar:2.18.4:test
|  |  \- com.fasterxml.jackson.core:jackson-core:jar:2.18.4.1:test
|  +- com.fasterxml.jackson.module:jackson-module-scala_2.13:jar:2.18.4:test
|  |  \- com.thoughtworks.paranamer:paranamer:jar:2.8:test
|  +- com.fasterxml.jackson.dataformat:jackson-dataformat-csv:jar:2.18.4:test
|  +- com.fasterxml.jackson.datatype:jackson-datatype-jdk8:jar:2.18.4:test
|  +- net.sf.jopt-simple:jopt-simple:jar:5.0.4:test
|  +- org.bitbucket.b_c:jose4j:jar:0.9.4:test
|  +- com.yammer.metrics:metrics-core:jar:2.2.0:test
|  +- org.scala-lang.modules:scala-collection-compat_2.13:jar:2.10.0:test
|  +- org.scala-lang.modules:scala-java8-compat_2.13:jar:1.0.2:test
|  +- org.scala-lang:scala-reflect:jar:2.13.15:test
|  +- com.typesafe.scala-logging:scala-logging_2.13:jar:3.9.5:test
|  +- commons-io:commons-io:jar:2.16.1:test
|  +- io.dropwizard.metrics:metrics-core:jar:4.1.12.1:test
|  \- commons-cli:commons-cli:jar:1.4:test
+- org.junit.jupiter:junit-jupiter-api:jar:5.5.2:test
|  +- org.apiguardian:apiguardian-api:jar:1.1.0:test
|  +- org.opentest4j:opentest4j:jar:1.2.0:test
|  \- org.junit.platform:junit-platform-commons:jar:1.11.4:test
+- org.junit.jupiter:junit-jupiter-engine:jar:5.5.2:test
|  \- org.junit.platform:junit-platform-engine:jar:1.11.4:test
+- org.junit.jupiter:junit-jupiter:jar:5.5.2:test
|  \- org.junit.jupiter:junit-jupiter-params:jar:5.11.4:test
+- org.mockito:mockito-core:jar:3.0.0:test
|  +- net.bytebuddy:byte-buddy:jar:1.15.11:test
|  +- net.bytebuddy:byte-buddy-agent:jar:1.15.11:test
|  \- org.objenesis:objenesis:jar:2.6:test
+- org.mockito:mockito-junit-jupiter:jar:3.0.0:test
+- org.assertj:assertj-core:jar:3.18.1:test
+- org.apache.zookeeper:zookeeper:jar:3.7.2:test
|  +- org.apache.zookeeper:zookeeper-jute:jar:3.7.2:test
|  +- org.apache.yetus:audience-annotations:jar:0.12.0:test
|  +- io.netty:netty-handler:jar:4.1.127.Final:test
|  |  +- io.netty:netty-common:jar:4.1.127.Final:test
|  |  +- io.netty:netty-resolver:jar:4.1.127.Final:test
|  |  +- io.netty:netty-buffer:jar:4.1.127.Final:test
|  |  +- io.netty:netty-transport:jar:4.1.127.Final:test
|  |  +- io.netty:netty-transport-native-unix-common:jar:4.1.127.Final:test
|  |  \- io.netty:netty-codec:jar:4.1.127.Final:test
|  \- io.netty:netty-transport-native-epoll:jar:4.1.127.Final:test
|     \- io.netty:netty-transport-classes-epoll:jar:4.1.127.Final:test
+- org.projectlombok:lombok:jar:1.18.34:compile
\- org.mapstruct:mapstruct:jar:1.4.2.Final:compile
+- com.santander.ars:gln-back-arsenal-logback-kafka-appender:jar:3.18.12-SNAPSHOT:compile
|  +- org.xerial.snappy:snappy-java:jar:1.1.10.7:compile
|  \- org.apache.kafka:kafka-clients:jar:3.9.1:compile
|     +- com.github.luben:zstd-jni:jar:1.5.6-4:runtime
|     \- org.lz4:lz4-java:jar:1.8.0:runtime
+- ch.qos.logback:logback-core:jar:1.5.20:compile
+- ch.qos.logback:logback-classic:jar:1.5.20:compile
+- ch.qos.logback.contrib:logback-json-classic:jar:0.1.5:compile
|  \- ch.qos.logback.contrib:logback-json-core:jar:0.1.5:compile
+- ch.qos.logback.contrib:logback-jackson:jar:0.1.5:compile
+- com.santander.ars:gln-back-arsenal-log-core:jar:3.18.12-SNAPSHOT:compile
+- org.springframework:spring-context:jar:6.0.6:compile
|  +- org.springframework:spring-aop:jar:6.2.12:compile
|  +- org.springframework:spring-beans:jar:6.2.12:compile
|  +- org.springframework:spring-core:jar:6.2.12:compile
|  |  \- org.springframework:spring-jcl:jar:6.2.12:compile
|  \- org.springframework:spring-expression:jar:6.2.12:compile
+- org.projectlombok:lombok:jar:1.18.34:compile
+- org.slf4j:slf4j-api:jar:2.0.6:compile
+- org.junit.jupiter:junit-jupiter:jar:5.9.1:test
|  +- org.junit.jupiter:junit-jupiter-api:jar:5.9.1:test
|  |  +- org.opentest4j:opentest4j:jar:1.2.0:test
|  |  +- org.junit.platform:junit-platform-commons:jar:1.9.1:test
|  |  \- org.apiguardian:apiguardian-api:jar:1.1.2:test
|  +- org.junit.jupiter:junit-jupiter-params:jar:5.9.1:test
|  \- org.junit.jupiter:junit-jupiter-engine:jar:5.9.1:test
|     \- org.junit.platform:junit-platform-engine:jar:1.9.1:test
\- org.mapstruct:mapstruct:jar:1.4.2.Final:compile
+- org.slf4j:slf4j-api:jar:2.0.6:compile
+- ch.qos.logback:logback-classic:jar:1.5.20:compile
|  \- ch.qos.logback:logback-core:jar:1.5.20:compile
+- org.junit.jupiter:junit-jupiter:jar:5.7.1:test
|  +- org.junit.jupiter:junit-jupiter-api:jar:5.11.4:test
|  |  +- org.opentest4j:opentest4j:jar:1.3.0:test
|  |  +- org.junit.platform:junit-platform-commons:jar:1.11.4:test
|  |  \- org.apiguardian:apiguardian-api:jar:1.1.2:test
|  +- org.junit.jupiter:junit-jupiter-params:jar:5.11.4:test
|  \- org.junit.jupiter:junit-jupiter-engine:jar:5.11.4:test
|     \- org.junit.platform:junit-platform-engine:jar:1.11.4:test
+- org.mockito:mockito-core:jar:3.6.0:test
|  +- net.bytebuddy:byte-buddy:jar:1.15.11:test
|  +- net.bytebuddy:byte-buddy-agent:jar:1.15.11:test
|  \- org.objenesis:objenesis:jar:3.1:test
+- org.apache.commons:commons-text:jar:1.10.0:compile
|  \- org.apache.commons:commons-lang3:jar:3.18.0:compile
+- org.projectlombok:lombok:jar:1.18.34:compile
\- org.mapstruct:mapstruct:jar:1.4.2.Final:compile
+- org.slf4j:slf4j-api:jar:2.0.6:compile
+- ch.qos.logback:logback-classic:jar:1.5.20:compile
|  \- ch.qos.logback:logback-core:jar:1.5.20:compile
+- org.junit.jupiter:junit-jupiter:jar:5.7.1:test
|  +- org.junit.jupiter:junit-jupiter-api:jar:5.11.4:test
|  |  +- org.opentest4j:opentest4j:jar:1.3.0:test
|  |  +- org.junit.platform:junit-platform-commons:jar:1.11.4:test
|  |  \- org.apiguardian:apiguardian-api:jar:1.1.2:test
|  +- org.junit.jupiter:junit-jupiter-params:jar:5.11.4:test
|  \- org.junit.jupiter:junit-jupiter-engine:jar:5.11.4:test
|     \- org.junit.platform:junit-platform-engine:jar:1.11.4:test
+- org.mockito:mockito-core:jar:3.6.0:test
|  +- net.bytebuddy:byte-buddy:jar:1.15.11:test
|  +- net.bytebuddy:byte-buddy-agent:jar:1.15.11:test
|  \- org.objenesis:objenesis:jar:3.1:test
+- org.apache.commons:commons-text:jar:1.10.0:compile
|  \- org.apache.commons:commons-lang3:jar:3.18.0:compile
+- org.projectlombok:lombok:jar:1.18.34:compile
\- org.mapstruct:mapstruct:jar:1.4.2.Final:compile
+- com.santander.ars:arsenal-altair-connector-psformat:jar:3.18.12-SNAPSHOT:compile
+- org.slf4j:slf4j-api:jar:2.0.6:compile
+- ch.qos.logback:logback-classic:jar:1.5.20:compile
|  \- ch.qos.logback:logback-core:jar:1.5.20:compile
+- org.junit.jupiter:junit-jupiter:jar:5.7.1:test
|  +- org.junit.jupiter:junit-jupiter-api:jar:5.11.4:test
|  |  +- org.opentest4j:opentest4j:jar:1.3.0:test
|  |  +- org.junit.platform:junit-platform-commons:jar:1.11.4:test
|  |  \- org.apiguardian:apiguardian-api:jar:1.1.2:test
|  +- org.junit.jupiter:junit-jupiter-params:jar:5.11.4:test
|  \- org.junit.jupiter:junit-jupiter-engine:jar:5.11.4:test
|     \- org.junit.platform:junit-platform-engine:jar:1.11.4:test
+- org.mockito:mockito-core:jar:3.6.0:test
|  +- net.bytebuddy:byte-buddy:jar:1.15.11:test
|  +- net.bytebuddy:byte-buddy-agent:jar:1.15.11:test
|  \- org.objenesis:objenesis:jar:3.1:test
+- org.apache.commons:commons-text:jar:1.10.0:compile
|  \- org.apache.commons:commons-lang3:jar:3.18.0:compile
+- org.projectlombok:lombok:jar:1.18.34:compile
\- org.mapstruct:mapstruct:jar:1.4.2.Final:compile
+- com.santander.ars:arsenal-altair-connector-psformat:jar:3.18.12-SNAPSHOT:compile
+- com.santander.ars:arsenal-altair-connector-core:jar:3.18.12-SNAPSHOT:compile
+- com.ibm.mq:com.ibm.mq.allclient:jar:9.4.0.7:provided
|  +- org.bouncycastle:bcprov-jdk18on:jar:1.78.1:provided
|  +- org.bouncycastle:bcpkix-jdk18on:jar:1.78.1:provided
|  +- org.bouncycastle:bcutil-jdk18on:jar:1.78.1:provided
|  +- javax.jms:javax.jms-api:jar:2.0.1:provided
|  \- org.json:json:jar:20231013:provided
+- org.slf4j:slf4j-api:jar:2.0.6:compile
+- ch.qos.logback:logback-classic:jar:1.5.20:compile
|  \- ch.qos.logback:logback-core:jar:1.5.20:compile
+- org.junit.jupiter:junit-jupiter:jar:5.7.1:test
|  +- org.junit.jupiter:junit-jupiter-api:jar:5.11.4:test
|  |  +- org.opentest4j:opentest4j:jar:1.3.0:test
|  |  +- org.junit.platform:junit-platform-commons:jar:1.11.4:test
|  |  \- org.apiguardian:apiguardian-api:jar:1.1.2:test
|  +- org.junit.jupiter:junit-jupiter-params:jar:5.11.4:test
|  \- org.junit.jupiter:junit-jupiter-engine:jar:5.11.4:test
|     \- org.junit.platform:junit-platform-engine:jar:1.11.4:test
+- org.mockito:mockito-core:jar:3.6.0:test
|  +- net.bytebuddy:byte-buddy:jar:1.15.11:test
|  +- net.bytebuddy:byte-buddy-agent:jar:1.15.11:test
|  \- org.objenesis:objenesis:jar:3.1:test
+- org.apache.commons:commons-text:jar:1.10.0:compile
|  \- org.apache.commons:commons-lang3:jar:3.18.0:compile
+- org.projectlombok:lombok:jar:1.18.34:compile
\- org.mapstruct:mapstruct:jar:1.4.2.Final:compile
+- com.ibm.mq:mq-jms-spring-boot-starter:jar:2.3.5:compile
|  +- com.ibm.mq:com.ibm.mq.allclient:jar:9.4.0.7:compile
|  |  +- org.bouncycastle:bcprov-jdk18on:jar:1.78.1:compile
|  |  +- org.bouncycastle:bcpkix-jdk18on:jar:1.78.1:compile
|  |  +- org.bouncycastle:bcutil-jdk18on:jar:1.78.1:compile
|  |  +- javax.jms:javax.jms-api:jar:2.0.1:compile
|  |  \- org.json:json:jar:20231013:compile
|  +- org.springframework:spring-core:jar:6.2.12:compile
|  |  \- org.springframework:spring-jcl:jar:6.2.12:compile
|  +- org.springframework:spring-context:jar:6.2.12:compile
|  |  +- org.springframework:spring-aop:jar:6.2.12:compile
|  |  +- org.springframework:spring-expression:jar:6.2.12:compile
|  |  \- io.micrometer:micrometer-observation:jar:1.14.12:compile
|  |     \- io.micrometer:micrometer-commons:jar:1.14.12:compile
|  +- org.springframework:spring-beans:jar:6.2.12:compile
|  +- org.springframework:spring-jms:jar:6.2.12:compile
|  |  +- org.springframework:spring-messaging:jar:6.2.12:compile
|  |  \- org.springframework:spring-tx:jar:6.2.12:compile
|  +- org.springframework.boot:spring-boot-starter:jar:3.4.11:compile
|  |  +- org.springframework.boot:spring-boot-starter-logging:jar:3.4.11:compile
|  |  |  +- org.apache.logging.log4j:log4j-to-slf4j:jar:2.24.3:compile
|  |  |  |  \- org.apache.logging.log4j:log4j-api:jar:2.24.3:compile
|  |  |  \- org.slf4j:jul-to-slf4j:jar:2.0.17:compile
|  |  \- jakarta.annotation:jakarta.annotation-api:jar:2.1.1:compile
|  +- org.messaginghub:pooled-jms:jar:3.1.7:compile
|  |  +- jakarta.jms:jakarta.jms-api:jar:3.1.0:compile
|  |  \- org.apache.commons:commons-pool2:jar:2.12.1:compile
|  +- org.springframework.boot:spring-boot:jar:3.4.11:compile
|  \- org.springframework.boot:spring-boot-autoconfigure:jar:3.4.11:compile
+- org.junit.jupiter:junit-jupiter-api:jar:5.11.4:test
|  +- org.opentest4j:opentest4j:jar:1.3.0:test
|  +- org.junit.platform:junit-platform-commons:jar:1.11.4:test
|  \- org.apiguardian:apiguardian-api:jar:1.1.2:test
+- org.junit.jupiter:junit-jupiter-engine:jar:5.11.4:test
|  \- org.junit.platform:junit-platform-engine:jar:1.11.4:test
+- org.mockito:mockito-junit-jupiter:jar:5.14.2:test
|  \- org.mockito:mockito-core:jar:5.14.2:test
|     +- net.bytebuddy:byte-buddy:jar:1.15.11:test
|     +- net.bytebuddy:byte-buddy-agent:jar:1.15.11:test
|     \- org.objenesis:objenesis:jar:3.3:test
+- org.springframework.boot:spring-boot-starter-test:jar:3.4.11:test
|  +- org.springframework.boot:spring-boot-test:jar:3.4.11:test
|  +- org.springframework.boot:spring-boot-test-autoconfigure:jar:3.4.11:test
|  +- com.jayway.jsonpath:json-path:jar:2.9.0:test
|  +- jakarta.xml.bind:jakarta.xml.bind-api:jar:4.0.4:test
|  |  \- jakarta.activation:jakarta.activation-api:jar:2.1.4:test
|  +- net.minidev:json-smart:jar:2.5.2:test
|  |  \- net.minidev:accessors-smart:jar:2.5.2:test
|  |     \- org.ow2.asm:asm:jar:9.7.1:test
|  +- org.assertj:assertj-core:jar:3.26.3:test
|  +- org.awaitility:awaitility:jar:4.2.2:test
|  +- org.hamcrest:hamcrest:jar:2.2:test
|  +- org.junit.jupiter:junit-jupiter:jar:5.11.4:test
|  |  \- org.junit.jupiter:junit-jupiter-params:jar:5.11.4:test
|  +- org.skyscreamer:jsonassert:jar:1.5.3:test
|  |  \- com.vaadin.external.google:android-json:jar:0.0.20131108.vaadin1:test
|  +- org.springframework:spring-test:jar:6.2.12:test
|  \- org.xmlunit:xmlunit-core:jar:2.10.4:test
+- com.santander.ars:arsenal-altair-connector-mq:jar:3.18.12-SNAPSHOT:compile
|  +- com.santander.ars:arsenal-altair-connector-psformat:jar:3.18.12-SNAPSHOT:compile
|  +- com.santander.ars:arsenal-altair-connector-core:jar:3.18.12-SNAPSHOT:compile
|  +- org.slf4j:slf4j-api:jar:2.0.17:compile
|  +- ch.qos.logback:logback-classic:jar:1.5.20:compile
|  |  \- ch.qos.logback:logback-core:jar:1.5.20:compile
|  \- org.apache.commons:commons-text:jar:1.10.0:compile
+- com.santander.ars:gln-back-arsenal-backend-core:jar:3.18.12-SNAPSHOT:compile
|  +- org.springframework.boot:spring-boot-starter-web:jar:3.4.11:compile
|  |  +- org.springframework.boot:spring-boot-starter-json:jar:3.4.11:compile
|  |  |  +- com.fasterxml.jackson.datatype:jackson-datatype-jdk8:jar:2.18.4:compile
|  |  |  +- com.fasterxml.jackson.datatype:jackson-datatype-jsr310:jar:2.18.4:compile
|  |  |  \- com.fasterxml.jackson.module:jackson-module-parameter-names:jar:2.18.4:compile
|  |  +- org.springframework.boot:spring-boot-starter-tomcat:jar:3.4.11:compile
|  |  |  +- org.apache.tomcat.embed:tomcat-embed-core:jar:10.1.48:compile
|  |  |  +- org.apache.tomcat.embed:tomcat-embed-el:jar:10.1.48:compile
|  |  |  \- org.apache.tomcat.embed:tomcat-embed-websocket:jar:10.1.48:compile
|  |  +- org.springframework:spring-web:jar:6.2.12:compile
|  |  \- org.springframework:spring-webmvc:jar:6.2.12:compile
|  \- org.apache.commons:commons-lang3:jar:3.18.0:compile
+- org.yaml:snakeyaml:jar:2.3:compile
+- com.fasterxml.jackson.core:jackson-databind:jar:2.18.4:compile
|  +- com.fasterxml.jackson.core:jackson-annotations:jar:2.18.4:compile
|  \- com.fasterxml.jackson.core:jackson-core:jar:2.18.4.1:compile
+- commons-io:commons-io:jar:2.15.1:compile
+- org.projectlombok:lombok:jar:1.18.34:compile
\- org.mapstruct:mapstruct:jar:1.4.2.Final:compile
+- org.springframework.boot:spring-boot-starter-actuator:jar:3.4.11:compile
|  +- org.springframework.boot:spring-boot-starter:jar:3.4.11:compile
|  |  +- org.springframework.boot:spring-boot:jar:3.4.11:compile
|  |  +- org.springframework.boot:spring-boot-autoconfigure:jar:3.4.11:compile
|  |  +- org.springframework.boot:spring-boot-starter-logging:jar:3.4.11:compile
|  |  |  +- org.apache.logging.log4j:log4j-to-slf4j:jar:2.24.3:compile
|  |  |  |  \- org.apache.logging.log4j:log4j-api:jar:2.24.3:compile
|  |  |  \- org.slf4j:jul-to-slf4j:jar:2.0.17:compile
|  |  \- jakarta.annotation:jakarta.annotation-api:jar:2.1.1:compile
|  +- org.springframework.boot:spring-boot-actuator-autoconfigure:jar:3.4.11:compile
|  |  \- org.springframework.boot:spring-boot-actuator:jar:3.4.11:compile
|  +- io.micrometer:micrometer-observation:jar:1.14.0:compile
|  |  \- io.micrometer:micrometer-commons:jar:1.14.0:compile
|  \- io.micrometer:micrometer-jakarta9:jar:1.14.0:compile
|     \- io.micrometer:micrometer-core:jar:1.14.0:compile
|        +- org.hdrhistogram:HdrHistogram:jar:2.2.2:runtime
|        \- org.latencyutils:LatencyUtils:jar:2.0.3:runtime
+- org.springframework.boot:spring-boot-starter-web:jar:3.4.11:compile
|  +- org.springframework.boot:spring-boot-starter-tomcat:jar:3.4.11:compile
|  |  +- org.apache.tomcat.embed:tomcat-embed-core:jar:10.1.48:compile
|  |  +- org.apache.tomcat.embed:tomcat-embed-el:jar:10.1.48:compile
|  |  \- org.apache.tomcat.embed:tomcat-embed-websocket:jar:10.1.48:compile
|  +- org.springframework:spring-web:jar:6.2.12:compile
|  |  \- org.springframework:spring-beans:jar:6.2.12:compile
|  \- org.springframework:spring-webmvc:jar:6.2.12:compile
|     \- org.springframework:spring-expression:jar:6.2.12:compile
+- org.projectlombok:lombok:jar:1.18.42:compile
+- io.micrometer:micrometer-tracing:jar:1.4.0:compile
|  +- io.micrometer:context-propagation:jar:1.1.2:compile
|  \- aopalliance:aopalliance:jar:1.0:compile
+- io.micrometer:micrometer-tracing-bridge-brave:jar:1.4.0:compile
|  +- org.slf4j:slf4j-api:jar:2.0.17:compile
|  +- io.zipkin.brave:brave:jar:6.0.3:compile
|  +- io.zipkin.brave:brave-context-slf4j:jar:6.0.3:compile
|  +- io.zipkin.brave:brave-instrumentation-http:jar:6.0.3:compile
|  +- io.zipkin.aws:brave-propagation-aws:jar:1.2.5:compile
|  \- io.zipkin.contrib.brave-propagation-w3c:brave-propagation-tracecontext:jar:0.2.0:compile
+- org.springframework.boot:spring-boot-starter-test:jar:3.4.11:test
|  +- org.springframework.boot:spring-boot-test:jar:3.4.11:test
|  +- org.springframework.boot:spring-boot-test-autoconfigure:jar:3.4.11:test
|  +- com.jayway.jsonpath:json-path:jar:2.9.0:test
|  +- jakarta.xml.bind:jakarta.xml.bind-api:jar:4.0.4:test
|  |  \- jakarta.activation:jakarta.activation-api:jar:2.1.4:test
|  +- net.minidev:json-smart:jar:2.5.2:test
|  |  \- net.minidev:accessors-smart:jar:2.5.2:test
|  |     \- org.ow2.asm:asm:jar:9.7.1:test
|  +- org.assertj:assertj-core:jar:3.26.3:test
|  |  \- net.bytebuddy:byte-buddy:jar:1.15.11:test
|  +- org.awaitility:awaitility:jar:4.2.2:test
|  +- org.hamcrest:hamcrest:jar:2.2:test
|  +- org.junit.jupiter:junit-jupiter:jar:5.11.4:test
|  |  +- org.junit.jupiter:junit-jupiter-api:jar:5.11.4:test
|  |  |  +- org.opentest4j:opentest4j:jar:1.3.0:test
|  |  |  +- org.junit.platform:junit-platform-commons:jar:1.11.4:test
|  |  |  \- org.apiguardian:apiguardian-api:jar:1.1.2:test
|  |  +- org.junit.jupiter:junit-jupiter-params:jar:5.11.4:test
|  |  \- org.junit.jupiter:junit-jupiter-engine:jar:5.11.4:test
|  |     \- org.junit.platform:junit-platform-engine:jar:1.11.4:test
|  +- org.mockito:mockito-core:jar:5.14.2:test
|  |  +- net.bytebuddy:byte-buddy-agent:jar:1.15.11:test
|  |  \- org.objenesis:objenesis:jar:3.3:test
|  +- org.mockito:mockito-junit-jupiter:jar:5.14.2:test
|  +- org.skyscreamer:jsonassert:jar:1.5.3:test
|  |  \- com.vaadin.external.google:android-json:jar:0.0.20131108.vaadin1:test
|  +- org.springframework:spring-core:jar:6.2.12:compile
|  |  \- org.springframework:spring-jcl:jar:6.2.12:compile
|  +- org.springframework:spring-test:jar:6.2.12:test
|  \- org.xmlunit:xmlunit-core:jar:2.10.4:test
+- org.springframework.boot:spring-boot-starter-json:jar:3.4.11:compile
|  +- com.fasterxml.jackson.core:jackson-databind:jar:2.18.4:compile
|  |  +- com.fasterxml.jackson.core:jackson-annotations:jar:2.18.4:compile
|  |  \- com.fasterxml.jackson.core:jackson-core:jar:2.18.4.1:compile
|  +- com.fasterxml.jackson.datatype:jackson-datatype-jdk8:jar:2.18.4:compile
|  +- com.fasterxml.jackson.datatype:jackson-datatype-jsr310:jar:2.18.4:compile
|  \- com.fasterxml.jackson.module:jackson-module-parameter-names:jar:2.18.4:compile
+- org.springframework.boot:spring-boot-starter-aop:jar:3.4.11:compile
|  \- org.springframework:spring-aop:jar:6.2.12:compile
+- com.santander.ars:gln-back-arsenal-log-core:jar:3.18.12-SNAPSHOT:compile
+- com.santander.ars:gln-back-arsenal-logback-core:jar:3.18.12-SNAPSHOT:compile
|  +- com.santander.ars:gln-back-arsenal-logback-kafka-appender:jar:3.18.12-SNAPSHOT:compile
|  |  +- org.xerial.snappy:snappy-java:jar:1.1.10.7:compile
|  |  \- org.apache.kafka:kafka-clients:jar:3.9.1:compile
|  |     +- com.github.luben:zstd-jni:jar:1.5.6-4:runtime
|  |     \- org.lz4:lz4-java:jar:1.8.0:runtime
|  +- ch.qos.logback:logback-classic:jar:1.5.20:compile
|  +- ch.qos.logback.contrib:logback-json-classic:jar:0.1.5:compile
|  |  \- ch.qos.logback.contrib:logback-json-core:jar:0.1.5:compile
|  +- ch.qos.logback.contrib:logback-jackson:jar:0.1.5:compile
|  \- org.springframework:spring-context:jar:6.2.12:compile
+- ch.qos.logback:logback-core:jar:1.5.20:compile
+- net.logstash.logback:logstash-logback-encoder:jar:7.3:compile
+- org.springframework.boot:spring-boot-configuration-processor:jar:3.4.11:compile
+- org.apache.commons:commons-text:jar:1.10.0:compile
|  \- org.apache.commons:commons-lang3:jar:3.18.0:compile
+- org.json:json:jar:20231013:compile
+- org.mockito:mockito-inline:jar:5.1.1:test
+- org.aspectj:aspectjweaver:jar:1.9.24:compile
+- org.springframework.boot:spring-boot-starter-webflux:jar:3.4.11:compile
|  +- org.springframework.boot:spring-boot-starter-reactor-netty:jar:3.4.11:compile
|  |  \- io.projectreactor.netty:reactor-netty-http:jar:1.2.11:compile
|  |     +- io.netty:netty-codec-http:jar:4.1.127.Final:compile
|  |     |  +- io.netty:netty-common:jar:4.1.127.Final:compile
|  |     |  +- io.netty:netty-buffer:jar:4.1.127.Final:compile
|  |     |  +- io.netty:netty-transport:jar:4.1.127.Final:compile
|  |     |  +- io.netty:netty-codec:jar:4.1.127.Final:compile
|  |     |  \- io.netty:netty-handler:jar:4.1.127.Final:compile
|  |     +- io.netty:netty-codec-http2:jar:4.1.127.Final:compile
|  |     +- io.netty:netty-resolver-dns:jar:4.1.127.Final:compile
|  |     |  +- io.netty:netty-resolver:jar:4.1.127.Final:compile
|  |     |  \- io.netty:netty-codec-dns:jar:4.1.127.Final:compile
|  |     +- io.netty:netty-resolver-dns-native-macos:jar:osx-x86_64:4.1.127.Final:compile
|  |     |  \- io.netty:netty-resolver-dns-classes-macos:jar:4.1.127.Final:compile
|  |     +- io.netty:netty-transport-native-epoll:jar:linux-x86_64:4.1.127.Final:compile
|  |     |  +- io.netty:netty-transport-native-unix-common:jar:4.1.127.Final:compile
|  |     |  \- io.netty:netty-transport-classes-epoll:jar:4.1.127.Final:compile
|  |     \- io.projectreactor.netty:reactor-netty-core:jar:1.2.11:compile
|  |        \- io.netty:netty-handler-proxy:jar:4.1.127.Final:compile
|  |           \- io.netty:netty-codec-socks:jar:4.1.127.Final:compile
|  \- org.springframework:spring-webflux:jar:6.2.12:compile
|     \- io.projectreactor:reactor-core:jar:3.7.12:compile
|        \- org.reactivestreams:reactive-streams:jar:1.0.4:compile
+- com.squareup.okhttp3:mockwebserver:jar:4.12.0:test
|  +- com.squareup.okhttp3:okhttp:jar:4.12.0:test
|  |  \- com.squareup.okio:okio:jar:3.6.0:test
|  |     \- com.squareup.okio:okio-jvm:jar:3.6.0:test
|  |        \- org.jetbrains.kotlin:kotlin-stdlib-common:jar:1.9.25:test
|  +- junit:junit:jar:4.13.2:test
|  |  \- org.hamcrest:hamcrest-core:jar:2.2:test
|  \- org.jetbrains.kotlin:kotlin-stdlib-jdk8:jar:1.9.25:test
|     +- org.jetbrains.kotlin:kotlin-stdlib:jar:1.9.25:test
|     |  \- org.jetbrains:annotations:jar:13.0:test
|     \- org.jetbrains.kotlin:kotlin-stdlib-jdk7:jar:1.9.25:test
+- com.santander.ars:gln-back-arsenal-backend-embeddedmainframe:jar:3.18.12-SNAPSHOT:provided
|  +- com.ibm.mq:mq-jms-spring-boot-starter:jar:2.3.5:provided
|  |  +- com.ibm.mq:com.ibm.mq.allclient:jar:9.4.0.7:provided
|  |  |  +- org.bouncycastle:bcprov-jdk18on:jar:1.78.1:provided
|  |  |  +- org.bouncycastle:bcpkix-jdk18on:jar:1.78.1:provided
|  |  |  +- org.bouncycastle:bcutil-jdk18on:jar:1.78.1:provided
|  |  |  \- javax.jms:javax.jms-api:jar:2.0.1:provided
|  |  +- org.springframework:spring-jms:jar:6.2.12:provided
|  |  |  +- org.springframework:spring-messaging:jar:6.2.12:provided
|  |  |  \- org.springframework:spring-tx:jar:6.2.12:provided
|  |  \- org.messaginghub:pooled-jms:jar:3.1.7:provided
|  |     +- jakarta.jms:jakarta.jms-api:jar:3.1.0:provided
|  |     \- org.apache.commons:commons-pool2:jar:2.12.1:provided
|  +- com.santander.ars:arsenal-altair-connector-mq:jar:3.18.12-SNAPSHOT:provided
|  |  +- com.santander.ars:arsenal-altair-connector-psformat:jar:3.18.12-SNAPSHOT:provided
|  |  \- com.santander.ars:arsenal-altair-connector-core:jar:3.18.12-SNAPSHOT:provided
|  +- com.santander.ars:gln-back-arsenal-backend-core:jar:3.18.12-SNAPSHOT:provided
|  +- org.yaml:snakeyaml:jar:2.3:compile
|  \- commons-io:commons-io:jar:2.16.1:provided
\- org.mapstruct:mapstruct:jar:1.4.2.Final:compile
+- org.springframework.boot:spring-boot-starter-cache:jar:3.4.11:compile
|  +- org.springframework.boot:spring-boot-starter:jar:3.4.11:compile
|  |  +- org.springframework.boot:spring-boot:jar:3.4.11:compile
|  |  +- org.springframework.boot:spring-boot-autoconfigure:jar:3.4.11:compile
|  |  +- org.springframework.boot:spring-boot-starter-logging:jar:3.4.11:compile
|  |  |  +- ch.qos.logback:logback-classic:jar:1.5.20:compile
|  |  |  |  \- ch.qos.logback:logback-core:jar:1.5.20:compile
|  |  |  +- org.apache.logging.log4j:log4j-to-slf4j:jar:2.24.3:compile
|  |  |  |  \- org.apache.logging.log4j:log4j-api:jar:2.24.3:compile
|  |  |  \- org.slf4j:jul-to-slf4j:jar:2.0.17:compile
|  |  +- jakarta.annotation:jakarta.annotation-api:jar:2.1.1:compile
|  |  \- org.yaml:snakeyaml:jar:2.3:compile
|  \- org.springframework:spring-context-support:jar:6.2.12:compile
|     +- org.springframework:spring-beans:jar:6.2.12:compile
|     \- org.springframework:spring-context:jar:6.2.12:compile
|        +- org.springframework:spring-expression:jar:6.2.12:compile
|        \- io.micrometer:micrometer-observation:jar:1.14.12:compile
|           \- io.micrometer:micrometer-commons:jar:1.14.12:compile
+- org.springframework.boot:spring-boot-starter-data-redis:jar:3.4.11:compile
|  +- io.lettuce:lettuce-core:jar:6.4.2.RELEASE:compile
|  |  +- io.netty:netty-common:jar:4.1.127.Final:compile
|  |  +- io.netty:netty-handler:jar:4.1.127.Final:compile
|  |  |  +- io.netty:netty-resolver:jar:4.1.127.Final:compile
|  |  |  +- io.netty:netty-buffer:jar:4.1.127.Final:compile
|  |  |  +- io.netty:netty-transport-native-unix-common:jar:4.1.127.Final:compile
|  |  |  \- io.netty:netty-codec:jar:4.1.127.Final:compile
|  |  +- io.netty:netty-transport:jar:4.1.127.Final:compile
|  |  \- io.projectreactor:reactor-core:jar:3.7.12:compile
|  |     \- org.reactivestreams:reactive-streams:jar:1.0.4:compile
|  \- org.springframework.data:spring-data-redis:jar:3.4.11:compile
|     +- org.springframework.data:spring-data-keyvalue:jar:3.4.11:compile
|     |  \- org.springframework.data:spring-data-commons:jar:3.4.11:compile
|     +- org.springframework:spring-tx:jar:6.2.12:compile
|     +- org.springframework:spring-oxm:jar:6.2.12:compile
|     +- org.springframework:spring-aop:jar:6.2.12:compile
|     \- org.slf4j:slf4j-api:jar:2.0.17:compile
+- org.springframework.boot:spring-boot-starter-test:jar:3.4.11:test
|  +- org.springframework.boot:spring-boot-test:jar:3.4.11:test
|  +- org.springframework.boot:spring-boot-test-autoconfigure:jar:3.4.11:test
|  +- com.jayway.jsonpath:json-path:jar:2.9.0:test
|  +- jakarta.xml.bind:jakarta.xml.bind-api:jar:4.0.4:runtime
|  |  \- jakarta.activation:jakarta.activation-api:jar:2.1.4:runtime
|  +- net.minidev:json-smart:jar:2.5.2:test
|  |  \- net.minidev:accessors-smart:jar:2.5.2:test
|  |     \- org.ow2.asm:asm:jar:9.7.1:test
|  +- org.assertj:assertj-core:jar:3.26.3:test
|  |  \- net.bytebuddy:byte-buddy:jar:1.15.11:test
|  +- org.awaitility:awaitility:jar:4.2.2:test
|  +- org.hamcrest:hamcrest:jar:2.2:test
|  +- org.junit.jupiter:junit-jupiter:jar:5.11.4:test
|  |  \- org.junit.jupiter:junit-jupiter-params:jar:5.11.4:test
|  +- org.mockito:mockito-core:jar:5.14.2:test
|  |  +- net.bytebuddy:byte-buddy-agent:jar:1.15.11:test
|  |  \- org.objenesis:objenesis:jar:3.3:test
|  +- org.skyscreamer:jsonassert:jar:1.5.3:test
|  |  \- com.vaadin.external.google:android-json:jar:0.0.20131108.vaadin1:test
|  +- org.springframework:spring-core:jar:6.2.12:compile
|  |  \- org.springframework:spring-jcl:jar:6.2.12:compile
|  +- org.springframework:spring-test:jar:6.2.12:test
|  \- org.xmlunit:xmlunit-core:jar:2.10.4:test
+- org.junit.jupiter:junit-jupiter-api:jar:5.11.4:test
|  +- org.opentest4j:opentest4j:jar:1.3.0:test
|  +- org.junit.platform:junit-platform-commons:jar:1.11.4:test
|  \- org.apiguardian:apiguardian-api:jar:1.1.2:test
+- org.junit.jupiter:junit-jupiter-engine:jar:5.11.4:test
|  \- org.junit.platform:junit-platform-engine:jar:1.11.4:test
+- org.mockito:mockito-junit-jupiter:jar:5.14.2:test
+- commons-io:commons-io:jar:2.16.1:compile
+- org.projectlombok:lombok:jar:1.18.34:compile
\- org.mapstruct:mapstruct:jar:1.4.2.Final:compile
+- br.com.santander.dlb:DLBCryptoLoader:jar:1.0:compile
|  +- com.altec.bsbr.app.dl:DLBCryptoSDK:jar:1.16:compile
|  +- com.altec.bsbr.app.dl:DLBCryptoSDKECC:jar:1.9:compile
|  \- com.altec.bsbr.app.dl:DLBUtils:jar:1.1:compile
+- org.springframework.boot:spring-boot-starter:jar:3.4.11:compile
|  +- org.springframework.boot:spring-boot:jar:3.4.11:compile
|  +- org.springframework.boot:spring-boot-autoconfigure:jar:3.4.11:compile
|  +- org.springframework.boot:spring-boot-starter-logging:jar:3.4.11:compile
|  |  +- ch.qos.logback:logback-classic:jar:1.5.20:compile
|  |  |  \- ch.qos.logback:logback-core:jar:1.5.20:compile
|  |  +- org.apache.logging.log4j:log4j-to-slf4j:jar:2.24.3:compile
|  |  |  \- org.apache.logging.log4j:log4j-api:jar:2.24.3:compile
|  |  \- org.slf4j:jul-to-slf4j:jar:2.0.17:compile
|  +- jakarta.annotation:jakarta.annotation-api:jar:2.1.1:compile
|  +- org.springframework:spring-core:jar:6.2.12:compile
|  |  \- org.springframework:spring-jcl:jar:6.2.12:compile
|  \- org.yaml:snakeyaml:jar:2.3:compile
+- org.springframework.boot:spring-boot-starter-json:jar:3.4.11:compile
|  +- org.springframework:spring-web:jar:6.2.12:compile
|  |  \- io.micrometer:micrometer-observation:jar:1.14.12:compile
|  |     \- io.micrometer:micrometer-commons:jar:1.14.12:compile
|  +- com.fasterxml.jackson.core:jackson-databind:jar:2.18.4:compile
|  |  +- com.fasterxml.jackson.core:jackson-annotations:jar:2.18.4:compile
|  |  \- com.fasterxml.jackson.core:jackson-core:jar:2.18.4.1:compile
|  +- com.fasterxml.jackson.datatype:jackson-datatype-jdk8:jar:2.18.4:compile
|  +- com.fasterxml.jackson.datatype:jackson-datatype-jsr310:jar:2.18.4:compile
|  \- com.fasterxml.jackson.module:jackson-module-parameter-names:jar:2.18.4:compile
+- org.springframework:spring-webmvc:jar:6.2.12:compile
|  +- org.springframework:spring-aop:jar:6.2.12:compile
|  +- org.springframework:spring-beans:jar:6.2.12:compile
|  +- org.springframework:spring-context:jar:6.2.12:compile
|  \- org.springframework:spring-expression:jar:6.2.12:compile
+- org.bouncycastle:bcprov-jdk18on:jar:1.78.1:compile
+- jakarta.servlet:jakarta.servlet-api:jar:6.0.0:provided
+- commons-io:commons-io:jar:2.16.1:compile
+- org.junit.jupiter:junit-jupiter-api:jar:5.11.4:test
|  +- org.opentest4j:opentest4j:jar:1.3.0:test
|  +- org.junit.platform:junit-platform-commons:jar:1.11.4:test
|  \- org.apiguardian:apiguardian-api:jar:1.1.2:test
+- org.junit.jupiter:junit-jupiter-engine:jar:5.11.4:test
|  \- org.junit.platform:junit-platform-engine:jar:1.11.4:test
+- org.springframework.boot:spring-boot-starter-oauth2-resource-server:jar:3.4.11:compile
|  +- org.springframework.security:spring-security-config:jar:6.4.12:compile
|  +- org.springframework.security:spring-security-core:jar:6.4.12:compile
|  |  \- org.springframework.security:spring-security-crypto:jar:6.4.12:compile
|  +- org.springframework.security:spring-security-oauth2-resource-server:jar:6.4.12:compile
|  |  \- org.springframework.security:spring-security-oauth2-core:jar:6.4.12:compile
|  \- org.springframework.security:spring-security-oauth2-jose:jar:6.4.12:compile
|     \- com.nimbusds:nimbus-jose-jwt:jar:9.37.4:compile
|        \- com.github.stephenc.jcip:jcip-annotations:jar:1.0-1:compile
+- org.springframework.security:spring-security-test:jar:6.4.12:test
|  +- org.springframework.security:spring-security-web:jar:6.4.12:compile
|  \- org.springframework:spring-test:jar:6.2.12:test
+- com.github.jknack:handlebars:jar:4.3.1:compile
|  \- org.slf4j:slf4j-api:jar:2.0.17:compile
+- org.springframework.boot:spring-boot-starter-test:jar:3.4.11:test
|  +- org.springframework.boot:spring-boot-test:jar:3.4.11:test
|  +- org.springframework.boot:spring-boot-test-autoconfigure:jar:3.4.11:test
|  +- jakarta.xml.bind:jakarta.xml.bind-api:jar:4.0.4:test
|  |  \- jakarta.activation:jakarta.activation-api:jar:2.1.4:test
|  +- net.minidev:json-smart:jar:2.5.2:runtime
|  |  \- net.minidev:accessors-smart:jar:2.5.2:runtime
|  |     \- org.ow2.asm:asm:jar:9.7.1:runtime
|  +- org.assertj:assertj-core:jar:3.26.3:test
|  |  \- net.bytebuddy:byte-buddy:jar:1.15.11:test
|  +- org.awaitility:awaitility:jar:4.2.2:test
|  +- org.hamcrest:hamcrest:jar:2.2:test
|  +- org.junit.jupiter:junit-jupiter:jar:5.11.4:test
|  |  \- org.junit.jupiter:junit-jupiter-params:jar:5.11.4:test
|  +- org.mockito:mockito-core:jar:5.14.2:test
|  |  +- net.bytebuddy:byte-buddy-agent:jar:1.15.11:test
|  |  \- org.objenesis:objenesis:jar:3.3:test
|  +- org.skyscreamer:jsonassert:jar:1.5.3:test
|  |  \- com.vaadin.external.google:android-json:jar:0.0.20131108.vaadin1:test
|  \- org.xmlunit:xmlunit-core:jar:2.10.4:test
+- org.mockito:mockito-junit-jupiter:jar:5.14.2:test
+- com.jayway.jsonpath:json-path:jar:2.9.0:compile
+- org.projectlombok:lombok:jar:1.18.34:compile
\- org.mapstruct:mapstruct:jar:1.4.2.Final:compile
+- org.springframework.boot:spring-boot-starter:jar:3.4.11:compile
|  +- org.springframework.boot:spring-boot:jar:3.4.11:compile
|  |  \- org.springframework:spring-context:jar:6.2.12:compile
|  |     +- org.springframework:spring-aop:jar:6.2.12:compile
|  |     \- org.springframework:spring-expression:jar:6.2.12:compile
|  +- org.springframework.boot:spring-boot-autoconfigure:jar:3.4.11:compile
|  +- org.springframework.boot:spring-boot-starter-logging:jar:3.4.11:compile
|  |  +- ch.qos.logback:logback-classic:jar:1.5.20:compile
|  |  |  +- ch.qos.logback:logback-core:jar:1.5.20:compile
|  |  |  \- org.slf4j:slf4j-api:jar:2.0.17:compile
|  |  +- org.apache.logging.log4j:log4j-to-slf4j:jar:2.24.3:compile
|  |  |  \- org.apache.logging.log4j:log4j-api:jar:2.24.3:compile
|  |  \- org.slf4j:jul-to-slf4j:jar:2.0.17:compile
|  +- jakarta.annotation:jakarta.annotation-api:jar:2.1.1:compile
|  +- org.springframework:spring-core:jar:6.2.12:compile
|  |  \- org.springframework:spring-jcl:jar:6.2.12:compile
|  \- org.yaml:snakeyaml:jar:2.3:compile
+- org.springframework.boot:spring-boot-starter-json:jar:3.4.11:compile
|  +- org.springframework:spring-web:jar:6.2.12:compile
|  |  +- org.springframework:spring-beans:jar:6.2.12:compile
|  |  \- io.micrometer:micrometer-observation:jar:1.14.12:compile
|  |     \- io.micrometer:micrometer-commons:jar:1.14.12:compile
|  +- com.fasterxml.jackson.core:jackson-databind:jar:2.18.4:compile
|  |  +- com.fasterxml.jackson.core:jackson-annotations:jar:2.18.4:compile
|  |  \- com.fasterxml.jackson.core:jackson-core:jar:2.18.4.1:compile
|  +- com.fasterxml.jackson.datatype:jackson-datatype-jdk8:jar:2.18.4:compile
|  +- com.fasterxml.jackson.datatype:jackson-datatype-jsr310:jar:2.18.4:compile
|  \- com.fasterxml.jackson.module:jackson-module-parameter-names:jar:2.18.4:compile
+- br.com.santander.dlb:DLBIES:jar:2.0:compile
|  \- com.altec.bsbr.app.dl:DLBUtils:jar:1.1:compile
+- com.santander.ars:gln-back-arsenal-backend-test-starter:jar:3.18.12-SNAPSHOT:test
|  +- jakarta.servlet:jakarta.servlet-api:jar:6.0.0:test
|  +- org.junit.jupiter:junit-jupiter-api:jar:5.11.4:test
|  |  +- org.opentest4j:opentest4j:jar:1.3.0:test
|  |  +- org.junit.platform:junit-platform-commons:jar:1.11.4:test
|  |  \- org.apiguardian:apiguardian-api:jar:1.1.2:test
|  +- org.junit.jupiter:junit-jupiter-engine:jar:5.11.4:test
|  |  \- org.junit.platform:junit-platform-engine:jar:1.11.4:test
|  +- org.junit.jupiter:junit-jupiter:jar:5.11.4:test
|  |  \- org.junit.jupiter:junit-jupiter-params:jar:5.11.4:test
|  +- org.junit.vintage:junit-vintage-engine:jar:5.11.4:test
|  |  \- junit:junit:jar:4.13.2:test
|  +- net.bytebuddy:byte-buddy:jar:1.15.11:test
|  +- net.bytebuddy:byte-buddy-agent:jar:1.15.11:test
|  +- org.mockito:mockito-core:jar:5.14.2:test
|  |  \- org.objenesis:objenesis:jar:3.3:test
|  +- org.mockito:mockito-junit-jupiter:jar:5.14.2:test
|  +- org.hamcrest:hamcrest-library:jar:2.2:test
|  |  \- org.hamcrest:hamcrest-core:jar:2.2:test
|  +- com.tngtech.archunit:archunit-junit5-api:jar:1.3.0:test
|  |  \- com.tngtech.archunit:archunit:jar:1.3.0:test
|  +- com.tngtech.archunit:archunit-junit5-engine:jar:1.3.0:test
|  |  \- com.tngtech.archunit:archunit-junit5-engine-api:jar:1.3.0:test
|  +- org.springframework.boot:spring-boot-starter-test:jar:3.4.11:test
|  |  +- org.springframework.boot:spring-boot-test:jar:3.4.11:test
|  |  +- org.springframework.boot:spring-boot-test-autoconfigure:jar:3.4.11:test
|  |  +- com.jayway.jsonpath:json-path:jar:2.9.0:test
|  |  +- jakarta.xml.bind:jakarta.xml.bind-api:jar:4.0.4:test
|  |  |  \- jakarta.activation:jakarta.activation-api:jar:2.1.4:test
|  |  +- net.minidev:json-smart:jar:2.5.2:test
|  |  |  \- net.minidev:accessors-smart:jar:2.5.2:test
|  |  |     \- org.ow2.asm:asm:jar:9.7.1:test
|  |  +- org.assertj:assertj-core:jar:3.26.3:test
|  |  +- org.awaitility:awaitility:jar:4.2.2:test
|  |  +- org.hamcrest:hamcrest:jar:2.2:test
|  |  +- org.skyscreamer:jsonassert:jar:1.5.3:test
|  |  |  \- com.vaadin.external.google:android-json:jar:0.0.20131108.vaadin1:test
|  |  \- org.xmlunit:xmlunit-core:jar:2.10.4:test
|  +- org.springframework:spring-test:jar:6.2.12:test
|  +- io.cucumber:cucumber-java:jar:7.21.0:test
|  |  \- io.cucumber:cucumber-core:jar:7.21.0:test
|  |     +- io.cucumber:cucumber-gherkin:jar:7.21.0:test
|  |     +- io.cucumber:cucumber-gherkin-messages:jar:7.21.0:test
|  |     |  \- io.cucumber:gherkin:jar:31.0.0:test
|  |     +- io.cucumber:messages:jar:27.2.0:test
|  |     +- io.cucumber:testng-xml-formatter:jar:0.3.1:test
|  |     |  \- io.cucumber:query:jar:13.6.0:test
|  |     +- io.cucumber:tag-expressions:jar:6.1.2:test
|  |     +- io.cucumber:cucumber-expressions:jar:18.0.1:test
|  |     +- io.cucumber:datatable:jar:7.21.0:test
|  |     +- io.cucumber:cucumber-plugin:jar:7.21.0:test
|  |     +- io.cucumber:docstring:jar:7.21.0:test
|  |     +- io.cucumber:html-formatter:jar:21.9.0:test
|  |     +- io.cucumber:junit-xml-formatter:jar:0.7.1:test
|  |     \- io.cucumber:ci-environment:jar:10.0.1:test
|  +- io.cucumber:cucumber-spring:jar:7.21.0:test
|  +- io.cucumber:cucumber-junit:jar:7.21.0:test
|  \- commons-io:commons-io:jar:2.16.1:test
+- org.projectlombok:lombok:jar:1.18.34:compile
\- org.mapstruct:mapstruct:jar:1.4.2.Final:compile
+- org.springframework.boot:spring-boot-starter-web:jar:3.4.11:compile
|  +- org.springframework.boot:spring-boot-starter:jar:3.4.11:compile
|  |  +- org.springframework.boot:spring-boot:jar:3.4.11:compile
|  |  +- org.springframework.boot:spring-boot-autoconfigure:jar:3.4.11:compile
|  |  +- org.springframework.boot:spring-boot-starter-logging:jar:3.4.11:compile
|  |  |  +- ch.qos.logback:logback-classic:jar:1.5.20:compile
|  |  |  |  \- ch.qos.logback:logback-core:jar:1.5.20:compile
|  |  |  +- org.apache.logging.log4j:log4j-to-slf4j:jar:2.24.3:compile
|  |  |  |  \- org.apache.logging.log4j:log4j-api:jar:2.24.3:compile
|  |  |  \- org.slf4j:jul-to-slf4j:jar:2.0.17:compile
|  |  +- jakarta.annotation:jakarta.annotation-api:jar:2.1.1:compile
|  |  \- org.yaml:snakeyaml:jar:2.3:compile
|  +- org.springframework.boot:spring-boot-starter-json:jar:3.4.11:compile
|  |  +- com.fasterxml.jackson.core:jackson-databind:jar:2.18.4:compile
|  |  |  +- com.fasterxml.jackson.core:jackson-annotations:jar:2.18.4:compile
|  |  |  \- com.fasterxml.jackson.core:jackson-core:jar:2.18.4.1:compile
|  |  +- com.fasterxml.jackson.datatype:jackson-datatype-jdk8:jar:2.18.4:compile
|  |  +- com.fasterxml.jackson.datatype:jackson-datatype-jsr310:jar:2.18.4:compile
|  |  \- com.fasterxml.jackson.module:jackson-module-parameter-names:jar:2.18.4:compile
|  +- org.springframework.boot:spring-boot-starter-tomcat:jar:3.4.11:compile
|  |  +- org.apache.tomcat.embed:tomcat-embed-core:jar:10.1.48:compile
|  |  +- org.apache.tomcat.embed:tomcat-embed-el:jar:10.1.48:compile
|  |  \- org.apache.tomcat.embed:tomcat-embed-websocket:jar:10.1.48:compile
|  +- org.springframework:spring-web:jar:6.2.12:compile
|  |  +- org.springframework:spring-beans:jar:6.2.12:compile
|  |  \- io.micrometer:micrometer-observation:jar:1.14.12:compile
|  |     \- io.micrometer:micrometer-commons:jar:1.14.12:compile
|  \- org.springframework:spring-webmvc:jar:6.2.12:compile
|     +- org.springframework:spring-aop:jar:6.2.12:compile
|     +- org.springframework:spring-context:jar:6.2.12:compile
|     \- org.springframework:spring-expression:jar:6.2.12:compile
+- org.springframework.boot:spring-boot-starter-test:jar:3.4.11:test
|  +- org.springframework.boot:spring-boot-test:jar:3.4.11:test
|  +- org.springframework.boot:spring-boot-test-autoconfigure:jar:3.4.11:test
|  +- com.jayway.jsonpath:json-path:jar:2.9.0:test
|  |  \- org.slf4j:slf4j-api:jar:2.0.17:compile
|  +- jakarta.xml.bind:jakarta.xml.bind-api:jar:4.0.4:test
|  |  \- jakarta.activation:jakarta.activation-api:jar:2.1.4:test
|  +- net.minidev:json-smart:jar:2.5.2:test
|  |  \- net.minidev:accessors-smart:jar:2.5.2:test
|  |     \- org.ow2.asm:asm:jar:9.7.1:test
|  +- org.assertj:assertj-core:jar:3.26.3:test
|  |  \- net.bytebuddy:byte-buddy:jar:1.15.11:test
|  +- org.awaitility:awaitility:jar:4.2.2:test
|  +- org.hamcrest:hamcrest:jar:2.2:test
|  +- org.junit.jupiter:junit-jupiter:jar:5.11.4:test
|  |  +- org.junit.jupiter:junit-jupiter-api:jar:5.11.4:test
|  |  |  +- org.opentest4j:opentest4j:jar:1.3.0:test
|  |  |  +- org.junit.platform:junit-platform-commons:jar:1.11.4:test
|  |  |  \- org.apiguardian:apiguardian-api:jar:1.1.2:test
|  |  +- org.junit.jupiter:junit-jupiter-params:jar:5.11.4:test
|  |  \- org.junit.jupiter:junit-jupiter-engine:jar:5.11.4:test
|  |     \- org.junit.platform:junit-platform-engine:jar:1.11.4:test
|  +- org.mockito:mockito-core:jar:5.14.2:test
|  |  +- net.bytebuddy:byte-buddy-agent:jar:1.15.11:test
|  |  \- org.objenesis:objenesis:jar:3.3:test
|  +- org.mockito:mockito-junit-jupiter:jar:5.14.2:test
|  +- org.skyscreamer:jsonassert:jar:1.5.3:test
|  |  \- com.vaadin.external.google:android-json:jar:0.0.20131108.vaadin1:test
|  +- org.springframework:spring-core:jar:6.2.12:compile
|  |  \- org.springframework:spring-jcl:jar:6.2.12:compile
|  +- org.springframework:spring-test:jar:6.2.12:test
|  \- org.xmlunit:xmlunit-core:jar:2.10.4:test
+- com.santander.ars:gln-back-arsenal-backend-core:jar:3.18.12-SNAPSHOT:compile
|  \- org.apache.commons:commons-lang3:jar:3.18.0:compile
+- org.projectlombok:lombok:jar:1.18.34:compile
\- org.mapstruct:mapstruct:jar:1.4.2.Final:compile
+- com.santander.ars:gln-back-arsenal-core:jar:3.18.12-SNAPSHOT:compile
|  \- com.santander.ars:gln-back-arsenal-backend-core:jar:3.18.12-SNAPSHOT:compile
|     \- org.apache.commons:commons-lang3:jar:3.18.0:compile
+- org.hibernate.orm:hibernate-core:jar:6.6.33.Final:compile
|  +- jakarta.persistence:jakarta.persistence-api:jar:3.1.0:compile
|  +- jakarta.transaction:jakarta.transaction-api:jar:2.0.1:compile
|  +- org.jboss.logging:jboss-logging:jar:3.6.1.Final:compile
|  +- org.hibernate.common:hibernate-commons-annotations:jar:7.0.3.Final:runtime
|  +- io.smallrye:jandex:jar:3.2.0:runtime
|  +- com.fasterxml:classmate:jar:1.7.1:compile
|  +- net.bytebuddy:byte-buddy:jar:1.15.11:compile
|  +- jakarta.xml.bind:jakarta.xml.bind-api:jar:4.0.4:runtime
|  |  \- jakarta.activation:jakarta.activation-api:jar:2.1.4:runtime
|  +- org.glassfish.jaxb:jaxb-runtime:jar:4.0.6:runtime
|  |  \- org.glassfish.jaxb:jaxb-core:jar:4.0.6:runtime
|  |     +- org.eclipse.angus:angus-activation:jar:2.0.3:runtime
|  |     +- org.glassfish.jaxb:txw2:jar:4.0.6:runtime
|  |     \- com.sun.istack:istack-commons-runtime:jar:4.1.2:runtime
|  +- jakarta.inject:jakarta.inject-api:jar:2.0.1:runtime
|  \- org.antlr:antlr4-runtime:jar:4.13.0:runtime
+- org.springframework:spring-messaging:jar:6.2.12:compile
|  +- org.springframework:spring-beans:jar:6.2.12:compile
|  \- org.springframework:spring-core:jar:6.2.12:compile
|     \- org.springframework:spring-jcl:jar:6.2.12:compile
+- org.hibernate.validator:hibernate-validator:jar:8.0.3.Final:compile
|  \- jakarta.validation:jakarta.validation-api:jar:3.0.2:compile
+- org.springframework.security:spring-security-core:jar:6.4.12:compile
|  +- org.springframework.security:spring-security-crypto:jar:6.4.12:compile
|  +- org.springframework:spring-aop:jar:6.2.12:compile
|  +- org.springframework:spring-context:jar:6.2.12:compile
|  +- org.springframework:spring-expression:jar:6.2.12:compile
|  \- io.micrometer:micrometer-observation:jar:1.14.12:compile
|     \- io.micrometer:micrometer-commons:jar:1.14.12:compile
+- org.springframework:spring-web:jar:6.2.12:compile
+- org.springframework.boot:spring-boot-starter-web:jar:3.4.11:compile
|  +- org.springframework.boot:spring-boot-starter:jar:3.4.11:compile
|  |  +- org.springframework.boot:spring-boot:jar:3.4.11:compile
|  |  +- org.springframework.boot:spring-boot-autoconfigure:jar:3.4.11:compile
|  |  +- org.springframework.boot:spring-boot-starter-logging:jar:3.4.11:compile
|  |  |  +- ch.qos.logback:logback-classic:jar:1.5.20:compile
|  |  |  |  \- ch.qos.logback:logback-core:jar:1.5.20:compile
|  |  |  +- org.apache.logging.log4j:log4j-to-slf4j:jar:2.24.3:compile
|  |  |  |  \- org.apache.logging.log4j:log4j-api:jar:2.24.3:compile
|  |  |  \- org.slf4j:jul-to-slf4j:jar:2.0.17:compile
|  |  +- jakarta.annotation:jakarta.annotation-api:jar:2.1.1:compile
|  |  \- org.yaml:snakeyaml:jar:2.3:compile
|  +- org.springframework.boot:spring-boot-starter-json:jar:3.4.11:compile
|  |  +- com.fasterxml.jackson.core:jackson-databind:jar:2.18.4:compile
|  |  |  +- com.fasterxml.jackson.core:jackson-annotations:jar:2.18.4:compile
|  |  |  \- com.fasterxml.jackson.core:jackson-core:jar:2.18.4.1:compile
|  |  +- com.fasterxml.jackson.datatype:jackson-datatype-jdk8:jar:2.18.4:compile
|  |  +- com.fasterxml.jackson.datatype:jackson-datatype-jsr310:jar:2.18.4:compile
|  |  \- com.fasterxml.jackson.module:jackson-module-parameter-names:jar:2.18.4:compile
|  +- org.springframework.boot:spring-boot-starter-tomcat:jar:3.4.11:compile
|  |  +- org.apache.tomcat.embed:tomcat-embed-core:jar:10.1.48:compile
|  |  +- org.apache.tomcat.embed:tomcat-embed-el:jar:10.1.48:compile
|  |  \- org.apache.tomcat.embed:tomcat-embed-websocket:jar:10.1.48:compile
|  \- org.springframework:spring-webmvc:jar:6.2.12:compile
+- org.springframework.boot:spring-boot-configuration-processor:jar:3.4.11:compile
+- io.github.resilience4j:resilience4j-circuitbreaker:jar:2.2.0:compile
|  +- io.github.resilience4j:resilience4j-core:jar:2.2.0:compile
|  \- org.slf4j:slf4j-api:jar:2.0.17:compile
+- io.github.resilience4j:resilience4j-retry:jar:2.2.0:compile
+- io.github.resilience4j:resilience4j-ratelimiter:jar:2.2.0:compile
+- io.github.resilience4j:resilience4j-timelimiter:jar:2.2.0:compile
+- org.junit.jupiter:junit-jupiter-api:jar:5.11.4:compile
|  +- org.opentest4j:opentest4j:jar:1.3.0:compile
|  +- org.junit.platform:junit-platform-commons:jar:1.11.4:compile
|  \- org.apiguardian:apiguardian-api:jar:1.1.2:compile
+- org.mockito:mockito-core:jar:5.14.2:compile
|  +- net.bytebuddy:byte-buddy-agent:jar:1.15.11:compile
|  \- org.objenesis:objenesis:jar:3.3:runtime
+- org.mockito:mockito-junit-jupiter:jar:5.14.2:compile
+- io.github.resilience4j:resilience4j-bulkhead:jar:2.2.0:compile
+- org.projectlombok:lombok:jar:1.18.34:compile
\- org.mapstruct:mapstruct:jar:1.4.2.Final:compile
+- org.apache.mina:mina-core:jar:2.2.4:compile
|  \- org.slf4j:slf4j-api:jar:2.0.17:compile
+- org.apache.directory.server:apacheds-kerberos-codec:jar:2.0.0.AM27:compile
|  +- org.apache.directory.server:apacheds-i18n:jar:2.0.0.AM27:compile
|  +- org.apache.directory.api:api-asn1-api:jar:2.1.5:compile
|  +- org.apache.directory.api:api-asn1-ber:jar:2.1.5:compile
|  +- org.apache.directory.api:api-i18n:jar:2.1.5:compile
|  +- org.apache.directory.api:api-ldap-model:jar:2.1.5:compile
|  |  +- org.apache.servicemix.bundles:org.apache.servicemix.bundles.antlr:jar:2.7.7_5:compile
|  |  +- org.apache.commons:commons-lang3:jar:3.18.0:compile
|  |  +- org.apache.commons:commons-collections4:jar:4.4:compile
|  |  \- commons-codec:commons-codec:jar:1.17.2:compile
|  +- org.apache.directory.api:api-util:jar:2.1.5:compile
|  \- com.github.ben-manes.caffeine:caffeine:jar:3.1.8:compile
+- com.squareup.okio:okio:jar:3.6.0:runtime
|  \- com.squareup.okio:okio-jvm:jar:3.6.0:runtime
|     +- org.jetbrains.kotlin:kotlin-stdlib-jdk8:jar:1.9.25:runtime
|     |  +- org.jetbrains.kotlin:kotlin-stdlib:jar:1.9.25:runtime
|     |  |  \- org.jetbrains:annotations:jar:13.0:runtime
|     |  \- org.jetbrains.kotlin:kotlin-stdlib-jdk7:jar:1.9.25:runtime
|     \- org.jetbrains.kotlin:kotlin-stdlib-common:jar:1.9.25:runtime
+- org.springframework:spring-web:jar:6.2.12:compile
|  +- org.springframework:spring-beans:jar:6.2.12:compile
|  +- org.springframework:spring-core:jar:6.2.12:compile
|  |  \- org.springframework:spring-jcl:jar:6.2.12:compile
|  \- io.micrometer:micrometer-observation:jar:1.14.12:compile
|     \- io.micrometer:micrometer-commons:jar:1.14.12:compile
+- org.springframework:spring-webmvc:jar:6.2.12:compile
|  +- org.springframework:spring-aop:jar:6.2.12:compile
|  +- org.springframework:spring-context:jar:6.2.12:compile
|  \- org.springframework:spring-expression:jar:6.2.12:compile
+- org.springframework:spring-test:jar:6.2.12:provided
+- org.springframework.boot:spring-boot-autoconfigure:jar:3.4.11:provided
|  \- org.springframework.boot:spring-boot:jar:3.4.11:provided
+- jakarta.annotation:jakarta.annotation-api:jar:2.1.1:compile
+- ch.qos.logback:logback-core:jar:1.5.20:compile
+- ch.qos.logback:logback-classic:jar:1.5.20:compile
+- ch.qos.logback.access:logback-access-common:jar:2.0.6:compile
+- net.logstash.logback:logstash-logback-encoder:jar:7.4:compile
+- jakarta.servlet:jakarta.servlet-api:jar:6.0.0:provided
+- com.fasterxml.jackson.core:jackson-annotations:jar:2.18.4:compile
+- com.fasterxml.jackson.core:jackson-databind:jar:2.18.4:compile
|  \- com.fasterxml.jackson.core:jackson-core:jar:2.18.4.1:compile
+- org.codehaus.janino:janino:jar:3.1.2:compile
|  \- org.codehaus.janino:commons-compiler:jar:3.1.12:compile
+- javax.xml.bind:jaxb-api:jar:2.3.0:compile
+- io.jsonwebtoken:jjwt:jar:0.9.1:compile
+- commons-beanutils:commons-beanutils:jar:1.11.0:compile
+- com.openpojo:openpojo:jar:0.8.13:test
+- io.cucumber:cucumber-html:jar:0.2.7:compile
+- org.testng:testng:jar:7.7.1:test
|  +- com.beust:jcommander:jar:1.82:test
|  \- org.webjars:jquery:jar:3.6.1:test
+- br.com.santander.dynatrace.otl:SantanderDynatraceOtl:jar:2.4.2:compile
|  +- org.jodd:jodd:jar:3.3.4:compile
|  +- com.dynatrace.metric.util:dynatrace-metric-utils-java:jar:1.4.0:compile
|  +- io.opentelemetry:opentelemetry-sdk-metrics:jar:1.43.0:compile
|  |  +- io.opentelemetry:opentelemetry-sdk-common:jar:1.43.0:compile
|  |  \- io.opentelemetry:opentelemetry-api-incubator:jar:1.43.0-alpha:runtime
|  +- io.opentracing:opentracing-api:jar:0.33.0:compile
|  +- io.opentracing:opentracing-mock:jar:0.33.0:compile
|  |  \- io.opentracing:opentracing-noop:jar:0.33.0:compile
|  +- io.opentracing:opentracing-util:jar:0.33.0:compile
|  +- io.opentelemetry:opentelemetry-api:jar:1.43.0:compile
|  |  \- io.opentelemetry:opentelemetry-context:jar:1.43.0:compile
|  +- io.opentelemetry:opentelemetry-exporter-otlp:jar:1.43.0:compile
|  |  +- io.opentelemetry:opentelemetry-sdk-trace:jar:1.43.0:compile
|  |  +- io.opentelemetry:opentelemetry-sdk-logs:jar:1.43.0:compile
|  |  +- io.opentelemetry:opentelemetry-exporter-otlp-common:jar:1.43.0:runtime
|  |  |  \- io.opentelemetry:opentelemetry-exporter-common:jar:1.43.0:runtime
|  |  +- io.opentelemetry:opentelemetry-exporter-sender-okhttp:jar:1.43.0:runtime
|  |  \- io.opentelemetry:opentelemetry-sdk-extension-autoconfigure-spi:jar:1.43.0:runtime
|  +- io.opentelemetry:opentelemetry-sdk:jar:1.43.0:compile
|  \- com.jcraft:jsch:jar:0.1.55:compile
+- org.junit.jupiter:junit-jupiter-api:jar:5.11.4:test
|  +- org.opentest4j:opentest4j:jar:1.3.0:test
|  +- org.junit.platform:junit-platform-commons:jar:1.11.4:test
|  \- org.apiguardian:apiguardian-api:jar:1.1.2:test
+- org.junit.jupiter:junit-jupiter-engine:jar:5.11.4:test
|  \- org.junit.platform:junit-platform-engine:jar:1.11.4:test
+- org.mockito:mockito-junit-jupiter:jar:5.14.2:test
|  \- org.mockito:mockito-core:jar:5.14.2:test
|     +- net.bytebuddy:byte-buddy:jar:1.15.11:test
|     +- net.bytebuddy:byte-buddy-agent:jar:1.15.11:test
|     \- org.objenesis:objenesis:jar:3.3:test
+- org.projectlombok:lombok:jar:1.18.42:compile
\- org.mapstruct:mapstruct:jar:1.4.2.Final:compile
+- org.springframework.boot:spring-boot-starter-web:jar:3.4.11:compile
|  +- org.springframework.boot:spring-boot-starter:jar:3.4.11:compile
|  |  +- org.springframework.boot:spring-boot:jar:3.4.11:compile
|  |  +- org.springframework.boot:spring-boot-autoconfigure:jar:3.4.11:compile
|  |  +- org.springframework.boot:spring-boot-starter-logging:jar:3.4.11:compile
|  |  |  +- ch.qos.logback:logback-classic:jar:1.5.20:compile
|  |  |  |  \- ch.qos.logback:logback-core:jar:1.5.20:compile
|  |  |  +- org.apache.logging.log4j:log4j-to-slf4j:jar:2.24.3:compile
|  |  |  |  \- org.apache.logging.log4j:log4j-api:jar:2.24.3:compile
|  |  |  \- org.slf4j:jul-to-slf4j:jar:2.0.17:compile
|  |  +- jakarta.annotation:jakarta.annotation-api:jar:2.1.1:compile
|  |  \- org.yaml:snakeyaml:jar:2.3:compile
|  +- org.springframework.boot:spring-boot-starter-json:jar:3.4.11:compile
|  |  +- com.fasterxml.jackson.core:jackson-databind:jar:2.18.4:compile
|  |  |  +- com.fasterxml.jackson.core:jackson-annotations:jar:2.18.4:compile
|  |  |  \- com.fasterxml.jackson.core:jackson-core:jar:2.18.4.1:compile
|  |  +- com.fasterxml.jackson.datatype:jackson-datatype-jdk8:jar:2.18.4:compile
|  |  +- com.fasterxml.jackson.datatype:jackson-datatype-jsr310:jar:2.18.4:compile
|  |  \- com.fasterxml.jackson.module:jackson-module-parameter-names:jar:2.18.4:compile
|  +- org.springframework.boot:spring-boot-starter-tomcat:jar:3.4.11:compile
|  |  +- org.apache.tomcat.embed:tomcat-embed-core:jar:10.1.48:compile
|  |  +- org.apache.tomcat.embed:tomcat-embed-el:jar:10.1.48:compile
|  |  \- org.apache.tomcat.embed:tomcat-embed-websocket:jar:10.1.48:compile
|  +- org.springframework:spring-web:jar:6.2.12:compile
|  |  +- org.springframework:spring-beans:jar:6.2.12:compile
|  |  \- io.micrometer:micrometer-observation:jar:1.14.12:compile
|  |     \- io.micrometer:micrometer-commons:jar:1.14.12:compile
|  \- org.springframework:spring-webmvc:jar:6.2.12:compile
|     +- org.springframework:spring-aop:jar:6.2.12:compile
|     +- org.springframework:spring-context:jar:6.2.12:compile
|     \- org.springframework:spring-expression:jar:6.2.12:compile
+- org.junit.jupiter:junit-jupiter-api:jar:5.11.4:test
|  +- org.opentest4j:opentest4j:jar:1.3.0:test
|  +- org.junit.platform:junit-platform-commons:jar:1.11.4:test
|  \- org.apiguardian:apiguardian-api:jar:1.1.2:test
+- org.junit.jupiter:junit-jupiter-engine:jar:5.11.4:test
|  \- org.junit.platform:junit-platform-engine:jar:1.11.4:test
+- org.mockito:mockito-junit-jupiter:jar:5.14.2:test
|  \- org.mockito:mockito-core:jar:5.14.2:test
|     +- net.bytebuddy:byte-buddy:jar:1.15.11:test
|     +- net.bytebuddy:byte-buddy-agent:jar:1.15.11:test
|     \- org.objenesis:objenesis:jar:3.3:test
+- org.springframework.boot:spring-boot-starter-test:jar:3.4.11:test
|  +- org.springframework.boot:spring-boot-test:jar:3.4.11:test
|  +- org.springframework.boot:spring-boot-test-autoconfigure:jar:3.4.11:test
|  +- com.jayway.jsonpath:json-path:jar:2.9.0:test
|  |  \- org.slf4j:slf4j-api:jar:2.0.17:compile
|  +- jakarta.xml.bind:jakarta.xml.bind-api:jar:4.0.4:test
|  |  \- jakarta.activation:jakarta.activation-api:jar:2.1.4:test
|  +- net.minidev:json-smart:jar:2.5.2:test
|  |  \- net.minidev:accessors-smart:jar:2.5.2:test
|  |     \- org.ow2.asm:asm:jar:9.7.1:test
|  +- org.assertj:assertj-core:jar:3.26.3:test
|  +- org.awaitility:awaitility:jar:4.2.2:test
|  +- org.hamcrest:hamcrest:jar:2.2:test
|  +- org.junit.jupiter:junit-jupiter:jar:5.11.4:test
|  |  \- org.junit.jupiter:junit-jupiter-params:jar:5.11.4:test
|  +- org.skyscreamer:jsonassert:jar:1.5.3:test
|  |  \- com.vaadin.external.google:android-json:jar:0.0.20131108.vaadin1:test
|  +- org.springframework:spring-core:jar:6.2.12:compile
|  |  \- org.springframework:spring-jcl:jar:6.2.12:compile
|  +- org.springframework:spring-test:jar:6.2.12:test
|  \- org.xmlunit:xmlunit-core:jar:2.10.4:test
+- com.santander.ars:gln-back-arsenal-backend-core:jar:3.18.12-SNAPSHOT:compile
|  \- org.apache.commons:commons-lang3:jar:3.18.0:compile
+- org.projectlombok:lombok:jar:1.18.34:compile
\- org.mapstruct:mapstruct:jar:1.4.2.Final:compile
+- org.springframework.boot:spring-boot-starter-web:jar:3.4.11:compile
|  +- org.springframework.boot:spring-boot-starter:jar:3.4.11:compile
|  |  +- org.springframework.boot:spring-boot:jar:3.4.11:compile
|  |  +- org.springframework.boot:spring-boot-autoconfigure:jar:3.4.11:compile
|  |  +- org.springframework.boot:spring-boot-starter-logging:jar:3.4.11:compile
|  |  |  +- ch.qos.logback:logback-classic:jar:1.5.20:compile
|  |  |  |  \- ch.qos.logback:logback-core:jar:1.5.20:compile
|  |  |  +- org.apache.logging.log4j:log4j-to-slf4j:jar:2.24.3:compile
|  |  |  |  \- org.apache.logging.log4j:log4j-api:jar:2.24.3:compile
|  |  |  \- org.slf4j:jul-to-slf4j:jar:2.0.17:compile
|  |  +- jakarta.annotation:jakarta.annotation-api:jar:2.1.1:compile
|  |  \- org.yaml:snakeyaml:jar:2.3:compile
|  +- org.springframework.boot:spring-boot-starter-json:jar:3.4.11:compile
|  |  +- com.fasterxml.jackson.core:jackson-databind:jar:2.18.4:compile
|  |  |  +- com.fasterxml.jackson.core:jackson-annotations:jar:2.18.4:compile
|  |  |  \- com.fasterxml.jackson.core:jackson-core:jar:2.18.4.1:compile
|  |  +- com.fasterxml.jackson.datatype:jackson-datatype-jdk8:jar:2.18.4:compile
|  |  +- com.fasterxml.jackson.datatype:jackson-datatype-jsr310:jar:2.18.4:compile
|  |  \- com.fasterxml.jackson.module:jackson-module-parameter-names:jar:2.18.4:compile
|  +- org.springframework.boot:spring-boot-starter-tomcat:jar:3.4.11:compile
|  |  +- org.apache.tomcat.embed:tomcat-embed-core:jar:10.1.48:compile
|  |  +- org.apache.tomcat.embed:tomcat-embed-el:jar:10.1.48:compile
|  |  \- org.apache.tomcat.embed:tomcat-embed-websocket:jar:10.1.48:compile
|  +- org.springframework:spring-web:jar:6.2.12:compile
|  |  +- org.springframework:spring-beans:jar:6.2.12:compile
|  |  \- io.micrometer:micrometer-observation:jar:1.14.12:compile
|  |     \- io.micrometer:micrometer-commons:jar:1.14.12:compile
|  \- org.springframework:spring-webmvc:jar:6.2.12:compile
|     +- org.springframework:spring-aop:jar:6.2.12:compile
|     +- org.springframework:spring-context:jar:6.2.12:compile
|     \- org.springframework:spring-expression:jar:6.2.12:compile
+- org.junit.jupiter:junit-jupiter-api:jar:5.11.4:test
|  +- org.opentest4j:opentest4j:jar:1.3.0:test
|  +- org.junit.platform:junit-platform-commons:jar:1.11.4:test
|  \- org.apiguardian:apiguardian-api:jar:1.1.2:test
+- org.junit.jupiter:junit-jupiter-engine:jar:5.11.4:test
|  \- org.junit.platform:junit-platform-engine:jar:1.11.4:test
+- org.mockito:mockito-junit-jupiter:jar:5.14.2:test
|  \- org.mockito:mockito-core:jar:5.14.2:test
|     +- net.bytebuddy:byte-buddy:jar:1.15.11:test
|     +- net.bytebuddy:byte-buddy-agent:jar:1.15.11:test
|     \- org.objenesis:objenesis:jar:3.3:test
+- org.springframework.boot:spring-boot-starter-test:jar:3.4.11:test
|  +- org.springframework.boot:spring-boot-test:jar:3.4.11:test
|  +- org.springframework.boot:spring-boot-test-autoconfigure:jar:3.4.11:test
|  +- com.jayway.jsonpath:json-path:jar:2.9.0:test
|  |  \- org.slf4j:slf4j-api:jar:2.0.17:compile
|  +- jakarta.xml.bind:jakarta.xml.bind-api:jar:4.0.4:test
|  |  \- jakarta.activation:jakarta.activation-api:jar:2.1.4:test
|  +- net.minidev:json-smart:jar:2.5.2:test
|  |  \- net.minidev:accessors-smart:jar:2.5.2:test
|  |     \- org.ow2.asm:asm:jar:9.7.1:test
|  +- org.assertj:assertj-core:jar:3.26.3:test
|  +- org.awaitility:awaitility:jar:4.2.2:test
|  +- org.hamcrest:hamcrest:jar:2.2:test
|  +- org.junit.jupiter:junit-jupiter:jar:5.11.4:test
|  |  \- org.junit.jupiter:junit-jupiter-params:jar:5.11.4:test
|  +- org.skyscreamer:jsonassert:jar:1.5.3:test
|  |  \- com.vaadin.external.google:android-json:jar:0.0.20131108.vaadin1:test
|  +- org.springframework:spring-core:jar:6.2.12:compile
|  |  \- org.springframework:spring-jcl:jar:6.2.12:compile
|  +- org.springframework:spring-test:jar:6.2.12:test
|  \- org.xmlunit:xmlunit-core:jar:2.10.4:test
+- com.santander.ars:gln-back-arsenal-backend-core:jar:3.18.12-SNAPSHOT:compile
|  \- org.apache.commons:commons-lang3:jar:3.18.0:compile
+- org.projectlombok:lombok:jar:1.18.34:compile
\- org.mapstruct:mapstruct:jar:1.4.2.Final:compile
+- org.springframework.boot:spring-boot-starter-web:jar:3.4.11:compile
|  +- org.springframework.boot:spring-boot-starter:jar:3.4.11:compile
|  |  +- org.springframework.boot:spring-boot:jar:3.4.11:compile
|  |  +- org.springframework.boot:spring-boot-autoconfigure:jar:3.4.11:compile
|  |  +- org.springframework.boot:spring-boot-starter-logging:jar:3.4.11:compile
|  |  |  +- ch.qos.logback:logback-classic:jar:1.5.20:compile
|  |  |  |  \- ch.qos.logback:logback-core:jar:1.5.20:compile
|  |  |  +- org.apache.logging.log4j:log4j-to-slf4j:jar:2.24.3:compile
|  |  |  |  \- org.apache.logging.log4j:log4j-api:jar:2.24.3:compile
|  |  |  \- org.slf4j:jul-to-slf4j:jar:2.0.17:compile
|  |  +- jakarta.annotation:jakarta.annotation-api:jar:2.1.1:compile
|  |  \- org.yaml:snakeyaml:jar:2.3:compile
|  +- org.springframework.boot:spring-boot-starter-json:jar:3.4.11:compile
|  |  +- com.fasterxml.jackson.core:jackson-databind:jar:2.18.4:compile
|  |  |  +- com.fasterxml.jackson.core:jackson-annotations:jar:2.18.4:compile
|  |  |  \- com.fasterxml.jackson.core:jackson-core:jar:2.18.4.1:compile
|  |  +- com.fasterxml.jackson.datatype:jackson-datatype-jdk8:jar:2.18.4:compile
|  |  +- com.fasterxml.jackson.datatype:jackson-datatype-jsr310:jar:2.18.4:compile
|  |  \- com.fasterxml.jackson.module:jackson-module-parameter-names:jar:2.18.4:compile
|  +- org.springframework.boot:spring-boot-starter-tomcat:jar:3.4.11:compile
|  |  +- org.apache.tomcat.embed:tomcat-embed-core:jar:10.1.48:compile
|  |  +- org.apache.tomcat.embed:tomcat-embed-el:jar:10.1.48:compile
|  |  \- org.apache.tomcat.embed:tomcat-embed-websocket:jar:10.1.48:compile
|  +- org.springframework:spring-web:jar:6.2.12:compile
|  \- org.springframework:spring-webmvc:jar:6.2.12:compile
+- org.junit.jupiter:junit-jupiter-api:jar:5.11.4:test
|  +- org.opentest4j:opentest4j:jar:1.3.0:test
|  +- org.junit.platform:junit-platform-commons:jar:1.11.4:test
|  \- org.apiguardian:apiguardian-api:jar:1.1.2:test
+- org.junit.jupiter:junit-jupiter-engine:jar:5.11.4:test
|  \- org.junit.platform:junit-platform-engine:jar:1.11.4:test
+- org.mockito:mockito-junit-jupiter:jar:5.14.2:test
|  \- org.mockito:mockito-core:jar:5.14.2:test
|     +- net.bytebuddy:byte-buddy:jar:1.15.11:test
|     +- net.bytebuddy:byte-buddy-agent:jar:1.15.11:test
|     \- org.objenesis:objenesis:jar:3.3:test
+- org.springframework.boot:spring-boot-starter-test:jar:3.4.11:test
|  +- org.springframework.boot:spring-boot-test:jar:3.4.11:test
|  +- org.springframework.boot:spring-boot-test-autoconfigure:jar:3.4.11:test
|  +- com.jayway.jsonpath:json-path:jar:2.9.0:test
|  |  \- org.slf4j:slf4j-api:jar:2.0.17:compile
|  +- jakarta.xml.bind:jakarta.xml.bind-api:jar:4.0.4:test
|  |  \- jakarta.activation:jakarta.activation-api:jar:2.1.4:test
|  +- net.minidev:json-smart:jar:2.5.2:test
|  |  \- net.minidev:accessors-smart:jar:2.5.2:test
|  |     \- org.ow2.asm:asm:jar:9.7.1:test
|  +- org.assertj:assertj-core:jar:3.26.3:test
|  +- org.awaitility:awaitility:jar:4.2.2:test
|  +- org.hamcrest:hamcrest:jar:2.2:test
|  +- org.junit.jupiter:junit-jupiter:jar:5.11.4:test
|  |  \- org.junit.jupiter:junit-jupiter-params:jar:5.11.4:test
|  +- org.skyscreamer:jsonassert:jar:1.5.3:test
|  |  \- com.vaadin.external.google:android-json:jar:0.0.20131108.vaadin1:test
|  +- org.springframework:spring-core:jar:6.2.12:compile
|  |  \- org.springframework:spring-jcl:jar:6.2.12:compile
|  +- org.springframework:spring-test:jar:6.2.12:test
|  \- org.xmlunit:xmlunit-core:jar:2.10.4:test
+- com.santander.ars:gln-back-arsenal-backend-core:jar:3.18.12-SNAPSHOT:compile
|  \- org.apache.commons:commons-lang3:jar:3.18.0:compile
+- org.springframework.security:spring-security-core:jar:6.4.12:compile
|  +- org.springframework.security:spring-security-crypto:jar:6.4.12:compile
|  +- org.springframework:spring-aop:jar:6.2.12:compile
|  +- org.springframework:spring-beans:jar:6.2.12:compile
|  +- org.springframework:spring-context:jar:6.2.12:compile
|  +- org.springframework:spring-expression:jar:6.2.12:compile
|  \- io.micrometer:micrometer-observation:jar:1.14.12:compile
|     \- io.micrometer:micrometer-commons:jar:1.14.12:compile
+- org.springframework.boot:spring-boot-starter-oauth2-resource-server:jar:3.4.11:compile
|  +- org.springframework.security:spring-security-config:jar:6.4.12:compile
|  +- org.springframework.security:spring-security-oauth2-resource-server:jar:6.4.12:compile
|  |  \- org.springframework.security:spring-security-oauth2-core:jar:6.4.12:compile
|  \- org.springframework.security:spring-security-oauth2-jose:jar:6.4.12:compile
|     \- com.nimbusds:nimbus-jose-jwt:jar:9.37.4:compile
|        \- com.github.stephenc.jcip:jcip-annotations:jar:1.0-1:compile
+- org.springframework.security:spring-security-test:jar:6.4.12:test
|  \- org.springframework.security:spring-security-web:jar:6.4.12:compile
+- org.projectlombok:lombok:jar:1.18.34:compile
\- org.mapstruct:mapstruct:jar:1.4.2.Final:compile
+- org.springframework.data:spring-data-redis:jar:3.4.11:compile
|  +- org.springframework.data:spring-data-keyvalue:jar:3.4.11:compile
|  |  +- org.springframework.data:spring-data-commons:jar:3.4.11:compile
|  |  \- org.springframework:spring-context:jar:6.2.12:compile
|  +- org.springframework:spring-tx:jar:6.2.12:compile
|  |  \- org.springframework:spring-beans:jar:6.2.12:compile
|  +- org.springframework:spring-oxm:jar:6.2.12:compile
|  +- org.springframework:spring-aop:jar:6.2.12:compile
|  +- org.springframework:spring-context-support:jar:6.2.12:compile
|  \- org.slf4j:slf4j-api:jar:2.0.17:compile
+- io.lettuce:lettuce-core:jar:6.4.2.RELEASE:compile
|  +- io.netty:netty-common:jar:4.1.127.Final:compile
|  +- io.netty:netty-handler:jar:4.1.127.Final:compile
|  |  +- io.netty:netty-resolver:jar:4.1.127.Final:compile
|  |  +- io.netty:netty-buffer:jar:4.1.127.Final:compile
|  |  +- io.netty:netty-transport-native-unix-common:jar:4.1.127.Final:compile
|  |  \- io.netty:netty-codec:jar:4.1.127.Final:compile
|  +- io.netty:netty-transport:jar:4.1.127.Final:compile
|  \- io.projectreactor:reactor-core:jar:3.7.12:compile
|     \- org.reactivestreams:reactive-streams:jar:1.0.4:compile
+- org.apache.commons:commons-pool2:jar:2.12.1:compile
+- org.springframework.boot:spring-boot-starter-web:jar:3.4.11:compile
|  +- org.springframework.boot:spring-boot-starter:jar:3.4.11:compile
|  |  +- org.springframework.boot:spring-boot:jar:3.4.11:compile
|  |  +- org.springframework.boot:spring-boot-autoconfigure:jar:3.4.11:compile
|  |  +- org.springframework.boot:spring-boot-starter-logging:jar:3.4.11:compile
|  |  |  +- ch.qos.logback:logback-classic:jar:1.5.20:compile
|  |  |  |  \- ch.qos.logback:logback-core:jar:1.5.20:compile
|  |  |  +- org.apache.logging.log4j:log4j-to-slf4j:jar:2.24.3:compile
|  |  |  |  \- org.apache.logging.log4j:log4j-api:jar:2.24.3:compile
|  |  |  \- org.slf4j:jul-to-slf4j:jar:2.0.17:compile
|  |  +- jakarta.annotation:jakarta.annotation-api:jar:2.1.1:compile
|  |  \- org.yaml:snakeyaml:jar:2.3:compile
|  +- org.springframework.boot:spring-boot-starter-json:jar:3.4.11:compile
|  |  +- com.fasterxml.jackson.core:jackson-databind:jar:2.18.4:compile
|  |  |  +- com.fasterxml.jackson.core:jackson-annotations:jar:2.18.4:compile
|  |  |  \- com.fasterxml.jackson.core:jackson-core:jar:2.18.4.1:compile
|  |  +- com.fasterxml.jackson.datatype:jackson-datatype-jdk8:jar:2.18.4:compile
|  |  +- com.fasterxml.jackson.datatype:jackson-datatype-jsr310:jar:2.18.4:compile
|  |  \- com.fasterxml.jackson.module:jackson-module-parameter-names:jar:2.18.4:compile
|  +- org.springframework.boot:spring-boot-starter-tomcat:jar:3.4.11:compile
|  |  +- org.apache.tomcat.embed:tomcat-embed-core:jar:10.1.48:compile
|  |  +- org.apache.tomcat.embed:tomcat-embed-el:jar:10.1.48:compile
|  |  \- org.apache.tomcat.embed:tomcat-embed-websocket:jar:10.1.48:compile
|  +- org.springframework:spring-web:jar:6.2.12:compile
|  |  \- io.micrometer:micrometer-observation:jar:1.14.12:compile
|  |     \- io.micrometer:micrometer-commons:jar:1.14.12:compile
|  \- org.springframework:spring-webmvc:jar:6.2.12:compile
|     \- org.springframework:spring-expression:jar:6.2.12:compile
+- org.projectlombok:lombok:jar:1.18.42:provided
+- org.springframework.boot:spring-boot-starter-test:jar:3.4.11:test
|  +- org.springframework.boot:spring-boot-test:jar:3.4.11:test
|  +- org.springframework.boot:spring-boot-test-autoconfigure:jar:3.4.11:test
|  +- com.jayway.jsonpath:json-path:jar:2.9.0:test
|  +- jakarta.xml.bind:jakarta.xml.bind-api:jar:4.0.4:runtime
|  |  \- jakarta.activation:jakarta.activation-api:jar:2.1.4:runtime
|  +- net.minidev:json-smart:jar:2.5.2:test
|  |  \- net.minidev:accessors-smart:jar:2.5.2:test
|  |     \- org.ow2.asm:asm:jar:9.7.1:test
|  +- org.assertj:assertj-core:jar:3.26.3:test
|  |  \- net.bytebuddy:byte-buddy:jar:1.15.11:test
|  +- org.awaitility:awaitility:jar:4.2.2:test
|  +- org.hamcrest:hamcrest:jar:2.2:test
|  +- org.junit.jupiter:junit-jupiter:jar:5.11.4:test
|  |  +- org.junit.jupiter:junit-jupiter-api:jar:5.11.4:test
|  |  |  +- org.opentest4j:opentest4j:jar:1.3.0:test
|  |  |  +- org.junit.platform:junit-platform-commons:jar:1.11.4:test
|  |  |  \- org.apiguardian:apiguardian-api:jar:1.1.2:test
|  |  +- org.junit.jupiter:junit-jupiter-params:jar:5.11.4:test
|  |  \- org.junit.jupiter:junit-jupiter-engine:jar:5.11.4:test
|  |     \- org.junit.platform:junit-platform-engine:jar:1.11.4:test
|  +- org.mockito:mockito-core:jar:5.14.2:test
|  |  +- net.bytebuddy:byte-buddy-agent:jar:1.15.11:test
|  |  \- org.objenesis:objenesis:jar:3.3:test
|  +- org.mockito:mockito-junit-jupiter:jar:5.14.2:test
|  +- org.skyscreamer:jsonassert:jar:1.5.3:test
|  |  \- com.vaadin.external.google:android-json:jar:0.0.20131108.vaadin1:test
|  +- org.springframework:spring-core:jar:6.2.12:compile
|  |  \- org.springframework:spring-jcl:jar:6.2.12:compile
|  +- org.springframework:spring-test:jar:6.2.12:test
|  \- org.xmlunit:xmlunit-core:jar:2.10.4:test
\- org.mapstruct:mapstruct:jar:1.4.2.Final:compile
+- org.projectlombok:lombok:jar:1.18.34:compile
\- org.mapstruct:mapstruct:jar:1.4.2.Final:compile
+- org.projectlombok:lombok:jar:1.18.34:compile
\- org.mapstruct:mapstruct:jar:1.4.2.Final:compile
+- org.projectlombok:lombok:jar:1.18.34:compile
\- org.mapstruct:mapstruct:jar:1.4.2.Final:compile
+- org.apache.maven:maven-plugin-api:jar:3.9.6:provided
|  +- org.apache.maven:maven-model:jar:3.9.6:provided
|  +- org.apache.maven:maven-artifact:jar:3.9.6:provided
|  +- org.eclipse.sisu:org.eclipse.sisu.plexus:jar:0.9.0.M2:provided
|  |  +- javax.annotation:javax.annotation-api:jar:1.2:provided
|  |  +- org.eclipse.sisu:org.eclipse.sisu.inject:jar:0.9.0.M2:provided
|  |  \- org.codehaus.plexus:plexus-component-annotations:jar:2.1.0:provided
|  +- org.codehaus.plexus:plexus-utils:jar:3.5.1:provided
|  \- org.codehaus.plexus:plexus-classworlds:jar:2.7.0:provided
+- org.apache.maven.plugin-tools:maven-plugin-annotations:jar:3.10.2:provided
+- com.github.spullara.mustache.java:compiler:jar:0.9.11:compile
+- com.github.jsqlparser:jsqlparser:jar:4.8:compile
+- org.projectlombok:lombok:jar:1.18.30:provided
+- org.apache.commons:commons-text:jar:1.11.0:compile
|  \- org.apache.commons:commons-lang3:jar:3.18.0:compile
+- org.slf4j:slf4j-api:jar:2.0.11:compile
+- org.jboss.weld.se:weld-se-core:jar:5.1.2.Final:compile
|  +- org.jboss.weld.environment:weld-environment-common:jar:5.1.2.Final:compile
|  |  \- org.jboss.weld:weld-core-impl:jar:5.1.2.Final:compile
|  |     +- org.jboss.weld:weld-api:jar:5.0.SP3:compile
|  |     +- org.jboss.weld:weld-spi:jar:5.0.SP3:compile
|  |     +- jakarta.el:jakarta.el-api:jar:5.0.1:compile
|  |     \- org.jboss.logging:jboss-logging:jar:3.6.1.Final:compile
|  +- org.jboss.weld:weld-lite-extension-translator:jar:5.1.2.Final:compile
|  |  +- jakarta.interceptor:jakarta.interceptor-api:jar:2.1.0:compile
|  |  \- org.jboss.logging:jboss-logging-processor:jar:2.2.1.Final:compile
|  |     +- org.jboss.logging:jboss-logging-annotations:jar:2.2.1.Final:compile
|  |     \- org.jboss.jdeparser:jdeparser:jar:2.0.3.Final:compile
|  +- jakarta.enterprise:jakarta.enterprise.cdi-api:jar:4.0.1:compile
|  |  +- jakarta.enterprise:jakarta.enterprise.lang-model:jar:4.0.1:compile
|  |  +- jakarta.annotation:jakarta.annotation-api:jar:2.1.1:compile
|  |  \- jakarta.inject:jakarta.inject-api:jar:2.0.1:compile
|  \- org.jboss.classfilewriter:jboss-classfilewriter:jar:1.3.0.Final:compile
+- org.junit.jupiter:junit-jupiter:jar:RELEASE:test
|  +- org.junit.jupiter:junit-jupiter-api:jar:5.11.4:test
|  |  +- org.opentest4j:opentest4j:jar:1.3.0:test
|  |  +- org.junit.platform:junit-platform-commons:jar:1.11.4:test
|  |  \- org.apiguardian:apiguardian-api:jar:1.1.2:test
|  +- org.junit.jupiter:junit-jupiter-params:jar:5.11.4:test
|  \- org.junit.jupiter:junit-jupiter-engine:jar:5.11.4:test
|     \- org.junit.platform:junit-platform-engine:jar:1.11.4:test
+- org.mockito:mockito-junit-jupiter:jar:5.10.0:test
|  \- org.mockito:mockito-core:jar:5.14.2:test
|     +- net.bytebuddy:byte-buddy:jar:1.15.11:test
|     +- net.bytebuddy:byte-buddy-agent:jar:1.15.11:test
|     \- org.objenesis:objenesis:jar:3.3:test
+- com.google.jimfs:jimfs:jar:1.3.0:test
|  \- com.google.guava:guava:jar:32.1.1-jre:test
|     +- com.google.guava:failureaccess:jar:1.0.1:test
|     +- com.google.guava:listenablefuture:jar:9999.0-empty-to-avoid-conflict-with-guava:test
|     +- com.google.code.findbugs:jsr305:jar:3.0.2:test
|     +- org.checkerframework:checker-qual:jar:3.33.0:test
|     +- com.google.errorprone:error_prone_annotations:jar:2.18.0:test
|     \- com.google.j2objc:j2objc-annotations:jar:2.8:test
+- org.hamcrest:hamcrest:jar:2.2:test
\- org.mapstruct:mapstruct:jar:1.4.2.Final:compile
+- org.openapitools:openapi-generator:jar:7.9.0:provided
|  +- io.swagger.parser.v3:swagger-parser:jar:2.1.22:provided
|  |  +- io.swagger.parser.v3:swagger-parser-v2-converter:jar:2.1.22:provided
|  |  |  +- io.swagger:swagger-core:jar:1.6.14:provided
|  |  |  |  +- jakarta.xml.bind:jakarta.xml.bind-api:jar:4.0.4:provided
|  |  |  |  |  \- jakarta.activation:jakarta.activation-api:jar:2.1.4:provided
|  |  |  |  \- io.swagger:swagger-models:jar:1.6.14:provided
|  |  |  |     \- io.swagger:swagger-annotations:jar:1.6.14:provided
|  |  |  +- io.swagger:swagger-parser:jar:1.0.70:provided
|  |  |  |  \- io.swagger:swagger-parser-safe-url-resolver:jar:1.0.70:provided
|  |  |  +- io.swagger:swagger-compat-spec-parser:jar:1.0.70:provided
|  |  |  |  +- com.github.java-json-tools:json-schema-validator:jar:2.2.14:provided
|  |  |  |  |  +- com.github.java-json-tools:jackson-coreutils-equivalence:jar:1.0:provided
|  |  |  |  |  +- com.github.java-json-tools:json-schema-core:jar:1.2.14:provided
|  |  |  |  |  |  +- com.github.java-json-tools:uri-template:jar:0.10:provided
|  |  |  |  |  |  \- org.mozilla:rhino:jar:1.7.7.2:provided
|  |  |  |  |  +- com.googlecode.libphonenumber:libphonenumber:jar:8.11.1:provided
|  |  |  |  |  \- net.sf.jopt-simple:jopt-simple:jar:5.0.4:provided
|  |  |  |  +- com.github.java-json-tools:json-patch:jar:1.13:provided
|  |  |  |  |  +- com.github.java-json-tools:msg-simple:jar:1.2:provided
|  |  |  |  |  |  \- com.github.java-json-tools:btf:jar:1.3:provided
|  |  |  |  |  \- com.github.java-json-tools:jackson-coreutils:jar:2.0:provided
|  |  |  |  \- org.apache.httpcomponents:httpclient:jar:4.5.14:provided
|  |  |  |     +- org.apache.httpcomponents:httpcore:jar:4.4.16:provided
|  |  |  |     +- commons-logging:commons-logging:jar:1.2:provided
|  |  |  |     \- commons-codec:commons-codec:jar:1.17.2:provided
|  |  |  +- io.swagger.core.v3:swagger-models:jar:2.2.21:provided
|  |  |  \- io.swagger.parser.v3:swagger-parser-core:jar:2.1.22:provided
|  |  +- io.swagger.parser.v3:swagger-parser-v3:jar:2.1.22:provided
|  |  |  +- io.swagger.core.v3:swagger-core:jar:2.2.21:provided
|  |  |  |  +- com.fasterxml.jackson.datatype:jackson-datatype-jsr310:jar:2.18.4:provided
|  |  |  |  +- io.swagger.core.v3:swagger-annotations:jar:2.2.21:provided
|  |  |  |  \- jakarta.validation:jakarta.validation-api:jar:3.0.2:provided
|  |  |  +- io.swagger.parser.v3:swagger-parser-safe-url-resolver:jar:2.1.22:provided
|  |  |  \- com.fasterxml.jackson.dataformat:jackson-dataformat-yaml:jar:2.18.4:provided
|  |  \- org.yaml:snakeyaml:jar:2.3:provided
|  +- com.samskivert:jmustache:jar:1.16:provided
|  +- com.github.jknack:handlebars:jar:4.3.1:provided
|  +- com.github.jknack:handlebars-jackson2:jar:4.3.1:provided
|  +- commons-io:commons-io:jar:2.16.1:provided
|  +- org.slf4j:slf4j-ext:jar:2.0.17:provided
|  +- org.slf4j:slf4j-api:jar:2.0.17:provided
|  +- org.slf4j:slf4j-simple:jar:2.0.17:provided
|  +- org.apache.commons:commons-lang3:jar:3.18.0:provided
|  +- org.apache.commons:commons-text:jar:1.10.0:provided
|  +- org.apache.maven.resolver:maven-resolver-util:jar:1.9.18:provided
|  |  \- org.apache.maven.resolver:maven-resolver-api:jar:1.9.18:provided
|  +- commons-cli:commons-cli:jar:1.5.0:provided
|  +- com.google.guava:guava:jar:32.1.3-jre:provided
|  |  +- com.google.guava:failureaccess:jar:1.0.1:provided
|  |  +- com.google.guava:listenablefuture:jar:9999.0-empty-to-avoid-conflict-with-guava:provided
|  |  +- com.google.code.findbugs:jsr305:jar:3.0.2:provided
|  |  +- org.checkerframework:checker-qual:jar:3.37.0:provided
|  |  +- com.google.errorprone:error_prone_annotations:jar:2.21.1:provided
|  |  \- com.google.j2objc:j2objc-annotations:jar:2.8:provided
|  +- com.fasterxml.jackson.datatype:jackson-datatype-guava:jar:2.18.4:provided
|  |  \- com.fasterxml.jackson.core:jackson-core:jar:2.18.4.1:provided
|  +- org.commonmark:commonmark:jar:0.21.0:provided
|  +- com.github.mifmif:generex:jar:1.0.2:provided
|  |  \- dk.brics.automaton:automaton:jar:1.11-8:provided
|  +- com.github.curious-odd-man:rgxgen:jar:1.4:provided
|  +- com.fasterxml.jackson.core:jackson-databind:jar:2.18.4:provided
|  +- com.fasterxml.jackson.datatype:jackson-datatype-joda:jar:2.18.4:provided
|  |  \- joda-time:joda-time:jar:2.12.7:provided
|  +- com.fasterxml.jackson.core:jackson-annotations:jar:2.18.4:provided
|  +- com.github.joschi.jackson:jackson-datatype-threetenbp:jar:2.15.2:provided
|  |  \- org.threeten:threetenbp:jar:1.6.8:provided
|  +- org.openapitools:openapi-generator-core:jar:7.9.0:provided
|  +- net.java.dev.jna:jna:jar:5.12.1:provided
|  \- com.github.ben-manes.caffeine:caffeine:jar:3.1.8:provided
+- org.junit.jupiter:junit-jupiter:jar:RELEASE:test
|  +- org.junit.jupiter:junit-jupiter-api:jar:5.11.4:test
|  |  +- org.opentest4j:opentest4j:jar:1.3.0:test
|  |  +- org.junit.platform:junit-platform-commons:jar:1.11.4:test
|  |  \- org.apiguardian:apiguardian-api:jar:1.1.2:test
|  +- org.junit.jupiter:junit-jupiter-params:jar:5.11.4:test
|  \- org.junit.jupiter:junit-jupiter-engine:jar:5.11.4:test
|     \- org.junit.platform:junit-platform-engine:jar:1.11.4:test
+- org.projectlombok:lombok:jar:1.18.34:compile
\- org.mapstruct:mapstruct:jar:1.4.2.Final:compile
+- org.apache.maven:maven-plugin-api:jar:3.9.6:provided
|  +- org.apache.maven:maven-model:jar:3.9.6:provided
|  +- org.apache.maven:maven-artifact:jar:3.9.6:provided
|  +- org.eclipse.sisu:org.eclipse.sisu.plexus:jar:0.9.0.M2:provided
|  |  +- javax.annotation:javax.annotation-api:jar:1.2:provided
|  |  +- org.eclipse.sisu:org.eclipse.sisu.inject:jar:0.9.0.M2:provided
|  |  \- org.codehaus.plexus:plexus-component-annotations:jar:2.1.0:provided
|  +- org.codehaus.plexus:plexus-utils:jar:3.5.1:provided
|  \- org.codehaus.plexus:plexus-classworlds:jar:2.7.0:provided
+- org.apache.maven.plugin-tools:maven-plugin-annotations:jar:3.10.2:provided
+- com.fasterxml.jackson.core:jackson-databind:jar:2.16.1:compile
|  +- com.fasterxml.jackson.core:jackson-annotations:jar:2.18.4:compile
|  \- com.fasterxml.jackson.core:jackson-core:jar:2.18.4.1:compile
+- com.github.spullara.mustache.java:compiler:jar:0.9.11:compile
+- org.projectlombok:lombok:jar:1.18.30:provided
+- org.slf4j:slf4j-api:jar:2.0.11:compile
+- org.jboss.weld.se:weld-se-core:jar:5.1.2.Final:compile
|  +- org.jboss.weld.environment:weld-environment-common:jar:5.1.2.Final:compile
|  |  \- org.jboss.weld:weld-core-impl:jar:5.1.2.Final:compile
|  |     +- org.jboss.weld:weld-api:jar:5.0.SP3:compile
|  |     +- org.jboss.weld:weld-spi:jar:5.0.SP3:compile
|  |     +- jakarta.el:jakarta.el-api:jar:5.0.1:compile
|  |     \- org.jboss.logging:jboss-logging:jar:3.6.1.Final:compile
|  +- org.jboss.weld:weld-lite-extension-translator:jar:5.1.2.Final:compile
|  |  +- jakarta.interceptor:jakarta.interceptor-api:jar:2.1.0:compile
|  |  \- org.jboss.logging:jboss-logging-processor:jar:2.2.1.Final:compile
|  |     +- org.jboss.logging:jboss-logging-annotations:jar:2.2.1.Final:compile
|  |     \- org.jboss.jdeparser:jdeparser:jar:2.0.3.Final:compile
|  +- jakarta.enterprise:jakarta.enterprise.cdi-api:jar:4.0.1:compile
|  |  +- jakarta.enterprise:jakarta.enterprise.lang-model:jar:4.0.1:compile
|  |  +- jakarta.annotation:jakarta.annotation-api:jar:2.1.1:compile
|  |  \- jakarta.inject:jakarta.inject-api:jar:2.0.1:compile
|  \- org.jboss.classfilewriter:jboss-classfilewriter:jar:1.3.0.Final:compile
+- org.apache.commons:commons-text:jar:1.11.0:compile
|  \- org.apache.commons:commons-lang3:jar:3.18.0:compile
+- org.junit.jupiter:junit-jupiter-engine:jar:5.10.2:test
|  +- org.junit.platform:junit-platform-engine:jar:1.10.2:test
|  |  +- org.opentest4j:opentest4j:jar:1.3.0:test
|  |  \- org.junit.platform:junit-platform-commons:jar:1.10.2:test
|  +- org.junit.jupiter:junit-jupiter-api:jar:5.10.2:test
|  \- org.apiguardian:apiguardian-api:jar:1.1.2:test
+- org.junit.jupiter:junit-jupiter-params:jar:5.10.2:test
+- org.mockito:mockito-core:jar:5.10.0:test
|  +- net.bytebuddy:byte-buddy:jar:1.15.11:test
|  +- net.bytebuddy:byte-buddy-agent:jar:1.15.11:test
|  \- org.objenesis:objenesis:jar:3.3:test
+- org.mockito:mockito-junit-jupiter:jar:5.10.0:test
+- org.hamcrest:hamcrest:jar:2.2:test
+- org.jboss.weld:weld-junit5:jar:4.0.2.Final:test
|  \- org.jboss.weld:weld-junit-common:jar:4.0.2.Final:test
|     +- jakarta.persistence:jakarta.persistence-api:jar:3.1.0:test
|     \- com.github.spotbugs:spotbugs-annotations:jar:4.8.6:test
+- com.google.jimfs:jimfs:jar:1.3.0:test
|  \- com.google.guava:guava:jar:32.1.1-jre:test
|     +- com.google.guava:failureaccess:jar:1.0.1:test
|     +- com.google.guava:listenablefuture:jar:9999.0-empty-to-avoid-conflict-with-guava:test
|     +- com.google.code.findbugs:jsr305:jar:3.0.2:test
|     +- org.checkerframework:checker-qual:jar:3.33.0:test
|     +- com.google.errorprone:error_prone_annotations:jar:2.18.0:test
|     \- com.google.j2objc:j2objc-annotations:jar:2.8:test
+- commons-io:commons-io:jar:2.16.1:compile
\- org.mapstruct:mapstruct:jar:1.4.2.Final:compile
+- org.jcommander:jcommander:jar:1.83:compile
+- com.fasterxml.jackson.core:jackson-databind:jar:2.17.2:compile
+- com.fasterxml.jackson.core:jackson-core:jar:2.17.2:compile
+- com.fasterxml.jackson.core:jackson-annotations:jar:2.17.2:compile
+- org.slf4j:slf4j-api:jar:2.0.13:compile
+- org.slf4j:slf4j-simple:jar:2.0.13:compile
+- org.projectlombok:lombok:jar:1.18.30:provided
+- org.apache.commons:commons-text:jar:1.11.0:compile
|  \- org.apache.commons:commons-lang3:jar:3.18.0:compile
+- ch.qos.logback:logback-classic:jar:1.4.14:compile
|  \- ch.qos.logback:logback-core:jar:1.5.20:compile
+- com.altec.bsbr.fwk.jab:fwk-jab-lib-core:jar:3.0.1:compile
|  +- org.springframework:spring-core:jar:6.2.12:compile
|  |  \- org.springframework:spring-jcl:jar:6.2.12:compile
|  +- org.springframework:spring-context:jar:6.2.12:compile
|  |  +- org.springframework:spring-beans:jar:6.2.12:compile
|  |  +- org.springframework:spring-expression:jar:6.2.12:compile
|  |  \- io.micrometer:micrometer-observation:jar:1.14.12:compile
|  |     \- io.micrometer:micrometer-commons:jar:1.14.12:compile
|  +- org.springframework:spring-aop:jar:6.2.12:compile
|  +- org.slf4j:jcl-over-slf4j:jar:2.0.17:compile
|  +- joda-time:joda-time:jar:2.9.9:compile
|  +- org.aspectj:aspectjweaver:jar:1.9.24:compile
|  +- org.aspectj:aspectjtools:jar:1.9.24:compile
|  +- org.aspectj:aspectjrt:jar:1.9.24:compile
|  \- commons-logging:commons-logging:jar:1.2:compile
+- com.altec.bsbr.fwk.jab:fwk-jab-lib-jms:jar:3.0.1:compile
|  +- org.springframework:spring-jms:jar:6.2.12:compile
|  |  +- org.springframework:spring-messaging:jar:6.2.12:compile
|  |  \- org.springframework:spring-tx:jar:6.2.12:compile
|  \- org.springframework:spring-context-support:jar:6.2.12:compile
+- com.altec.bsbr.fwk.jab:fwk-jab-conector-altair-mq:jar:3.2.5:compile
|  +- com.altec.bsbr.fwk.jab:fwk-jab-lib-psFormat:jar:2.3.2:compile
|  +- org.springframework:spring-web:jar:6.2.12:compile
|  +- com.altec.bsbr.fwk.jab:fwk-jab-conector-altair-core:jar:3.1.2:compile
|  +- commons-codec:commons-codec:jar:1.17.2:compile
|  +- org.powermock:powermock-api-mockito2:jar:2.0.9:compile
|  |  \- org.powermock:powermock-api-support:jar:2.0.9:compile
|  |     +- org.powermock:powermock-reflect:jar:2.0.9:compile
|  |     \- org.powermock:powermock-core:jar:2.0.9:compile
|  |        \- org.javassist:javassist:jar:3.27.0-GA:compile
|  \- org.powermock:powermock-module-junit4:jar:2.0.9:compile
|     +- org.powermock:powermock-module-junit4-common:jar:2.0.9:compile
|     +- junit:junit:jar:4.13.2:compile
|     \- org.hamcrest:hamcrest-core:jar:2.2:compile
+- com.ibm.mq:com.ibm.mq.jakarta.client:jar:9.4.1.1:compile
|  +- org.bouncycastle:bcprov-jdk18on:jar:1.78.1:compile
|  +- org.bouncycastle:bcpkix-jdk18on:jar:1.78.1:compile
|  +- org.bouncycastle:bcutil-jdk18on:jar:1.78.1:compile
|  \- org.json:json:jar:20231013:compile
+- org.junit.jupiter:junit-jupiter-engine:jar:5.11.4:test
|  +- org.junit.platform:junit-platform-engine:jar:1.11.4:test
|  |  +- org.opentest4j:opentest4j:jar:1.3.0:test
|  |  \- org.junit.platform:junit-platform-commons:jar:1.11.4:test
|  +- org.junit.jupiter:junit-jupiter-api:jar:5.11.4:test
|  \- org.apiguardian:apiguardian-api:jar:1.1.2:test
+- org.junit.jupiter:junit-jupiter-params:jar:5.11.4:test
+- org.mockito:mockito-core:jar:5.12.0:test
|  +- net.bytebuddy:byte-buddy:jar:1.15.11:compile
|  +- net.bytebuddy:byte-buddy-agent:jar:1.15.11:compile
|  \- org.objenesis:objenesis:jar:3.3:compile
+- org.mockito:mockito-junit-jupiter:jar:5.12.0:test
+- org.hamcrest:hamcrest:jar:2.2:test
+- commons-io:commons-io:jar:2.15.1:compile
+- jakarta.jms:jakarta.jms-api:jar:3.1.0:compile
\- org.mapstruct:mapstruct:jar:1.4.2.Final:compile
+- org.projectlombok:lombok:jar:1.18.34:compile
\- org.mapstruct:mapstruct:jar:1.4.2.Final:compile
+- org.projectlombok:lombok:jar:1.18.34:compile
\- org.mapstruct:mapstruct:jar:1.4.2.Final:compile
+- org.jsoup:jsoup:jar:1.18.1:compile
+- org.postgresql:postgresql:jar:42.7.8:compile
|  \- org.checkerframework:checker-qual:jar:3.49.5:runtime
+- com.h2database:h2:jar:2.3.232:runtime
+- commons-io:commons-io:jar:2.16.0:compile
+- org.springframework.boot:spring-boot-starter-data-jpa:jar:3.4.11:compile
|  +- org.springframework.boot:spring-boot-starter:jar:3.4.11:compile
|  |  +- org.springframework.boot:spring-boot:jar:3.4.11:compile
|  |  +- org.springframework.boot:spring-boot-autoconfigure:jar:3.4.11:compile
|  |  +- org.springframework.boot:spring-boot-starter-logging:jar:3.4.11:compile
|  |  |  +- org.apache.logging.log4j:log4j-to-slf4j:jar:2.24.3:compile
|  |  |  |  \- org.apache.logging.log4j:log4j-api:jar:2.24.3:compile
|  |  |  \- org.slf4j:jul-to-slf4j:jar:2.0.17:compile
|  |  \- org.yaml:snakeyaml:jar:2.3:compile
|  +- org.springframework.boot:spring-boot-starter-jdbc:jar:3.4.11:compile
|  |  +- com.zaxxer:HikariCP:jar:5.1.0:compile
|  |  \- org.springframework:spring-jdbc:jar:6.2.12:compile
|  +- org.hibernate.orm:hibernate-core:jar:6.6.33.Final:compile
|  |  +- jakarta.persistence:jakarta.persistence-api:jar:3.1.0:compile
|  |  +- jakarta.transaction:jakarta.transaction-api:jar:2.0.1:compile
|  |  +- org.jboss.logging:jboss-logging:jar:3.6.1.Final:compile
|  |  +- org.hibernate.common:hibernate-commons-annotations:jar:7.0.3.Final:runtime
|  |  +- io.smallrye:jandex:jar:3.2.0:runtime
|  |  +- com.fasterxml:classmate:jar:1.7.1:compile
|  |  +- jakarta.xml.bind:jakarta.xml.bind-api:jar:4.0.4:compile
|  |  |  \- jakarta.activation:jakarta.activation-api:jar:2.1.4:compile
|  |  +- org.glassfish.jaxb:jaxb-runtime:jar:4.0.6:runtime
|  |  |  \- org.glassfish.jaxb:jaxb-core:jar:4.0.6:runtime
|  |  |     +- org.eclipse.angus:angus-activation:jar:2.0.3:runtime
|  |  |     +- org.glassfish.jaxb:txw2:jar:4.0.6:runtime
|  |  |     \- com.sun.istack:istack-commons-runtime:jar:4.1.2:runtime
|  |  +- jakarta.inject:jakarta.inject-api:jar:2.0.1:runtime
|  |  \- org.antlr:antlr4-runtime:jar:4.13.0:compile
|  +- org.springframework.data:spring-data-jpa:jar:3.4.11:compile
|  |  +- org.springframework.data:spring-data-commons:jar:3.4.11:compile
|  |  +- org.springframework:spring-orm:jar:6.2.12:compile
|  |  +- org.springframework:spring-tx:jar:6.2.12:compile
|  |  \- org.slf4j:slf4j-api:jar:2.0.17:compile
|  \- org.springframework:spring-aspects:jar:6.2.12:compile
+- org.springframework.boot:spring-boot-starter-webflux:jar:3.4.11:compile
|  +- org.springframework.boot:spring-boot-starter-json:jar:3.4.11:compile
|  |  +- com.fasterxml.jackson.core:jackson-databind:jar:2.18.4:compile
|  |  |  +- com.fasterxml.jackson.core:jackson-annotations:jar:2.18.4:compile
|  |  |  \- com.fasterxml.jackson.core:jackson-core:jar:2.18.4.1:compile
|  |  +- com.fasterxml.jackson.datatype:jackson-datatype-jdk8:jar:2.18.4:compile
|  |  +- com.fasterxml.jackson.datatype:jackson-datatype-jsr310:jar:2.18.4:compile
|  |  \- com.fasterxml.jackson.module:jackson-module-parameter-names:jar:2.18.4:compile
|  +- org.springframework.boot:spring-boot-starter-reactor-netty:jar:3.4.11:compile
|  |  \- io.projectreactor.netty:reactor-netty-http:jar:1.2.11:compile
|  |     +- io.netty:netty-codec-http:jar:4.1.127.Final:compile
|  |     |  +- io.netty:netty-common:jar:4.1.127.Final:compile
|  |     |  +- io.netty:netty-buffer:jar:4.1.127.Final:compile
|  |     |  +- io.netty:netty-transport:jar:4.1.127.Final:compile
|  |     |  +- io.netty:netty-codec:jar:4.1.127.Final:compile
|  |     |  \- io.netty:netty-handler:jar:4.1.127.Final:compile
|  |     +- io.netty:netty-codec-http2:jar:4.1.127.Final:compile
|  |     +- io.netty:netty-resolver-dns:jar:4.1.127.Final:compile
|  |     |  +- io.netty:netty-resolver:jar:4.1.127.Final:compile
|  |     |  \- io.netty:netty-codec-dns:jar:4.1.127.Final:compile
|  |     +- io.netty:netty-resolver-dns-native-macos:jar:osx-x86_64:4.1.127.Final:compile
|  |     |  \- io.netty:netty-resolver-dns-classes-macos:jar:4.1.127.Final:compile
|  |     +- io.netty:netty-transport-native-epoll:jar:linux-x86_64:4.1.127.Final:compile
|  |     |  +- io.netty:netty-transport-native-unix-common:jar:4.1.127.Final:compile
|  |     |  \- io.netty:netty-transport-classes-epoll:jar:4.1.127.Final:compile
|  |     \- io.projectreactor.netty:reactor-netty-core:jar:1.2.11:compile
|  |        \- io.netty:netty-handler-proxy:jar:4.1.127.Final:compile
|  |           \- io.netty:netty-codec-socks:jar:4.1.127.Final:compile
|  +- org.springframework:spring-web:jar:6.2.12:compile
|  |  \- io.micrometer:micrometer-observation:jar:1.14.12:compile
|  |     \- io.micrometer:micrometer-commons:jar:1.14.12:compile
|  \- org.springframework:spring-webflux:jar:6.2.12:compile
|     \- io.projectreactor:reactor-core:jar:3.7.12:compile
|        \- org.reactivestreams:reactive-streams:jar:1.0.4:compile
+- org.springframework.security:spring-security-web:jar:6.4.12:compile
|  +- org.springframework.security:spring-security-core:jar:6.4.12:compile
|  |  \- org.springframework.security:spring-security-crypto:jar:6.4.12:compile
|  +- org.springframework:spring-core:jar:6.2.12:compile
|  |  \- org.springframework:spring-jcl:jar:6.2.12:compile
|  +- org.springframework:spring-aop:jar:6.2.12:compile
|  +- org.springframework:spring-beans:jar:6.2.12:compile
|  +- org.springframework:spring-context:jar:6.2.12:compile
|  \- org.springframework:spring-expression:jar:6.2.12:compile
+- com.santander.ars:gln-back-arsenal-backend-api-starter:jar:3.18.12-SNAPSHOT:compile
|  +- jakarta.servlet:jakarta.servlet-api:jar:6.0.0:compile
|  +- org.springframework:spring-webmvc:jar:6.2.12:compile
|  +- org.springframework.cloud:spring-cloud-starter-openfeign:jar:4.2.2:compile
|  |  +- org.springframework.cloud:spring-cloud-starter:jar:4.2.2:compile
|  |  |  +- org.springframework.cloud:spring-cloud-context:jar:4.2.2:compile
|  |  |  \- org.bouncycastle:bcprov-jdk18on:jar:1.78.1:compile
|  |  +- org.springframework.cloud:spring-cloud-openfeign-core:jar:4.2.2:compile
|  |  |  \- io.github.openfeign:feign-form-spring:jar:13.5:compile
|  |  |     +- io.github.openfeign:feign-form:jar:13.5:compile
|  |  |     \- commons-fileupload:commons-fileupload:jar:1.6.0:compile
|  |  +- org.springframework.cloud:spring-cloud-commons:jar:4.2.2:compile
|  |  +- io.github.openfeign:feign-core:jar:13.5:compile
|  |  \- io.github.openfeign:feign-slf4j:jar:13.5:compile
|  +- org.springdoc:springdoc-openapi-starter-webmvc-ui:jar:2.8.6:compile
|  |  +- org.springdoc:springdoc-openapi-starter-webmvc-api:jar:2.8.6:compile
|  |  |  \- org.springdoc:springdoc-openapi-starter-common:jar:2.8.6:compile
|  |  |     \- io.swagger.core.v3:swagger-core-jakarta:jar:2.2.29:compile
|  |  |        +- io.swagger.core.v3:swagger-annotations-jakarta:jar:2.2.29:compile
|  |  |        +- io.swagger.core.v3:swagger-models-jakarta:jar:2.2.29:compile
|  |  |        \- com.fasterxml.jackson.dataformat:jackson-dataformat-yaml:jar:2.18.4:compile
|  |  +- org.webjars:swagger-ui:jar:5.20.1:compile
|  |  \- org.webjars:webjars-locator-lite:jar:1.0.1:compile
|  |     \- org.jspecify:jspecify:jar:1.0.0:compile
|  +- org.springframework.boot:spring-boot-starter-actuator:jar:3.4.11:compile
|  |  +- org.springframework.boot:spring-boot-actuator-autoconfigure:jar:3.4.11:compile
|  |  |  \- org.springframework.boot:spring-boot-actuator:jar:3.4.11:compile
|  |  \- io.micrometer:micrometer-jakarta9:jar:1.14.12:compile
|  |     \- io.micrometer:micrometer-core:jar:1.14.12:compile
|  |        +- org.hdrhistogram:HdrHistogram:jar:2.2.2:runtime
|  |        \- org.latencyutils:LatencyUtils:jar:2.0.3:runtime
|  +- org.apache.maven:maven-model:jar:3.9.4:compile
|  |  \- org.codehaus.plexus:plexus-utils:jar:3.5.1:compile
|  +- io.github.resilience4j:resilience4j-spring-boot2:jar:2.2.0:compile
|  |  +- io.github.resilience4j:resilience4j-spring:jar:2.2.0:compile
|  |  |  +- io.github.resilience4j:resilience4j-annotations:jar:2.2.0:compile
|  |  |  +- io.github.resilience4j:resilience4j-consumer:jar:2.2.0:compile
|  |  |  |  \- io.github.resilience4j:resilience4j-circularbuffer:jar:2.2.0:runtime
|  |  |  \- io.github.resilience4j:resilience4j-framework-common:jar:2.2.0:compile
|  |  \- io.github.resilience4j:resilience4j-micrometer:jar:2.2.0:compile
|  +- org.springframework.boot:spring-boot-starter-aop:jar:3.4.11:compile
|  +- org.junit.jupiter:junit-jupiter-api:jar:5.11.4:compile
|  |  +- org.opentest4j:opentest4j:jar:1.3.0:compile
|  |  +- org.junit.platform:junit-platform-commons:jar:1.11.4:compile
|  |  \- org.apiguardian:apiguardian-api:jar:1.1.2:compile
|  +- org.junit.jupiter:junit-jupiter-engine:jar:5.11.4:compile
|  |  \- org.junit.platform:junit-platform-engine:jar:1.11.4:compile
|  +- org.mockito:mockito-core:jar:5.14.2:compile
|  |  \- org.objenesis:objenesis:jar:3.3:runtime
|  +- org.mockito:mockito-junit-jupiter:jar:5.14.2:compile
|  \- org.springframework:spring-test:jar:6.2.12:compile
+- com.santander.ars:gln-back-arsenal-backend-error-starter:jar:3.18.12-SNAPSHOT:compile
|  +- org.springframework:spring-messaging:jar:6.2.12:compile
|  +- jakarta.validation:jakarta.validation-api:jar:3.0.2:compile
|  +- jakarta.annotation:jakarta.annotation-api:jar:2.1.1:compile
|  +- org.hibernate.validator:hibernate-validator:jar:8.0.3.Final:compile
|  +- org.hibernate.validator:hibernate-validator-annotation-processor:jar:8.0.3.Final:compile
|  +- org.springframework.boot:spring-boot-starter-web:jar:3.4.11:compile
|  |  \- org.springframework.boot:spring-boot-starter-tomcat:jar:3.4.11:compile
|  |     +- org.apache.tomcat.embed:tomcat-embed-core:jar:10.1.48:compile
|  |     +- org.apache.tomcat.embed:tomcat-embed-el:jar:10.1.48:compile
|  |     \- org.apache.tomcat.embed:tomcat-embed-websocket:jar:10.1.48:compile
|  +- io.github.resilience4j:resilience4j-bulkhead:jar:2.2.0:compile
|  |  \- io.github.resilience4j:resilience4j-core:jar:2.2.0:compile
|  +- io.github.resilience4j:resilience4j-circuitbreaker:jar:2.2.0:compile
|  +- io.github.resilience4j:resilience4j-retry:jar:2.2.0:compile
|  +- io.github.resilience4j:resilience4j-ratelimiter:jar:2.2.0:compile
|  \- io.github.resilience4j:resilience4j-timelimiter:jar:2.2.0:compile
+- com.santander.ars:gln-back-arsenal-global-observability-starter:jar:3.18.12-SNAPSHOT:compile
|  +- io.micrometer:micrometer-tracing:jar:1.4.11:compile
|  |  +- io.micrometer:context-propagation:jar:1.1.3:compile
|  |  \- aopalliance:aopalliance:jar:1.0:compile
|  +- io.micrometer:micrometer-tracing-bridge-brave:jar:1.4.11:compile
|  |  +- io.zipkin.brave:brave:jar:6.0.3:compile
|  |  +- io.zipkin.brave:brave-context-slf4j:jar:6.0.3:compile
|  |  +- io.zipkin.brave:brave-instrumentation-http:jar:6.0.3:compile
|  |  +- io.zipkin.aws:brave-propagation-aws:jar:1.2.5:compile
|  |  \- io.zipkin.contrib.brave-propagation-w3c:brave-propagation-tracecontext:jar:0.2.0:compile
|  +- com.santander.ars:gln-back-arsenal-log-core:jar:3.18.12-SNAPSHOT:compile
|  +- com.santander.ars:gln-back-arsenal-logback-core:jar:3.18.12-SNAPSHOT:compile
|  |  +- com.santander.ars:gln-back-arsenal-logback-kafka-appender:jar:3.18.12-SNAPSHOT:compile
|  |  |  +- org.xerial.snappy:snappy-java:jar:1.1.10.7:compile
|  |  |  \- org.apache.kafka:kafka-clients:jar:3.9.1:compile
|  |  |     +- com.github.luben:zstd-jni:jar:1.5.6-4:runtime
|  |  |     \- org.lz4:lz4-java:jar:1.8.0:runtime
|  |  +- ch.qos.logback:logback-classic:jar:1.5.20:compile
|  |  +- ch.qos.logback.contrib:logback-json-classic:jar:0.1.5:compile
|  |  |  \- ch.qos.logback.contrib:logback-json-core:jar:0.1.5:compile
|  |  \- ch.qos.logback.contrib:logback-jackson:jar:0.1.5:compile
|  +- ch.qos.logback:logback-core:jar:1.5.20:compile
|  +- net.logstash.logback:logstash-logback-encoder:jar:7.3:compile
|  +- org.apache.commons:commons-text:jar:1.10.0:compile
|  |  \- org.apache.commons:commons-lang3:jar:3.18.0:compile
|  +- org.json:json:jar:20231013:compile
|  \- org.aspectj:aspectjweaver:jar:1.9.24:compile
+- com.santander.ars:gln-back-arsenal-backend-test-starter:jar:3.18.12-SNAPSHOT:test
|  +- org.junit.jupiter:junit-jupiter:jar:5.11.4:test
|  |  \- org.junit.jupiter:junit-jupiter-params:jar:5.11.4:test
|  +- org.junit.vintage:junit-vintage-engine:jar:5.11.4:test
|  |  \- junit:junit:jar:4.13.2:test
|  +- net.bytebuddy:byte-buddy:jar:1.15.11:compile
|  +- net.bytebuddy:byte-buddy-agent:jar:1.15.11:compile
|  +- org.hamcrest:hamcrest-library:jar:2.2:test
|  |  \- org.hamcrest:hamcrest-core:jar:2.2:test
|  +- com.tngtech.archunit:archunit-junit5-api:jar:1.3.0:test
|  |  \- com.tngtech.archunit:archunit:jar:1.3.0:test
|  +- com.tngtech.archunit:archunit-junit5-engine:jar:1.3.0:test
|  |  \- com.tngtech.archunit:archunit-junit5-engine-api:jar:1.3.0:test
|  +- org.springframework.boot:spring-boot-starter-test:jar:3.4.11:test
|  |  +- org.springframework.boot:spring-boot-test:jar:3.4.11:test
|  |  +- org.springframework.boot:spring-boot-test-autoconfigure:jar:3.4.11:test
|  |  +- com.jayway.jsonpath:json-path:jar:2.9.0:test
|  |  +- net.minidev:json-smart:jar:2.5.2:test
|  |  |  \- net.minidev:accessors-smart:jar:2.5.2:test
|  |  |     \- org.ow2.asm:asm:jar:9.7.1:test
|  |  +- org.assertj:assertj-core:jar:3.26.3:test
|  |  +- org.awaitility:awaitility:jar:4.2.2:test
|  |  +- org.skyscreamer:jsonassert:jar:1.5.3:test
|  |  |  \- com.vaadin.external.google:android-json:jar:0.0.20131108.vaadin1:test
|  |  \- org.xmlunit:xmlunit-core:jar:2.10.4:test
|  +- io.cucumber:cucumber-java:jar:7.21.0:test
|  |  \- io.cucumber:cucumber-core:jar:7.21.0:test
|  |     +- io.cucumber:cucumber-gherkin:jar:7.21.0:test
|  |     +- io.cucumber:cucumber-gherkin-messages:jar:7.21.0:test
|  |     |  \- io.cucumber:gherkin:jar:31.0.0:test
|  |     +- io.cucumber:messages:jar:27.2.0:test
|  |     +- io.cucumber:testng-xml-formatter:jar:0.3.1:test
|  |     |  \- io.cucumber:query:jar:13.6.0:test
|  |     +- io.cucumber:tag-expressions:jar:6.1.2:test
|  |     +- io.cucumber:cucumber-expressions:jar:18.0.1:test
|  |     +- io.cucumber:datatable:jar:7.21.0:test
|  |     +- io.cucumber:cucumber-plugin:jar:7.21.0:test
|  |     +- io.cucumber:docstring:jar:7.21.0:test
|  |     +- io.cucumber:html-formatter:jar:21.9.0:test
|  |     +- io.cucumber:junit-xml-formatter:jar:0.7.1:test
|  |     \- io.cucumber:ci-environment:jar:10.0.1:test
|  +- io.cucumber:cucumber-spring:jar:7.21.0:test
|  \- io.cucumber:cucumber-junit:jar:7.21.0:test
+- io.rest-assured:rest-assured:jar:5.5.6:test
|  +- org.apache.groovy:groovy:jar:4.0.29:test
|  +- org.apache.groovy:groovy-xml:jar:4.0.29:test
|  +- org.apache.httpcomponents:httpclient:jar:4.5.13:test
|  |  +- org.apache.httpcomponents:httpcore:jar:4.4.16:test
|  |  +- commons-logging:commons-logging:jar:1.2:test
|  |  \- commons-codec:commons-codec:jar:1.17.2:test
|  +- org.apache.httpcomponents:httpmime:jar:4.5.13:test
|  +- org.hamcrest:hamcrest:jar:2.2:test
|  +- org.ccil.cowan.tagsoup:tagsoup:jar:1.2.1:test
|  +- io.rest-assured:json-path:jar:5.5.6:test
|  |  +- org.apache.groovy:groovy-json:jar:4.0.29:test
|  |  \- io.rest-assured:rest-assured-common:jar:5.5.6:test
|  \- io.rest-assured:xml-path:jar:5.5.6:test
+- org.projectlombok:lombok:jar:1.18.34:compile
\- org.mapstruct:mapstruct:jar:1.4.2.Final:compile
+- com.santander.ars:gln-back-arsenal-backend-api-starter:jar:3.18.12-SNAPSHOT:compile
|  +- jakarta.servlet:jakarta.servlet-api:jar:6.0.0:compile
|  +- org.springframework:spring-web:jar:6.2.12:compile
|  |  \- io.micrometer:micrometer-observation:jar:1.14.12:compile
|  |     \- io.micrometer:micrometer-commons:jar:1.14.12:compile
|  +- org.springframework:spring-webmvc:jar:6.2.12:compile
|  +- org.springframework.cloud:spring-cloud-starter-openfeign:jar:4.2.2:compile
|  |  +- org.springframework.cloud:spring-cloud-starter:jar:4.2.2:compile
|  |  |  +- org.springframework.cloud:spring-cloud-context:jar:4.2.2:compile
|  |  |  \- org.bouncycastle:bcprov-jdk18on:jar:1.78.1:compile
|  |  +- org.springframework.cloud:spring-cloud-openfeign-core:jar:4.2.2:compile
|  |  |  +- org.springframework.boot:spring-boot-autoconfigure:jar:3.4.11:compile
|  |  |  \- io.github.openfeign:feign-form-spring:jar:13.5:compile
|  |  |     +- io.github.openfeign:feign-form:jar:13.5:compile
|  |  |     \- commons-fileupload:commons-fileupload:jar:1.6.0:compile
|  |  +- org.springframework.cloud:spring-cloud-commons:jar:4.2.2:compile
|  |  \- io.github.openfeign:feign-slf4j:jar:13.5:compile
|  +- commons-io:commons-io:jar:2.16.1:compile
|  +- org.springdoc:springdoc-openapi-starter-webmvc-ui:jar:2.8.6:compile
|  |  +- org.springdoc:springdoc-openapi-starter-webmvc-api:jar:2.8.6:compile
|  |  |  \- org.springdoc:springdoc-openapi-starter-common:jar:2.8.6:compile
|  |  |     \- io.swagger.core.v3:swagger-core-jakarta:jar:2.2.29:compile
|  |  |        +- io.swagger.core.v3:swagger-annotations-jakarta:jar:2.2.29:compile
|  |  |        +- io.swagger.core.v3:swagger-models-jakarta:jar:2.2.29:compile
|  |  |        \- com.fasterxml.jackson.dataformat:jackson-dataformat-yaml:jar:2.18.4:compile
|  |  +- org.webjars:swagger-ui:jar:5.20.1:compile
|  |  \- org.webjars:webjars-locator-lite:jar:1.0.1:compile
|  |     \- org.jspecify:jspecify:jar:1.0.0:compile
|  +- org.springframework.boot:spring-boot-starter-actuator:jar:3.4.11:compile
|  |  +- org.springframework.boot:spring-boot-starter:jar:3.4.11:compile
|  |  |  +- org.springframework.boot:spring-boot:jar:3.4.11:compile
|  |  |  +- org.springframework.boot:spring-boot-starter-logging:jar:3.4.11:compile
|  |  |  |  +- org.apache.logging.log4j:log4j-to-slf4j:jar:2.24.3:compile
|  |  |  |  |  \- org.apache.logging.log4j:log4j-api:jar:2.24.3:compile
|  |  |  |  \- org.slf4j:jul-to-slf4j:jar:2.0.17:compile
|  |  |  +- jakarta.annotation:jakarta.annotation-api:jar:2.1.1:compile
|  |  |  \- org.yaml:snakeyaml:jar:2.3:compile
|  |  +- org.springframework.boot:spring-boot-actuator-autoconfigure:jar:3.4.11:compile
|  |  |  \- org.springframework.boot:spring-boot-actuator:jar:3.4.11:compile
|  |  \- io.micrometer:micrometer-jakarta9:jar:1.14.12:compile
|  |     \- io.micrometer:micrometer-core:jar:1.14.12:compile
|  |        +- org.hdrhistogram:HdrHistogram:jar:2.2.2:runtime
|  |        \- org.latencyutils:LatencyUtils:jar:2.0.3:runtime
|  +- org.apache.maven:maven-model:jar:3.9.4:compile
|  |  \- org.codehaus.plexus:plexus-utils:jar:3.5.1:compile
|  +- io.github.resilience4j:resilience4j-spring-boot2:jar:2.2.0:compile
|  |  +- io.github.resilience4j:resilience4j-spring:jar:2.2.0:compile
|  |  |  +- io.github.resilience4j:resilience4j-annotations:jar:2.2.0:compile
|  |  |  +- io.github.resilience4j:resilience4j-consumer:jar:2.2.0:compile
|  |  |  |  \- io.github.resilience4j:resilience4j-circularbuffer:jar:2.2.0:runtime
|  |  |  \- io.github.resilience4j:resilience4j-framework-common:jar:2.2.0:compile
|  |  +- org.slf4j:slf4j-api:jar:2.0.17:compile
|  |  \- io.github.resilience4j:resilience4j-micrometer:jar:2.2.0:compile
|  +- org.springframework.boot:spring-boot-starter-aop:jar:3.4.11:compile
|  +- org.junit.jupiter:junit-jupiter-api:jar:5.11.4:compile
|  |  +- org.opentest4j:opentest4j:jar:1.3.0:compile
|  |  +- org.junit.platform:junit-platform-commons:jar:1.11.4:compile
|  |  \- org.apiguardian:apiguardian-api:jar:1.1.2:compile
|  +- org.junit.jupiter:junit-jupiter-engine:jar:5.11.4:compile
|  |  \- org.junit.platform:junit-platform-engine:jar:1.11.4:compile
|  +- org.mockito:mockito-core:jar:5.14.2:compile
|  |  \- org.objenesis:objenesis:jar:3.3:runtime
|  +- org.mockito:mockito-junit-jupiter:jar:5.14.2:compile
|  \- org.springframework:spring-test:jar:6.2.12:compile
+- com.santander.ars:gln-back-arsenal-backend-gluon-error-starter:jar:3.18.12-SNAPSHOT:compile
|  +- com.santander.ars:gln-back-arsenal-core:jar:3.18.12-SNAPSHOT:compile
|  |  \- com.santander.ars:gln-back-arsenal-backend-core:jar:3.18.12-SNAPSHOT:compile
|  +- org.hibernate.orm:hibernate-core:jar:6.6.33.Final:compile
|  |  +- jakarta.persistence:jakarta.persistence-api:jar:3.1.0:compile
|  |  +- jakarta.transaction:jakarta.transaction-api:jar:2.0.1:compile
|  |  +- org.jboss.logging:jboss-logging:jar:3.6.1.Final:compile
|  |  +- org.hibernate.common:hibernate-commons-annotations:jar:7.0.3.Final:runtime
|  |  +- io.smallrye:jandex:jar:3.2.0:runtime
|  |  +- com.fasterxml:classmate:jar:1.7.1:compile
|  |  +- jakarta.xml.bind:jakarta.xml.bind-api:jar:4.0.4:compile
|  |  |  \- jakarta.activation:jakarta.activation-api:jar:2.1.4:compile
|  |  +- org.glassfish.jaxb:jaxb-runtime:jar:4.0.6:runtime
|  |  |  \- org.glassfish.jaxb:jaxb-core:jar:4.0.6:runtime
|  |  |     +- org.eclipse.angus:angus-activation:jar:2.0.3:runtime
|  |  |     +- org.glassfish.jaxb:txw2:jar:4.0.6:runtime
|  |  |     \- com.sun.istack:istack-commons-runtime:jar:4.1.2:runtime
|  |  +- jakarta.inject:jakarta.inject-api:jar:2.0.1:runtime
|  |  \- org.antlr:antlr4-runtime:jar:4.13.0:runtime
|  +- org.springframework:spring-messaging:jar:6.2.12:compile
|  +- org.hibernate.validator:hibernate-validator:jar:8.0.3.Final:compile
|  |  \- jakarta.validation:jakarta.validation-api:jar:3.0.2:compile
|  +- org.springframework.security:spring-security-core:jar:6.4.12:compile
|  |  \- org.springframework.security:spring-security-crypto:jar:6.4.12:compile
|  +- org.springframework.boot:spring-boot-starter-web:jar:3.4.11:compile
|  |  \- org.springframework.boot:spring-boot-starter-tomcat:jar:3.4.11:compile
|  |     +- org.apache.tomcat.embed:tomcat-embed-core:jar:10.1.48:compile
|  |     +- org.apache.tomcat.embed:tomcat-embed-el:jar:10.1.48:compile
|  |     \- org.apache.tomcat.embed:tomcat-embed-websocket:jar:10.1.48:compile
|  +- io.github.resilience4j:resilience4j-circuitbreaker:jar:2.2.0:compile
|  |  \- io.github.resilience4j:resilience4j-core:jar:2.2.0:compile
|  +- io.github.resilience4j:resilience4j-retry:jar:2.2.0:compile
|  +- io.github.resilience4j:resilience4j-ratelimiter:jar:2.2.0:compile
|  +- io.github.resilience4j:resilience4j-timelimiter:jar:2.2.0:compile
|  \- io.github.resilience4j:resilience4j-bulkhead:jar:2.2.0:compile
+- com.santander.ars:gln-back-arsenal-global-observability-starter:jar:3.18.12-SNAPSHOT:compile
|  +- io.micrometer:micrometer-tracing:jar:1.4.11:compile
|  |  +- io.micrometer:context-propagation:jar:1.1.3:compile
|  |  \- aopalliance:aopalliance:jar:1.0:compile
|  +- io.micrometer:micrometer-tracing-bridge-brave:jar:1.4.11:compile
|  |  +- io.zipkin.brave:brave:jar:6.0.3:compile
|  |  +- io.zipkin.brave:brave-context-slf4j:jar:6.0.3:compile
|  |  +- io.zipkin.brave:brave-instrumentation-http:jar:6.0.3:compile
|  |  +- io.zipkin.aws:brave-propagation-aws:jar:1.2.5:compile
|  |  \- io.zipkin.contrib.brave-propagation-w3c:brave-propagation-tracecontext:jar:0.2.0:compile
|  +- org.springframework.boot:spring-boot-starter-json:jar:3.4.11:compile
|  |  +- com.fasterxml.jackson.core:jackson-databind:jar:2.18.4:compile
|  |  |  +- com.fasterxml.jackson.core:jackson-annotations:jar:2.18.4:compile
|  |  |  \- com.fasterxml.jackson.core:jackson-core:jar:2.18.4.1:compile
|  |  +- com.fasterxml.jackson.datatype:jackson-datatype-jdk8:jar:2.18.4:compile
|  |  +- com.fasterxml.jackson.datatype:jackson-datatype-jsr310:jar:2.18.4:compile
|  |  \- com.fasterxml.jackson.module:jackson-module-parameter-names:jar:2.18.4:compile
|  +- com.santander.ars:gln-back-arsenal-log-core:jar:3.18.12-SNAPSHOT:compile
|  +- com.santander.ars:gln-back-arsenal-logback-core:jar:3.18.12-SNAPSHOT:compile
|  |  +- com.santander.ars:gln-back-arsenal-logback-kafka-appender:jar:3.18.12-SNAPSHOT:compile
|  |  |  +- org.xerial.snappy:snappy-java:jar:1.1.10.7:compile
|  |  |  \- org.apache.kafka:kafka-clients:jar:3.9.1:compile
|  |  |     +- com.github.luben:zstd-jni:jar:1.5.6-4:runtime
|  |  |     \- org.lz4:lz4-java:jar:1.8.0:runtime
|  |  +- ch.qos.logback:logback-classic:jar:1.5.20:compile
|  |  +- ch.qos.logback.contrib:logback-json-classic:jar:0.1.5:compile
|  |  |  \- ch.qos.logback.contrib:logback-json-core:jar:0.1.5:compile
|  |  \- ch.qos.logback.contrib:logback-jackson:jar:0.1.5:compile
|  +- ch.qos.logback:logback-core:jar:1.5.20:compile
|  +- net.logstash.logback:logstash-logback-encoder:jar:7.3:compile
|  +- org.apache.commons:commons-text:jar:1.10.0:compile
|  |  \- org.apache.commons:commons-lang3:jar:3.18.0:compile
|  +- org.json:json:jar:20231013:compile
|  +- org.aspectj:aspectjweaver:jar:1.9.24:compile
|  \- org.springframework.boot:spring-boot-starter-webflux:jar:3.4.11:compile
|     +- org.springframework.boot:spring-boot-starter-reactor-netty:jar:3.4.11:compile
|     |  \- io.projectreactor.netty:reactor-netty-http:jar:1.2.11:compile
|     |     +- io.netty:netty-codec-http:jar:4.1.127.Final:compile
|     |     |  +- io.netty:netty-common:jar:4.1.127.Final:compile
|     |     |  +- io.netty:netty-buffer:jar:4.1.127.Final:compile
|     |     |  +- io.netty:netty-transport:jar:4.1.127.Final:compile
|     |     |  +- io.netty:netty-codec:jar:4.1.127.Final:compile
|     |     |  \- io.netty:netty-handler:jar:4.1.127.Final:compile
|     |     +- io.netty:netty-codec-http2:jar:4.1.127.Final:compile
|     |     +- io.netty:netty-resolver-dns:jar:4.1.127.Final:compile
|     |     |  +- io.netty:netty-resolver:jar:4.1.127.Final:compile
|     |     |  \- io.netty:netty-codec-dns:jar:4.1.127.Final:compile
|     |     +- io.netty:netty-resolver-dns-native-macos:jar:osx-x86_64:4.1.127.Final:compile
|     |     |  \- io.netty:netty-resolver-dns-classes-macos:jar:4.1.127.Final:compile
|     |     +- io.netty:netty-transport-native-epoll:jar:linux-x86_64:4.1.127.Final:compile
|     |     |  +- io.netty:netty-transport-native-unix-common:jar:4.1.127.Final:compile
|     |     |  \- io.netty:netty-transport-classes-epoll:jar:4.1.127.Final:compile
|     |     \- io.projectreactor.netty:reactor-netty-core:jar:1.2.11:compile
|     |        \- io.netty:netty-handler-proxy:jar:4.1.127.Final:compile
|     |           \- io.netty:netty-codec-socks:jar:4.1.127.Final:compile
|     \- org.springframework:spring-webflux:jar:6.2.12:compile
|        \- io.projectreactor:reactor-core:jar:3.7.12:compile
|           \- org.reactivestreams:reactive-streams:jar:1.0.4:compile
+- com.santander.ars:gln-back-arsenal-backend-test-starter:jar:3.18.12-SNAPSHOT:test
|  +- org.junit.jupiter:junit-jupiter:jar:5.11.4:test
|  |  \- org.junit.jupiter:junit-jupiter-params:jar:5.11.4:test
|  +- org.junit.vintage:junit-vintage-engine:jar:5.11.4:test
|  |  \- junit:junit:jar:4.13.2:test
|  +- net.bytebuddy:byte-buddy:jar:1.15.11:compile
|  +- net.bytebuddy:byte-buddy-agent:jar:1.15.11:compile
|  +- org.hamcrest:hamcrest-library:jar:2.2:test
|  |  \- org.hamcrest:hamcrest-core:jar:2.2:test
|  +- com.tngtech.archunit:archunit-junit5-api:jar:1.3.0:test
|  |  \- com.tngtech.archunit:archunit:jar:1.3.0:test
|  +- com.tngtech.archunit:archunit-junit5-engine:jar:1.3.0:test
|  |  \- com.tngtech.archunit:archunit-junit5-engine-api:jar:1.3.0:test
|  +- org.springframework.boot:spring-boot-starter-test:jar:3.4.11:test
|  |  +- org.springframework.boot:spring-boot-test:jar:3.4.11:test
|  |  +- org.springframework.boot:spring-boot-test-autoconfigure:jar:3.4.11:test
|  |  +- com.jayway.jsonpath:json-path:jar:2.9.0:test
|  |  +- net.minidev:json-smart:jar:2.5.2:test
|  |  |  \- net.minidev:accessors-smart:jar:2.5.2:test
|  |  |     \- org.ow2.asm:asm:jar:9.7.1:test
|  |  +- org.assertj:assertj-core:jar:3.26.3:test
|  |  +- org.awaitility:awaitility:jar:4.2.2:test
|  |  +- org.skyscreamer:jsonassert:jar:1.5.3:test
|  |  |  \- com.vaadin.external.google:android-json:jar:0.0.20131108.vaadin1:test
|  |  \- org.xmlunit:xmlunit-core:jar:2.10.4:test
|  +- io.cucumber:cucumber-java:jar:7.21.0:test
|  |  \- io.cucumber:cucumber-core:jar:7.21.0:test
|  |     +- io.cucumber:cucumber-gherkin:jar:7.21.0:test
|  |     +- io.cucumber:cucumber-gherkin-messages:jar:7.21.0:test
|  |     |  \- io.cucumber:gherkin:jar:31.0.0:test
|  |     +- io.cucumber:messages:jar:27.2.0:test
|  |     +- io.cucumber:testng-xml-formatter:jar:0.3.1:test
|  |     |  \- io.cucumber:query:jar:13.6.0:test
|  |     +- io.cucumber:tag-expressions:jar:6.1.2:test
|  |     +- io.cucumber:cucumber-expressions:jar:18.0.1:test
|  |     +- io.cucumber:datatable:jar:7.21.0:test
|  |     +- io.cucumber:cucumber-plugin:jar:7.21.0:test
|  |     +- io.cucumber:docstring:jar:7.21.0:test
|  |     +- io.cucumber:html-formatter:jar:21.9.0:test
|  |     +- io.cucumber:junit-xml-formatter:jar:0.7.1:test
|  |     \- io.cucumber:ci-environment:jar:10.0.1:test
|  +- io.cucumber:cucumber-spring:jar:7.21.0:test
|  \- io.cucumber:cucumber-junit:jar:7.21.0:test
+- org.springframework.security:spring-security-web:jar:6.4.12:compile
|  +- org.springframework:spring-core:jar:6.2.12:compile
|  |  \- org.springframework:spring-jcl:jar:6.2.12:compile
|  +- org.springframework:spring-aop:jar:6.2.12:compile
|  +- org.springframework:spring-beans:jar:6.2.12:compile
|  +- org.springframework:spring-context:jar:6.2.12:compile
|  \- org.springframework:spring-expression:jar:6.2.12:compile
+- io.rest-assured:rest-assured:jar:5.5.6:test
|  +- org.apache.groovy:groovy:jar:4.0.29:test
|  +- org.apache.groovy:groovy-xml:jar:4.0.29:test
|  +- org.apache.httpcomponents:httpclient:jar:4.5.13:test
|  |  +- org.apache.httpcomponents:httpcore:jar:4.4.16:test
|  |  +- commons-logging:commons-logging:jar:1.2:test
|  |  \- commons-codec:commons-codec:jar:1.17.2:test
|  +- org.apache.httpcomponents:httpmime:jar:4.5.13:test
|  +- org.hamcrest:hamcrest:jar:2.2:test
|  +- org.ccil.cowan.tagsoup:tagsoup:jar:1.2.1:test
|  +- io.rest-assured:json-path:jar:5.5.6:test
|  |  +- org.apache.groovy:groovy-json:jar:4.0.29:test
|  |  \- io.rest-assured:rest-assured-common:jar:5.5.6:test
|  \- io.rest-assured:xml-path:jar:5.5.6:test
+- io.github.openfeign:feign-okhttp:jar:13.5:test
|  +- io.github.openfeign:feign-core:jar:13.5:compile
|  \- com.squareup.okhttp3:okhttp:jar:4.12.0:test
|     +- com.squareup.okio:okio:jar:3.6.0:test
|     |  \- com.squareup.okio:okio-jvm:jar:3.6.0:test
|     |     \- org.jetbrains.kotlin:kotlin-stdlib-common:jar:1.9.25:test
|     \- org.jetbrains.kotlin:kotlin-stdlib-jdk8:jar:1.9.25:test
|        +- org.jetbrains.kotlin:kotlin-stdlib:jar:1.9.25:test
|        |  \- org.jetbrains:annotations:jar:13.0:test
|        \- org.jetbrains.kotlin:kotlin-stdlib-jdk7:jar:1.9.25:test
+- org.projectlombok:lombok:jar:1.18.34:compile
\- org.mapstruct:mapstruct:jar:1.4.2.Final:compile
+- com.h2database:h2:jar:2.3.232:runtime
+- org.springframework.boot:spring-boot-starter-data-jpa:jar:3.4.11:compile
|  +- org.springframework.boot:spring-boot-starter:jar:3.4.11:compile
|  |  +- org.springframework.boot:spring-boot:jar:3.4.11:compile
|  |  +- org.springframework.boot:spring-boot-autoconfigure:jar:3.4.11:compile
|  |  \- org.springframework.boot:spring-boot-starter-logging:jar:3.4.11:compile
|  |     +- org.apache.logging.log4j:log4j-to-slf4j:jar:2.24.3:compile
|  |     |  \- org.apache.logging.log4j:log4j-api:jar:2.24.3:compile
|  |     \- org.slf4j:jul-to-slf4j:jar:2.0.17:compile
|  +- org.springframework.boot:spring-boot-starter-jdbc:jar:3.4.11:compile
|  |  +- com.zaxxer:HikariCP:jar:5.1.0:compile
|  |  \- org.springframework:spring-jdbc:jar:6.2.12:compile
|  +- org.springframework.data:spring-data-jpa:jar:3.4.11:compile
|  |  +- org.springframework.data:spring-data-commons:jar:3.4.11:compile
|  |  +- org.springframework:spring-orm:jar:6.2.12:compile
|  |  +- org.springframework:spring-tx:jar:6.2.12:compile
|  |  \- org.slf4j:slf4j-api:jar:2.0.17:compile
|  \- org.springframework:spring-aspects:jar:6.2.12:compile
|     \- org.aspectj:aspectjweaver:jar:1.9.24:compile
+- org.springframework.boot:spring-boot-starter-webflux:jar:3.4.11:compile
|  +- org.springframework.boot:spring-boot-starter-json:jar:3.4.11:compile
|  |  +- com.fasterxml.jackson.datatype:jackson-datatype-jdk8:jar:2.18.4:compile
|  |  +- com.fasterxml.jackson.datatype:jackson-datatype-jsr310:jar:2.18.4:compile
|  |  \- com.fasterxml.jackson.module:jackson-module-parameter-names:jar:2.18.4:compile
|  +- org.springframework.boot:spring-boot-starter-reactor-netty:jar:3.4.11:compile
|  |  \- io.projectreactor.netty:reactor-netty-http:jar:1.2.11:compile
|  |     +- io.netty:netty-codec-http:jar:4.1.127.Final:compile
|  |     |  +- io.netty:netty-common:jar:4.1.127.Final:compile
|  |     |  +- io.netty:netty-buffer:jar:4.1.127.Final:compile
|  |     |  +- io.netty:netty-transport:jar:4.1.127.Final:compile
|  |     |  +- io.netty:netty-codec:jar:4.1.127.Final:compile
|  |     |  \- io.netty:netty-handler:jar:4.1.127.Final:compile
|  |     +- io.netty:netty-codec-http2:jar:4.1.127.Final:compile
|  |     +- io.netty:netty-resolver-dns:jar:4.1.127.Final:compile
|  |     |  +- io.netty:netty-resolver:jar:4.1.127.Final:compile
|  |     |  \- io.netty:netty-codec-dns:jar:4.1.127.Final:compile
|  |     +- io.netty:netty-resolver-dns-native-macos:jar:osx-x86_64:4.1.127.Final:compile
|  |     |  \- io.netty:netty-resolver-dns-classes-macos:jar:4.1.127.Final:compile
|  |     +- io.netty:netty-transport-native-epoll:jar:linux-x86_64:4.1.127.Final:compile
|  |     |  +- io.netty:netty-transport-native-unix-common:jar:4.1.127.Final:compile
|  |     |  \- io.netty:netty-transport-classes-epoll:jar:4.1.127.Final:compile
|  |     \- io.projectreactor.netty:reactor-netty-core:jar:1.2.11:compile
|  |        \- io.netty:netty-handler-proxy:jar:4.1.127.Final:compile
|  |           \- io.netty:netty-codec-socks:jar:4.1.127.Final:compile
|  +- org.springframework:spring-web:jar:6.2.12:compile
|  |  \- io.micrometer:micrometer-observation:jar:1.14.12:compile
|  |     \- io.micrometer:micrometer-commons:jar:1.14.12:compile
|  \- org.springframework:spring-webflux:jar:6.2.12:compile
|     \- io.projectreactor:reactor-core:jar:3.7.12:compile
|        \- org.reactivestreams:reactive-streams:jar:1.0.4:compile
+- org.jsoup:jsoup:jar:1.18.1:compile
+- org.springframework.security:spring-security-web:jar:6.4.12:compile
|  +- org.springframework.security:spring-security-core:jar:6.4.12:compile
|  |  \- org.springframework.security:spring-security-crypto:jar:6.4.12:compile
|  +- org.springframework:spring-core:jar:6.2.12:compile
|  |  \- org.springframework:spring-jcl:jar:6.2.12:compile
|  +- org.springframework:spring-aop:jar:6.2.12:compile
|  +- org.springframework:spring-beans:jar:6.2.12:compile
|  +- org.springframework:spring-context:jar:6.2.12:compile
|  \- org.springframework:spring-expression:jar:6.2.12:compile
+- com.santander.ars:gln-back-arsenal-backend-api-starter:jar:3.18.12-SNAPSHOT:compile
|  +- jakarta.servlet:jakarta.servlet-api:jar:6.0.0:compile
|  +- org.springframework:spring-webmvc:jar:6.2.12:compile
|  +- org.springframework.cloud:spring-cloud-starter-openfeign:jar:4.2.2:compile
|  |  +- org.springframework.cloud:spring-cloud-starter:jar:4.2.2:compile
|  |  |  +- org.springframework.cloud:spring-cloud-context:jar:4.2.2:compile
|  |  |  \- org.bouncycastle:bcprov-jdk18on:jar:1.78.1:compile
|  |  +- org.springframework.cloud:spring-cloud-openfeign-core:jar:4.2.2:compile
|  |  |  \- io.github.openfeign:feign-form-spring:jar:13.5:compile
|  |  |     +- io.github.openfeign:feign-form:jar:13.5:compile
|  |  |     \- commons-fileupload:commons-fileupload:jar:1.6.0:compile
|  |  +- org.springframework.cloud:spring-cloud-commons:jar:4.2.2:compile
|  |  +- io.github.openfeign:feign-core:jar:13.5:compile
|  |  \- io.github.openfeign:feign-slf4j:jar:13.5:compile
|  +- commons-io:commons-io:jar:2.16.1:compile
|  +- org.springdoc:springdoc-openapi-starter-webmvc-ui:jar:2.8.6:compile
|  |  +- org.springdoc:springdoc-openapi-starter-webmvc-api:jar:2.8.6:compile
|  |  |  \- org.springdoc:springdoc-openapi-starter-common:jar:2.8.6:compile
|  |  |     \- io.swagger.core.v3:swagger-core-jakarta:jar:2.2.29:compile
|  |  |        +- io.swagger.core.v3:swagger-annotations-jakarta:jar:2.2.29:compile
|  |  |        +- io.swagger.core.v3:swagger-models-jakarta:jar:2.2.29:compile
|  |  |        \- com.fasterxml.jackson.dataformat:jackson-dataformat-yaml:jar:2.18.4:compile
|  |  +- org.webjars:swagger-ui:jar:5.20.1:compile
|  |  \- org.webjars:webjars-locator-lite:jar:1.0.1:compile
|  |     \- org.jspecify:jspecify:jar:1.0.0:compile
|  +- org.springframework.boot:spring-boot-starter-actuator:jar:3.4.11:compile
|  |  +- org.springframework.boot:spring-boot-actuator-autoconfigure:jar:3.4.11:compile
|  |  |  \- org.springframework.boot:spring-boot-actuator:jar:3.4.11:compile
|  |  \- io.micrometer:micrometer-jakarta9:jar:1.14.12:compile
|  |     \- io.micrometer:micrometer-core:jar:1.14.12:compile
|  |        +- org.hdrhistogram:HdrHistogram:jar:2.2.2:runtime
|  |        \- org.latencyutils:LatencyUtils:jar:2.0.3:runtime
|  +- org.apache.maven:maven-model:jar:3.9.4:compile
|  |  \- org.codehaus.plexus:plexus-utils:jar:3.5.1:compile
|  +- io.github.resilience4j:resilience4j-spring-boot2:jar:2.2.0:compile
|  |  +- io.github.resilience4j:resilience4j-spring:jar:2.2.0:compile
|  |  |  +- io.github.resilience4j:resilience4j-annotations:jar:2.2.0:compile
|  |  |  +- io.github.resilience4j:resilience4j-consumer:jar:2.2.0:compile
|  |  |  |  \- io.github.resilience4j:resilience4j-circularbuffer:jar:2.2.0:runtime
|  |  |  \- io.github.resilience4j:resilience4j-framework-common:jar:2.2.0:compile
|  |  \- io.github.resilience4j:resilience4j-micrometer:jar:2.2.0:compile
|  +- org.springframework.boot:spring-boot-starter-aop:jar:3.4.11:compile
|  +- org.junit.jupiter:junit-jupiter-api:jar:5.11.4:compile
|  |  +- org.opentest4j:opentest4j:jar:1.3.0:compile
|  |  +- org.junit.platform:junit-platform-commons:jar:1.11.4:compile
|  |  \- org.apiguardian:apiguardian-api:jar:1.1.2:compile
|  +- org.junit.jupiter:junit-jupiter-engine:jar:5.11.4:compile
|  |  \- org.junit.platform:junit-platform-engine:jar:1.11.4:compile
|  +- org.mockito:mockito-core:jar:5.14.2:compile
|  |  \- org.objenesis:objenesis:jar:3.3:runtime
|  +- org.mockito:mockito-junit-jupiter:jar:5.14.2:compile
|  \- org.springframework:spring-test:jar:6.2.12:compile
+- com.santander.ars:gln-back-arsenal-backend-error-starter:jar:3.18.12-SNAPSHOT:compile
|  +- org.springframework:spring-messaging:jar:6.2.12:compile
|  +- jakarta.validation:jakarta.validation-api:jar:3.0.2:compile
|  +- jakarta.annotation:jakarta.annotation-api:jar:2.1.1:compile
|  +- org.hibernate.validator:hibernate-validator:jar:8.0.3.Final:compile
|  +- org.hibernate.validator:hibernate-validator-annotation-processor:jar:8.0.3.Final:compile
|  +- org.springframework.boot:spring-boot-starter-web:jar:3.4.11:compile
|  |  \- org.springframework.boot:spring-boot-starter-tomcat:jar:3.4.11:compile
|  |     +- org.apache.tomcat.embed:tomcat-embed-core:jar:10.1.48:compile
|  |     +- org.apache.tomcat.embed:tomcat-embed-el:jar:10.1.48:compile
|  |     \- org.apache.tomcat.embed:tomcat-embed-websocket:jar:10.1.48:compile
|  +- io.github.resilience4j:resilience4j-bulkhead:jar:2.2.0:compile
|  |  \- io.github.resilience4j:resilience4j-core:jar:2.2.0:compile
|  +- io.github.resilience4j:resilience4j-circuitbreaker:jar:2.2.0:compile
|  +- io.github.resilience4j:resilience4j-retry:jar:2.2.0:compile
|  +- io.github.resilience4j:resilience4j-ratelimiter:jar:2.2.0:compile
|  \- io.github.resilience4j:resilience4j-timelimiter:jar:2.2.0:compile
+- org.hibernate.orm:hibernate-core:jar:6.4.2.Final:compile
|  +- jakarta.persistence:jakarta.persistence-api:jar:3.1.0:compile
|  +- jakarta.transaction:jakarta.transaction-api:jar:2.0.1:compile
|  +- org.jboss.logging:jboss-logging:jar:3.6.1.Final:compile
|  +- org.hibernate.common:hibernate-commons-annotations:jar:6.0.6.Final:runtime
|  +- io.smallrye:jandex:jar:3.1.2:runtime
|  +- com.fasterxml:classmate:jar:1.7.1:compile
|  +- net.bytebuddy:byte-buddy:jar:1.15.11:compile
|  +- jakarta.xml.bind:jakarta.xml.bind-api:jar:4.0.4:compile
|  |  \- jakarta.activation:jakarta.activation-api:jar:2.1.4:compile
|  +- org.glassfish.jaxb:jaxb-runtime:jar:4.0.6:runtime
|  |  \- org.glassfish.jaxb:jaxb-core:jar:4.0.6:runtime
|  |     +- org.eclipse.angus:angus-activation:jar:2.0.3:runtime
|  |     +- org.glassfish.jaxb:txw2:jar:4.0.6:runtime
|  |     \- com.sun.istack:istack-commons-runtime:jar:4.1.2:runtime
|  +- jakarta.inject:jakarta.inject-api:jar:2.0.1:runtime
|  \- org.antlr:antlr4-runtime:jar:4.13.0:compile
+- com.santander.ars:gln-back-arsenal-backend-test-starter:jar:3.18.12-SNAPSHOT:test
|  +- org.junit.jupiter:junit-jupiter:jar:5.11.4:test
|  |  \- org.junit.jupiter:junit-jupiter-params:jar:5.11.4:test
|  +- org.junit.vintage:junit-vintage-engine:jar:5.11.4:test
|  |  \- junit:junit:jar:4.13.2:test
|  +- net.bytebuddy:byte-buddy-agent:jar:1.15.11:compile
|  +- org.hamcrest:hamcrest-library:jar:2.2:test
|  |  \- org.hamcrest:hamcrest-core:jar:2.2:test
|  +- com.tngtech.archunit:archunit-junit5-api:jar:1.3.0:test
|  |  \- com.tngtech.archunit:archunit:jar:1.3.0:test
|  +- com.tngtech.archunit:archunit-junit5-engine:jar:1.3.0:test
|  |  \- com.tngtech.archunit:archunit-junit5-engine-api:jar:1.3.0:test
|  +- org.springframework.boot:spring-boot-starter-test:jar:3.4.11:test
|  |  +- org.springframework.boot:spring-boot-test:jar:3.4.11:test
|  |  +- org.springframework.boot:spring-boot-test-autoconfigure:jar:3.4.11:test
|  |  +- com.jayway.jsonpath:json-path:jar:2.9.0:test
|  |  +- net.minidev:json-smart:jar:2.5.2:test
|  |  |  \- net.minidev:accessors-smart:jar:2.5.2:test
|  |  |     \- org.ow2.asm:asm:jar:9.7.1:test
|  |  +- org.assertj:assertj-core:jar:3.26.3:test
|  |  +- org.awaitility:awaitility:jar:4.2.2:test
|  |  +- org.hamcrest:hamcrest:jar:2.2:test
|  |  +- org.skyscreamer:jsonassert:jar:1.5.3:test
|  |  |  \- com.vaadin.external.google:android-json:jar:0.0.20131108.vaadin1:test
|  |  \- org.xmlunit:xmlunit-core:jar:2.10.4:test
|  +- io.cucumber:cucumber-java:jar:7.21.0:test
|  |  \- io.cucumber:cucumber-core:jar:7.21.0:test
|  |     +- io.cucumber:cucumber-gherkin:jar:7.21.0:test
|  |     +- io.cucumber:cucumber-gherkin-messages:jar:7.21.0:test
|  |     |  \- io.cucumber:gherkin:jar:31.0.0:test
|  |     +- io.cucumber:messages:jar:27.2.0:test
|  |     +- io.cucumber:testng-xml-formatter:jar:0.3.1:test
|  |     |  \- io.cucumber:query:jar:13.6.0:test
|  |     +- io.cucumber:tag-expressions:jar:6.1.2:test
|  |     +- io.cucumber:cucumber-expressions:jar:18.0.1:test
|  |     +- io.cucumber:datatable:jar:7.21.0:test
|  |     +- io.cucumber:cucumber-plugin:jar:7.21.0:test
|  |     +- io.cucumber:docstring:jar:7.21.0:test
|  |     +- io.cucumber:html-formatter:jar:21.9.0:test
|  |     +- io.cucumber:junit-xml-formatter:jar:0.7.1:test
|  |     \- io.cucumber:ci-environment:jar:10.0.1:test
|  +- io.cucumber:cucumber-spring:jar:7.21.0:test
|  \- io.cucumber:cucumber-junit:jar:7.21.0:test
+- com.santander.ars:gln-back-arsenal-backend-embeddedmainframe:jar:3.18.12-SNAPSHOT:compile
|  +- com.ibm.mq:mq-jms-spring-boot-starter:jar:2.3.5:compile
|  |  +- com.ibm.mq:com.ibm.mq.allclient:jar:9.4.0.7:compile
|  |  |  +- org.bouncycastle:bcpkix-jdk18on:jar:1.78.1:compile
|  |  |  +- org.bouncycastle:bcutil-jdk18on:jar:1.78.1:compile
|  |  |  +- javax.jms:javax.jms-api:jar:2.0.1:compile
|  |  |  \- org.json:json:jar:20231013:compile
|  |  +- org.springframework:spring-jms:jar:6.2.12:compile
|  |  \- org.messaginghub:pooled-jms:jar:3.1.7:compile
|  |     +- jakarta.jms:jakarta.jms-api:jar:3.1.0:compile
|  |     \- org.apache.commons:commons-pool2:jar:2.12.1:compile
|  +- com.santander.ars:arsenal-altair-connector-mq:jar:3.18.12-SNAPSHOT:compile
|  |  +- com.santander.ars:arsenal-altair-connector-psformat:jar:3.18.12-SNAPSHOT:compile
|  |  +- com.santander.ars:arsenal-altair-connector-core:jar:3.18.12-SNAPSHOT:compile
|  |  +- ch.qos.logback:logback-classic:jar:1.5.20:compile
|  |  |  \- ch.qos.logback:logback-core:jar:1.5.20:compile
|  |  \- org.apache.commons:commons-text:jar:1.10.0:compile
|  +- com.santander.ars:gln-back-arsenal-backend-core:jar:3.18.12-SNAPSHOT:compile
|  |  \- org.apache.commons:commons-lang3:jar:3.18.0:compile
|  +- org.yaml:snakeyaml:jar:2.3:compile
|  \- com.fasterxml.jackson.core:jackson-databind:jar:2.18.4:compile
|     +- com.fasterxml.jackson.core:jackson-annotations:jar:2.18.4:compile
|     \- com.fasterxml.jackson.core:jackson-core:jar:2.18.4.1:compile
+- com.santander.ars:gln-back-arsenal-backend-web-channel-holder-starter:jar:3.18.12-SNAPSHOT:compile
+- org.projectlombok:lombok:jar:1.18.34:compile
\- org.mapstruct:mapstruct:jar:1.4.2.Final:compile
+- org.projectlombok:lombok:jar:1.18.34:compile
\- org.mapstruct:mapstruct:jar:1.4.2.Final:compile
+- org.projectlombok:lombok:jar:1.18.34:compile
\- org.mapstruct:mapstruct:jar:1.4.2.Final:compile
+- org.projectlombok:lombok:jar:1.18.34:compile
\- org.mapstruct:mapstruct:jar:1.4.2.Final:compile
+- org.projectlombok:lombok:jar:1.18.34:compile
\- org.mapstruct:mapstruct:jar:1.4.2.Final:compile
+- org.projectlombok:lombok:jar:1.18.34:compile
\- org.mapstruct:mapstruct:jar:1.4.2.Final:compile
+- org.projectlombok:lombok:jar:1.18.34:compile
\- org.mapstruct:mapstruct:jar:1.4.2.Final:compile
+- org.projectlombok:lombok:jar:1.18.34:compile
\- org.mapstruct:mapstruct:jar:1.4.2.Final:compile
```
