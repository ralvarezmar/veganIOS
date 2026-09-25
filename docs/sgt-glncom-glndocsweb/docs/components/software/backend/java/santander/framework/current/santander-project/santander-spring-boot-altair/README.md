# Santander Spring Boot Altair ![1.2.1](https://img.shields.io/badge/1.2.1-FF073D)

![Current](https://img.shields.io/badge/CURRENT-30FF24) ![GA](https://img.shields.io/badge/GA-C81D11)

## Description

The Altair Spring Boot library extends [Altair Connector Library],
adding new functionalities such as: connector configuration (destination queues, user, etc) depending on the channel.

## Functionality

Altair Spring Boot library provides connectivity between spring boot microservices and mainframe transactions.

### AltairQueueService implementation

A *Bean* of the `AltairQueueService` class is exposed, this *Bean* will use the information corresponding to the channel found in
the `Context` to execute the transaction in a totally transparent way to the project.

### Installation

To add the library to any project, include the maven dependency of its starter in the `pom.xml` file:

``` xml { .copy }
<dependency>
  <groupId>com.santander.framework.springboot</groupId>
  <artifactId>santander-spring-boot-starter-altair</artifactId>
</dependency>
```

!!! warning
This library does not support reactive mode for now.

### Configuration

| Parameter        | Description |
|------------------|-------------|
| format-classpath | Classpath where format classes are located(classes annotated with @PsFormat).|
| hostname         | MQ server hostname. |
| port             | MQ server port. |
| channel          | MQ Channel Name. |
| username         | MQ server user. If the informed value is the path of a file (Secret), the user is read from the file, otherwise the value passed is assumed.|
| pwd              | MQ server password. If the informed value is the path of a file (Secret), the password is read from the file, otherwise the value passed is assumed. |
| message-expired-timeout   | time in milliseconds that the message becomes eligible to be discarded |
| receive-timeout  | time in milliseconds to receive data  |
| mq-file          | full path to the altair configuration yaml file  |

#### Santander Spring Boot Altair property settings

Add the configuration parameters to file `application.yml` and/or `application-local.yml`:

``` yaml
santander:
  altair:
    format-classpath: br.com.santander.minhaaplicacao.formatos
    server:
      hostname: mqlocal.paas.isbanbr.dev.corp
      port: 1414
      channel: CHANNEL1
      username: /etc/credentials/srv-altair/username
      pwd: /etc/credentials/srv-altair/password
      receive-timeout: 1000
      message-expired-timeout: 1000
      mq-file: altair.yml
```

The above is just an example and treats the values ​​as hardcodes. Remember that you can **and should**
replace them with **environment variables** in a real application.

#### Channel setup

You must create a configuration file (altair.yml) and include the configuration of all channels, and include information about the altair user, the request and response queue used by this transaction

The example below has 2 channels (M3 and IBF)

``` yaml { .copy title="Example altair.yml"}
M3:
  altairUser: MQ...
  requestQueue: AEA.QR.REQUEST.....
  responseQueue: AEA.QL.ANSWER.....
IBF:
  altairUser: MQ...
  requestQueue: AEA.QR.REQUEST.....
  responseQueue: AEA.QL.ANSWER.....
```

!!! warning
With the configuration like the previous one: if we execute a transaction with a channel other than the ones we have configured or without a channel **an exception will be thrown**, because **there will be no associated
queue**.

For Kubernetes projects, create a volume with the altair.yml file, and add the settings below.

``` yaml { .copy }
volumes:
  - name: altair-yml
    configMap:
      name: altair.yml

volumeMounts:
  - name: altair-yml
    readOnly: true
    mountPath: /app/config
```

### Executing a transaction in applications

In application environments we must inject a *Bean* from the `AltairQueueService`:

```java
import com.santander.framework.springboot.altair.core;
...

@Autowired
AltairQueueService altairQueueService;
```

The following methods are exposed in *Bean* with the `AltairQueueService` implementation.

``` java
public ResponseDto executeNotImpersonatedTrx(PsFormatEnum psFormatEnum, String transactionName, Object data,
HeaderPS headerPS) throws InvalidChannelException, PsFormatException

public ResponseDto executeImpersonatedTrx(PsFormatEnum psFormatEnum, String transactionName, Object data,
HeaderPS headerPS, SecurityDto securityData) throws InvalidChannelException, PsFormatException
```

For the following examples, we assume that the ***PEM2650*** class have been created with annotations from the original Altair library (*@PsFormat*, *@PsFieldString*, etc.) to represent the transaction and result
information respectively.

The following lines of code will serve as an example of execution of an not impersonated transaction:

``` java
HeaderPS7 headerPS = new HeaderPS7();
headerPS.setControleAltair(1);

PEM2650 data = new PEM2650();
request.setPENUMPE("06376468");

ResponseDto responseDto = queueService.executeNotImpersonatedTrx(PsFormatEnum.PS7, "PE47", data, headerPS);
```

The following example is an sample execution of an impersonated transaction:

``` java
HeaderPS8 headerPS = new HeaderPS8();
headerPS.setControleAltair(1);

PEM2650 data = new PEM2650();
request.setPENUMPE("06376468");

SecurityDto securityDto = new SecurityDto();
securityDto.setUser("usermf");
securityDto.setSessionToken("tokenabcd");

ResponseDto responseDto = queueService.executeImpersonatedTrx(PsFormatEnum.PS8, "PE47", data, headerPS, securityDto);
```

!!! info "Important"
  For personated transaction you must include security information

## Native compilation support

This module is no supported in native compilation.
