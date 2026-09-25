
# Dependency Tree

All dependencies of this project will be documented in this file.

## Log Result

```text
+- org.apache.camel:camel-core:jar:4.8.9:compile
|  +- org.apache.camel:camel-core-engine:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-api:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-base-engine:jar:4.8.9:compile
|  |  |  \- org.apache.camel:camel-base:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-core-reifier:jar:4.8.9:compile
|  |  |  \- org.apache.camel:camel-core-processor:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-management-api:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-support:jar:4.8.9:compile
|  |  \- org.apache.camel:camel-util:jar:4.8.9:compile
|  +- org.apache.camel:camel-core-languages:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-core-model:jar:4.8.9:compile
|  |  \- org.apache.camel:camel-xml-jaxp-util:jar:4.8.9:compile
|  +- org.apache.camel:camel-bean:jar:4.8.9:compile
|  +- org.apache.camel:camel-browse:jar:4.8.9:compile
|  +- org.apache.camel:camel-cluster:jar:4.8.9:compile
|  +- org.apache.camel:camel-controlbus:jar:4.8.9:compile
|  +- org.apache.camel:camel-dataformat:jar:4.8.9:compile
|  +- org.apache.camel:camel-dataset:jar:4.8.9:compile
|  +- org.apache.camel:camel-direct:jar:4.8.9:compile
|  +- org.apache.camel:camel-file:jar:4.8.9:compile
|  |  \- commons-codec:commons-codec:jar:1.17.2:compile
|  +- org.apache.camel:camel-health:jar:4.8.9:compile
|  +- org.apache.camel:camel-language:jar:4.8.9:compile
|  +- org.apache.camel:camel-log:jar:4.8.9:compile
|  +- org.apache.camel:camel-mock:jar:4.8.9:compile
|  +- org.apache.camel:camel-ref:jar:4.8.9:compile
|  +- org.apache.camel:camel-rest:jar:4.8.9:compile
|  |  \- org.apache.camel:camel-tooling-model:jar:4.8.9:compile
|  +- org.apache.camel:camel-saga:jar:4.8.9:compile
|  +- org.apache.camel:camel-scheduler:jar:4.8.9:compile
|  +- org.apache.camel:camel-seda:jar:4.8.9:compile
|  +- org.apache.camel:camel-stub:jar:4.8.9:compile
|  +- org.apache.camel:camel-timer:jar:4.8.9:compile
|  +- org.apache.camel:camel-validator:jar:4.8.9:compile
|  +- org.apache.camel:camel-xpath:jar:4.8.9:compile
|  +- org.apache.camel:camel-xslt:jar:4.8.9:compile
|  +- org.apache.camel:camel-xml-io:jar:4.8.9:compile
|  |  \- org.apache.camel:camel-xml-io-util:jar:4.8.9:compile
|  +- org.apache.camel:camel-xml-jaxb:jar:4.8.9:compile
|  |  \- org.glassfish.jaxb:jaxb-runtime:jar:4.0.6:compile
|  |     \- org.glassfish.jaxb:jaxb-core:jar:4.0.6:compile
|  |        +- org.eclipse.angus:angus-activation:jar:2.0.3:runtime
|  |        +- org.glassfish.jaxb:txw2:jar:4.0.6:compile
|  |        \- com.sun.istack:istack-commons-runtime:jar:4.1.2:compile
|  +- org.apache.camel:camel-xml-jaxp:jar:4.8.9:compile
|  +- org.apache.camel:camel-yaml-io:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-core-catalog:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-util-json:jar:4.8.9:compile
|  |  \- com.fasterxml.jackson.dataformat:jackson-dataformat-yaml:jar:2.18.4:compile
|  |     \- com.fasterxml.jackson.core:jackson-core:jar:2.18.4.1:compile
|  \- org.slf4j:slf4j-api:jar:2.0.17:compile
+- org.apache.camel:camel-endpointdsl:jar:4.8.9:compile
+- org.springframework.boot:spring-boot-autoconfigure:jar:3.4.11:compile
|  \- org.springframework.boot:spring-boot:jar:3.4.11:compile
|     \- org.springframework:spring-context:jar:6.2.12:compile
+- org.springframework.boot:spring-boot-configuration-processor:jar:3.4.11:compile
+- com.ibm.mq:com.ibm.mq.allclient:jar:9.1.3.0:compile
|  +- org.bouncycastle:bcpkix-jdk15on:jar:1.61:compile
|  \- javax.jms:javax.jms-api:jar:2.0.1:compile
+- org.bouncycastle:bcprov-jdk18on:jar:1.78.1:compile
+- com.santander.ars:arsenal-altair-connector-mq:jar:3.18.11:compile
|  +- com.santander.ars:arsenal-altair-connector-psformat:jar:3.18.11:compile
|  +- com.santander.ars:arsenal-altair-connector-core:jar:3.18.11:compile
|  +- ch.qos.logback:logback-classic:jar:1.5.19:compile
|  |  \- ch.qos.logback:logback-core:jar:1.5.19:compile
|  +- org.apache.commons:commons-text:jar:1.10.0:compile
|  |  \- org.apache.commons:commons-lang3:jar:3.18.0:compile
|  \- org.mapstruct:mapstruct:jar:1.4.2.Final:compile
+- org.projectlombok:lombok:jar:1.18.34:provided
+- com.google.code.gson:gson:jar:2.11.0:compile
|  \- com.google.errorprone:error_prone_annotations:jar:2.27.0:compile
+- org.junit.jupiter:junit-jupiter-api:jar:5.11.4:test
|  +- org.opentest4j:opentest4j:jar:1.3.0:test
|  +- org.junit.platform:junit-platform-commons:jar:1.11.4:test
|  \- org.apiguardian:apiguardian-api:jar:1.1.2:test
+- org.apache.camel:camel-test-junit5:jar:4.8.9:test
|  +- org.junit.jupiter:junit-jupiter-engine:jar:5.11.4:test
|  |  \- org.junit.platform:junit-platform-engine:jar:1.11.4:test
|  \- org.junit.jupiter:junit-jupiter-params:jar:5.11.4:test
+- org.apache.camel:camel-test-spring-junit5:jar:4.8.9:test
|  +- org.apache.camel:camel-spring-xml:jar:4.8.9:test
|  |  +- org.apache.camel:camel-spring:jar:4.8.9:test
|  |  |  \- org.springframework:spring-tx:jar:6.2.12:test
|  |  +- org.apache.camel:camel-core-xml:jar:4.8.9:test
|  |  \- jakarta.annotation:jakarta.annotation-api:jar:2.1.1:compile
|  \- org.springframework:spring-test:jar:6.2.12:test
+- org.springframework.boot:spring-boot-starter-web:jar:3.4.11:compile
|  +- org.springframework.boot:spring-boot-starter:jar:3.4.11:compile
|  |  +- org.springframework.boot:spring-boot-starter-logging:jar:3.4.11:compile
|  |  |  +- org.apache.logging.log4j:log4j-to-slf4j:jar:2.24.3:compile
|  |  |  |  \- org.apache.logging.log4j:log4j-api:jar:2.24.3:compile
|  |  |  \- org.slf4j:jul-to-slf4j:jar:2.0.17:compile
|  |  \- org.yaml:snakeyaml:jar:2.3:compile
|  +- org.springframework.boot:spring-boot-starter-json:jar:3.4.11:compile
|  |  +- com.fasterxml.jackson.core:jackson-databind:jar:2.18.4:compile
|  |  |  \- com.fasterxml.jackson.core:jackson-annotations:jar:2.18.4:compile
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
|     \- org.springframework:spring-expression:jar:6.2.12:compile
+- org.springframework.boot:spring-boot-starter-test:jar:3.4.11:test
|  +- org.springframework.boot:spring-boot-test:jar:3.4.11:test
|  +- org.springframework.boot:spring-boot-test-autoconfigure:jar:3.4.11:test
|  +- com.jayway.jsonpath:json-path:jar:2.9.0:test
|  +- jakarta.xml.bind:jakarta.xml.bind-api:jar:4.0.4:compile
|  |  \- jakarta.activation:jakarta.activation-api:jar:2.1.4:compile
|  +- net.minidev:json-smart:jar:2.5.2:test
|  |  \- net.minidev:accessors-smart:jar:2.5.2:test
|  |     \- org.ow2.asm:asm:jar:9.7.1:test
|  +- org.assertj:assertj-core:jar:3.26.3:test
|  +- org.awaitility:awaitility:jar:4.2.2:test
|  +- org.hamcrest:hamcrest:jar:2.2:test
|  +- org.junit.jupiter:junit-jupiter:jar:5.11.4:test
|  +- org.mockito:mockito-junit-jupiter:jar:5.14.2:test
|  +- org.skyscreamer:jsonassert:jar:1.5.3:test
|  |  \- com.vaadin.external.google:android-json:jar:0.0.20131108.vaadin1:test
|  +- org.springframework:spring-core:jar:6.2.12:compile
|  |  \- org.springframework:spring-jcl:jar:6.2.12:compile
|  \- org.xmlunit:xmlunit-core:jar:2.10.4:test
+- org.apache.camel.springboot:camel-spring-boot-starter:jar:4.8.9:test
|  +- org.apache.camel.springboot:camel-spring-boot:jar:4.8.9:test
|  |  +- org.apache.camel:camel-spring-main:jar:4.8.9:test
|  |  |  \- org.apache.camel:camel-main:jar:4.8.9:test
|  |  \- org.apache.camel:camel-cloud:jar:4.8.9:test
|  +- org.apache.camel.springboot:camel-core-starter:jar:4.8.9:test
|  +- org.apache.camel.springboot:camel-bean-starter:jar:4.8.9:test
|  +- org.apache.camel.springboot:camel-browse-starter:jar:4.8.9:test
|  +- org.apache.camel.springboot:camel-controlbus-starter:jar:4.8.9:test
|  +- org.apache.camel.springboot:camel-dataformat-starter:jar:4.8.9:test
|  +- org.apache.camel.springboot:camel-dataset-starter:jar:4.8.9:test
|  +- org.apache.camel.springboot:camel-direct-starter:jar:4.8.9:test
|  +- org.apache.camel.springboot:camel-file-starter:jar:4.8.9:test
|  +- org.apache.camel.springboot:camel-language-starter:jar:4.8.9:test
|  +- org.apache.camel.springboot:camel-log-starter:jar:4.8.9:test
|  +- org.apache.camel.springboot:camel-mock-starter:jar:4.8.9:test
|  +- org.apache.camel.springboot:camel-ref-starter:jar:4.8.9:test
|  +- org.apache.camel.springboot:camel-rest-starter:jar:4.8.9:test
|  +- org.apache.camel.springboot:camel-saga-starter:jar:4.8.9:test
|  +- org.apache.camel.springboot:camel-scheduler-starter:jar:4.8.9:test
|  +- org.apache.camel.springboot:camel-seda-starter:jar:4.8.9:test
|  +- org.apache.camel.springboot:camel-stub-starter:jar:4.8.9:test
|  +- org.apache.camel.springboot:camel-timer-starter:jar:4.8.9:test
|  +- org.apache.camel.springboot:camel-validator-starter:jar:4.8.9:test
|  +- org.apache.camel.springboot:camel-xpath-starter:jar:4.8.9:test
|  +- org.apache.camel.springboot:camel-xslt-starter:jar:4.8.9:test
|  \- org.apache.camel.springboot:camel-xml-jaxp-starter:jar:4.8.9:test
+- org.mockito:mockito-core:jar:5.8.0:test
|  +- net.bytebuddy:byte-buddy:jar:1.15.11:test
|  +- net.bytebuddy:byte-buddy-agent:jar:1.15.11:test
|  \- org.objenesis:objenesis:jar:3.3:test
\- commons-io:commons-io:jar:2.15.1:compile
+- org.apache.camel:camel-core:jar:4.8.9:compile
|  +- org.apache.camel:camel-core-engine:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-api:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-base-engine:jar:4.8.9:compile
|  |  |  \- org.apache.camel:camel-base:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-core-reifier:jar:4.8.9:compile
|  |  |  \- org.apache.camel:camel-core-processor:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-management-api:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-support:jar:4.8.9:compile
|  |  \- org.apache.camel:camel-util:jar:4.8.9:compile
|  +- org.apache.camel:camel-core-languages:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-core-model:jar:4.8.9:compile
|  |  \- org.apache.camel:camel-xml-jaxp-util:jar:4.8.9:compile
|  +- org.apache.camel:camel-bean:jar:4.8.9:compile
|  +- org.apache.camel:camel-browse:jar:4.8.9:compile
|  +- org.apache.camel:camel-cluster:jar:4.8.9:compile
|  +- org.apache.camel:camel-controlbus:jar:4.8.9:compile
|  +- org.apache.camel:camel-dataformat:jar:4.8.9:compile
|  +- org.apache.camel:camel-dataset:jar:4.8.9:compile
|  +- org.apache.camel:camel-direct:jar:4.8.9:compile
|  +- org.apache.camel:camel-file:jar:4.8.9:compile
|  |  \- commons-codec:commons-codec:jar:1.17.2:compile
|  +- org.apache.camel:camel-health:jar:4.8.9:compile
|  +- org.apache.camel:camel-language:jar:4.8.9:compile
|  +- org.apache.camel:camel-log:jar:4.8.9:compile
|  +- org.apache.camel:camel-mock:jar:4.8.9:compile
|  +- org.apache.camel:camel-ref:jar:4.8.9:compile
|  +- org.apache.camel:camel-rest:jar:4.8.9:compile
|  |  \- org.apache.camel:camel-tooling-model:jar:4.8.9:compile
|  +- org.apache.camel:camel-saga:jar:4.8.9:compile
|  +- org.apache.camel:camel-scheduler:jar:4.8.9:compile
|  +- org.apache.camel:camel-seda:jar:4.8.9:compile
|  +- org.apache.camel:camel-stub:jar:4.8.9:compile
|  +- org.apache.camel:camel-timer:jar:4.8.9:compile
|  +- org.apache.camel:camel-validator:jar:4.8.9:compile
|  +- org.apache.camel:camel-xpath:jar:4.8.9:compile
|  +- org.apache.camel:camel-xslt:jar:4.8.9:compile
|  +- org.apache.camel:camel-xml-io:jar:4.8.9:compile
|  |  \- org.apache.camel:camel-xml-io-util:jar:4.8.9:compile
|  +- org.apache.camel:camel-xml-jaxb:jar:4.8.9:compile
|  |  \- org.glassfish.jaxb:jaxb-runtime:jar:4.0.6:compile
|  |     \- org.glassfish.jaxb:jaxb-core:jar:4.0.6:compile
|  |        +- org.eclipse.angus:angus-activation:jar:2.0.3:runtime
|  |        +- org.glassfish.jaxb:txw2:jar:4.0.6:compile
|  |        \- com.sun.istack:istack-commons-runtime:jar:4.1.2:compile
|  +- org.apache.camel:camel-xml-jaxp:jar:4.8.9:compile
|  +- org.apache.camel:camel-yaml-io:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-core-catalog:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-util-json:jar:4.8.9:compile
|  |  \- com.fasterxml.jackson.dataformat:jackson-dataformat-yaml:jar:2.18.4:compile
|  |     \- com.fasterxml.jackson.core:jackson-core:jar:2.18.4.1:compile
|  \- org.slf4j:slf4j-api:jar:2.0.17:compile
+- org.json:json:jar:20231013:compile
+- org.springframework.boot:spring-boot-autoconfigure:jar:3.4.11:compile
|  \- org.springframework.boot:spring-boot:jar:3.4.11:compile
|     \- org.springframework:spring-context:jar:6.2.12:compile
+- org.springframework.boot:spring-boot-configuration-processor:jar:3.4.11:compile
+- org.apache.camel.springboot:camel-spring-boot-starter:jar:4.8.9:test
|  +- org.springframework.boot:spring-boot-starter:jar:3.4.11:compile
|  |  +- org.springframework.boot:spring-boot-starter-logging:jar:3.4.11:compile
|  |  |  +- ch.qos.logback:logback-classic:jar:1.5.19:compile
|  |  |  |  \- ch.qos.logback:logback-core:jar:1.5.19:compile
|  |  |  +- org.apache.logging.log4j:log4j-to-slf4j:jar:2.24.3:compile
|  |  |  |  \- org.apache.logging.log4j:log4j-api:jar:2.24.3:compile
|  |  |  \- org.slf4j:jul-to-slf4j:jar:2.0.17:compile
|  |  +- jakarta.annotation:jakarta.annotation-api:jar:2.1.1:compile
|  |  \- org.yaml:snakeyaml:jar:2.3:compile
|  +- org.apache.camel.springboot:camel-spring-boot:jar:4.8.9:test
|  |  +- org.apache.camel:camel-spring:jar:4.8.9:test
|  |  |  \- org.springframework:spring-tx:jar:6.2.12:test
|  |  +- org.apache.camel:camel-spring-main:jar:4.8.9:test
|  |  |  \- org.apache.camel:camel-main:jar:4.8.9:test
|  |  \- org.apache.camel:camel-cloud:jar:4.8.9:test
|  +- org.apache.camel.springboot:camel-core-starter:jar:4.8.9:test
|  +- org.apache.camel.springboot:camel-bean-starter:jar:4.8.9:test
|  +- org.apache.camel.springboot:camel-browse-starter:jar:4.8.9:test
|  +- org.apache.camel.springboot:camel-controlbus-starter:jar:4.8.9:test
|  +- org.apache.camel.springboot:camel-dataformat-starter:jar:4.8.9:test
|  +- org.apache.camel.springboot:camel-dataset-starter:jar:4.8.9:test
|  +- org.apache.camel.springboot:camel-direct-starter:jar:4.8.9:test
|  +- org.apache.camel.springboot:camel-file-starter:jar:4.8.9:test
|  +- org.apache.camel.springboot:camel-language-starter:jar:4.8.9:test
|  +- org.apache.camel.springboot:camel-log-starter:jar:4.8.9:test
|  +- org.apache.camel.springboot:camel-mock-starter:jar:4.8.9:test
|  +- org.apache.camel.springboot:camel-ref-starter:jar:4.8.9:test
|  +- org.apache.camel.springboot:camel-rest-starter:jar:4.8.9:test
|  +- org.apache.camel.springboot:camel-saga-starter:jar:4.8.9:test
|  +- org.apache.camel.springboot:camel-scheduler-starter:jar:4.8.9:test
|  +- org.apache.camel.springboot:camel-seda-starter:jar:4.8.9:test
|  +- org.apache.camel.springboot:camel-stub-starter:jar:4.8.9:test
|  +- org.apache.camel.springboot:camel-timer-starter:jar:4.8.9:test
|  +- org.apache.camel.springboot:camel-validator-starter:jar:4.8.9:test
|  +- org.apache.camel.springboot:camel-xpath-starter:jar:4.8.9:test
|  +- org.apache.camel.springboot:camel-xslt-starter:jar:4.8.9:test
|  \- org.apache.camel.springboot:camel-xml-jaxp-starter:jar:4.8.9:test
+- org.springframework.boot:spring-boot-starter-web:jar:3.4.11:compile
|  +- org.springframework.boot:spring-boot-starter-json:jar:3.4.11:compile
|  |  +- com.fasterxml.jackson.core:jackson-databind:jar:2.18.4:compile
|  |  |  \- com.fasterxml.jackson.core:jackson-annotations:jar:2.18.4:compile
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
|     \- org.springframework:spring-expression:jar:6.2.12:compile
+- org.springframework.boot:spring-boot-starter-test:jar:3.4.11:test
|  +- org.springframework.boot:spring-boot-test:jar:3.4.11:test
|  +- org.springframework.boot:spring-boot-test-autoconfigure:jar:3.4.11:test
|  +- com.jayway.jsonpath:json-path:jar:2.9.0:test
|  +- jakarta.xml.bind:jakarta.xml.bind-api:jar:4.0.4:compile
|  |  \- jakarta.activation:jakarta.activation-api:jar:2.1.4:compile
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
|  +- org.mockito:mockito-core:jar:5.8.0:test
|  |  +- net.bytebuddy:byte-buddy-agent:jar:1.15.11:test
|  |  \- org.objenesis:objenesis:jar:3.3:test
|  +- org.mockito:mockito-junit-jupiter:jar:5.14.2:test
|  +- org.skyscreamer:jsonassert:jar:1.5.3:test
|  +- org.springframework:spring-core:jar:6.2.12:compile
|  |  \- org.springframework:spring-jcl:jar:6.2.12:compile
|  +- org.springframework:spring-test:jar:6.2.12:test
|  \- org.xmlunit:xmlunit-core:jar:2.10.4:test
+- org.apache.camel:camel-test-spring-junit5:jar:4.8.9:test
|  +- org.apache.camel:camel-test-junit5:jar:4.8.9:test
|  \- org.apache.camel:camel-spring-xml:jar:4.8.9:test
|     \- org.apache.camel:camel-core-xml:jar:4.8.9:test
\- io.rest-assured:rest-assured:jar:5.5.6:test
   +- org.apache.groovy:groovy:jar:4.0.29:test
   +- org.apache.groovy:groovy-xml:jar:4.0.29:test
   +- org.apache.httpcomponents:httpclient:jar:4.5.13:test
   |  +- org.apache.httpcomponents:httpcore:jar:4.4.16:test
   |  \- commons-logging:commons-logging:jar:1.2:test
   +- org.apache.httpcomponents:httpmime:jar:4.5.13:test
   +- org.ccil.cowan.tagsoup:tagsoup:jar:1.2.1:test
   +- io.rest-assured:json-path:jar:5.5.6:test
   |  +- org.apache.groovy:groovy-json:jar:4.0.29:test
   |  \- io.rest-assured:rest-assured-common:jar:5.5.6:test
   \- io.rest-assured:xml-path:jar:5.5.6:test
      \- org.apache.commons:commons-lang3:jar:3.18.0:test
+- org.apache.camel.springboot:camel-core-starter:jar:4.8.9:compile
|  +- org.springframework.boot:spring-boot-starter:jar:3.4.11:compile
|  |  +- org.springframework.boot:spring-boot-starter-logging:jar:3.4.11:compile
|  |  |  +- ch.qos.logback:logback-classic:jar:1.5.19:compile
|  |  |  |  \- ch.qos.logback:logback-core:jar:1.5.19:compile
|  |  |  +- org.apache.logging.log4j:log4j-to-slf4j:jar:2.24.3:compile
|  |  |  |  \- org.apache.logging.log4j:log4j-api:jar:2.24.3:compile
|  |  |  \- org.slf4j:jul-to-slf4j:jar:2.0.17:compile
|  |  +- jakarta.annotation:jakarta.annotation-api:jar:2.1.1:compile
|  |  \- org.yaml:snakeyaml:jar:2.3:compile
|  +- org.apache.camel:camel-core-engine:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-api:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-base-engine:jar:4.8.9:compile
|  |  |  \- org.apache.camel:camel-base:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-core-reifier:jar:4.8.9:compile
|  |  |  +- org.apache.camel:camel-core-model:jar:4.8.9:compile
|  |  |  \- org.apache.camel:camel-core-processor:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-management-api:jar:4.8.9:compile
|  |  \- org.apache.camel:camel-util:jar:4.8.9:compile
|  \- org.apache.camel.springboot:camel-spring-boot:jar:4.8.9:compile
|     +- org.apache.camel:camel-spring:jar:4.8.9:compile
|     |  \- org.springframework:spring-tx:jar:6.2.12:compile
|     +- org.apache.camel:camel-spring-main:jar:4.8.9:compile
|     |  \- org.apache.camel:camel-main:jar:4.8.9:compile
|     +- org.apache.camel:camel-util-json:jar:4.8.9:compile
|     +- org.apache.camel:camel-cloud:jar:4.8.9:compile
|     +- org.apache.camel:camel-cluster:jar:4.8.9:compile
|     \- org.apache.camel:camel-health:jar:4.8.9:compile
+- org.springframework.boot:spring-boot-autoconfigure:jar:3.4.11:provided
|  \- org.springframework.boot:spring-boot:jar:3.4.11:compile
|     \- org.springframework:spring-context:jar:6.2.12:compile
+- org.springframework.boot:spring-boot-autoconfigure-processor:jar:3.4.11:compile
+- org.springframework.boot:spring-boot-configuration-processor:jar:3.4.11:provided
+- org.apache.camel:camel-servlet:jar:4.8.9:compile
|  +- org.apache.camel:camel-support:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-xml-jaxp-util:jar:4.8.9:compile
|  |  \- org.slf4j:slf4j-api:jar:2.0.17:compile
|  \- org.apache.camel:camel-http-common:jar:4.8.9:compile
|     +- org.apache.camel:camel-http-base:jar:4.8.9:compile
|     \- org.apache.camel:camel-attachments:jar:4.8.9:compile
+- jakarta.servlet:jakarta.servlet-api:jar:6.0.0:provided
+- org.springframework.boot:spring-boot-starter-web:jar:3.4.11:test
|  +- org.springframework.boot:spring-boot-starter-json:jar:3.4.11:test
|  |  +- com.fasterxml.jackson.core:jackson-databind:jar:2.18.4:test
|  |  |  +- com.fasterxml.jackson.core:jackson-annotations:jar:2.18.4:test
|  |  |  \- com.fasterxml.jackson.core:jackson-core:jar:2.18.4.1:test
|  |  +- com.fasterxml.jackson.datatype:jackson-datatype-jdk8:jar:2.18.4:test
|  |  +- com.fasterxml.jackson.datatype:jackson-datatype-jsr310:jar:2.18.4:test
|  |  \- com.fasterxml.jackson.module:jackson-module-parameter-names:jar:2.18.4:test
|  +- org.springframework.boot:spring-boot-starter-tomcat:jar:3.4.11:test
|  |  +- org.apache.tomcat.embed:tomcat-embed-core:jar:10.1.48:test
|  |  +- org.apache.tomcat.embed:tomcat-embed-el:jar:10.1.48:test
|  |  \- org.apache.tomcat.embed:tomcat-embed-websocket:jar:10.1.48:test
|  +- org.springframework:spring-web:jar:6.2.12:test
|  |  +- org.springframework:spring-beans:jar:6.2.12:compile
|  |  \- io.micrometer:micrometer-observation:jar:1.14.12:compile
|  |     \- io.micrometer:micrometer-commons:jar:1.14.12:compile
|  \- org.springframework:spring-webmvc:jar:6.2.12:test
|     +- org.springframework:spring-aop:jar:6.2.12:compile
|     \- org.springframework:spring-expression:jar:6.2.12:compile
+- org.springframework.boot:spring-boot-starter-test:jar:3.4.11:test
|  +- org.springframework.boot:spring-boot-test:jar:3.4.11:test
|  +- org.springframework.boot:spring-boot-test-autoconfigure:jar:3.4.11:test
|  +- com.jayway.jsonpath:json-path:jar:2.9.0:test
|  +- jakarta.xml.bind:jakarta.xml.bind-api:jar:4.0.4:compile
|  |  \- jakarta.activation:jakarta.activation-api:jar:2.1.4:compile
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
|  +- org.mockito:mockito-core:jar:5.8.0:test
|  |  +- net.bytebuddy:byte-buddy-agent:jar:1.15.11:test
|  |  \- org.objenesis:objenesis:jar:3.3:test
|  +- org.mockito:mockito-junit-jupiter:jar:5.14.2:test
|  +- org.skyscreamer:jsonassert:jar:1.5.3:test
|  |  \- com.vaadin.external.google:android-json:jar:0.0.20131108.vaadin1:test
|  +- org.springframework:spring-core:jar:6.2.12:compile
|  |  \- org.springframework:spring-jcl:jar:6.2.12:compile
|  +- org.springframework:spring-test:jar:6.2.12:test
|  \- org.xmlunit:xmlunit-core:jar:2.10.4:test
+- org.apache.camel:camel-test-spring-junit5:jar:4.8.9:test
|  +- org.apache.camel:camel-test-junit5:jar:4.8.9:test
|  |  +- org.apache.camel:camel-core-languages:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-bean:jar:4.8.9:test
|  |  +- org.apache.camel:camel-browse:jar:4.8.9:test
|  |  +- org.apache.camel:camel-controlbus:jar:4.8.9:test
|  |  +- org.apache.camel:camel-dataformat:jar:4.8.9:test
|  |  +- org.apache.camel:camel-dataset:jar:4.8.9:test
|  |  +- org.apache.camel:camel-direct:jar:4.8.9:test
|  |  +- org.apache.camel:camel-file:jar:4.8.9:test
|  |  +- org.apache.camel:camel-language:jar:4.8.9:test
|  |  +- org.apache.camel:camel-log:jar:4.8.9:test
|  |  +- org.apache.camel:camel-mock:jar:4.8.9:test
|  |  +- org.apache.camel:camel-ref:jar:4.8.9:test
|  |  +- org.apache.camel:camel-rest:jar:4.8.9:test
|  |  |  \- org.apache.camel:camel-tooling-model:jar:4.8.9:test
|  |  +- org.apache.camel:camel-saga:jar:4.8.9:test
|  |  +- org.apache.camel:camel-scheduler:jar:4.8.9:test
|  |  +- org.apache.camel:camel-seda:jar:4.8.9:test
|  |  +- org.apache.camel:camel-stub:jar:4.8.9:test
|  |  +- org.apache.camel:camel-timer:jar:4.8.9:test
|  |  +- org.apache.camel:camel-validator:jar:4.8.9:test
|  |  +- org.apache.camel:camel-xpath:jar:4.8.9:test
|  |  \- org.apache.camel:camel-xslt:jar:4.8.9:test
|  \- org.apache.camel:camel-spring-xml:jar:4.8.9:test
|     +- org.apache.camel:camel-xml-jaxb:jar:4.8.9:test
|     |  \- org.glassfish.jaxb:jaxb-runtime:jar:4.0.6:test
|     |     \- org.glassfish.jaxb:jaxb-core:jar:4.0.6:test
|     |        +- org.eclipse.angus:angus-activation:jar:2.0.3:test
|     |        +- org.glassfish.jaxb:txw2:jar:4.0.6:test
|     |        \- com.sun.istack:istack-commons-runtime:jar:4.1.2:test
|     +- org.apache.camel:camel-xml-jaxp:jar:4.8.9:test
|     |  \- org.apache.camel:camel-xml-io-util:jar:4.8.9:test
|     \- org.apache.camel:camel-core-xml:jar:4.8.9:test
\- io.rest-assured:rest-assured:jar:5.5.6:test
   +- org.apache.groovy:groovy:jar:4.0.29:test
   +- org.apache.groovy:groovy-xml:jar:4.0.29:test
   +- org.apache.httpcomponents:httpclient:jar:4.5.13:test
   |  +- org.apache.httpcomponents:httpcore:jar:4.4.16:test
   |  +- commons-logging:commons-logging:jar:1.2:test
   |  \- commons-codec:commons-codec:jar:1.17.2:test
   +- org.apache.httpcomponents:httpmime:jar:4.5.13:test
   +- org.ccil.cowan.tagsoup:tagsoup:jar:1.2.1:test
   +- io.rest-assured:json-path:jar:5.5.6:test
   |  +- org.apache.groovy:groovy-json:jar:4.0.29:test
   |  \- io.rest-assured:rest-assured-common:jar:5.5.6:test
   \- io.rest-assured:xml-path:jar:5.5.6:test
      \- org.apache.commons:commons-lang3:jar:3.18.0:test
+- org.apache.camel:camel-core:jar:4.8.9:compile
|  +- org.apache.camel:camel-core-engine:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-api:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-base-engine:jar:4.8.9:compile
|  |  |  \- org.apache.camel:camel-base:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-core-reifier:jar:4.8.9:compile
|  |  |  \- org.apache.camel:camel-core-processor:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-management-api:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-support:jar:4.8.9:compile
|  |  \- org.apache.camel:camel-util:jar:4.8.9:compile
|  +- org.apache.camel:camel-core-languages:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-core-model:jar:4.8.9:compile
|  |  \- org.apache.camel:camel-xml-jaxp-util:jar:4.8.9:compile
|  +- org.apache.camel:camel-bean:jar:4.8.9:compile
|  +- org.apache.camel:camel-browse:jar:4.8.9:compile
|  +- org.apache.camel:camel-cluster:jar:4.8.9:compile
|  +- org.apache.camel:camel-controlbus:jar:4.8.9:compile
|  +- org.apache.camel:camel-dataformat:jar:4.8.9:compile
|  +- org.apache.camel:camel-dataset:jar:4.8.9:compile
|  +- org.apache.camel:camel-direct:jar:4.8.9:compile
|  +- org.apache.camel:camel-file:jar:4.8.9:compile
|  |  \- commons-codec:commons-codec:jar:1.17.2:compile
|  +- org.apache.camel:camel-health:jar:4.8.9:compile
|  +- org.apache.camel:camel-language:jar:4.8.9:compile
|  +- org.apache.camel:camel-log:jar:4.8.9:compile
|  +- org.apache.camel:camel-mock:jar:4.8.9:compile
|  +- org.apache.camel:camel-ref:jar:4.8.9:compile
|  +- org.apache.camel:camel-rest:jar:4.8.9:compile
|  |  \- org.apache.camel:camel-tooling-model:jar:4.8.9:compile
|  +- org.apache.camel:camel-saga:jar:4.8.9:compile
|  +- org.apache.camel:camel-scheduler:jar:4.8.9:compile
|  +- org.apache.camel:camel-seda:jar:4.8.9:compile
|  +- org.apache.camel:camel-stub:jar:4.8.9:compile
|  +- org.apache.camel:camel-timer:jar:4.8.9:compile
|  +- org.apache.camel:camel-validator:jar:4.8.9:compile
|  +- org.apache.camel:camel-xpath:jar:4.8.9:compile
|  +- org.apache.camel:camel-xslt:jar:4.8.9:compile
|  +- org.apache.camel:camel-xml-io:jar:4.8.9:compile
|  |  \- org.apache.camel:camel-xml-io-util:jar:4.8.9:compile
|  +- org.apache.camel:camel-xml-jaxb:jar:4.8.9:compile
|  |  \- org.glassfish.jaxb:jaxb-runtime:jar:4.0.6:compile
|  |     \- org.glassfish.jaxb:jaxb-core:jar:4.0.6:compile
|  |        +- org.eclipse.angus:angus-activation:jar:2.0.3:runtime
|  |        +- org.glassfish.jaxb:txw2:jar:4.0.6:compile
|  |        \- com.sun.istack:istack-commons-runtime:jar:4.1.2:compile
|  +- org.apache.camel:camel-xml-jaxp:jar:4.8.9:compile
|  +- org.apache.camel:camel-yaml-io:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-core-catalog:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-util-json:jar:4.8.9:compile
|  |  \- com.fasterxml.jackson.dataformat:jackson-dataformat-yaml:jar:2.18.4:compile
|  |     \- com.fasterxml.jackson.core:jackson-core:jar:2.18.4.1:compile
|  \- org.slf4j:slf4j-api:jar:2.0.17:compile
+- org.apache.camel:camel-endpointdsl:jar:4.8.9:compile
+- org.apache.camel:spi-annotations:jar:4.8.9:compile
+- org.apache.camel.springboot:camel-spring-boot-starter:jar:4.8.9:compile
|  +- org.springframework.boot:spring-boot-starter:jar:3.4.11:compile
|  |  +- org.springframework.boot:spring-boot-starter-logging:jar:3.4.11:compile
|  |  |  +- ch.qos.logback:logback-classic:jar:1.5.19:compile
|  |  |  |  \- ch.qos.logback:logback-core:jar:1.5.19:compile
|  |  |  +- org.apache.logging.log4j:log4j-to-slf4j:jar:2.24.3:compile
|  |  |  |  \- org.apache.logging.log4j:log4j-api:jar:2.24.3:compile
|  |  |  \- org.slf4j:jul-to-slf4j:jar:2.0.17:compile
|  |  +- jakarta.annotation:jakarta.annotation-api:jar:2.1.1:compile
|  |  \- org.yaml:snakeyaml:jar:2.3:compile
|  +- org.apache.camel.springboot:camel-spring-boot:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-spring:jar:4.8.9:compile
|  |  |  \- org.springframework:spring-tx:jar:6.2.12:compile
|  |  +- org.apache.camel:camel-spring-main:jar:4.8.9:compile
|  |  |  \- org.apache.camel:camel-main:jar:4.8.9:compile
|  |  \- org.apache.camel:camel-cloud:jar:4.8.9:compile
|  +- org.apache.camel.springboot:camel-core-starter:jar:4.8.9:compile
|  +- org.apache.camel.springboot:camel-bean-starter:jar:4.8.9:compile
|  +- org.apache.camel.springboot:camel-browse-starter:jar:4.8.9:compile
|  +- org.apache.camel.springboot:camel-controlbus-starter:jar:4.8.9:compile
|  +- org.apache.camel.springboot:camel-dataformat-starter:jar:4.8.9:compile
|  +- org.apache.camel.springboot:camel-dataset-starter:jar:4.8.9:compile
|  +- org.apache.camel.springboot:camel-direct-starter:jar:4.8.9:compile
|  +- org.apache.camel.springboot:camel-file-starter:jar:4.8.9:compile
|  +- org.apache.camel.springboot:camel-language-starter:jar:4.8.9:compile
|  +- org.apache.camel.springboot:camel-log-starter:jar:4.8.9:compile
|  +- org.apache.camel.springboot:camel-mock-starter:jar:4.8.9:compile
|  +- org.apache.camel.springboot:camel-ref-starter:jar:4.8.9:compile
|  +- org.apache.camel.springboot:camel-rest-starter:jar:4.8.9:compile
|  +- org.apache.camel.springboot:camel-saga-starter:jar:4.8.9:compile
|  +- org.apache.camel.springboot:camel-scheduler-starter:jar:4.8.9:compile
|  +- org.apache.camel.springboot:camel-seda-starter:jar:4.8.9:compile
|  +- org.apache.camel.springboot:camel-stub-starter:jar:4.8.9:compile
|  +- org.apache.camel.springboot:camel-timer-starter:jar:4.8.9:compile
|  +- org.apache.camel.springboot:camel-validator-starter:jar:4.8.9:compile
|  +- org.apache.camel.springboot:camel-xpath-starter:jar:4.8.9:compile
|  +- org.apache.camel.springboot:camel-xslt-starter:jar:4.8.9:compile
|  \- org.apache.camel.springboot:camel-xml-jaxp-starter:jar:4.8.9:compile
+- org.apache.camel:camel-test-junit5:jar:4.8.9:test
|  +- org.junit.jupiter:junit-jupiter-api:jar:5.11.4:test
|  |  +- org.opentest4j:opentest4j:jar:1.3.0:test
|  |  +- org.junit.platform:junit-platform-commons:jar:1.11.4:test
|  |  \- org.apiguardian:apiguardian-api:jar:1.1.2:test
|  +- org.junit.jupiter:junit-jupiter-engine:jar:5.11.4:test
|  |  \- org.junit.platform:junit-platform-engine:jar:1.11.4:test
|  \- org.junit.jupiter:junit-jupiter-params:jar:5.11.4:test
+- org.springframework.boot:spring-boot-starter-web:jar:3.4.11:compile
|  +- org.springframework.boot:spring-boot-starter-json:jar:3.4.11:compile
|  |  +- com.fasterxml.jackson.core:jackson-databind:jar:2.18.4:compile
|  |  |  \- com.fasterxml.jackson.core:jackson-annotations:jar:2.18.4:compile
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
|  +- jakarta.xml.bind:jakarta.xml.bind-api:jar:4.0.4:compile
|  |  \- jakarta.activation:jakarta.activation-api:jar:2.1.4:compile
|  +- net.minidev:json-smart:jar:2.5.2:runtime
|  |  \- net.minidev:accessors-smart:jar:2.5.2:runtime
|  |     \- org.ow2.asm:asm:jar:9.7.1:runtime
|  +- org.assertj:assertj-core:jar:3.26.3:test
|  +- org.awaitility:awaitility:jar:4.2.2:test
|  +- org.hamcrest:hamcrest:jar:2.2:test
|  +- org.junit.jupiter:junit-jupiter:jar:5.11.4:test
|  +- org.mockito:mockito-junit-jupiter:jar:5.14.2:test
|  +- org.skyscreamer:jsonassert:jar:1.5.3:test
|  |  \- com.vaadin.external.google:android-json:jar:0.0.20131108.vaadin1:test
|  +- org.springframework:spring-core:jar:6.2.12:compile
|  |  \- org.springframework:spring-jcl:jar:6.2.12:compile
|  +- org.springframework:spring-test:jar:6.2.12:test
|  \- org.xmlunit:xmlunit-core:jar:2.10.4:test
+- org.apache.camel:camel-test-spring-junit5:jar:4.8.9:test
|  \- org.apache.camel:camel-spring-xml:jar:4.8.9:test
|     \- org.apache.camel:camel-core-xml:jar:4.8.9:test
+- org.springframework.boot:spring-boot-autoconfigure:jar:3.4.11:compile
|  \- org.springframework.boot:spring-boot:jar:3.4.11:compile
+- org.springframework.boot:spring-boot-configuration-processor:jar:3.4.11:compile
+- org.apache.commons:commons-lang3:jar:3.18.0:compile
+- org.projectlombok:lombok:jar:1.18.34:provided
+- com.jayway.jsonpath:json-path:jar:2.9.0:compile
+- net.tirasa.connid:connector-framework-internal:jar:1.5.2.0:compile
|  \- net.tirasa.connid:connector-framework:jar:1.5.2.0:compile
+- org.springframework.security:spring-security-oauth2-resource-server:jar:6.4.12:compile
|  +- org.springframework.security:spring-security-core:jar:6.4.12:compile
|  |  \- org.springframework.security:spring-security-crypto:jar:6.4.12:compile
|  +- org.springframework.security:spring-security-oauth2-core:jar:6.4.12:compile
|  \- org.springframework.security:spring-security-web:jar:6.4.12:compile
+- org.springframework.security:spring-security-oauth2-jose:jar:6.4.12:compile
|  \- com.nimbusds:nimbus-jose-jwt:jar:9.37.4:compile
|     \- com.github.stephenc.jcip:jcip-annotations:jar:1.0-1:compile
+- com.altec.bsbr.app.dl:DLBCryptoSDK:jar:3.0:compile
|  \- com.altec.bsbr.app.dl:DLBUtils:jar:1.1:compile
+- com.altec.bsbr.app.dl:DLBCryptoSDKECC:jar:2.6:compile
+- org.bouncycastle:bcprov-jdk18on:jar:1.78.1:compile
+- br.com.santander.dlb:DLBCryptoLoader:jar:1.1:compile
|  \- commons-io:commons-io:jar:2.15.1:compile
\- org.mockito:mockito-core:jar:5.8.0:test
   +- net.bytebuddy:byte-buddy:jar:1.15.11:test
   +- net.bytebuddy:byte-buddy-agent:jar:1.15.11:test
   \- org.objenesis:objenesis:jar:3.3:test
+- org.apache.camel:camel-core:jar:4.8.9:compile
|  +- org.apache.camel:camel-core-engine:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-api:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-base-engine:jar:4.8.9:compile
|  |  |  \- org.apache.camel:camel-base:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-core-reifier:jar:4.8.9:compile
|  |  |  \- org.apache.camel:camel-core-processor:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-management-api:jar:4.8.9:compile
|  |  \- org.apache.camel:camel-util:jar:4.8.9:compile
|  +- org.apache.camel:camel-core-languages:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-core-model:jar:4.8.9:compile
|  |  \- org.apache.camel:camel-xml-jaxp-util:jar:4.8.9:compile
|  +- org.apache.camel:camel-bean:jar:4.8.9:compile
|  +- org.apache.camel:camel-browse:jar:4.8.9:compile
|  +- org.apache.camel:camel-cluster:jar:4.8.9:compile
|  +- org.apache.camel:camel-controlbus:jar:4.8.9:compile
|  +- org.apache.camel:camel-dataformat:jar:4.8.9:compile
|  +- org.apache.camel:camel-dataset:jar:4.8.9:compile
|  +- org.apache.camel:camel-file:jar:4.8.9:compile
|  |  \- commons-codec:commons-codec:jar:1.17.2:compile
|  +- org.apache.camel:camel-health:jar:4.8.9:compile
|  +- org.apache.camel:camel-language:jar:4.8.9:compile
|  +- org.apache.camel:camel-log:jar:4.8.9:compile
|  +- org.apache.camel:camel-ref:jar:4.8.9:compile
|  +- org.apache.camel:camel-rest:jar:4.8.9:compile
|  |  \- org.apache.camel:camel-tooling-model:jar:4.8.9:compile
|  +- org.apache.camel:camel-saga:jar:4.8.9:compile
|  +- org.apache.camel:camel-scheduler:jar:4.8.9:compile
|  +- org.apache.camel:camel-seda:jar:4.8.9:compile
|  +- org.apache.camel:camel-stub:jar:4.8.9:compile
|  +- org.apache.camel:camel-timer:jar:4.8.9:compile
|  +- org.apache.camel:camel-validator:jar:4.8.9:compile
|  +- org.apache.camel:camel-xpath:jar:4.8.9:compile
|  +- org.apache.camel:camel-xslt:jar:4.8.9:compile
|  +- org.apache.camel:camel-xml-io:jar:4.8.9:compile
|  |  \- org.apache.camel:camel-xml-io-util:jar:4.8.9:compile
|  +- org.apache.camel:camel-xml-jaxb:jar:4.8.9:compile
|  |  \- org.glassfish.jaxb:jaxb-runtime:jar:4.0.6:compile
|  |     \- org.glassfish.jaxb:jaxb-core:jar:4.0.6:compile
|  |        +- org.eclipse.angus:angus-activation:jar:2.0.3:runtime
|  |        +- org.glassfish.jaxb:txw2:jar:4.0.6:compile
|  |        \- com.sun.istack:istack-commons-runtime:jar:4.1.2:compile
|  +- org.apache.camel:camel-xml-jaxp:jar:4.8.9:compile
|  +- org.apache.camel:camel-yaml-io:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-core-catalog:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-util-json:jar:4.8.9:compile
|  |  \- com.fasterxml.jackson.dataformat:jackson-dataformat-yaml:jar:2.18.4:compile
|  |     \- com.fasterxml.jackson.core:jackson-core:jar:2.18.4.1:compile
|  \- org.slf4j:slf4j-api:jar:2.0.17:compile
+- com.santander.ars:gln-back-arsenal-global-observability-starter:jar:3.18.11:compile
|  +- org.springframework.boot:spring-boot-starter-actuator:jar:3.4.11:compile
|  |  +- org.springframework.boot:spring-boot-actuator-autoconfigure:jar:3.4.11:compile
|  |  |  \- org.springframework.boot:spring-boot-actuator:jar:3.4.11:compile
|  |  \- io.micrometer:micrometer-jakarta9:jar:1.14.12:compile
|  |     \- io.micrometer:micrometer-core:jar:1.11.0:compile
|  |        +- org.hdrhistogram:HdrHistogram:jar:2.1.12:runtime
|  |        \- org.latencyutils:LatencyUtils:jar:2.0.3:runtime
|  +- org.projectlombok:lombok:jar:1.18.34:provided
|  +- io.micrometer:micrometer-tracing:jar:1.1.1:compile
|  |  +- io.micrometer:context-propagation:jar:1.1.3:compile
|  |  \- aopalliance:aopalliance:jar:1.0:compile
|  +- io.micrometer:micrometer-tracing-bridge-brave:jar:1.1.1:compile
|  |  +- io.zipkin.brave:brave:jar:6.0.3:compile
|  |  +- io.zipkin.brave:brave-context-slf4j:jar:6.0.3:compile
|  |  +- io.zipkin.brave:brave-instrumentation-http:jar:6.0.3:compile
|  |  \- io.zipkin.aws:brave-propagation-aws:jar:0.23.4:compile
|  +- org.springframework.boot:spring-boot-starter-json:jar:3.4.11:compile
|  |  +- com.fasterxml.jackson.core:jackson-databind:jar:2.18.4:compile
|  |  |  \- com.fasterxml.jackson.core:jackson-annotations:jar:2.18.4:compile
|  |  +- com.fasterxml.jackson.datatype:jackson-datatype-jdk8:jar:2.18.4:compile
|  |  +- com.fasterxml.jackson.datatype:jackson-datatype-jsr310:jar:2.18.4:compile
|  |  \- com.fasterxml.jackson.module:jackson-module-parameter-names:jar:2.18.4:compile
|  +- org.springframework.boot:spring-boot-starter-aop:jar:3.4.11:compile
|  |  \- org.springframework:spring-aop:jar:6.2.12:compile
|  +- com.santander.ars:gln-back-arsenal-log-core:jar:3.18.11:compile
|  +- com.santander.ars:gln-back-arsenal-logback-core:jar:3.18.11:compile
|  |  +- com.santander.ars:gln-back-arsenal-logback-kafka-appender:jar:3.18.11:compile
|  |  |  +- org.xerial.snappy:snappy-java:jar:1.1.10.5:compile
|  |  |  \- org.apache.kafka:kafka-clients:jar:3.9.1:compile
|  |  |     +- com.github.luben:zstd-jni:jar:1.5.6-4:runtime
|  |  |     \- org.lz4:lz4-java:jar:1.8.0:runtime
|  |  +- ch.qos.logback.contrib:logback-json-classic:jar:0.1.5:compile
|  |  |  \- ch.qos.logback.contrib:logback-json-core:jar:0.1.5:compile
|  |  +- ch.qos.logback.contrib:logback-jackson:jar:0.1.5:compile
|  |  \- org.springframework:spring-context:jar:6.2.12:compile
|  +- ch.qos.logback:logback-core:jar:1.5.19:compile
|  +- net.logstash.logback:logstash-logback-encoder:jar:7.3:compile
|  +- org.apache.commons:commons-text:jar:1.10.0:compile
|  |  \- org.apache.commons:commons-lang3:jar:3.18.0:compile
|  +- org.json:json:jar:20231013:compile
|  +- org.aspectj:aspectjweaver:jar:1.9.24:compile
|  +- org.springframework.boot:spring-boot-starter-webflux:jar:3.4.11:compile
|  |  +- org.springframework.boot:spring-boot-starter-reactor-netty:jar:3.4.11:compile
|  |  |  \- io.projectreactor.netty:reactor-netty-http:jar:1.2.11:compile
|  |  |     +- io.netty:netty-codec-http:jar:4.1.127.Final:compile
|  |  |     |  +- io.netty:netty-common:jar:4.1.128.Final:compile
|  |  |     |  +- io.netty:netty-buffer:jar:4.1.128.Final:compile
|  |  |     |  +- io.netty:netty-transport:jar:4.1.128.Final:compile
|  |  |     |  +- io.netty:netty-codec:jar:4.1.127.Final:compile
|  |  |     |  \- io.netty:netty-handler:jar:4.1.128.Final:compile
|  |  |     +- io.netty:netty-codec-http2:jar:4.1.128.Final:compile
|  |  |     +- io.netty:netty-resolver-dns:jar:4.1.128.Final:compile
|  |  |     |  +- io.netty:netty-resolver:jar:4.1.128.Final:compile
|  |  |     |  \- io.netty:netty-codec-dns:jar:4.1.128.Final:compile
|  |  |     +- io.netty:netty-resolver-dns-native-macos:jar:osx-x86_64:4.1.128.Final:compile
|  |  |     |  \- io.netty:netty-resolver-dns-classes-macos:jar:4.1.128.Final:compile
|  |  |     +- io.netty:netty-transport-native-epoll:jar:linux-x86_64:4.1.128.Final:compile
|  |  |     |  +- io.netty:netty-transport-native-unix-common:jar:4.1.128.Final:compile
|  |  |     |  \- io.netty:netty-transport-classes-epoll:jar:4.1.128.Final:compile
|  |  |     \- io.projectreactor.netty:reactor-netty-core:jar:1.2.11:compile
|  |  |        \- io.netty:netty-handler-proxy:jar:4.1.128.Final:compile
|  |  |           \- io.netty:netty-codec-socks:jar:4.1.128.Final:compile
|  |  \- org.springframework:spring-webflux:jar:6.2.12:compile
|  |     \- io.projectreactor:reactor-core:jar:3.7.12:compile
|  |        \- org.reactivestreams:reactive-streams:jar:1.0.4:compile
|  \- org.mapstruct:mapstruct:jar:1.4.2.Final:compile
+- com.santander.ars:ars-altair-connector-mq:jar:1.0.0:compile
|  +- com.santander.ars:ars-altair-connector-psformat:jar:1.0.0:compile
|  +- com.santander.ars:ars-altair-connector-core:jar:1.0.0:compile
|  \- ch.qos.logback:logback-classic:jar:1.5.19:compile
+- org.springframework.boot:spring-boot-starter-test:jar:3.4.11:test
|  +- org.springframework.boot:spring-boot-starter:jar:3.4.11:compile
|  |  +- org.springframework.boot:spring-boot:jar:3.4.11:compile
|  |  +- org.springframework.boot:spring-boot-autoconfigure:jar:3.4.11:compile
|  |  +- org.springframework.boot:spring-boot-starter-logging:jar:3.4.11:compile
|  |  |  +- org.apache.logging.log4j:log4j-to-slf4j:jar:2.24.3:compile
|  |  |  |  \- org.apache.logging.log4j:log4j-api:jar:2.24.3:compile
|  |  |  \- org.slf4j:jul-to-slf4j:jar:2.0.17:compile
|  |  +- jakarta.annotation:jakarta.annotation-api:jar:2.1.1:compile
|  |  \- org.yaml:snakeyaml:jar:2.3:compile
|  +- org.springframework.boot:spring-boot-test:jar:3.4.11:test
|  +- org.springframework.boot:spring-boot-test-autoconfigure:jar:3.4.11:test
|  +- com.jayway.jsonpath:json-path:jar:2.9.0:test
|  +- jakarta.xml.bind:jakarta.xml.bind-api:jar:4.0.4:compile
|  |  \- jakarta.activation:jakarta.activation-api:jar:2.1.4:compile
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
|  +- org.mockito:mockito-core:jar:5.8.0:test
|  |  +- net.bytebuddy:byte-buddy-agent:jar:1.15.11:test
|  |  \- org.objenesis:objenesis:jar:3.3:test
|  +- org.mockito:mockito-junit-jupiter:jar:5.14.2:test
|  +- org.skyscreamer:jsonassert:jar:1.5.3:test
|  |  \- com.vaadin.external.google:android-json:jar:0.0.20131108.vaadin1:test
|  +- org.springframework:spring-core:jar:6.2.12:compile
|  |  \- org.springframework:spring-jcl:jar:6.2.12:compile
|  +- org.springframework:spring-test:jar:6.2.12:test
|  \- org.xmlunit:xmlunit-core:jar:2.10.4:test
+- org.apache.camel:camel-test-spring-junit5:jar:4.8.9:test
|  +- org.apache.camel:camel-test-junit5:jar:4.8.9:test
|  \- org.apache.camel:camel-spring-xml:jar:4.8.9:test
|     +- org.apache.camel:camel-spring:jar:4.8.9:test
|     |  \- org.springframework:spring-tx:jar:6.2.12:test
|     \- org.apache.camel:camel-core-xml:jar:4.8.9:test
+- io.micrometer:micrometer-observation-test:jar:1.11.0:test
|  \- io.micrometer:micrometer-observation:jar:1.11.0:compile
|     \- io.micrometer:micrometer-commons:jar:1.11.0:compile
+- org.springframework.boot:spring-boot-starter-web:jar:3.4.11:test
|  +- org.springframework.boot:spring-boot-starter-tomcat:jar:3.4.11:test
|  |  +- org.apache.tomcat.embed:tomcat-embed-core:jar:10.1.48:test
|  |  +- org.apache.tomcat.embed:tomcat-embed-el:jar:10.1.48:test
|  |  \- org.apache.tomcat.embed:tomcat-embed-websocket:jar:10.1.48:test
|  +- org.springframework:spring-web:jar:6.2.12:compile
|  |  \- org.springframework:spring-beans:jar:6.2.12:compile
|  \- org.springframework:spring-webmvc:jar:6.2.12:test
|     \- org.springframework:spring-expression:jar:6.2.12:compile
+- org.apache.camel:camel-direct:jar:4.8.9:test
|  \- org.apache.camel:camel-support:jar:4.8.9:compile
\- org.apache.camel:camel-mock:jar:4.8.9:test
+- com.santander.ars:gln-back-arsenal-integration-observability-starter:jar:4.16.11-SNAPSHOT:compile
|  +- org.apache.camel:camel-core:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-core-engine:jar:4.8.9:compile
|  |  |  +- org.apache.camel:camel-base-engine:jar:4.8.9:compile
|  |  |  |  \- org.apache.camel:camel-base:jar:4.8.9:compile
|  |  |  \- org.apache.camel:camel-core-reifier:jar:4.8.9:compile
|  |  |     \- org.apache.camel:camel-core-processor:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-core-languages:jar:4.8.9:compile
|  |  |  \- org.apache.camel:camel-core-model:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-bean:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-browse:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-cluster:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-controlbus:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-dataformat:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-dataset:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-direct:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-file:jar:4.8.9:compile
|  |  |  \- commons-codec:commons-codec:jar:1.17.2:compile
|  |  +- org.apache.camel:camel-health:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-language:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-log:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-mock:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-ref:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-rest:jar:4.8.9:compile
|  |  |  \- org.apache.camel:camel-tooling-model:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-saga:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-scheduler:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-seda:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-stub:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-timer:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-validator:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-xpath:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-xslt:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-xml-io:jar:4.8.9:compile
|  |  |  \- org.apache.camel:camel-xml-io-util:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-xml-jaxb:jar:4.8.9:compile
|  |  |  +- jakarta.xml.bind:jakarta.xml.bind-api:jar:4.0.4:compile
|  |  |  |  \- jakarta.activation:jakarta.activation-api:jar:2.1.4:compile
|  |  |  \- org.glassfish.jaxb:jaxb-runtime:jar:4.0.6:compile
|  |  |     \- org.glassfish.jaxb:jaxb-core:jar:4.0.6:compile
|  |  |        +- org.eclipse.angus:angus-activation:jar:2.0.3:runtime
|  |  |        +- org.glassfish.jaxb:txw2:jar:4.0.6:compile
|  |  |        \- com.sun.istack:istack-commons-runtime:jar:4.1.2:compile
|  |  +- org.apache.camel:camel-xml-jaxp:jar:4.8.9:compile
|  |  \- org.apache.camel:camel-yaml-io:jar:4.8.9:compile
|  |     +- org.apache.camel:camel-core-catalog:jar:4.8.9:compile
|  |     \- com.fasterxml.jackson.dataformat:jackson-dataformat-yaml:jar:2.18.4:compile
|  |        +- org.yaml:snakeyaml:jar:2.3:compile
|  |        \- com.fasterxml.jackson.core:jackson-core:jar:2.18.4.1:compile
|  +- com.santander.ars:gln-back-arsenal-global-observability-starter:jar:3.18.11:compile
|  |  +- org.springframework.boot:spring-boot-starter-actuator:jar:3.4.11:compile
|  |  |  +- org.springframework.boot:spring-boot-starter:jar:3.4.11:compile
|  |  |  |  +- org.springframework.boot:spring-boot:jar:3.4.11:compile
|  |  |  |  +- org.springframework.boot:spring-boot-autoconfigure:jar:3.4.11:compile
|  |  |  |  +- org.springframework.boot:spring-boot-starter-logging:jar:3.4.11:compile
|  |  |  |  |  +- org.apache.logging.log4j:log4j-to-slf4j:jar:2.24.3:compile
|  |  |  |  |  |  \- org.apache.logging.log4j:log4j-api:jar:2.24.3:compile
|  |  |  |  |  \- org.slf4j:jul-to-slf4j:jar:2.0.17:compile
|  |  |  |  +- jakarta.annotation:jakarta.annotation-api:jar:2.1.1:compile
|  |  |  |  \- org.springframework:spring-core:jar:6.2.12:compile
|  |  |  |     \- org.springframework:spring-jcl:jar:6.2.12:compile
|  |  |  +- org.springframework.boot:spring-boot-actuator-autoconfigure:jar:3.4.11:compile
|  |  |  |  \- org.springframework.boot:spring-boot-actuator:jar:3.4.11:compile
|  |  |  +- io.micrometer:micrometer-observation:jar:1.14.12:compile
|  |  |  |  \- io.micrometer:micrometer-commons:jar:1.14.12:compile
|  |  |  \- io.micrometer:micrometer-jakarta9:jar:1.14.12:compile
|  |  |     \- io.micrometer:micrometer-core:jar:1.14.12:compile
|  |  |        +- org.hdrhistogram:HdrHistogram:jar:2.2.2:runtime
|  |  |        \- org.latencyutils:LatencyUtils:jar:2.0.3:runtime
|  |  +- org.springframework.boot:spring-boot-starter-web:jar:3.4.11:compile
|  |  |  +- org.springframework.boot:spring-boot-starter-tomcat:jar:3.4.11:compile
|  |  |  |  +- org.apache.tomcat.embed:tomcat-embed-core:jar:10.1.48:compile
|  |  |  |  +- org.apache.tomcat.embed:tomcat-embed-el:jar:10.1.48:compile
|  |  |  |  \- org.apache.tomcat.embed:tomcat-embed-websocket:jar:10.1.48:compile
|  |  |  +- org.springframework:spring-web:jar:6.2.12:compile
|  |  |  |  \- org.springframework:spring-beans:jar:6.2.12:compile
|  |  |  \- org.springframework:spring-webmvc:jar:6.2.12:compile
|  |  |     \- org.springframework:spring-expression:jar:6.2.12:compile
|  |  +- io.micrometer:micrometer-tracing:jar:1.4.11:compile
|  |  |  +- io.micrometer:context-propagation:jar:1.1.3:compile
|  |  |  \- aopalliance:aopalliance:jar:1.0:compile
|  |  +- io.micrometer:micrometer-tracing-bridge-brave:jar:1.4.11:compile
|  |  |  +- io.zipkin.brave:brave:jar:6.0.3:compile
|  |  |  +- io.zipkin.brave:brave-context-slf4j:jar:6.0.3:compile
|  |  |  +- io.zipkin.brave:brave-instrumentation-http:jar:6.0.3:compile
|  |  |  +- io.zipkin.aws:brave-propagation-aws:jar:1.2.5:compile
|  |  |  \- io.zipkin.contrib.brave-propagation-w3c:brave-propagation-tracecontext:jar:0.2.0:compile
|  |  +- org.springframework.boot:spring-boot-starter-json:jar:3.4.11:compile
|  |  |  +- com.fasterxml.jackson.core:jackson-databind:jar:2.18.4:compile
|  |  |  |  \- com.fasterxml.jackson.core:jackson-annotations:jar:2.18.4:compile
|  |  |  +- com.fasterxml.jackson.datatype:jackson-datatype-jdk8:jar:2.18.4:compile
|  |  |  +- com.fasterxml.jackson.datatype:jackson-datatype-jsr310:jar:2.18.4:compile
|  |  |  \- com.fasterxml.jackson.module:jackson-module-parameter-names:jar:2.18.4:compile
|  |  +- org.springframework.boot:spring-boot-starter-aop:jar:3.4.11:compile
|  |  |  \- org.springframework:spring-aop:jar:6.2.12:compile
|  |  +- com.santander.ars:gln-back-arsenal-log-core:jar:3.18.11:compile
|  |  +- com.santander.ars:gln-back-arsenal-logback-core:jar:3.18.11:compile
|  |  |  +- com.santander.ars:gln-back-arsenal-logback-kafka-appender:jar:3.18.11:compile
|  |  |  |  +- org.xerial.snappy:snappy-java:jar:1.1.10.5:compile
|  |  |  |  \- org.apache.kafka:kafka-clients:jar:3.9.1:compile
|  |  |  |     +- com.github.luben:zstd-jni:jar:1.5.6-4:runtime
|  |  |  |     \- org.lz4:lz4-java:jar:1.8.0:runtime
|  |  |  +- ch.qos.logback.contrib:logback-json-classic:jar:0.1.5:compile
|  |  |  |  \- ch.qos.logback.contrib:logback-json-core:jar:0.1.5:compile
|  |  |  +- ch.qos.logback.contrib:logback-jackson:jar:0.1.5:compile
|  |  |  \- org.springframework:spring-context:jar:6.2.12:compile
|  |  +- ch.qos.logback:logback-core:jar:1.5.19:compile
|  |  +- net.logstash.logback:logstash-logback-encoder:jar:7.3:compile
|  |  +- org.apache.commons:commons-text:jar:1.10.0:compile
|  |  |  \- org.apache.commons:commons-lang3:jar:3.18.0:compile
|  |  +- org.json:json:jar:20231013:compile
|  |  +- org.aspectj:aspectjweaver:jar:1.9.24:compile
|  |  +- org.springframework.boot:spring-boot-starter-webflux:jar:3.4.11:compile
|  |  |  +- org.springframework.boot:spring-boot-starter-reactor-netty:jar:3.4.11:compile
|  |  |  |  \- io.projectreactor.netty:reactor-netty-http:jar:1.2.11:compile
|  |  |  |     +- io.netty:netty-codec-http:jar:4.1.127.Final:compile
|  |  |  |     |  +- io.netty:netty-common:jar:4.1.128.Final:compile
|  |  |  |     |  +- io.netty:netty-buffer:jar:4.1.128.Final:compile
|  |  |  |     |  +- io.netty:netty-transport:jar:4.1.128.Final:compile
|  |  |  |     |  +- io.netty:netty-codec:jar:4.1.127.Final:compile
|  |  |  |     |  \- io.netty:netty-handler:jar:4.1.128.Final:compile
|  |  |  |     +- io.netty:netty-codec-http2:jar:4.1.128.Final:compile
|  |  |  |     +- io.netty:netty-resolver-dns:jar:4.1.128.Final:compile
|  |  |  |     |  +- io.netty:netty-resolver:jar:4.1.128.Final:compile
|  |  |  |     |  \- io.netty:netty-codec-dns:jar:4.1.128.Final:compile
|  |  |  |     +- io.netty:netty-resolver-dns-native-macos:jar:osx-x86_64:4.1.128.Final:compile
|  |  |  |     |  \- io.netty:netty-resolver-dns-classes-macos:jar:4.1.128.Final:compile
|  |  |  |     +- io.netty:netty-transport-native-epoll:jar:linux-x86_64:4.1.128.Final:compile
|  |  |  |     |  +- io.netty:netty-transport-native-unix-common:jar:4.1.128.Final:compile
|  |  |  |     |  \- io.netty:netty-transport-classes-epoll:jar:4.1.128.Final:compile
|  |  |  |     \- io.projectreactor.netty:reactor-netty-core:jar:1.2.11:compile
|  |  |  |        \- io.netty:netty-handler-proxy:jar:4.1.128.Final:compile
|  |  |  |           \- io.netty:netty-codec-socks:jar:4.1.128.Final:compile
|  |  |  \- org.springframework:spring-webflux:jar:6.2.12:compile
|  |  |     \- io.projectreactor:reactor-core:jar:3.7.12:compile
|  |  |        \- org.reactivestreams:reactive-streams:jar:1.0.4:compile
|  |  \- org.mapstruct:mapstruct:jar:1.4.2.Final:compile
|  \- com.santander.ars:ars-altair-connector-mq:jar:1.0.0:compile
|     +- com.santander.ars:ars-altair-connector-psformat:jar:1.0.0:compile
|     +- com.santander.ars:ars-altair-connector-core:jar:1.0.0:compile
|     \- ch.qos.logback:logback-classic:jar:1.5.19:compile
+- org.apache.camel:camel-http-base:jar:4.8.9:compile
|  \- org.apache.camel:camel-support:jar:4.8.9:compile
|     +- org.apache.camel:camel-api:jar:4.8.9:compile
|     +- org.apache.camel:camel-management-api:jar:4.8.9:compile
|     +- org.apache.camel:camel-util:jar:4.8.9:compile
|     +- org.apache.camel:camel-util-json:jar:4.8.9:compile
|     \- org.apache.camel:camel-xml-jaxp-util:jar:4.8.9:compile
+- org.apache.camel:camel-bean-validator:jar:4.8.9:compile
|  +- org.hibernate.validator:hibernate-validator:jar:8.0.3.Final:compile
|  |  \- com.fasterxml:classmate:jar:1.7.1:compile
|  +- org.jboss.logging:jboss-logging:jar:3.6.1.Final:compile
|  +- jakarta.el:jakarta.el-api:jar:6.0.1:compile
|  +- org.glassfish.expressly:expressly:jar:5.0.0:compile
|  \- org.slf4j:slf4j-api:jar:2.0.17:compile
+- jakarta.validation:jakarta.validation-api:jar:3.0.2:compile
+- org.springframework.boot:spring-boot-configuration-processor:jar:3.4.11:compile
+- org.projectlombok:lombok:jar:1.18.34:provided
+- org.junit.jupiter:junit-jupiter:jar:5.11.4:compile
|  +- org.junit.jupiter:junit-jupiter-api:jar:5.11.4:compile
|  |  +- org.opentest4j:opentest4j:jar:1.3.0:compile
|  |  +- org.junit.platform:junit-platform-commons:jar:1.11.4:compile
|  |  \- org.apiguardian:apiguardian-api:jar:1.1.2:compile
|  +- org.junit.jupiter:junit-jupiter-params:jar:5.11.4:compile
|  \- org.junit.jupiter:junit-jupiter-engine:jar:5.11.4:runtime
|     \- org.junit.platform:junit-platform-engine:jar:1.11.4:runtime
\- org.mockito:mockito-junit-jupiter:jar:5.14.2:test
   \- org.mockito:mockito-core:jar:5.8.0:test
      +- net.bytebuddy:byte-buddy:jar:1.15.11:test
      +- net.bytebuddy:byte-buddy-agent:jar:1.15.11:test
      \- org.objenesis:objenesis:jar:3.3:test
+- org.apache.camel:camel-core:jar:4.8.9:compile
|  +- org.apache.camel:camel-core-engine:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-api:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-base-engine:jar:4.8.9:compile
|  |  |  \- org.apache.camel:camel-base:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-core-reifier:jar:4.8.9:compile
|  |  |  \- org.apache.camel:camel-core-processor:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-support:jar:4.8.9:compile
|  |  \- org.apache.camel:camel-util:jar:4.8.9:compile
|  +- org.apache.camel:camel-core-languages:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-core-model:jar:4.8.9:compile
|  |  \- org.apache.camel:camel-xml-jaxp-util:jar:4.8.9:compile
|  +- org.apache.camel:camel-bean:jar:4.8.9:compile
|  +- org.apache.camel:camel-browse:jar:4.8.9:compile
|  +- org.apache.camel:camel-cluster:jar:4.8.9:compile
|  +- org.apache.camel:camel-controlbus:jar:4.8.9:compile
|  +- org.apache.camel:camel-dataformat:jar:4.8.9:compile
|  +- org.apache.camel:camel-dataset:jar:4.8.9:compile
|  +- org.apache.camel:camel-direct:jar:4.8.9:compile
|  +- org.apache.camel:camel-file:jar:4.8.9:compile
|  |  \- commons-codec:commons-codec:jar:1.17.2:compile
|  +- org.apache.camel:camel-health:jar:4.8.9:compile
|  +- org.apache.camel:camel-language:jar:4.8.9:compile
|  +- org.apache.camel:camel-log:jar:4.8.9:compile
|  +- org.apache.camel:camel-mock:jar:4.8.9:compile
|  +- org.apache.camel:camel-ref:jar:4.8.9:compile
|  +- org.apache.camel:camel-rest:jar:4.8.9:compile
|  |  \- org.apache.camel:camel-tooling-model:jar:4.8.9:compile
|  +- org.apache.camel:camel-saga:jar:4.8.9:compile
|  +- org.apache.camel:camel-scheduler:jar:4.8.9:compile
|  +- org.apache.camel:camel-seda:jar:4.8.9:compile
|  +- org.apache.camel:camel-stub:jar:4.8.9:compile
|  +- org.apache.camel:camel-timer:jar:4.8.9:compile
|  +- org.apache.camel:camel-validator:jar:4.8.9:compile
|  +- org.apache.camel:camel-xpath:jar:4.8.9:compile
|  +- org.apache.camel:camel-xslt:jar:4.8.9:compile
|  +- org.apache.camel:camel-xml-io:jar:4.8.9:compile
|  |  \- org.apache.camel:camel-xml-io-util:jar:4.8.9:compile
|  +- org.apache.camel:camel-xml-jaxb:jar:4.8.9:compile
|  |  +- jakarta.xml.bind:jakarta.xml.bind-api:jar:4.0.4:compile
|  |  |  \- jakarta.activation:jakarta.activation-api:jar:2.1.4:compile
|  |  \- org.glassfish.jaxb:jaxb-runtime:jar:4.0.6:compile
|  |     \- org.glassfish.jaxb:jaxb-core:jar:4.0.6:compile
|  |        +- org.eclipse.angus:angus-activation:jar:2.0.3:runtime
|  |        +- org.glassfish.jaxb:txw2:jar:4.0.6:compile
|  |        \- com.sun.istack:istack-commons-runtime:jar:4.1.2:compile
|  +- org.apache.camel:camel-xml-jaxp:jar:4.8.9:compile
|  +- org.apache.camel:camel-yaml-io:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-core-catalog:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-util-json:jar:4.8.9:compile
|  |  \- com.fasterxml.jackson.dataformat:jackson-dataformat-yaml:jar:2.18.4:compile
|  |     +- com.fasterxml.jackson.core:jackson-databind:jar:2.18.4:compile
|  |     |  \- com.fasterxml.jackson.core:jackson-annotations:jar:2.18.4:compile
|  |     \- com.fasterxml.jackson.core:jackson-core:jar:2.18.4.1:compile
|  \- org.slf4j:slf4j-api:jar:2.0.17:compile
+- org.apache.camel:camel-endpointdsl:jar:4.8.9:compile
+- org.apache.camel.springboot:camel-spring-boot-starter:jar:4.8.9:compile
|  +- org.springframework.boot:spring-boot-starter:jar:3.4.11:compile
|  |  +- org.springframework.boot:spring-boot-starter-logging:jar:3.4.11:compile
|  |  |  +- org.apache.logging.log4j:log4j-to-slf4j:jar:2.24.3:compile
|  |  |  |  \- org.apache.logging.log4j:log4j-api:jar:2.24.3:compile
|  |  |  \- org.slf4j:jul-to-slf4j:jar:2.0.17:compile
|  |  +- jakarta.annotation:jakarta.annotation-api:jar:2.1.1:compile
|  |  \- org.yaml:snakeyaml:jar:2.3:compile
|  +- org.apache.camel.springboot:camel-spring-boot:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-spring-main:jar:4.8.9:compile
|  |  |  \- org.apache.camel:camel-main:jar:4.8.9:compile
|  |  \- org.apache.camel:camel-cloud:jar:4.8.9:compile
|  +- org.apache.camel.springboot:camel-core-starter:jar:4.8.9:compile
|  +- org.apache.camel.springboot:camel-bean-starter:jar:4.8.9:compile
|  +- org.apache.camel.springboot:camel-browse-starter:jar:4.8.9:compile
|  +- org.apache.camel.springboot:camel-controlbus-starter:jar:4.8.9:compile
|  +- org.apache.camel.springboot:camel-dataformat-starter:jar:4.8.9:compile
|  +- org.apache.camel.springboot:camel-dataset-starter:jar:4.8.9:compile
|  +- org.apache.camel.springboot:camel-direct-starter:jar:4.8.9:compile
|  +- org.apache.camel.springboot:camel-file-starter:jar:4.8.9:compile
|  +- org.apache.camel.springboot:camel-language-starter:jar:4.8.9:compile
|  +- org.apache.camel.springboot:camel-log-starter:jar:4.8.9:compile
|  +- org.apache.camel.springboot:camel-mock-starter:jar:4.8.9:compile
|  +- org.apache.camel.springboot:camel-ref-starter:jar:4.8.9:compile
|  +- org.apache.camel.springboot:camel-rest-starter:jar:4.8.9:compile
|  +- org.apache.camel.springboot:camel-saga-starter:jar:4.8.9:compile
|  +- org.apache.camel.springboot:camel-scheduler-starter:jar:4.8.9:compile
|  +- org.apache.camel.springboot:camel-seda-starter:jar:4.8.9:compile
|  +- org.apache.camel.springboot:camel-stub-starter:jar:4.8.9:compile
|  +- org.apache.camel.springboot:camel-timer-starter:jar:4.8.9:compile
|  +- org.apache.camel.springboot:camel-validator-starter:jar:4.8.9:compile
|  +- org.apache.camel.springboot:camel-xpath-starter:jar:4.8.9:compile
|  +- org.apache.camel.springboot:camel-xslt-starter:jar:4.8.9:compile
|  \- org.apache.camel.springboot:camel-xml-jaxp-starter:jar:4.8.9:compile
+- org.apache.camel:camel-spring:jar:4.8.9:compile
|  +- org.apache.camel:camel-management-api:jar:4.8.9:compile
|  +- org.springframework:spring-core:jar:6.2.12:compile
|  |  \- org.springframework:spring-jcl:jar:6.2.12:compile
|  +- org.springframework:spring-aop:jar:6.2.12:compile
|  +- org.springframework:spring-context:jar:6.2.12:compile
|  |  \- io.micrometer:micrometer-observation:jar:1.14.12:compile
|  |     \- io.micrometer:micrometer-commons:jar:1.14.12:compile
|  +- org.springframework:spring-beans:jar:6.2.12:compile
|  +- org.springframework:spring-expression:jar:6.2.12:compile
|  \- org.springframework:spring-tx:jar:6.2.12:compile
+- org.apache.camel:camel-api-component-maven-plugin:jar:4.8.9:compile
|  +- org.apache.camel:camel-tooling-util:jar:4.8.9:compile
|  +- org.apache.maven.reporting:maven-reporting-api:jar:3.1.1:compile
|  |  \- org.apache.maven.doxia:doxia-sink-api:jar:1.11.1:compile
|  |     \- org.apache.maven.doxia:doxia-logging-api:jar:1.11.1:compile
|  +- org.codehaus.plexus:plexus-utils:jar:4.0.1:compile
|  +- org.codehaus.plexus:plexus-build-api:jar:1.2.0:compile
|  |  +- javax.inject:javax.inject:jar:1:compile
|  |  +- org.sonatype.plexus:plexus-build-api:jar:0.0.7:compile
|  |  \- org.eclipse.sisu:org.eclipse.sisu.plexus:jar:0.9.0.M2:compile
|  +- org.apache.velocity:velocity-engine-core:jar:2.3:compile
|  +- org.jboss.forge.roaster:roaster-jdt:jar:2.29.0.Final:compile
|  |  \- org.jboss.forge.roaster:roaster-api:jar:2.29.0.Final:compile
|  \- com.google.guava:guava:jar:32.1.3-jre:compile
|     +- com.google.guava:failureaccess:jar:1.0.1:compile
|     +- com.google.guava:listenablefuture:jar:9999.0-empty-to-avoid-conflict-with-guava:compile
|     +- org.checkerframework:checker-qual:jar:3.37.0:compile
|     +- com.google.errorprone:error_prone_annotations:jar:2.21.1:compile
|     \- com.google.j2objc:j2objc-annotations:jar:2.8:compile
+- org.springframework.boot:spring-boot-configuration-processor:jar:3.4.11:compile
+- com.altec.bsbr.fwk.jab:fwk-jab-lib-core:jar:3.0.1:compile
|  +- org.slf4j:jcl-over-slf4j:jar:2.0.17:compile
|  +- ch.qos.logback:logback-classic:jar:1.5.19:compile
|  +- ch.qos.logback:logback-core:jar:1.5.19:compile
|  +- joda-time:joda-time:jar:2.9.9:compile
|  +- org.aspectj:aspectjweaver:jar:1.9.24:compile
|  +- org.aspectj:aspectjtools:jar:1.9.24:compile
|  +- org.aspectj:aspectjrt:jar:1.9.24:compile
|  \- commons-logging:commons-logging:jar:1.2:compile
+- com.altec.bsbr.fwk.jab:fwk-jab-lib-jms:jar:3.0.1:compile
|  +- org.springframework:spring-jms:jar:6.2.12:compile
|  |  \- org.springframework:spring-messaging:jar:6.2.12:compile
|  \- org.springframework:spring-context-support:jar:6.2.12:compile
+- com.altec.bsbr.fwk.jab:fwk-jab-lib-psFormat:jar:2.3.1:compile
+- com.altec.bsbr.fwk.jab:fwk-jab-lib-record:jar:3.0.1:compile
+- org.hibernate.validator:hibernate-validator:jar:9.0.0.Beta2:compile
|  +- jakarta.validation:jakarta.validation-api:jar:3.0.2:compile
|  +- org.jboss.logging:jboss-logging:jar:3.6.1.Final:compile
|  \- com.fasterxml:classmate:jar:1.7.1:compile
+- com.altec.bsbr.fwk.jab:fwk-jab-conn-legado:jar:3.0.2:compile
+- com.ibm.mq:mq-jms-spring-boot-starter:jar:2.1.2:compile
|  +- org.messaginghub:pooled-jms:jar:3.1.7:compile
|  |  +- jakarta.jms:jakarta.jms-api:jar:3.1.0:compile
|  |  \- org.apache.commons:commons-pool2:jar:2.12.1:compile
|  +- org.springframework.boot:spring-boot:jar:3.4.11:compile
|  \- org.springframework.boot:spring-boot-autoconfigure:jar:3.4.11:compile
+- com.ibm.mq:com.ibm.mq.allclient:jar:9.1.3.0:provided
|  +- org.bouncycastle:bcpkix-jdk15on:jar:1.61:provided
|  \- javax.jms:javax.jms-api:jar:2.0.1:provided
+- org.bouncycastle:bcprov-jdk18on:jar:1.78.1:compile
+- org.projectlombok:lombok:jar:1.18.34:provided
+- org.apache.commons:commons-lang3:jar:3.18.0:compile
+- org.apache.camel:camel-test-junit5:jar:4.8.9:test
|  +- org.junit.jupiter:junit-jupiter-api:jar:5.11.4:test
|  |  +- org.opentest4j:opentest4j:jar:1.3.0:test
|  |  +- org.junit.platform:junit-platform-commons:jar:1.11.4:test
|  |  \- org.apiguardian:apiguardian-api:jar:1.1.2:test
|  +- org.junit.jupiter:junit-jupiter-engine:jar:5.11.4:test
|  |  \- org.junit.platform:junit-platform-engine:jar:1.11.4:test
|  \- org.junit.jupiter:junit-jupiter-params:jar:5.11.4:test
+- org.apache.camel:camel-test-spring-junit5:jar:4.8.9:test
|  +- org.apache.camel:camel-spring-xml:jar:4.8.9:test
|  |  \- org.apache.camel:camel-core-xml:jar:4.8.9:test
|  \- org.springframework:spring-test:jar:6.2.12:test
+- org.springframework.boot:spring-boot-test:jar:3.4.11:test
\- org.mockito:mockito-core:jar:5.8.0:test
   +- net.bytebuddy:byte-buddy:jar:1.15.11:test
   +- net.bytebuddy:byte-buddy-agent:jar:1.15.11:test
   \- org.objenesis:objenesis:jar:3.3:test
+- org.apache.maven:maven-plugin-api:jar:3.8.1:provided
|  +- org.eclipse.sisu:org.eclipse.sisu.plexus:jar:0.3.4:provided
|  |  \- javax.enterprise:cdi-api:jar:1.0:provided
|  |     \- javax.annotation:jsr250-api:jar:1.0:provided
|  +- org.codehaus.plexus:plexus-utils:jar:3.2.1:provided
|  \- org.codehaus.plexus:plexus-classworlds:jar:2.6.0:provided
+- org.apache.maven:maven-core:jar:3.8.1:provided
|  +- org.apache.maven:maven-settings:jar:3.8.1:provided
|  +- org.apache.maven:maven-settings-builder:jar:3.8.1:provided
|  |  \- org.sonatype.plexus:plexus-sec-dispatcher:jar:1.4:provided
|  |     \- org.sonatype.plexus:plexus-cipher:jar:1.4:provided
|  +- org.apache.maven:maven-builder-support:jar:3.8.1:provided
|  +- org.apache.maven:maven-repository-metadata:jar:3.8.1:provided
|  +- org.apache.maven:maven-model-builder:jar:3.8.1:provided
|  +- org.apache.maven:maven-resolver-provider:jar:3.8.1:provided
|  +- org.apache.maven.resolver:maven-resolver-impl:jar:1.6.2:provided
|  +- org.apache.maven.resolver:maven-resolver-api:jar:1.6.2:provided
|  +- org.apache.maven.resolver:maven-resolver-spi:jar:1.6.2:provided
|  +- org.apache.maven.resolver:maven-resolver-util:jar:1.6.2:provided
|  +- org.apache.maven.shared:maven-shared-utils:jar:3.2.1:provided
|  +- org.eclipse.sisu:org.eclipse.sisu.inject:jar:0.3.4:provided
|  +- com.google.inject:guice:jar:no_aop:4.2.1:provided
|  |  +- aopalliance:aopalliance:jar:1.0:provided
|  |  \- com.google.guava:guava:jar:32.1.3-jre:provided
|  |     +- com.google.guava:failureaccess:jar:1.0.1:provided
|  |     +- com.google.guava:listenablefuture:jar:9999.0-empty-to-avoid-conflict-with-guava:provided
|  |     +- com.google.code.findbugs:jsr305:jar:3.0.2:provided
|  |     +- org.checkerframework:checker-qual:jar:3.37.0:provided
|  |     +- com.google.errorprone:error_prone_annotations:jar:2.21.1:provided
|  |     \- com.google.j2objc:j2objc-annotations:jar:2.8:provided
|  +- javax.inject:javax.inject:jar:1:provided
|  +- org.codehaus.plexus:plexus-component-annotations:jar:2.1.0:provided
|  \- org.apache.commons:commons-lang3:jar:3.18.0:compile
+- org.apache.maven:maven-artifact:jar:3.8.1:provided
+- org.apache.maven:maven-compat:jar:3.8.1:test
|  +- org.codehaus.plexus:plexus-interpolation:jar:1.25:provided
|  \- org.apache.maven.wagon:wagon-provider-api:jar:3.4.3:test
+- org.apache.maven.plugin-tools:maven-plugin-annotations:jar:3.8.1:provided
+- org.apache.maven.plugin-testing:maven-plugin-testing-harness:jar:3.3.0:test
|  +- commons-io:commons-io:jar:2.15.1:compile
|  \- org.codehaus.plexus:plexus-archiver:jar:2.2:test
|     +- org.codehaus.plexus:plexus-container-default:jar:1.0-alpha-9-stable-1:test
|     |  +- junit:junit:jar:3.8.1:test
|     |  \- classworlds:classworlds:jar:1.1-alpha-2:test
|     \- org.codehaus.plexus:plexus-io:jar:2.0.4:test
+- org.apache.maven:maven-model:jar:3.8.1:test
+- org.junit.jupiter:junit-jupiter-engine:jar:5.9.2:compile
|  +- org.junit.platform:junit-platform-engine:jar:1.9.2:compile
|  |  +- org.opentest4j:opentest4j:jar:1.2.0:compile
|  |  \- org.junit.platform:junit-platform-commons:jar:1.9.2:compile
|  +- org.junit.jupiter:junit-jupiter-api:jar:5.9.2:compile
|  \- org.apiguardian:apiguardian-api:jar:1.1.2:compile
+- io.swagger.parser.v3:swagger-parser-v3:jar:2.1.19:compile
|  +- io.swagger.core.v3:swagger-models:jar:2.2.19:compile
|  +- io.swagger.core.v3:swagger-core:jar:2.2.19:compile
|  |  +- com.fasterxml.jackson.datatype:jackson-datatype-jsr310:jar:2.15.2:compile
|  |  +- io.swagger.core.v3:swagger-annotations:jar:2.2.19:compile
|  |  \- jakarta.validation:jakarta.validation-api:jar:2.0.2:compile
|  +- io.swagger.parser.v3:swagger-parser-core:jar:2.1.19:compile
|  +- io.swagger.parser.v3:swagger-parser-safe-url-resolver:jar:2.1.19:compile
|  +- org.yaml:snakeyaml:jar:2.2:compile
|  +- com.fasterxml.jackson.core:jackson-annotations:jar:2.15.3:compile
|  +- com.fasterxml.jackson.core:jackson-databind:jar:2.15.3:compile
|  |  \- com.fasterxml.jackson.core:jackson-core:jar:2.15.3:compile
|  \- com.fasterxml.jackson.dataformat:jackson-dataformat-yaml:jar:2.15.3:compile
+- com.sun.xml.bind:jaxb-impl:jar:2.3.8:compile
|  +- jakarta.xml.bind:jakarta.xml.bind-api:jar:2.3.3:compile
|  \- com.sun.activation:jakarta.activation:jar:1.2.2:runtime
+- org.apache.velocity:velocity-engine-core:jar:2.3:compile
+- org.slf4j:slf4j-simple:jar:2.0.6:test
|  \- org.slf4j:slf4j-api:jar:2.0.6:compile
\- org.projectlombok:lombok:jar:1.18.34:provided
+- org.apache.maven:maven-plugin-api:jar:3.8.1:provided
|  +- org.eclipse.sisu:org.eclipse.sisu.plexus:jar:0.3.4:provided
|  |  \- javax.enterprise:cdi-api:jar:1.0:provided
|  |     \- javax.annotation:jsr250-api:jar:1.0:provided
|  +- org.codehaus.plexus:plexus-utils:jar:3.2.1:provided
|  \- org.codehaus.plexus:plexus-classworlds:jar:2.6.0:provided
+- org.apache.maven:maven-core:jar:3.8.1:provided
|  +- org.apache.maven:maven-settings:jar:3.8.1:provided
|  +- org.apache.maven:maven-settings-builder:jar:3.8.1:provided
|  |  \- org.sonatype.plexus:plexus-sec-dispatcher:jar:1.4:provided
|  |     \- org.sonatype.plexus:plexus-cipher:jar:1.4:provided
|  +- org.apache.maven:maven-builder-support:jar:3.8.1:provided
|  +- org.apache.maven:maven-repository-metadata:jar:3.8.1:provided
|  +- org.apache.maven:maven-model-builder:jar:3.8.1:provided
|  +- org.apache.maven:maven-resolver-provider:jar:3.8.1:provided
|  +- org.apache.maven.resolver:maven-resolver-impl:jar:1.6.2:provided
|  +- org.apache.maven.resolver:maven-resolver-api:jar:1.6.2:provided
|  +- org.apache.maven.resolver:maven-resolver-spi:jar:1.6.2:provided
|  +- org.apache.maven.resolver:maven-resolver-util:jar:1.6.2:provided
|  +- org.apache.maven.shared:maven-shared-utils:jar:3.2.1:provided
|  +- org.eclipse.sisu:org.eclipse.sisu.inject:jar:0.3.4:provided
|  +- com.google.inject:guice:jar:no_aop:4.2.1:provided
|  |  +- aopalliance:aopalliance:jar:1.0:provided
|  |  \- com.google.guava:guava:jar:32.1.3-jre:provided
|  |     +- com.google.guava:failureaccess:jar:1.0.1:provided
|  |     +- com.google.guava:listenablefuture:jar:9999.0-empty-to-avoid-conflict-with-guava:provided
|  |     +- com.google.code.findbugs:jsr305:jar:3.0.2:provided
|  |     +- org.checkerframework:checker-qual:jar:3.37.0:provided
|  |     +- com.google.errorprone:error_prone_annotations:jar:2.21.1:provided
|  |     \- com.google.j2objc:j2objc-annotations:jar:2.8:provided
|  +- javax.inject:javax.inject:jar:1:provided
|  +- org.codehaus.plexus:plexus-component-annotations:jar:2.1.0:provided
|  \- org.apache.commons:commons-lang3:jar:3.18.0:compile
+- org.apache.maven:maven-artifact:jar:3.8.1:provided
+- org.apache.maven:maven-compat:jar:3.8.1:test
|  +- org.codehaus.plexus:plexus-interpolation:jar:1.25:provided
|  \- org.apache.maven.wagon:wagon-provider-api:jar:3.4.3:test
+- org.apache.maven.plugin-tools:maven-plugin-annotations:jar:3.8.1:provided
+- org.apache.maven.plugin-testing:maven-plugin-testing-harness:jar:3.3.0:test
|  +- commons-io:commons-io:jar:2.15.1:compile
|  \- org.codehaus.plexus:plexus-archiver:jar:2.2:test
|     +- org.codehaus.plexus:plexus-container-default:jar:1.0-alpha-9-stable-1:test
|     |  +- junit:junit:jar:3.8.1:test
|     |  \- classworlds:classworlds:jar:1.1-alpha-2:test
|     \- org.codehaus.plexus:plexus-io:jar:2.0.4:test
+- org.apache.maven:maven-model:jar:3.8.1:test
+- org.junit.jupiter:junit-jupiter-engine:jar:5.10.1:test
|  +- org.junit.platform:junit-platform-engine:jar:1.10.1:test
|  |  +- org.opentest4j:opentest4j:jar:1.3.0:test
|  |  \- org.junit.platform:junit-platform-commons:jar:1.10.1:test
|  +- org.junit.jupiter:junit-jupiter-api:jar:5.10.1:test
|  \- org.apiguardian:apiguardian-api:jar:1.1.2:test
+- io.swagger.parser.v3:swagger-parser-v3:jar:2.1.19:compile
|  +- io.swagger.core.v3:swagger-models:jar:2.2.19:compile
|  +- io.swagger.core.v3:swagger-core:jar:2.2.19:compile
|  |  +- com.fasterxml.jackson.datatype:jackson-datatype-jsr310:jar:2.15.2:compile
|  |  +- io.swagger.core.v3:swagger-annotations:jar:2.2.19:compile
|  |  \- jakarta.validation:jakarta.validation-api:jar:2.0.2:compile
|  +- io.swagger.parser.v3:swagger-parser-core:jar:2.1.19:compile
|  +- io.swagger.parser.v3:swagger-parser-safe-url-resolver:jar:2.1.19:compile
|  +- org.yaml:snakeyaml:jar:2.2:compile
|  +- com.fasterxml.jackson.core:jackson-annotations:jar:2.15.3:compile
|  +- com.fasterxml.jackson.core:jackson-databind:jar:2.15.3:compile
|  |  \- com.fasterxml.jackson.core:jackson-core:jar:2.15.3:compile
|  \- com.fasterxml.jackson.dataformat:jackson-dataformat-yaml:jar:2.15.3:compile
+- com.sun.xml.bind:jaxb-impl:jar:2.3.8:compile
|  +- jakarta.xml.bind:jakarta.xml.bind-api:jar:2.3.3:compile
|  \- com.sun.activation:jakarta.activation:jar:1.2.2:runtime
+- org.apache.velocity:velocity-engine-core:jar:2.3:compile
+- org.slf4j:slf4j-simple:jar:2.0.6:test
|  \- org.slf4j:slf4j-api:jar:2.0.6:compile
\- org.projectlombok:lombok:jar:1.18.34:provided
+- org.springframework.boot:spring-boot-starter-web:jar:3.4.11:compile
|  +- org.springframework.boot:spring-boot-starter:jar:3.4.11:compile
|  |  +- org.springframework.boot:spring-boot-starter-logging:jar:3.4.11:compile
|  |  |  +- ch.qos.logback:logback-classic:jar:1.5.19:compile
|  |  |  |  \- ch.qos.logback:logback-core:jar:1.5.19:compile
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
+- org.apache.camel:camel-core:jar:4.8.9:compile
|  +- org.apache.camel:camel-core-engine:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-api:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-base-engine:jar:4.8.9:compile
|  |  |  \- org.apache.camel:camel-base:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-core-reifier:jar:4.8.9:compile
|  |  |  \- org.apache.camel:camel-core-processor:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-management-api:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-support:jar:4.8.9:compile
|  |  \- org.apache.camel:camel-util:jar:4.8.9:compile
|  +- org.apache.camel:camel-core-languages:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-core-model:jar:4.8.9:compile
|  |  \- org.apache.camel:camel-xml-jaxp-util:jar:4.8.9:compile
|  +- org.apache.camel:camel-bean:jar:4.8.9:compile
|  +- org.apache.camel:camel-browse:jar:4.8.9:compile
|  +- org.apache.camel:camel-cluster:jar:4.8.9:compile
|  +- org.apache.camel:camel-controlbus:jar:4.8.9:compile
|  +- org.apache.camel:camel-dataformat:jar:4.8.9:compile
|  +- org.apache.camel:camel-dataset:jar:4.8.9:compile
|  +- org.apache.camel:camel-direct:jar:4.8.9:compile
|  +- org.apache.camel:camel-file:jar:4.8.9:compile
|  |  \- commons-codec:commons-codec:jar:1.17.2:compile
|  +- org.apache.camel:camel-health:jar:4.8.9:compile
|  +- org.apache.camel:camel-language:jar:4.8.9:compile
|  +- org.apache.camel:camel-log:jar:4.8.9:compile
|  +- org.apache.camel:camel-mock:jar:4.8.9:compile
|  +- org.apache.camel:camel-ref:jar:4.8.9:compile
|  +- org.apache.camel:camel-rest:jar:4.8.9:compile
|  |  \- org.apache.camel:camel-tooling-model:jar:4.8.9:compile
|  +- org.apache.camel:camel-saga:jar:4.8.9:compile
|  +- org.apache.camel:camel-scheduler:jar:4.8.9:compile
|  +- org.apache.camel:camel-seda:jar:4.8.9:compile
|  +- org.apache.camel:camel-stub:jar:4.8.9:compile
|  +- org.apache.camel:camel-timer:jar:4.8.9:compile
|  +- org.apache.camel:camel-validator:jar:4.8.9:compile
|  +- org.apache.camel:camel-xpath:jar:4.8.9:compile
|  +- org.apache.camel:camel-xslt:jar:4.8.9:compile
|  +- org.apache.camel:camel-xml-io:jar:4.8.9:compile
|  |  \- org.apache.camel:camel-xml-io-util:jar:4.8.9:compile
|  +- org.apache.camel:camel-xml-jaxb:jar:4.8.9:compile
|  |  \- org.glassfish.jaxb:jaxb-runtime:jar:4.0.6:compile
|  |     \- org.glassfish.jaxb:jaxb-core:jar:4.0.6:compile
|  |        +- org.eclipse.angus:angus-activation:jar:2.0.3:runtime
|  |        +- org.glassfish.jaxb:txw2:jar:4.0.6:compile
|  |        \- com.sun.istack:istack-commons-runtime:jar:4.1.2:compile
|  +- org.apache.camel:camel-xml-jaxp:jar:4.8.9:compile
|  +- org.apache.camel:camel-yaml-io:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-core-catalog:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-util-json:jar:4.8.9:compile
|  |  \- com.fasterxml.jackson.dataformat:jackson-dataformat-yaml:jar:2.18.4:compile
|  \- org.slf4j:slf4j-api:jar:2.0.17:compile
+- org.springframework.boot:spring-boot-autoconfigure:jar:3.4.11:compile
|  \- org.springframework.boot:spring-boot:jar:3.4.11:compile
+- org.springframework.boot:spring-boot-configuration-processor:jar:3.4.11:compile
+- org.apache.camel.springboot:camel-spring-boot-starter:jar:4.8.9:test
|  +- org.apache.camel.springboot:camel-spring-boot:jar:4.8.9:test
|  |  +- org.apache.camel:camel-spring:jar:4.8.9:test
|  |  |  \- org.springframework:spring-tx:jar:6.2.12:test
|  |  +- org.apache.camel:camel-spring-main:jar:4.8.9:test
|  |  |  \- org.apache.camel:camel-main:jar:4.8.9:test
|  |  \- org.apache.camel:camel-cloud:jar:4.8.9:test
|  +- org.apache.camel.springboot:camel-core-starter:jar:4.8.9:test
|  +- org.apache.camel.springboot:camel-bean-starter:jar:4.8.9:test
|  +- org.apache.camel.springboot:camel-browse-starter:jar:4.8.9:test
|  +- org.apache.camel.springboot:camel-controlbus-starter:jar:4.8.9:test
|  +- org.apache.camel.springboot:camel-dataformat-starter:jar:4.8.9:test
|  +- org.apache.camel.springboot:camel-dataset-starter:jar:4.8.9:test
|  +- org.apache.camel.springboot:camel-direct-starter:jar:4.8.9:test
|  +- org.apache.camel.springboot:camel-file-starter:jar:4.8.9:test
|  +- org.apache.camel.springboot:camel-language-starter:jar:4.8.9:test
|  +- org.apache.camel.springboot:camel-log-starter:jar:4.8.9:test
|  +- org.apache.camel.springboot:camel-mock-starter:jar:4.8.9:test
|  +- org.apache.camel.springboot:camel-ref-starter:jar:4.8.9:test
|  +- org.apache.camel.springboot:camel-rest-starter:jar:4.8.9:test
|  +- org.apache.camel.springboot:camel-saga-starter:jar:4.8.9:test
|  +- org.apache.camel.springboot:camel-scheduler-starter:jar:4.8.9:test
|  +- org.apache.camel.springboot:camel-seda-starter:jar:4.8.9:test
|  +- org.apache.camel.springboot:camel-stub-starter:jar:4.8.9:test
|  +- org.apache.camel.springboot:camel-timer-starter:jar:4.8.9:test
|  +- org.apache.camel.springboot:camel-validator-starter:jar:4.8.9:test
|  +- org.apache.camel.springboot:camel-xpath-starter:jar:4.8.9:test
|  +- org.apache.camel.springboot:camel-xslt-starter:jar:4.8.9:test
|  \- org.apache.camel.springboot:camel-xml-jaxp-starter:jar:4.8.9:test
+- org.apache.camel.springboot:camel-servlet-starter:jar:4.8.9:test
|  \- org.apache.camel:camel-servlet:jar:4.8.9:test
|     \- org.apache.camel:camel-http-common:jar:4.8.9:test
|        +- org.apache.camel:camel-http-base:jar:4.8.9:test
|        \- org.apache.camel:camel-attachments:jar:4.8.9:test
+- org.springframework.boot:spring-boot-starter-test:jar:3.4.11:test
|  +- org.springframework.boot:spring-boot-test:jar:3.4.11:test
|  +- org.springframework.boot:spring-boot-test-autoconfigure:jar:3.4.11:test
|  +- com.jayway.jsonpath:json-path:jar:2.9.0:test
|  +- jakarta.xml.bind:jakarta.xml.bind-api:jar:4.0.4:compile
|  |  \- jakarta.activation:jakarta.activation-api:jar:2.1.4:compile
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
|  +- org.mockito:mockito-core:jar:5.8.0:test
|  |  +- net.bytebuddy:byte-buddy-agent:jar:1.15.11:test
|  |  \- org.objenesis:objenesis:jar:3.3:test
|  +- org.mockito:mockito-junit-jupiter:jar:5.14.2:test
|  +- org.skyscreamer:jsonassert:jar:1.5.3:test
|  |  \- com.vaadin.external.google:android-json:jar:0.0.20131108.vaadin1:test
|  +- org.springframework:spring-core:jar:6.2.12:compile
|  |  \- org.springframework:spring-jcl:jar:6.2.12:compile
|  +- org.springframework:spring-test:jar:6.2.12:test
|  \- org.xmlunit:xmlunit-core:jar:2.10.4:test
+- org.apache.camel:camel-test-spring-junit5:jar:4.8.9:test
|  +- org.apache.camel:camel-test-junit5:jar:4.8.9:test
|  \- org.apache.camel:camel-spring-xml:jar:4.8.9:test
|     \- org.apache.camel:camel-core-xml:jar:4.8.9:test
\- io.rest-assured:rest-assured:jar:5.5.6:test
   +- org.apache.groovy:groovy:jar:4.0.29:test
   +- org.apache.groovy:groovy-xml:jar:4.0.29:test
   +- org.apache.httpcomponents:httpclient:jar:4.5.13:test
   |  +- org.apache.httpcomponents:httpcore:jar:4.4.16:test
   |  \- commons-logging:commons-logging:jar:1.2:test
   +- org.apache.httpcomponents:httpmime:jar:4.5.13:test
   +- org.ccil.cowan.tagsoup:tagsoup:jar:1.2.1:test
   +- io.rest-assured:json-path:jar:5.5.6:test
   |  +- org.apache.groovy:groovy-json:jar:4.0.29:test
   |  \- io.rest-assured:rest-assured-common:jar:5.5.6:test
   \- io.rest-assured:xml-path:jar:5.5.6:test
      \- org.apache.commons:commons-lang3:jar:3.18.0:test
+- org.springframework.boot:spring-boot-starter-web:jar:3.4.11:compile
|  +- org.springframework.boot:spring-boot-starter:jar:3.4.11:compile
|  |  +- org.springframework.boot:spring-boot:jar:3.4.11:compile
|  |  +- org.springframework.boot:spring-boot-autoconfigure:jar:3.4.11:compile
|  |  +- org.springframework.boot:spring-boot-starter-logging:jar:3.4.11:compile
|  |  |  +- ch.qos.logback:logback-classic:jar:1.5.19:compile
|  |  |  |  \- ch.qos.logback:logback-core:jar:1.5.19:compile
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
+- org.mockito:mockito-core:jar:5.8.0:test
|  +- net.bytebuddy:byte-buddy:jar:1.15.11:test
|  +- net.bytebuddy:byte-buddy-agent:jar:1.15.11:test
|  \- org.objenesis:objenesis:jar:3.3:test
+- org.mockito:mockito-junit-jupiter:jar:5.14.2:compile
+- org.springframework.boot:spring-boot-starter-test:jar:3.4.11:test
|  +- org.springframework.boot:spring-boot-test:jar:3.4.11:test
|  +- org.springframework.boot:spring-boot-test-autoconfigure:jar:3.4.11:test
|  +- com.jayway.jsonpath:json-path:jar:2.9.0:test
|  |  \- org.slf4j:slf4j-api:jar:2.0.17:compile
|  +- jakarta.xml.bind:jakarta.xml.bind-api:jar:4.0.4:compile
|  |  \- jakarta.activation:jakarta.activation-api:jar:2.1.4:compile
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
+- org.apache.camel:camel-core-model:jar:4.8.9:compile
|  +- org.apache.camel:camel-api:jar:4.8.9:compile
|  +- org.apache.camel:camel-core-processor:jar:4.8.9:compile
|  +- org.apache.camel:camel-support:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-util-json:jar:4.8.9:compile
|  |  \- org.apache.camel:camel-xml-jaxp-util:jar:4.8.9:compile
|  \- org.apache.camel:camel-util:jar:4.8.9:compile
+- org.projectlombok:lombok:jar:1.18.34:provided
\- org.apache.camel:camel-core-engine:jar:4.8.9:test
   +- org.apache.camel:camel-base-engine:jar:4.8.9:test
   |  \- org.apache.camel:camel-base:jar:4.8.9:test
   +- org.apache.camel:camel-core-reifier:jar:4.8.9:test
   \- org.apache.camel:camel-management-api:jar:4.8.9:compile
+- org.springdoc:springdoc-openapi-starter-webmvc-ui:jar:2.1.0:compile
|  +- org.springdoc:springdoc-openapi-starter-webmvc-api:jar:2.1.0:compile
|  |  \- org.springdoc:springdoc-openapi-starter-common:jar:2.1.0:compile
|  \- org.webjars:swagger-ui:jar:4.18.2:compile
+- org.springframework.boot:spring-boot-starter-web:jar:3.4.11:compile
|  +- org.springframework.boot:spring-boot-starter:jar:3.4.11:compile
|  |  +- org.springframework.boot:spring-boot:jar:3.4.11:compile
|  |  +- org.springframework.boot:spring-boot-autoconfigure:jar:3.4.11:compile
|  |  +- org.springframework.boot:spring-boot-starter-logging:jar:3.4.11:compile
|  |  |  +- org.apache.logging.log4j:log4j-to-slf4j:jar:2.24.3:compile
|  |  |  |  \- org.apache.logging.log4j:log4j-api:jar:2.24.3:compile
|  |  |  \- org.slf4j:jul-to-slf4j:jar:2.0.17:compile
|  |  +- jakarta.annotation:jakarta.annotation-api:jar:2.1.1:compile
|  |  \- org.yaml:snakeyaml:jar:2.3:compile
|  +- org.springframework.boot:spring-boot-starter-json:jar:3.4.11:compile
|  |  +- com.fasterxml.jackson.datatype:jackson-datatype-jdk8:jar:2.18.4:compile
|  |  \- com.fasterxml.jackson.module:jackson-module-parameter-names:jar:2.18.4:compile
|  +- org.springframework.boot:spring-boot-starter-tomcat:jar:3.4.11:compile
|  |  +- org.apache.tomcat.embed:tomcat-embed-core:jar:10.1.48:compile
|  |  +- org.apache.tomcat.embed:tomcat-embed-el:jar:10.1.48:compile
|  |  \- org.apache.tomcat.embed:tomcat-embed-websocket:jar:10.1.48:compile
|  +- org.springframework:spring-web:jar:6.2.12:compile
|  |  \- org.springframework:spring-beans:jar:6.2.12:compile
|  \- org.springframework:spring-webmvc:jar:6.2.12:compile
|     +- org.springframework:spring-aop:jar:6.2.12:compile
|     +- org.springframework:spring-context:jar:6.2.12:compile
|     \- org.springframework:spring-expression:jar:6.2.12:compile
+- org.springframework.boot:spring-boot-starter-actuator:jar:3.4.11:compile
|  +- org.springframework.boot:spring-boot-actuator-autoconfigure:jar:3.4.11:compile
|  |  \- org.springframework.boot:spring-boot-actuator:jar:3.4.11:compile
|  +- io.micrometer:micrometer-observation:jar:1.14.12:compile
|  |  \- io.micrometer:micrometer-commons:jar:1.14.12:compile
|  \- io.micrometer:micrometer-jakarta9:jar:1.14.12:compile
|     \- io.micrometer:micrometer-core:jar:1.14.12:compile
|        +- org.hdrhistogram:HdrHistogram:jar:2.2.2:runtime
|        \- org.latencyutils:LatencyUtils:jar:2.0.3:runtime
+- org.apache.camel.springboot:camel-spring-boot-starter:jar:4.8.9:compile
|  +- org.apache.camel.springboot:camel-spring-boot:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-spring:jar:4.8.9:compile
|  |  |  +- org.apache.camel:camel-management-api:jar:4.8.9:compile
|  |  |  \- org.springframework:spring-tx:jar:6.2.12:compile
|  |  +- org.apache.camel:camel-spring-main:jar:4.8.9:compile
|  |  |  \- org.apache.camel:camel-main:jar:4.8.9:compile
|  |  |     \- org.apache.camel:camel-base:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-util-json:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-cloud:jar:4.8.9:compile
|  |  |  \- org.apache.camel:camel-core-model:jar:4.8.9:compile
|  |  |     \- org.apache.camel:camel-core-processor:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-cluster:jar:4.8.9:compile
|  |  |  \- org.apache.camel:camel-base-engine:jar:4.8.9:compile
|  |  \- org.apache.camel:camel-health:jar:4.8.9:compile
|  +- org.apache.camel.springboot:camel-core-starter:jar:4.8.9:compile
|  |  \- org.apache.camel:camel-core-engine:jar:4.8.9:compile
|  |     +- org.apache.camel:camel-api:jar:4.8.9:compile
|  |     +- org.apache.camel:camel-core-reifier:jar:4.8.9:compile
|  |     \- org.apache.camel:camel-util:jar:4.8.9:compile
|  +- org.apache.camel.springboot:camel-bean-starter:jar:4.8.9:compile
|  |  \- org.apache.camel:camel-bean:jar:4.8.9:compile
|  +- org.apache.camel.springboot:camel-browse-starter:jar:4.8.9:compile
|  |  \- org.apache.camel:camel-browse:jar:4.8.9:compile
|  +- org.apache.camel.springboot:camel-controlbus-starter:jar:4.8.9:compile
|  |  \- org.apache.camel:camel-controlbus:jar:4.8.9:compile
|  +- org.apache.camel.springboot:camel-dataformat-starter:jar:4.8.9:compile
|  |  \- org.apache.camel:camel-dataformat:jar:4.8.9:compile
|  +- org.apache.camel.springboot:camel-dataset-starter:jar:4.8.9:compile
|  |  \- org.apache.camel:camel-dataset:jar:4.8.9:compile
|  +- org.apache.camel.springboot:camel-direct-starter:jar:4.8.9:compile
|  |  \- org.apache.camel:camel-direct:jar:4.8.9:compile
|  +- org.apache.camel.springboot:camel-file-starter:jar:4.8.9:compile
|  |  \- org.apache.camel:camel-file:jar:4.8.9:compile
|  +- org.apache.camel.springboot:camel-language-starter:jar:4.8.9:compile
|  |  \- org.apache.camel:camel-language:jar:4.8.9:compile
|  +- org.apache.camel.springboot:camel-log-starter:jar:4.8.9:compile
|  |  \- org.apache.camel:camel-log:jar:4.8.9:compile
|  +- org.apache.camel.springboot:camel-mock-starter:jar:4.8.9:compile
|  |  \- org.apache.camel:camel-mock:jar:4.8.9:compile
|  +- org.apache.camel.springboot:camel-ref-starter:jar:4.8.9:compile
|  |  \- org.apache.camel:camel-ref:jar:4.8.9:compile
|  +- org.apache.camel.springboot:camel-rest-starter:jar:4.8.9:compile
|  |  \- org.apache.camel:camel-rest:jar:4.8.9:compile
|  |     \- org.apache.camel:camel-tooling-model:jar:4.8.9:compile
|  +- org.apache.camel.springboot:camel-saga-starter:jar:4.8.9:compile
|  |  \- org.apache.camel:camel-saga:jar:4.8.9:compile
|  +- org.apache.camel.springboot:camel-scheduler-starter:jar:4.8.9:compile
|  |  \- org.apache.camel:camel-scheduler:jar:4.8.9:compile
|  +- org.apache.camel.springboot:camel-seda-starter:jar:4.8.9:compile
|  |  \- org.apache.camel:camel-seda:jar:4.8.9:compile
|  +- org.apache.camel.springboot:camel-stub-starter:jar:4.8.9:compile
|  |  \- org.apache.camel:camel-stub:jar:4.8.9:compile
|  +- org.apache.camel.springboot:camel-timer-starter:jar:4.8.9:compile
|  |  \- org.apache.camel:camel-timer:jar:4.8.9:compile
|  +- org.apache.camel.springboot:camel-validator-starter:jar:4.8.9:compile
|  |  \- org.apache.camel:camel-validator:jar:4.8.9:compile
|  +- org.apache.camel.springboot:camel-xpath-starter:jar:4.8.9:compile
|  |  \- org.apache.camel:camel-xpath:jar:4.8.9:compile
|  +- org.apache.camel.springboot:camel-xslt-starter:jar:4.8.9:compile
|  |  \- org.apache.camel:camel-xslt:jar:4.8.9:compile
|  \- org.apache.camel.springboot:camel-xml-jaxp-starter:jar:4.8.9:compile
|     \- org.apache.camel:camel-xml-jaxp:jar:4.8.9:compile
|        +- org.apache.camel:camel-xml-jaxp-util:jar:4.8.9:compile
|        \- org.apache.camel:camel-xml-io-util:jar:4.8.9:compile
+- org.apache.camel.springboot:camel-openapi-java-starter:jar:4.8.9:compile
|  +- org.apache.camel:camel-openapi-java:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-xml-io:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-tooling-util:jar:4.8.9:compile
|  |  +- io.swagger.core.v3:swagger-core-jakarta:jar:2.2.23:compile
|  |  |  \- io.swagger.core.v3:swagger-annotations-jakarta:jar:2.2.23:compile
|  |  +- io.swagger.core.v3:swagger-models-jakarta:jar:2.2.23:compile
|  |  +- io.swagger.parser.v3:swagger-parser:jar:2.1.22:compile
|  |  +- com.fasterxml.jackson.datatype:jackson-datatype-joda:jar:2.18.4:compile
|  |  |  \- joda-time:joda-time:jar:2.12.7:compile
|  |  +- com.fasterxml.jackson.dataformat:jackson-dataformat-yaml:jar:2.18.4:compile
|  |  \- com.fasterxml.jackson.jakarta.rs:jackson-jakarta-rs-json-provider:jar:2.18.4:compile
|  |     +- com.fasterxml.jackson.jakarta.rs:jackson-jakarta-rs-base:jar:2.18.4:compile
|  |     \- com.fasterxml.jackson.module:jackson-module-jakarta-xmlbind-annotations:jar:2.18.4:compile
|  \- io.swagger.parser.v3:swagger-parser-v3:jar:2.1.10:compile
|     +- io.swagger.parser.v3:swagger-parser-core:jar:2.1.10:compile
|     \- commons-io:commons-io:jar:2.15.1:compile
+- org.apache.camel.springboot:camel-servlet-starter:jar:4.8.9:compile
|  \- org.apache.camel:camel-servlet:jar:4.8.9:compile
|     +- org.apache.camel:camel-support:jar:4.8.9:compile
|     \- org.apache.camel:camel-http-common:jar:4.8.9:compile
|        \- org.apache.camel:camel-attachments:jar:4.8.9:compile
+- org.apache.camel.springboot:camel-http-starter:jar:4.8.9:compile
|  +- org.apache.camel:camel-http:jar:4.8.9:compile
|  |  \- jakarta.servlet:jakarta.servlet-api:jar:6.0.0:compile
|  +- org.apache.httpcomponents.client5:httpclient5:jar:5.4.4:compile
|  |  \- org.slf4j:slf4j-api:jar:2.0.17:compile
|  +- org.apache.httpcomponents.core5:httpcore5:jar:5.3.6:compile
|  \- org.apache.httpcomponents.core5:httpcore5-h2:jar:5.3.6:compile
+- org.apache.camel.springboot:camel-jackson-starter:jar:4.8.9:compile
|  \- org.apache.camel:camel-jackson:jar:4.8.9:compile
+- com.fasterxml.jackson.datatype:jackson-datatype-jsr310:jar:2.18.4:compile
|  +- com.fasterxml.jackson.core:jackson-annotations:jar:2.18.4:compile
|  +- com.fasterxml.jackson.core:jackson-core:jar:2.18.4.1:compile
|  \- com.fasterxml.jackson.core:jackson-databind:jar:2.18.4:compile
+- org.springframework.boot:spring-boot-starter-test:jar:3.4.11:test
|  +- org.springframework.boot:spring-boot-test:jar:3.4.11:test
|  +- org.springframework.boot:spring-boot-test-autoconfigure:jar:3.4.11:test
|  +- com.jayway.jsonpath:json-path:jar:2.9.0:test
|  +- jakarta.xml.bind:jakarta.xml.bind-api:jar:4.0.4:compile
|  |  \- jakarta.activation:jakarta.activation-api:jar:2.1.4:compile
|  +- net.minidev:json-smart:jar:2.5.2:test
|  |  \- net.minidev:accessors-smart:jar:2.5.2:test
|  |     \- org.ow2.asm:asm:jar:9.7.1:test
|  +- org.assertj:assertj-core:jar:3.26.3:test
|  |  \- net.bytebuddy:byte-buddy:jar:1.15.11:test
|  +- org.awaitility:awaitility:jar:4.2.2:test
|  +- org.hamcrest:hamcrest:jar:2.2:test
|  +- org.junit.jupiter:junit-jupiter:jar:5.11.4:compile
|  |  +- org.junit.jupiter:junit-jupiter-api:jar:5.11.4:compile
|  |  |  +- org.opentest4j:opentest4j:jar:1.3.0:compile
|  |  |  +- org.junit.platform:junit-platform-commons:jar:1.11.4:compile
|  |  |  \- org.apiguardian:apiguardian-api:jar:1.1.2:compile
|  |  +- org.junit.jupiter:junit-jupiter-params:jar:5.11.4:compile
|  |  \- org.junit.jupiter:junit-jupiter-engine:jar:5.11.4:runtime
|  |     \- org.junit.platform:junit-platform-engine:jar:1.11.4:runtime
|  +- org.mockito:mockito-core:jar:5.8.0:test
|  |  +- net.bytebuddy:byte-buddy-agent:jar:1.15.11:test
|  |  \- org.objenesis:objenesis:jar:3.3:test
|  +- org.mockito:mockito-junit-jupiter:jar:5.14.2:test
|  +- org.skyscreamer:jsonassert:jar:1.5.3:test
|  |  \- com.vaadin.external.google:android-json:jar:0.0.20131108.vaadin1:test
|  +- org.springframework:spring-core:jar:6.2.12:compile
|  |  \- org.springframework:spring-jcl:jar:6.2.12:compile
|  +- org.springframework:spring-test:jar:6.2.12:test
|  \- org.xmlunit:xmlunit-core:jar:2.10.4:test
+- org.apache.camel:camel-test-spring-junit5:jar:4.8.9:test
|  +- org.apache.camel:camel-test-junit5:jar:4.8.9:test
|  |  \- org.apache.camel:camel-core-languages:jar:4.8.9:compile
|  \- org.apache.camel:camel-spring-xml:jar:4.8.9:test
|     +- org.apache.camel:camel-xml-jaxb:jar:4.8.9:compile
|     |  \- org.glassfish.jaxb:jaxb-runtime:jar:4.0.6:compile
|     |     \- org.glassfish.jaxb:jaxb-core:jar:4.0.6:compile
|     |        +- org.eclipse.angus:angus-activation:jar:2.0.3:runtime
|     |        +- org.glassfish.jaxb:txw2:jar:4.0.6:compile
|     |        \- com.sun.istack:istack-commons-runtime:jar:4.1.2:compile
|     \- org.apache.camel:camel-core-xml:jar:4.8.9:test
+- io.rest-assured:rest-assured:jar:5.5.6:test
|  +- org.apache.groovy:groovy:jar:4.0.29:test
|  +- org.apache.groovy:groovy-xml:jar:4.0.29:test
|  +- org.apache.httpcomponents:httpclient:jar:4.5.13:test
|  |  +- org.apache.httpcomponents:httpcore:jar:4.4.16:test
|  |  +- commons-logging:commons-logging:jar:1.2:test
|  |  \- commons-codec:commons-codec:jar:1.17.2:compile
|  +- org.apache.httpcomponents:httpmime:jar:4.5.13:test
|  +- org.ccil.cowan.tagsoup:tagsoup:jar:1.2.1:test
|  +- io.rest-assured:json-path:jar:5.5.6:test
|  |  +- org.apache.groovy:groovy-json:jar:4.0.29:test
|  |  \- io.rest-assured:rest-assured-common:jar:5.5.6:test
|  \- io.rest-assured:xml-path:jar:5.5.6:test
|     \- org.apache.commons:commons-lang3:jar:3.18.0:compile
+- com.santander.ars:gln-back-arsenal-integration-gluon-error-starter:jar:4.16.11-SNAPSHOT:compile
|  +- org.apache.camel:camel-http-base:jar:4.8.9:compile
|  +- org.apache.camel:camel-bean-validator:jar:4.8.9:compile
|  |  +- org.hibernate.validator:hibernate-validator:jar:8.0.3.Final:compile
|  |  |  \- com.fasterxml:classmate:jar:1.7.1:compile
|  |  +- org.jboss.logging:jboss-logging:jar:3.6.1.Final:compile
|  |  +- jakarta.el:jakarta.el-api:jar:6.0.1:compile
|  |  \- org.glassfish.expressly:expressly:jar:5.0.0:compile
|  \- jakarta.validation:jakarta.validation-api:jar:3.0.2:compile
+- com.santander.ars:gln-back-arsenal-integration-observability-starter:jar:4.16.11-SNAPSHOT:compile
|  +- org.apache.camel:camel-core:jar:4.8.9:compile
|  |  \- org.apache.camel:camel-yaml-io:jar:4.8.9:compile
|  |     \- org.apache.camel:camel-core-catalog:jar:4.8.9:compile
|  +- com.santander.ars:gln-back-arsenal-global-observability-starter:jar:3.18.11:compile
|  |  +- org.projectlombok:lombok:jar:1.18.34:provided
|  |  +- io.micrometer:micrometer-tracing:jar:1.4.11:compile
|  |  |  +- io.micrometer:context-propagation:jar:1.1.3:compile
|  |  |  \- aopalliance:aopalliance:jar:1.0:compile
|  |  +- io.micrometer:micrometer-tracing-bridge-brave:jar:1.4.11:compile
|  |  |  +- io.zipkin.brave:brave:jar:6.0.3:compile
|  |  |  +- io.zipkin.brave:brave-context-slf4j:jar:6.0.3:compile
|  |  |  +- io.zipkin.brave:brave-instrumentation-http:jar:6.0.3:compile
|  |  |  +- io.zipkin.aws:brave-propagation-aws:jar:1.2.5:compile
|  |  |  \- io.zipkin.contrib.brave-propagation-w3c:brave-propagation-tracecontext:jar:0.2.0:compile
|  |  +- org.springframework.boot:spring-boot-starter-aop:jar:3.4.11:compile
|  |  +- com.santander.ars:gln-back-arsenal-log-core:jar:3.18.11:compile
|  |  +- com.santander.ars:gln-back-arsenal-logback-core:jar:3.18.11:compile
|  |  |  +- com.santander.ars:gln-back-arsenal-logback-kafka-appender:jar:3.18.11:compile
|  |  |  |  +- org.xerial.snappy:snappy-java:jar:1.1.10.5:compile
|  |  |  |  \- org.apache.kafka:kafka-clients:jar:3.9.1:compile
|  |  |  |     +- com.github.luben:zstd-jni:jar:1.5.6-4:runtime
|  |  |  |     \- org.lz4:lz4-java:jar:1.8.0:runtime
|  |  |  +- ch.qos.logback.contrib:logback-json-classic:jar:0.1.5:compile
|  |  |  |  \- ch.qos.logback.contrib:logback-json-core:jar:0.1.5:compile
|  |  |  \- ch.qos.logback.contrib:logback-jackson:jar:0.1.5:compile
|  |  +- ch.qos.logback:logback-core:jar:1.5.19:compile
|  |  +- net.logstash.logback:logstash-logback-encoder:jar:7.3:compile
|  |  +- org.apache.commons:commons-text:jar:1.10.0:compile
|  |  +- org.json:json:jar:20231013:compile
|  |  +- org.aspectj:aspectjweaver:jar:1.9.24:compile
|  |  +- org.springframework.boot:spring-boot-starter-webflux:jar:3.4.11:compile
|  |  |  +- org.springframework.boot:spring-boot-starter-reactor-netty:jar:3.4.11:compile
|  |  |  |  \- io.projectreactor.netty:reactor-netty-http:jar:1.2.11:compile
|  |  |  |     +- io.netty:netty-codec-http:jar:4.1.127.Final:compile
|  |  |  |     |  +- io.netty:netty-common:jar:4.1.128.Final:compile
|  |  |  |     |  +- io.netty:netty-buffer:jar:4.1.128.Final:compile
|  |  |  |     |  +- io.netty:netty-transport:jar:4.1.128.Final:compile
|  |  |  |     |  +- io.netty:netty-codec:jar:4.1.127.Final:compile
|  |  |  |     |  \- io.netty:netty-handler:jar:4.1.128.Final:compile
|  |  |  |     +- io.netty:netty-codec-http2:jar:4.1.128.Final:compile
|  |  |  |     +- io.netty:netty-resolver-dns:jar:4.1.128.Final:compile
|  |  |  |     |  +- io.netty:netty-resolver:jar:4.1.128.Final:compile
|  |  |  |     |  \- io.netty:netty-codec-dns:jar:4.1.128.Final:compile
|  |  |  |     +- io.netty:netty-resolver-dns-native-macos:jar:osx-x86_64:4.1.128.Final:compile
|  |  |  |     |  \- io.netty:netty-resolver-dns-classes-macos:jar:4.1.128.Final:compile
|  |  |  |     +- io.netty:netty-transport-native-epoll:jar:linux-x86_64:4.1.128.Final:compile
|  |  |  |     |  +- io.netty:netty-transport-native-unix-common:jar:4.1.128.Final:compile
|  |  |  |     |  \- io.netty:netty-transport-classes-epoll:jar:4.1.128.Final:compile
|  |  |  |     \- io.projectreactor.netty:reactor-netty-core:jar:1.2.11:compile
|  |  |  |        \- io.netty:netty-handler-proxy:jar:4.1.128.Final:compile
|  |  |  |           \- io.netty:netty-codec-socks:jar:4.1.128.Final:compile
|  |  |  \- org.springframework:spring-webflux:jar:6.2.12:compile
|  |  |     \- io.projectreactor:reactor-core:jar:3.7.12:compile
|  |  |        \- org.reactivestreams:reactive-streams:jar:1.0.4:compile
|  |  \- org.mapstruct:mapstruct:jar:1.4.2.Final:compile
|  \- com.santander.ars:ars-altair-connector-mq:jar:1.0.0:compile
|     +- com.santander.ars:ars-altair-connector-psformat:jar:1.0.0:compile
|     +- com.santander.ars:ars-altair-connector-core:jar:1.0.0:compile
|     \- ch.qos.logback:logback-classic:jar:1.5.19:compile
\- org.mock-server:mockserver-netty-no-dependencies:jar:5.15.0:test
+- org.springdoc:springdoc-openapi-starter-webmvc-ui:jar:2.1.0:compile
|  +- org.springdoc:springdoc-openapi-starter-webmvc-api:jar:2.1.0:compile
|  |  \- org.springdoc:springdoc-openapi-starter-common:jar:2.1.0:compile
|  \- org.webjars:swagger-ui:jar:4.18.2:compile
+- org.springframework.boot:spring-boot-starter-web:jar:3.4.11:compile
|  +- org.springframework.boot:spring-boot-starter:jar:3.4.11:compile
|  |  +- org.springframework.boot:spring-boot:jar:3.4.11:compile
|  |  +- org.springframework.boot:spring-boot-autoconfigure:jar:3.4.11:compile
|  |  +- org.springframework.boot:spring-boot-starter-logging:jar:3.4.11:compile
|  |  |  +- org.apache.logging.log4j:log4j-to-slf4j:jar:2.24.3:compile
|  |  |  |  \- org.apache.logging.log4j:log4j-api:jar:2.24.3:compile
|  |  |  \- org.slf4j:jul-to-slf4j:jar:2.0.17:compile
|  |  +- jakarta.annotation:jakarta.annotation-api:jar:2.1.1:compile
|  |  \- org.yaml:snakeyaml:jar:2.3:compile
|  +- org.springframework.boot:spring-boot-starter-json:jar:3.4.11:compile
|  |  +- com.fasterxml.jackson.datatype:jackson-datatype-jdk8:jar:2.18.4:compile
|  |  \- com.fasterxml.jackson.module:jackson-module-parameter-names:jar:2.18.4:compile
|  +- org.springframework.boot:spring-boot-starter-tomcat:jar:3.4.11:compile
|  |  +- org.apache.tomcat.embed:tomcat-embed-core:jar:10.1.48:compile
|  |  +- org.apache.tomcat.embed:tomcat-embed-el:jar:10.1.48:compile
|  |  \- org.apache.tomcat.embed:tomcat-embed-websocket:jar:10.1.48:compile
|  +- org.springframework:spring-web:jar:6.2.12:compile
|  |  \- org.springframework:spring-beans:jar:6.2.12:compile
|  \- org.springframework:spring-webmvc:jar:6.2.12:compile
|     +- org.springframework:spring-aop:jar:6.2.12:compile
|     +- org.springframework:spring-context:jar:6.2.12:compile
|     \- org.springframework:spring-expression:jar:6.2.12:compile
+- org.springframework.boot:spring-boot-starter-actuator:jar:3.4.11:compile
|  +- org.springframework.boot:spring-boot-actuator-autoconfigure:jar:3.4.11:compile
|  |  \- org.springframework.boot:spring-boot-actuator:jar:3.4.11:compile
|  +- io.micrometer:micrometer-observation:jar:1.14.12:compile
|  |  \- io.micrometer:micrometer-commons:jar:1.14.12:compile
|  \- io.micrometer:micrometer-jakarta9:jar:1.14.12:compile
|     \- io.micrometer:micrometer-core:jar:1.14.12:compile
|        +- org.hdrhistogram:HdrHistogram:jar:2.2.2:runtime
|        \- org.latencyutils:LatencyUtils:jar:2.0.3:runtime
+- org.apache.camel.springboot:camel-spring-boot-starter:jar:4.8.9:compile
|  +- org.apache.camel.springboot:camel-spring-boot:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-spring:jar:4.8.9:compile
|  |  |  +- org.apache.camel:camel-management-api:jar:4.8.9:compile
|  |  |  \- org.springframework:spring-tx:jar:6.2.12:compile
|  |  +- org.apache.camel:camel-spring-main:jar:4.8.9:compile
|  |  |  \- org.apache.camel:camel-main:jar:4.8.9:compile
|  |  |     \- org.apache.camel:camel-base:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-util-json:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-cloud:jar:4.8.9:compile
|  |  |  \- org.apache.camel:camel-core-model:jar:4.8.9:compile
|  |  |     \- org.apache.camel:camel-core-processor:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-cluster:jar:4.8.9:compile
|  |  |  \- org.apache.camel:camel-base-engine:jar:4.8.9:compile
|  |  \- org.apache.camel:camel-health:jar:4.8.9:compile
|  +- org.apache.camel.springboot:camel-core-starter:jar:4.8.9:compile
|  |  \- org.apache.camel:camel-core-engine:jar:4.8.9:compile
|  |     +- org.apache.camel:camel-api:jar:4.8.9:compile
|  |     +- org.apache.camel:camel-core-reifier:jar:4.8.9:compile
|  |     \- org.apache.camel:camel-util:jar:4.8.9:compile
|  +- org.apache.camel.springboot:camel-bean-starter:jar:4.8.9:compile
|  |  \- org.apache.camel:camel-bean:jar:4.8.9:compile
|  +- org.apache.camel.springboot:camel-browse-starter:jar:4.8.9:compile
|  |  \- org.apache.camel:camel-browse:jar:4.8.9:compile
|  +- org.apache.camel.springboot:camel-controlbus-starter:jar:4.8.9:compile
|  |  \- org.apache.camel:camel-controlbus:jar:4.8.9:compile
|  +- org.apache.camel.springboot:camel-dataformat-starter:jar:4.8.9:compile
|  |  \- org.apache.camel:camel-dataformat:jar:4.8.9:compile
|  +- org.apache.camel.springboot:camel-dataset-starter:jar:4.8.9:compile
|  |  \- org.apache.camel:camel-dataset:jar:4.8.9:compile
|  +- org.apache.camel.springboot:camel-direct-starter:jar:4.8.9:compile
|  |  \- org.apache.camel:camel-direct:jar:4.8.9:compile
|  +- org.apache.camel.springboot:camel-file-starter:jar:4.8.9:compile
|  |  \- org.apache.camel:camel-file:jar:4.8.9:compile
|  +- org.apache.camel.springboot:camel-language-starter:jar:4.8.9:compile
|  |  \- org.apache.camel:camel-language:jar:4.8.9:compile
|  +- org.apache.camel.springboot:camel-log-starter:jar:4.8.9:compile
|  |  \- org.apache.camel:camel-log:jar:4.8.9:compile
|  +- org.apache.camel.springboot:camel-mock-starter:jar:4.8.9:compile
|  |  \- org.apache.camel:camel-mock:jar:4.8.9:compile
|  +- org.apache.camel.springboot:camel-ref-starter:jar:4.8.9:compile
|  |  \- org.apache.camel:camel-ref:jar:4.8.9:compile
|  +- org.apache.camel.springboot:camel-rest-starter:jar:4.8.9:compile
|  |  \- org.apache.camel:camel-rest:jar:4.8.9:compile
|  |     \- org.apache.camel:camel-tooling-model:jar:4.8.9:compile
|  +- org.apache.camel.springboot:camel-saga-starter:jar:4.8.9:compile
|  |  \- org.apache.camel:camel-saga:jar:4.8.9:compile
|  +- org.apache.camel.springboot:camel-scheduler-starter:jar:4.8.9:compile
|  |  \- org.apache.camel:camel-scheduler:jar:4.8.9:compile
|  +- org.apache.camel.springboot:camel-seda-starter:jar:4.8.9:compile
|  |  \- org.apache.camel:camel-seda:jar:4.8.9:compile
|  +- org.apache.camel.springboot:camel-stub-starter:jar:4.8.9:compile
|  |  \- org.apache.camel:camel-stub:jar:4.8.9:compile
|  +- org.apache.camel.springboot:camel-timer-starter:jar:4.8.9:compile
|  |  \- org.apache.camel:camel-timer:jar:4.8.9:compile
|  +- org.apache.camel.springboot:camel-validator-starter:jar:4.8.9:compile
|  |  \- org.apache.camel:camel-validator:jar:4.8.9:compile
|  +- org.apache.camel.springboot:camel-xpath-starter:jar:4.8.9:compile
|  |  \- org.apache.camel:camel-xpath:jar:4.8.9:compile
|  +- org.apache.camel.springboot:camel-xslt-starter:jar:4.8.9:compile
|  |  \- org.apache.camel:camel-xslt:jar:4.8.9:compile
|  \- org.apache.camel.springboot:camel-xml-jaxp-starter:jar:4.8.9:compile
|     \- org.apache.camel:camel-xml-jaxp:jar:4.8.9:compile
|        +- org.apache.camel:camel-xml-jaxp-util:jar:4.8.9:compile
|        \- org.apache.camel:camel-xml-io-util:jar:4.8.9:compile
+- org.apache.camel.springboot:camel-openapi-java-starter:jar:4.8.9:compile
|  +- org.apache.camel:camel-openapi-java:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-xml-io:jar:4.8.9:compile
|  |  +- org.apache.camel:camel-tooling-util:jar:4.8.9:compile
|  |  +- io.swagger.core.v3:swagger-core-jakarta:jar:2.2.23:compile
|  |  |  \- io.swagger.core.v3:swagger-annotations-jakarta:jar:2.2.23:compile
|  |  +- io.swagger.core.v3:swagger-models-jakarta:jar:2.2.23:compile
|  |  +- io.swagger.parser.v3:swagger-parser:jar:2.1.22:compile
|  |  +- com.fasterxml.jackson.datatype:jackson-datatype-joda:jar:2.18.4:compile
|  |  |  \- joda-time:joda-time:jar:2.12.7:compile
|  |  +- com.fasterxml.jackson.dataformat:jackson-dataformat-yaml:jar:2.18.4:compile
|  |  \- com.fasterxml.jackson.jakarta.rs:jackson-jakarta-rs-json-provider:jar:2.18.4:compile
|  |     +- com.fasterxml.jackson.jakarta.rs:jackson-jakarta-rs-base:jar:2.18.4:compile
|  |     \- com.fasterxml.jackson.module:jackson-module-jakarta-xmlbind-annotations:jar:2.18.4:compile
|  \- io.swagger.parser.v3:swagger-parser-v3:jar:2.1.10:compile
|     +- io.swagger.parser.v3:swagger-parser-core:jar:2.1.10:compile
|     \- commons-io:commons-io:jar:2.15.1:compile
+- org.apache.camel.springboot:camel-servlet-starter:jar:4.8.9:compile
|  \- org.apache.camel:camel-servlet:jar:4.8.9:compile
|     +- org.apache.camel:camel-support:jar:4.8.9:compile
|     \- org.apache.camel:camel-http-common:jar:4.8.9:compile
|        \- org.apache.camel:camel-attachments:jar:4.8.9:compile
+- org.apache.camel.springboot:camel-http-starter:jar:4.8.9:compile
|  +- org.apache.camel:camel-http:jar:4.8.9:compile
|  |  \- jakarta.servlet:jakarta.servlet-api:jar:6.0.0:compile
|  +- org.apache.httpcomponents.client5:httpclient5:jar:5.4.4:compile
|  |  \- org.slf4j:slf4j-api:jar:2.0.17:compile
|  +- org.apache.httpcomponents.core5:httpcore5:jar:5.3.6:compile
|  \- org.apache.httpcomponents.core5:httpcore5-h2:jar:5.3.6:compile
+- org.apache.camel.springboot:camel-jackson-starter:jar:4.8.9:compile
|  \- org.apache.camel:camel-jackson:jar:4.8.9:compile
+- com.fasterxml.jackson.datatype:jackson-datatype-jsr310:jar:2.18.4:compile
|  +- com.fasterxml.jackson.core:jackson-annotations:jar:2.18.4:compile
|  +- com.fasterxml.jackson.core:jackson-core:jar:2.18.4.1:compile
|  \- com.fasterxml.jackson.core:jackson-databind:jar:2.18.4:compile
+- org.springframework.boot:spring-boot-starter-test:jar:3.4.11:test
|  +- org.springframework.boot:spring-boot-test:jar:3.4.11:test
|  +- org.springframework.boot:spring-boot-test-autoconfigure:jar:3.4.11:test
|  +- com.jayway.jsonpath:json-path:jar:2.9.0:test
|  +- jakarta.xml.bind:jakarta.xml.bind-api:jar:4.0.4:compile
|  |  \- jakarta.activation:jakarta.activation-api:jar:2.1.4:compile
|  +- net.minidev:json-smart:jar:2.5.2:test
|  |  \- net.minidev:accessors-smart:jar:2.5.2:test
|  |     \- org.ow2.asm:asm:jar:9.7.1:test
|  +- org.assertj:assertj-core:jar:3.26.3:test
|  |  \- net.bytebuddy:byte-buddy:jar:1.15.11:test
|  +- org.awaitility:awaitility:jar:4.2.2:test
|  +- org.hamcrest:hamcrest:jar:2.2:test
|  +- org.junit.jupiter:junit-jupiter:jar:5.11.4:compile
|  |  +- org.junit.jupiter:junit-jupiter-api:jar:5.11.4:compile
|  |  |  +- org.opentest4j:opentest4j:jar:1.3.0:compile
|  |  |  +- org.junit.platform:junit-platform-commons:jar:1.11.4:compile
|  |  |  \- org.apiguardian:apiguardian-api:jar:1.1.2:compile
|  |  +- org.junit.jupiter:junit-jupiter-params:jar:5.11.4:compile
|  |  \- org.junit.jupiter:junit-jupiter-engine:jar:5.11.4:runtime
|  |     \- org.junit.platform:junit-platform-engine:jar:1.11.4:runtime
|  +- org.mockito:mockito-core:jar:5.8.0:test
|  |  +- net.bytebuddy:byte-buddy-agent:jar:1.15.11:test
|  |  \- org.objenesis:objenesis:jar:3.3:test
|  +- org.mockito:mockito-junit-jupiter:jar:5.14.2:test
|  +- org.skyscreamer:jsonassert:jar:1.5.3:test
|  |  \- com.vaadin.external.google:android-json:jar:0.0.20131108.vaadin1:test
|  +- org.springframework:spring-core:jar:6.2.12:compile
|  |  \- org.springframework:spring-jcl:jar:6.2.12:compile
|  +- org.springframework:spring-test:jar:6.2.12:test
|  \- org.xmlunit:xmlunit-core:jar:2.10.4:test
+- org.apache.camel:camel-test-spring-junit5:jar:4.8.9:test
|  +- org.apache.camel:camel-test-junit5:jar:4.8.9:test
|  |  \- org.apache.camel:camel-core-languages:jar:4.8.9:compile
|  \- org.apache.camel:camel-spring-xml:jar:4.8.9:test
|     +- org.apache.camel:camel-xml-jaxb:jar:4.8.9:compile
|     |  \- org.glassfish.jaxb:jaxb-runtime:jar:4.0.6:compile
|     |     \- org.glassfish.jaxb:jaxb-core:jar:4.0.6:compile
|     |        +- org.eclipse.angus:angus-activation:jar:2.0.3:runtime
|     |        +- org.glassfish.jaxb:txw2:jar:4.0.6:compile
|     |        \- com.sun.istack:istack-commons-runtime:jar:4.1.2:compile
|     \- org.apache.camel:camel-core-xml:jar:4.8.9:test
+- io.rest-assured:rest-assured:jar:5.5.6:test
|  +- org.apache.groovy:groovy:jar:4.0.29:test
|  +- org.apache.groovy:groovy-xml:jar:4.0.29:test
|  +- org.apache.httpcomponents:httpclient:jar:4.5.13:test
|  |  +- org.apache.httpcomponents:httpcore:jar:4.4.16:test
|  |  +- commons-logging:commons-logging:jar:1.2:test
|  |  \- commons-codec:commons-codec:jar:1.17.2:compile
|  +- org.apache.httpcomponents:httpmime:jar:4.5.13:test
|  +- org.ccil.cowan.tagsoup:tagsoup:jar:1.2.1:test
|  +- io.rest-assured:json-path:jar:5.5.6:test
|  |  +- org.apache.groovy:groovy-json:jar:4.0.29:test
|  |  \- io.rest-assured:rest-assured-common:jar:5.5.6:test
|  \- io.rest-assured:xml-path:jar:5.5.6:test
|     \- org.apache.commons:commons-lang3:jar:3.18.0:compile
+- com.santander.ars:gln-back-arsenal-integration-gluon-error-starter:jar:4.16.11-SNAPSHOT:compile
|  +- org.apache.camel:camel-http-base:jar:4.8.9:compile
|  +- org.apache.camel:camel-bean-validator:jar:4.8.9:compile
|  |  +- org.hibernate.validator:hibernate-validator:jar:8.0.3.Final:compile
|  |  |  \- com.fasterxml:classmate:jar:1.7.1:compile
|  |  +- org.jboss.logging:jboss-logging:jar:3.6.1.Final:compile
|  |  +- jakarta.el:jakarta.el-api:jar:6.0.1:compile
|  |  \- org.glassfish.expressly:expressly:jar:5.0.0:compile
|  \- jakarta.validation:jakarta.validation-api:jar:3.0.2:compile
\- com.santander.ars:gln-back-arsenal-integration-observability-starter:jar:4.16.11-SNAPSHOT:compile
   +- org.apache.camel:camel-core:jar:4.8.9:compile
   |  \- org.apache.camel:camel-yaml-io:jar:4.8.9:compile
   |     \- org.apache.camel:camel-core-catalog:jar:4.8.9:compile
   +- com.santander.ars:gln-back-arsenal-global-observability-starter:jar:3.18.11:compile
   |  +- org.projectlombok:lombok:jar:1.18.34:provided
   |  +- io.micrometer:micrometer-tracing:jar:1.4.11:compile
   |  |  +- io.micrometer:context-propagation:jar:1.1.3:compile
   |  |  \- aopalliance:aopalliance:jar:1.0:compile
   |  +- io.micrometer:micrometer-tracing-bridge-brave:jar:1.4.11:compile
   |  |  +- io.zipkin.brave:brave:jar:6.0.3:compile
   |  |  +- io.zipkin.brave:brave-context-slf4j:jar:6.0.3:compile
   |  |  +- io.zipkin.brave:brave-instrumentation-http:jar:6.0.3:compile
   |  |  +- io.zipkin.aws:brave-propagation-aws:jar:1.2.5:compile
   |  |  \- io.zipkin.contrib.brave-propagation-w3c:brave-propagation-tracecontext:jar:0.2.0:compile
   |  +- org.springframework.boot:spring-boot-starter-aop:jar:3.4.11:compile
   |  +- com.santander.ars:gln-back-arsenal-log-core:jar:3.18.11:compile
   |  +- com.santander.ars:gln-back-arsenal-logback-core:jar:3.18.11:compile
   |  |  +- com.santander.ars:gln-back-arsenal-logback-kafka-appender:jar:3.18.11:compile
   |  |  |  +- org.xerial.snappy:snappy-java:jar:1.1.10.5:compile
   |  |  |  \- org.apache.kafka:kafka-clients:jar:3.9.1:compile
   |  |  |     +- com.github.luben:zstd-jni:jar:1.5.6-4:runtime
   |  |  |     \- org.lz4:lz4-java:jar:1.8.0:runtime
   |  |  +- ch.qos.logback.contrib:logback-json-classic:jar:0.1.5:compile
   |  |  |  \- ch.qos.logback.contrib:logback-json-core:jar:0.1.5:compile
   |  |  \- ch.qos.logback.contrib:logback-jackson:jar:0.1.5:compile
   |  +- ch.qos.logback:logback-core:jar:1.5.19:compile
   |  +- net.logstash.logback:logstash-logback-encoder:jar:7.3:compile
   |  +- org.apache.commons:commons-text:jar:1.10.0:compile
   |  +- org.json:json:jar:20231013:compile
   |  +- org.aspectj:aspectjweaver:jar:1.9.24:compile
   |  +- org.springframework.boot:spring-boot-starter-webflux:jar:3.4.11:compile
   |  |  +- org.springframework.boot:spring-boot-starter-reactor-netty:jar:3.4.11:compile
   |  |  |  \- io.projectreactor.netty:reactor-netty-http:jar:1.2.11:compile
   |  |  |     +- io.netty:netty-codec-http:jar:4.1.127.Final:compile
   |  |  |     |  +- io.netty:netty-common:jar:4.1.128.Final:compile
   |  |  |     |  +- io.netty:netty-buffer:jar:4.1.128.Final:compile
   |  |  |     |  +- io.netty:netty-transport:jar:4.1.128.Final:compile
   |  |  |     |  +- io.netty:netty-codec:jar:4.1.127.Final:compile
   |  |  |     |  \- io.netty:netty-handler:jar:4.1.128.Final:compile
   |  |  |     +- io.netty:netty-codec-http2:jar:4.1.128.Final:compile
   |  |  |     +- io.netty:netty-resolver-dns:jar:4.1.128.Final:compile
   |  |  |     |  +- io.netty:netty-resolver:jar:4.1.128.Final:compile
   |  |  |     |  \- io.netty:netty-codec-dns:jar:4.1.128.Final:compile
   |  |  |     +- io.netty:netty-resolver-dns-native-macos:jar:osx-x86_64:4.1.128.Final:compile
   |  |  |     |  \- io.netty:netty-resolver-dns-classes-macos:jar:4.1.128.Final:compile
   |  |  |     +- io.netty:netty-transport-native-epoll:jar:linux-x86_64:4.1.128.Final:compile
   |  |  |     |  +- io.netty:netty-transport-native-unix-common:jar:4.1.128.Final:compile
   |  |  |     |  \- io.netty:netty-transport-classes-epoll:jar:4.1.128.Final:compile
   |  |  |     \- io.projectreactor.netty:reactor-netty-core:jar:1.2.11:compile
   |  |  |        \- io.netty:netty-handler-proxy:jar:4.1.128.Final:compile
   |  |  |           \- io.netty:netty-codec-socks:jar:4.1.128.Final:compile
   |  |  \- org.springframework:spring-webflux:jar:6.2.12:compile
   |  |     \- io.projectreactor:reactor-core:jar:3.7.12:compile
   |  |        \- org.reactivestreams:reactive-streams:jar:1.0.4:compile
   |  \- org.mapstruct:mapstruct:jar:1.4.2.Final:compile
   \- com.santander.ars:ars-altair-connector-mq:jar:1.0.0:compile
      +- com.santander.ars:ars-altair-connector-psformat:jar:1.0.0:compile
      +- com.santander.ars:ars-altair-connector-core:jar:1.0.0:compile
      \- ch.qos.logback:logback-classic:jar:1.5.19:compile
```
