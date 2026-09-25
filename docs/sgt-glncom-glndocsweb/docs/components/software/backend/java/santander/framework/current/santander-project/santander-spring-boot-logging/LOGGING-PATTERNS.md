# Santander Spring Boot Logging Patterns ![1.2.1](https://img.shields.io/badge/1.2.1-FF073D)

![Current](https://img.shields.io/badge/CURRENT-30FF24) ![GA](https://img.shields.io/badge/GA-C81D11)

## Security pattern

### GLOBAL format {#security-default}

Default value for the `santander.logging.pattern.security` property:

#### Log4j

```json
{"timestamp":"%d{${timeStampPattern}}{UTC}Z","environment":"${environment}","userId":"%X{userId}","logLevel":"%level","log":"%enc{%m %ex{full}}{JSON} ","appKey":"${appKey}","serviceName":"${env:APP_NAME}","region": "${region}","entity":"${entity}","error":"%equals{%X{errorOccurred}}{}{false}","platform":"${platform}","traceId":"%X{traceId}","spanId":"%X{spanId}","parentSpanId":"%X{parentId}","trace_id":"%X{wTraceId}","span_id":"%X{wSpanId}","parent_id":"%X{wParentId}","tracestate":"%X{tracestate}","customLog":{"paasProject":"${paasproject}","sessionId":"%X{Session-Id}","platformLog":"%enc{%X{User-Agent}}{JSON}","paasAppVersion":"${paasAppVersion}","appInit":"%X{appInit}","serverId":"${env:HOSTNAME}"},"logType":"security","securityAttributes":%X{securityAttributes},"result":{"resultCode":"%X{secResultCode}"}} %n
```

#### Logback

```json
{"timestamp":"%d{${timeStampPattern},UTC}Z","environment":"${environment}","userId":"%X{userId}","logLevel":"%level","log":"%encJson(%m %ex{full}) ","appKey":"${appId}","serviceName":"${internalAppName}","region": "${region}","entity":"${entity}","error":"%X{errorOccurred:-false}","platform":"${platform}","traceId":"%X{traceId}","spanId":"%X{spanId}","parentSpanId":"%X{parentId}","trace_id":"%X{wTraceId}","span_id":"%X{wSpanId}","parent_id":"%X{wParentId}","tracestate":"%X{tracestate}","customLog":{"paasProject":"${paasproject}","sessionId":"%X{Session-Id}","platformLog":"%encJson(%X{User-Agent})","paasAppVersion":"${paasAppVersion}","appInit":"%X{appInit}","serverId":"${santander-hostname}"},"logType":"security","securityAttributes":%X{securityAttributes},"result":{"resultCode":"%X{secResultCode}"}}%n
```

### GLUONLOG format

Default value for the `santander.logging.pattern.security` property:

#### Log4j

```json
{"timestamp":"%d{${timeStampPattern}}{UTC}Z","environment":"${environment}","userId":"%X{userId}","logLevel":"%level","log":"%enc{%m %ex{full}}{JSON} ","appKey":"${appKey}"${keyvalue-serviceName}${keyvalue-region}${keyvalue-entity},"error":%equals{%X{errorOccurred}}{}{false}${keyvalue-platform},"traceId":"%X{traceId}","spanId":"%X{spanId}","parentSpanId":"%X{parentId}","trace_id":"%X{wTraceId}","span_id":"%X{wSpanId}","parent_id":"%X{wParentId}","tracestate":"%X{tracestate}","company":"${company}","componentName":"${componentName}","componentId":"${componentId}","componentType":"${componentType}","appName":"${appName}","appId":"${appId}","gluon":"Y","isGluon":true,"componentVersion":"${paasAppVersion}","logVersion":"${logVersion}","customLog":{"userId":"%X{userId}","coreUserId":"%X{coreUserId}","paasProject":"${paasproject}","sessionId":"%X{Session-Id}","platformLog":"%enc{%X{User-Agent}}{JSON}"${keyvalue-paasAppVersion},"appInit":"%X{appInit}","serverId":"${env:HOSTNAME}","businessReference":"%X{BusinessId}","sessionReference":"%X{SessionId}"},"logType":"security","securityAttributes":%X{securityAttributes},"result":{"resultCode":"%X{secResultCode}"}} %n
```

#### Logback

```json
{"timestamp":"%d{${timeStampPattern},UTC}Z","environment":"${environment}","userId":"%X{userId}","logLevel":"%level","log":"%encJson(%m %ex{full}) ","appKey":"${appId}"${keyvalue-serviceName}${keyvalue-region}${keyvalue-entity},"error":%X{errorOccurred:-false}${keyvalue-platform},"traceId":"%X{traceId}","spanId":"%X{spanId}","parentSpanId":"%X{parentId}","trace_id":"%X{wTraceId}","span_id":"%X{wSpanId}","parent_id":"%X{wParentId}","tracestate":"%X{tracestate}","company":"${company}","componentName":"${componentName}","componentId":"${componentId}","componentType":"${componentType}","appName":"${appName:-}","appId":"${gluonLogAppId}","gluon":"Y","isGluon":true,"componentVersion":"${paasAppVersion}","logVersion":"${logVersion}","customLog":{"userId":"%X{userId}","coreUserId":"%X{coreUserId}","paasProject":"${paasproject}","sessionId":"%X{Session-Id}","platformLog":"%encJson(%X{User-Agent})"${keyvalue-paasAppVersion},"appInit":"%X{appInit}","serverId":"${darwin-hostname}","businessReference":"%X{BusinessId}","sessionReference":"%X{SessionId}"},"logType":"security","securityAttributes":%X{securityAttributes},"result":{"resultCode":"%X{secResultCode}"}}%n
```

### SPAIN format

Old value for the `santander.logging.pattern.security` property:

```json
{"timeStamp":"%d{${timeStampPattern}}{UTC}Z","environment":"${environment}","system":"${system}","subSystem":"${subsystem}","application":"${application}","subApplication":"${subapplication}","paasProject":"${paasproject}","component":"%notEmpty{%X{alert-component} - }%c","sessionId":"%X{Session-Id}","userId":"%X{userId}","correlationTraceId":"%X{traceId}","correlationSpanId":"%X{spanId}","correlationParentSpanId":"%X{parentId}","wTraceParent":"%X{traceparent}","wTraceState":"%X{tracestate}","logLevel":"%level","log":"%enc{%m %ex{full}}{JSON} ","platformLog": "%enc{%X{User-Agent}}{JSON}","appKey":"${appKey}", "paasApp":"${env:APP_NAME}", "paasAppVersion": "${paasAppVersion}", "appInit": "%X{appInit}","serverId": "${env:HOSTNAME}","region": "${region}" ,"extensionType":"security","status":"%X{secStatus}","securityComponent":"%X{secComponent}","loggedUser":"%X{secLoggedUser}","customer":"%X{secCustomer}","securityAttributes":%X{securityAttributes},"result":{"value":"%X{secResultValue}","desc":"%X{secResultDesc}","resultCode":"%X{secResultCode}"}} %n
```

!!! info "Important"

    This pattern is not supported in logback flavour.

## Frontend pattern

Default value for the `santander.logging.pattern.frontend` property:

```json
{"timeStamp" :"%X{fe-timeStamp}","environment" :"%X{fe-environment}","system" :"%X{fe-system}","subSystem" :"%X{fe-subSystem}","application" :"%X{fe-application}","subApplication" :"%X{fe-subApplication}","paasProject" :"%X{fe-paasProject}","correlationTraceId":"%X{traceId}","correlationSpanId":"%X{spanId}","correlationParentSpanId":"%X{parentId}","wTraceParent":"%X{traceparent}","wTraceState":"%X{tracestate}","component" :"%X{fe-component}","sessionId" :"%X{fe-sessionId}","userId" :"%X{userId}","extensionType" :"frontSpa","logLevel" :"%X{fe-logLevel}","log" :"%enc{%m}{JSON}","platformLog" :"%enc{%X{fe-platformLog}}{JSON}","url" :"%X{fe-url}","exception" :"%enc{%X{fe-exception}}{JSON}","navigator" : %X{fe-navigator},"resolution" :"%X{fe-resolution}","ip" :"%X{fe-ip}","appKey":"%X{fe-appKey}", "paasApp":"%X{fe-appname}", "paasAppVersion":"%X{fe-paasAppVersion}", "appInit": "%X{fe-appInit}", "dwVersion": "%X{fe-dwVersion}", "wrapperDwVersion": "%X{fe-wrapperDwVersion}" } %n
```

!!! info "Important"

    Frontend pattern is not supported by the Logback implementation.

## Console pattern

Default value for the `santander.logging.pattern.console` property:

```text
[%-5level] %d{yyyy-MM-dd HH:mm:ss.SSS} [%t] %X{Session-Id} %X{X-B3-TraceId} %X{X-B3-SpanId} %X{X-B3-ParentSpanId} %c{1} - %msg %notEmpty{"jobExecutionId":"%X{JobExecutionId}","jobInstanceId":"%X{JobInstanceId}","stepExecutionId":"%X{StepExecutionId}","bootVersion":"%X{bootVersion}"} %ex{full}%n
```

## Technical pattern

### GLOBAL format {#technical-default}

Default value for the `santander.logging.pattern.technical` property:

#### Log4j

```json
{"timestamp":"%d{${timeStampPattern}}{UTC}Z","environment":"${environment}","userId":"%X{userId}","logLevel":"%level","log":"%enc{%m %ex{full}}{JSON} ","appKey":"${appKey}","serviceName":"${env:APP_NAME}","region": "${region}","entity":"${entity}","error":"%equals{%X{errorOccurred}}{}{false}","platform":"${platform}","traceId":"%X{traceId}","spanId":"%X{spanId}","parentSpanId":"%X{parentId}","trace_id":"%X{wTraceId}","span_id":"%X{wSpanId}","parent_id":"%X{wParentId}","tracestate":"%X{tracestate}","customLog":{"paasProject":"${paasproject}","sessionId":"%X{Session-Id}","platformLog":"%enc{%X{User-Agent}}{JSON}","paasAppVersion":"${paasAppVersion}","appInit":"%X{appInit}","serverId":"${env:HOSTNAME}","channel":"%X{channel}","threadId":"%threadName","component":"%notEmpty{%X{alert-component} - }%c","contactPoint":"%X{contactPoint}"%notEmpty{,"jobExecutionId":"%X{JobExecutionId}","jobInstanceId":"%X{JobInstanceId}","stepExecutionId":"%X{StepExecutionId}","bootVersion":"%X{bootVersion}"}},"logType":"technical"} %n
```

#### Logback

```json
{"timestamp":"%d{${timeStampPattern},UTC}Z","environment":"${environment}","userId":"%X{userId}","logLevel":"%level","log":"%encJson(%m %ex{full}) ","appKey":"${appId}","serviceName":"${internalAppName}","region": "${region}","entity":"${entity}","error":"%X{errorOccurred:-false}","platform":"${platform}","traceId":"%X{traceId}","spanId":"%X{spanId}","parentSpanId":"%X{parentId}","trace_id":"%X{wTraceId}","span_id":"%X{wSpanId}","parent_id":"%X{wParentId}","tracestate":"%X{tracestate}","customLog":{"paasProject":"${paasproject}","sessionId":"%X{Session-Id}","platformLog":"%encJson(%X{User-Agent})","paasAppVersion":"${paasAppVersion}","appInit":"%X{appInit}","serverId":"${santander-hostname}","channel":"%X{channel}","threadId":"%thread","component":"%notEmpty(%X{alert-component} - ){}%c","contactPoint":"%X{contactPoint}"%notEmpty(,"jobExecutionId":"%X{JobExecutionId}","jobInstanceId":"%X{JobInstanceId}","stepExecutionId":"%X{StepExecutionId}","bootVersion":"%X{bootVersion}")},"logType":"technical"}%n
```

### GLUONLOG format

Default value for the `santander.logging.pattern.technical` property:

#### Log4j

```json
{"timestamp":"%d{${timeStampPattern}}{UTC}Z","environment":"${environment}","userId":"%X{userId}","logLevel":"%level","log":"%enc{%m %ex{full}}{JSON} ","appKey":"${appKey}"${keyvalue-serviceName}${keyvalue-region}${keyvalue-entity},"error":%equals{%X{errorOccurred}}{}{false}${keyvalue-platform},"traceId":"%X{traceId}","spanId":"%X{spanId}","parentSpanId":"%X{parentId}","trace_id":"%X{wTraceId}","span_id":"%X{wSpanId}","parent_id":"%X{wParentId}","tracestate":"%X{tracestate}","company":"${company}","componentName":"${componentName}","componentId":"${componentId}","componentType":"${componentType}","appName":"${appName}","appId":"${appId}","gluon":"Y","isGluon":true,"componentVersion":"${paasAppVersion}","logVersion":"${logVersion}","customLog":{"userId":"%X{userId}","coreUserId":"%X{coreUserId}","paasProject":"${paasproject}","sessionId":"%X{Session-Id}","platformLog":"%enc{%X{User-Agent}}{JSON}"${keyvalue-paasAppVersion},"appInit":"%X{appInit}","serverId":"${env:HOSTNAME}","businessReference":"%X{BusinessId}","sessionReference":"%X{SessionId}","channel":"%X{channel}","threadId":"%threadName","component":"%notEmpty{%X{alert-component} - }%c","contactPoint":"%X{contactPoint}"%notEmpty{,"jobExecutionId":"%X{JobExecutionId}","jobInstanceId":"%X{JobInstanceId}","stepExecutionId":"%X{StepExecutionId}","bootVersion":"%X{bootVersion}"}},"logType":"technical"} %n
```

#### Logback

```json
{"timestamp":"%d{${timeStampPattern},UTC}Z","environment":"${environment}","userId":"%X{userId}","logLevel":"%level","log":"%encJson(%m %ex{full}) ","appKey":"${appId}"${keyvalue-serviceName}${keyvalue-region}${keyvalue-entity},"error":%X{errorOccurred:-false}${keyvalue-platform},"traceId":"%X{traceId}","spanId":"%X{spanId}","parentSpanId":"%X{parentId}","trace_id":"%X{wTraceId}","span_id":"%X{wSpanId}","parent_id":"%X{wParentId}","tracestate":"%X{tracestate}","company":"${company}","componentName":"${componentName}","componentId":"${componentId}","componentType":"${componentType}","appName":"${appName:-}","appId":"${gluonLogAppId}","gluon":"Y","isGluon":true,"componentVersion":"${paasAppVersion}","logVersion":"${logVersion}","customLog":{"userId":"%X{userId}","coreUserId":"%X{coreUserId}","paasProject":"${paasproject}","sessionId":"%X{Session-Id}","platformLog":"%encJson(%X{User-Agent})"${keyvalue-paasAppVersion},"appInit":"%X{appInit}","serverId":"${darwin-hostname}","businessReference":"%X{BusinessId}","sessionReference":"%X{SessionId}","channel":"%X{channel}","threadId":"%thread","component":"%notEmpty(%X{alert-component} - ){}%c","contactPoint":"%X{contactPoint}"%notEmpty(,"jobExecutionId":"%X{JobExecutionId}","jobInstanceId":"%X{JobInstanceId}","stepExecutionId":"%X{StepExecutionId}","bootVersion":"%X{bootVersion}")},"logType":"technical"}%n
```

### SPAIN format

Old value for the `santander.logging.pattern.technical` property:

```json
{"timeStamp":"%d{${timeStampPattern}}{UTC}Z","environment":"${environment}","system":"${system}","subSystem":"${subsystem}","application":"${application}","subApplication":"${subapplication}","paasProject":"${paasproject}","component":"%notEmpty{%X{alert-component} - }%c","sessionId":"%X{Session-Id}","userId":"%X{userId}","correlationTraceId":"%X{traceId}","correlationSpanId":"%X{spanId}","correlationParentSpanId":"%X{parentId}","wTraceParent":"%X{traceparent}","wTraceState":"%X{tracestate}","logLevel":"%level","log":"%enc{%m %ex{full}}{JSON} ","platformLog": "%enc{%X{User-Agent}}{JSON}","appKey":"${appKey}", "paasApp":"${env:APP_NAME}", "paasAppVersion": "${paasAppVersion}", "appInit": "%X{appInit}","serverId": "${env:HOSTNAME}","region": "${region}" ,"extensionType":"microservices","contactPoint": "%X{contactPoint}","channel": "%X{channel}","threadId": "%threadName"%notEmpty{,"customLog.jobExecutionId": "%X{JobExecutionId}" ,"customLog.jobInstanceId": "%X{JobInstanceId}" ,"customLog.stepExecutionId": "%X{StepExecutionId}" ,"customLog.bootVersion": "%X{bootVersion}" }} %n
```

!!! info "Important"

    This pattern is not supported in logback flavour.

## Functional pattern

### GLOBAL format {#functional-default}

Default value for the `santander.logging.pattern.functional` property:

#### Log4j

```json
{"timestamp":"%d{${timeStampPattern}}{UTC}Z","environment":"${environment}","userId":"%X{userId}","logLevel":"%level","log":"%enc{%m %ex{full}}{JSON} ","appKey":"${appKey}","serviceName":"${env:APP_NAME}","region": "${region}","entity":"${entity}","error":"%equals{%X{errorOccurred}}{}{false}","platform":"${platform}","traceId":"%X{traceId}","spanId":"%X{spanId}","parentSpanId":"%X{parentId}","trace_id":"%X{wTraceId}","span_id":"%X{wSpanId}","parent_id":"%X{wParentId}","tracestate":"%X{tracestate}","customLog":{"paasProject":"${paasproject}","sessionId":"%X{Session-Id}","platformLog":"%enc{%X{User-Agent}}{JSON}","paasAppVersion":"${paasAppVersion}","appInit":"%X{appInit}","serverId":"${env:HOSTNAME}"%notEmpty{,%X{functionalCustomLog}}%notEmpty{,"jobExecutionId":"%X{JobExecutionId}""jobInstanceId":"%X{JobInstanceId}","stepExecutionId":"%X{StepExecutionId}","bootVersion":"%X{bootVersion}"}},"logType":"functional","businessLog":{"input":%X{functionalInput},"output":%X{functionalOutput}%notEmpty{,%X{functionalBussinesLog}}}} %n
```

#### Logback

```json
{"timestamp":"%d{${timeStampPattern},UTC}Z","environment":"${environment}","userId":"%X{userId}","logLevel":"%level","log":"%encJson(%m %ex{full}) ","appKey":"${appId}","serviceName":"${internalAppName}","region": "${region}","entity":"${entity}","error":"%X{errorOccurred:-false}","platform":"${platform}","traceId":"%X{traceId}","spanId":"%X{spanId}","parentSpanId":"%X{parentId}","trace_id":"%X{wTraceId}","span_id":"%X{wSpanId}","parent_id":"%X{wParentId}","tracestate":"%X{tracestate}","customLog":{"paasProject":"${paasproject}","sessionId":"%X{Session-Id}","platformLog":"%encJson(%X{User-Agent})","paasAppVersion":"${paasAppVersion}","appInit":"%X{appInit}","serverId":"${santander-hostname}"%notEmpty(,%X{functionalCustomLog}){}%notEmpty(,"jobExecutionId":"%X{JobExecutionId}""jobInstanceId":"%X{JobInstanceId}","stepExecutionId":"%X{StepExecutionId}","bootVersion":"%X{bootVersion}")},"logType":"functional","businessLog":{"input":%X{functionalInput},"output":%X{functionalOutput}%notEmpty(,%X{functionalBussinesLog})}}%n
```

### GLUONLOG format

Default value for the `santander.logging.pattern.functional` property:

#### Log4j

```json
{"timestamp":"%d{${timeStampPattern}}{UTC}Z","environment":"${environment}","userId":"%X{userId}","logLevel":"%level","log":"%enc{%m %ex{full}}{JSON} ","appKey":"${appKey}"${keyvalue-serviceName}${keyvalue-region}${keyvalue-entity},"error":%equals{%X{errorOccurred}}{}{false}${keyvalue-platform},"traceId":"%X{traceId}","spanId":"%X{spanId}","parentSpanId":"%X{parentId}","trace_id":"%X{wTraceId}","span_id":"%X{wSpanId}","parent_id":"%X{wParentId}","tracestate":"%X{tracestate}","company":"${company}","componentName":"${componentName}","componentId":"${componentId}","componentType":"${componentType}","appName":"${appName}","appId":"${appId}","gluon":"Y","isGluon":true,"componentVersion":"${paasAppVersion}","logVersion":"${logVersion}","customLog":{"userId":"%X{userId}","coreUserId":"%X{coreUserId}","paasProject":"${paasproject}","sessionId":"%X{Session-Id}","platformLog":"%enc{%X{User-Agent}}{JSON}"${keyvalue-paasAppVersion},"appInit":"%X{appInit}","serverId":"${env:HOSTNAME}","businessReference":"%X{BusinessId}","sessionReference":"%X{SessionId}"%notEmpty{,%X{functionalCustomLog}}%notEmpty{,"jobExecutionId":"%X{JobExecutionId}","jobInstanceId":"%X{JobInstanceId}","stepExecutionId":"%X{StepExecutionId}","bootVersion":"%X{bootVersion}"}},"logType":"functional","businessLog":{"input":%X{functionalInput},"output":%X{functionalOutput}%notEmpty{,%X{functionalBussinesLog}}}} %n
```

#### Logback

```json
{"timestamp":"%d{${timeStampPattern},UTC}Z","environment":"${environment}","userId":"%X{userId}","logLevel":"%level","log":"%encJson(%m %ex{full}) ","appKey":"${appId}"${keyvalue-serviceName}${keyvalue-region}${keyvalue-entity},"error":%X{errorOccurred:-false}${keyvalue-platform},"traceId":"%X{traceId}","spanId":"%X{spanId}","parentSpanId":"%X{parentId}","trace_id":"%X{wTraceId}","span_id":"%X{wSpanId}","parent_id":"%X{wParentId}","tracestate":"%X{tracestate}","company":"${company}","componentName":"${componentName}","componentId":"${componentId}","componentType":"${componentType}","appName":"${appName:-}","appId":"${gluonLogAppId}","gluon":"Y","isGluon":true,"componentVersion":"${paasAppVersion}","logVersion":"${logVersion}","customLog":{"userId":"%X{userId}","coreUserId":"%X{coreUserId}","paasProject":"${paasproject}","sessionId":"%X{Session-Id}","platformLog":"%encJson(%X{User-Agent})"${keyvalue-paasAppVersion},"appInit":"%X{appInit}","serverId":"${darwin-hostname}","businessReference":"%X{BusinessId}","sessionReference":"%X{SessionId}"%notEmpty(,%X{functionalCustomLog}){}%notEmpty(,"jobExecutionId":"%X{JobExecutionId}","jobInstanceId":"%X{JobInstanceId}","stepExecutionId":"%X{StepExecutionId}","bootVersion":"%X{bootVersion}")},"logType":"functional","businessLog":{"input":%X{functionalInput},"output":%X{functionalOutput}%notEmpty(,%X{functionalBussinesLog})}}%n
```

### SPAIN format

Old value for the `santander.logging.pattern.functional` property:

```json
{"timeStamp":"%d{${timeStampPattern}}{UTC}Z","environment":"${environment}","system":"${system}","subSystem":"${subsystem}","application":"${application}","subApplication":"${subapplication}","paasProject":"${paasproject}","component":"%notEmpty{%X{alert-component} - }%c","sessionId":"%X{Session-Id}","userId":"%X{userId}","correlationTraceId":"%X{traceId}","correlationSpanId":"%X{spanId}","correlationParentSpanId":"%X{parentId}","wTraceParent":"%X{traceparent}","wTraceState":"%X{tracestate}","logLevel":"%level","log":"%enc{%m %ex{full}}{JSON} ","platformLog": "%enc{%X{User-Agent}}{JSON}","appKey":"${appKey}", "paasApp":"${env:APP_NAME}", "paasAppVersion": "${paasAppVersion}", "appInit": "%X{appInit}","serverId": "${env:HOSTNAME}","region": "${region}" ,"extensionType":"functional","businessLog":{%X{functionalBussinesLog}},"input":%X{functionalInput},"output":%X{functionalOutput}%notEmpty{,"customLog.jobExecutionId": "%X{JobExecutionId}" ,"customLog.jobInstanceId": "%X{JobInstanceId}" ,"customLog.stepExecutionId": "%X{StepExecutionId}" ,"customLog.bootVersion": "%X{bootVersion}" }} %n
```

!!! info "Important"

    This pattern is not supported in logback flavour.

## Activity pattern

### GLOBAL format {#activity-default}

Default value for the `santander.logging.pattern.activity` property:

#### Log4j

```json
{"timestamp":"%d{${timeStampPattern}}{UTC}Z","environment":"${environment}","userId":"%X{userId}","logLevel":"%level","log":"%enc{%m %ex{full}}{JSON} ","appKey":"${appKey}","serviceName":"${env:APP_NAME}","region": "${region}","entity":"${entity}","error":"%equals{%X{errorOccurred}}{}{false}","platform":"${platform}","traceId":"%X{traceId}","spanId":"%X{spanId}","parentSpanId":"%X{parentId}","trace_id":"%X{wTraceId}","span_id":"%X{wSpanId}","parent_id":"%X{wParentId}","tracestate":"%X{tracestate}","customLog":{"paasProject":"${paasproject}","sessionId":"%X{Session-Id}","platformLog":"%enc{%X{User-Agent}}{JSON}","paasAppVersion":"${paasAppVersion}","appInit":"%X{appInit}","serverId":"${env:HOSTNAME}","channel":"%X{channel}","contactPoint":"%X{contactPoint}","threadId":"%threadName","clientId":"%X{clientId}","responseTime":"%X{responseTime}"%notEmpty{,"opType":"%X{operationType}","opName":"%X{operationName}"}%notEmpty{,"trxTransaction": "%X{trxTransaction}","trxOperation":"%X{trxOperation}","trxVersion":"%X{trxVersion}"}%notEmpty{,"trxCodResolution":"%X{CODRESOLUTION}"}%notEmpty{,"jobExecutionId":"%X{JobExecutionId}","jobInstanceId":"%X{JobInstanceId}","stepExecutionId":"%X{StepExecutionId}","bootVersion":"%X{bootVersion}"}},"inputTimeStamp":"%X{inputTimeStamp}","method":"%X{method}","url": "%X{URL}","returnCode":"%X{returnCode}","logType":"activity"} %n
```

#### Logback

```json
{"timestamp":"%d{${timeStampPattern},UTC}Z","environment":"${environment}","userId":"%X{userId}","logLevel":"%level","log":"%encJson(%m %ex{full}) ","appKey":"${appId}","serviceName":"${internalAppName}","region": "${region}","entity":"${entity}","error":"%X{errorOccurred:-false}","platform":"${platform}","traceId":"%X{traceId}","spanId":"%X{spanId}","parentSpanId":"%X{parentId}","trace_id":"%X{wTraceId}","span_id":"%X{wSpanId}","parent_id":"%X{wParentId}","tracestate":"%X{tracestate}","customLog":{"paasProject":"${paasproject}","sessionId":"%X{Session-Id}","platformLog":"%encJson(%X{User-Agent})","paasAppVersion":"${paasAppVersion}","appInit":"%X{appInit}","serverId":"${santander-hostname}","channel":"%X{channel}","contactPoint":"%X{contactPoint}","threadId":"%thread","clientId":"%X{clientId}","responseTime":"%X{responseTime}"%notEmpty(,"opType":"%X{operationType}","opName":"%X{operationName}"){}%notEmpty(,"trxTransaction": "%X{trxTransaction}","trxOperation":"%X{trxOperation}","trxVersion":"%X{trxVersion}"){}%notEmpty(,"trxCodResolution":"%X{CODRESOLUTION}"){}%notEmpty(,"jobExecutionId":"%X{JobExecutionId}","jobInstanceId":"%X{JobInstanceId}","stepExecutionId":"%X{StepExecutionId}","bootVersion":"%X{bootVersion}")},"inputTimeStamp":"%X{inputTimeStamp}","method":"%X{method}","url": "%X{URL}","returnCode":"%X{returnCode}","logType":"activity"}%n
```

### GLUONLOG format

Default value for the `santander.logging.pattern.activity` property:

#### Log4j

```json
{"timestamp":"%d{${timeStampPattern}}{UTC}Z","environment":"${environment}","userId":"%X{userId}","logLevel":"%level","log":"%enc{%m %ex{full}}{JSON} ","appKey":"${appKey}"${keyvalue-serviceName}${keyvalue-region}${keyvalue-entity},"error":%equals{%X{errorOccurred}}{}{false}${keyvalue-platform},"traceId":"%X{traceId}","spanId":"%X{spanId}","parentSpanId":"%X{parentId}","trace_id":"%X{wTraceId}","span_id":"%X{wSpanId}","parent_id":"%X{wParentId}","tracestate":"%X{tracestate}","company":"${company}","componentName":"${componentName}","componentId":"${componentId}","componentType":"${componentType}","appName":"${appName}","appId":"${appId}","gluon":"Y","isGluon":true,"componentVersion":"${paasAppVersion}","logVersion":"${logVersion}","customLog":{"userId":"%X{userId}","coreUserId":"%X{coreUserId}","paasProject":"${paasproject}","sessionId":"%X{Session-Id}","platformLog":"%enc{%X{User-Agent}}{JSON}"${keyvalue-paasAppVersion},"appInit":"%X{appInit}","serverId":"${env:HOSTNAME}","businessReference":"%X{BusinessId}","sessionReference":"%X{SessionId}","channel":"%X{channel}","contactPoint":"%X{contactPoint}","threadId":"%threadName","clientId":"%X{clientId}","responseTime":"%X{responseTime}"%notEmpty{,"opType":"%X{operationType}","opName":"%X{operationName}"}%notEmpty{,"trxTransaction": "%X{trxTransaction}","trxOperation":"%X{trxOperation}","trxVersion":"%X{trxVersion}"}%notEmpty{,"trxCodResolution":"%X{CODRESOLUTION}"}%notEmpty{,"jobExecutionId":"%X{JobExecutionId}","jobInstanceId":"%X{JobInstanceId}","stepExecutionId":"%X{StepExecutionId}","bootVersion":"%X{bootVersion}"}},"inputTimeStamp":"%X{inputTimeStamp}","method":"%X{method}","url": "%X{URL}","returnCode":"%X{returnCode}","logType":"activity"} %n
```

#### Logback

```json
{"timestamp":"%d{${timeStampPattern},UTC}Z","environment":"${environment}","userId":"%X{userId}","logLevel":"%level","log":"%encJson(%m %ex{full}) ","appKey":"${appId}"${keyvalue-serviceName}${keyvalue-region}${keyvalue-entity},"error":%X{errorOccurred:-false}${keyvalue-platform},"traceId":"%X{traceId}","spanId":"%X{spanId}","parentSpanId":"%X{parentId}","trace_id":"%X{wTraceId}","span_id":"%X{wSpanId}","parent_id":"%X{wParentId}","tracestate":"%X{tracestate}","company":"${company}","componentName":"${componentName}","componentId":"${componentId}","componentType":"${componentType}","appName":"${appName:-}","appId":"${gluonLogAppId}","gluon":"Y","isGluon":true,"componentVersion":"${paasAppVersion}","logVersion":"${logVersion}","customLog":{"userId":"%X{userId}","coreUserId":"%X{coreUserId}","paasProject":"${paasproject}","sessionId":"%X{Session-Id}","platformLog":"%encJson(%X{User-Agent})"${keyvalue-paasAppVersion},"appInit":"%X{appInit}","serverId":"${darwin-hostname}","businessReference":"%X{BusinessId}","sessionReference":"%X{SessionId}","channel":"%X{channel}","contactPoint":"%X{contactPoint}","threadId":"%thread","clientId":"%X{clientId}","responseTime":"%X{responseTime}"%notEmpty(,"opType":"%X{operationType}","opName":"%X{operationName}"){}%notEmpty(,"trxTransaction": "%X{trxTransaction}","trxOperation":"%X{trxOperation}","trxVersion":"%X{trxVersion}"){}%notEmpty(,"trxCodResolution":"%X{CODRESOLUTION}"){}%notEmpty(,"jobExecutionId":"%X{JobExecutionId}","jobInstanceId":"%X{JobInstanceId}","stepExecutionId":"%X{StepExecutionId}","bootVersion":"%X{bootVersion}")},"inputTimeStamp":"%X{inputTimeStamp}","method":"%X{method}","url": "%X{URL}","returnCode":"%X{returnCode}","logType":"activity"}%n
```

### SPAIN format

Old value for the `santander.logging.pattern.activity` property:

```json
{"timeStamp":"%d{${timeStampPattern}}{UTC}Z","environment":"${environment}","system":"${system}","subSystem":"${subsystem}","application":"${application}","subApplication":"${subapplication}","paasProject":"${paasproject}","component":"%notEmpty{%X{alert-component} - }%c","sessionId":"%X{Session-Id}","userId":"%X{userId}","correlationTraceId":"%X{traceId}","correlationSpanId":"%X{spanId}","correlationParentSpanId":"%X{parentId}","wTraceParent":"%X{traceparent}","wTraceState":"%X{tracestate}","logLevel":"%level","log":"%enc{%m %ex{full}}{JSON} ","platformLog": "%enc{%X{User-Agent}}{JSON}","appKey":"${appKey}", "paasApp":"${env:APP_NAME}", "paasAppVersion": "${paasAppVersion}", "appInit": "%X{appInit}","serverId": "${env:HOSTNAME}","region": "${region}" ,"extensionType":"activityLog","contactPoint": "%X{contactPoint}","channel": "%X{channel}","inputTimeStamp": "%X{inputTimeStamp}","error": "%equals{%X{errorOccurred}}{}{false}","method": "%X{method}","url": "%X{URL}","returnCode":"%X{returnCode}","threadId": "%threadName", "clientId": "%X{clientId}" %notEmpty{,"customLog.opType": "%X{operationType}", "customLog.opName": "%X{operationName}" }%notEmpty{,"customLog.trxTransaction": "%X{trxTransaction}", "customLog.trxOperation": "%X{trxOperation}", "customLog.trxVersion": "%X{trxVersion}" }%notEmpty{,"customLog.trxCodResolution": "%X{CODRESOLUTION}" }%notEmpty{,"customLog.jobExecutionId": "%X{JobExecutionId}" ,"customLog.jobInstanceId": "%X{JobInstanceId}" ,"customLog.stepExecutionId": "%X{StepExecutionId}" ,"customLog.bootVersion": "%X{bootVersion}" }} %n
```

When the activity pattern is customised with a different pattern, it exists a way of providing the values of the new fields.
The `Context` offers a `Map<String, String>`, called `CustomizeActivityLog`,
where the values of the new fields are added, and they are pushed into the MDC at the moment the activity trace is printed.
The `CustomizeActivityLog` can be accessed by `getCustomizeActivityLog()` function through `Context`.

!!! info "Important"

    The `customLog.opType` field and the `customLog.opName` field are only completed if the Santander Spring Boot GraphQL library is present in the application.

!!! info "Important"

    This pattern is not supported in logback flavour.

## Metrics pattern

Default value for the `santander.logging.pattern.metrics` property:

    %m

!!! info "Important"

    Metrics pattern is not supported by the Logback implementation.

!!! info "Important"

    This pattern is not supported in logback flavour.

## Console Metrics pattern

Default value for the `santander.logging.pattern.console-metrics` property:

    %d{yyyy-MM-dd HH:mm:ss.SSS} - %m

!!! info "Important"

    This pattern is not supported in logback flavour.

## Gravity Kafka pattern

Default value for the `santander.logging.gravity.pattern` property:

```json
{
"timeStamp":"%d{${timeStampPattern}}{UTC}Z",
"logLevel":"%level",
"project": "${appKey}",
"hostname": "${env:HOSTNAME}",
"application":"${env:APP_NAME}",
"applicationName": "${env:APP_NAME}",
"Logs": %m
} %ex{0}%n
```

!!! info "Important"

    Gravity pattern is not supported by the Logback implementation.

!!! info "Important"

    This pattern is not supported in logback flavour.
