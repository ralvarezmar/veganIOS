# Retrieving the channel name inside a JWT

A starter was created to automatically extract the information of the channel from a JWT claim named `channel_tp`, and set its value in the camel message header `X-appname`, when an application that exposes REST resources received a request.

One of the uses is, together with `gln-back-arsenal-integration-altair-connector`, that reads the header X-appname, to correlate with the yaml file, to identify which user and queue will communicate with the mainframe.

Before including this starter in your application, make sure you meet the prerequisites.

##### Prerequisites

1. Your token issuer must provide a claim named: `channel_tp` with the value of the channel. Example:

   ``` { .json title="JWT decoded example"}
     ...
     "exp": 1706723328,
     "iat": 1706723028,
     "jti": "76baa35a-b823-4ce0-9eef-510f603aaa67",
     "iss": "https://localhost:8443/realms/quarkus",
     "sub": "eb4123a3-b722-4798-9af5-8957f823657a",
     "typ": "Bearer",
     "azp": "backend-service",
     "session_state": "cd40f500-a72d-402c-bdfe-9fc17e2023bc",
     "realm_access": {
       "roles": [
         "user"
       ]
     },
     "scope": "email altair profile",
     "sid": "cd40f500-a72d-402c-bdfe-9fc17e2023bc",
     "channel_tp": "AEAM3",
     "email_verified": false,
     "preferred_username": "alice"
     ...
   ```

2. The microservice must have the resources protected using spring-security, as described in the document: [Microservices authentication configuration](authentication-configuration.md).
This is necessary to validate, decode the JWT received in the application and extract the information needed.

##### Configuration

###### Step 1: Add dependency

``` { .xml }

<dependency>
    <groupId>com.santander.ars</groupId>
    <artifactId>gln-back-arsenal-integration-security-channel-holder-starter</artifactId>
</dependency>

```

##### How it works

1. When any REST resource exposed by the Camel application receives a request, it is intercepted and forwarded to a Camel processor;
2. In the processor the Authentication data is retrieved from the SecurityContext;
3. If a JWT is available, it is extracted and decoded;
4. In the JWT decoded, it is searched for the claim channel_tp. If found, this value is set in the message header X-appname;
5. The request returns to the flow and when the message arrives at your first route after restDefinition, it will contains the header X-appname with the identified channel.

##### How to confirm the value injection

One way is to use the component log to print the content of the message.

``` { .java }
  .to("log:DEBUG-Altair-Msg-SecurityChannel?level=INFO&showAll=true&multiline=true&style=Fixed")
```

``` { .shell }

2024-01-31 15:19:54 [http-nio-8080-exec-2] INFO  DEBUG-Altair-Msg-SecurityChannel - Exchange[
    Id                  304ACB0AA0F03A6-0000000000000000
    ExchangePattern     InOut
    Properties          {CamelCharsetName=UTF-8, CamelToEndpoint=log://DEBUG-After-Altair-Msg-SecurityChannel?level=INFO&multiline=true&showAll=true&style=Fixed}
    Headers             {X-appname=AEAM3, accept=*/*, accept-encoding=gzip, deflate, br, authorization=Bearer ..., CamelHttpCharacterEncoding=UTF-8, CamelHttpMethod=GET, CamelHttpPath=, CamelHttpQuery=null, CamelHttpServletRequest=SecurityContextHolderAwareRequestWrapper[ org.springframework.security.web.header.HeaderWriterFilter$HeaderWriterRequest@d75ecf6], CamelHttpServletResponse=org.springframework.security.web.header.HeaderWriterFilter$HeaderWriterResponse@40a1d907, CamelHttpUri=/user_management/v1/integracaoaltairTurbo/exemploTurboPS7, CamelHttpUrl=http://localhost:8080/user_management/v1/integracaoaltairTurbo/exemploTurboPS7, CamelInterceptedEndpoint=altair://integracaoaltairTurboFormatoPS7?personado=false&psFormatEnum=PsFormatEnum.PS7&transactionName=PEC9&useHeaderPs=false, CamelServletContextPath=/integracaoaltairTurbo/exemploTurboPS7, connection=keep-alive, host=localhost:8080, postman-token=4d36199d-724f-4fd4-87d9-a479dee5ed16, user-agent=PostmanRuntime/7.26.8}
    BodyType            com.altec.bsbr.fw.altair.dto.ResponseDto
    Body                com.altec.bsbr.fw.altair.dto.ResponseDto@145d5928
]
```

For more details about the use of this component, access the Camel reference: [Log component](https://camel.apache.org/components/4.0.x/log-component.html).
