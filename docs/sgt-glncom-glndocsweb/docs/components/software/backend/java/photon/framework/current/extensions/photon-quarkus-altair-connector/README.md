# Photon Quarkus Altair Connector

Photon Altair Connector is an extension that encapsulates communication with mainframe.
It uses the IBM MQ and do the data binding between a text message from queue to a java model object.

## How to use

### Dependency Inclusion

``` { .xml .copy }
<dependency>
    <groupId>com.santander.photon</groupId>
    <artifactId>photon-quarkus-altair-connector</artifactId>
</dependency>
```

### Configuration

Both MQ server configurations and channel configurations can be set in **application.properties**.

#### MQ server configuration

MQ server configuration parameters:

|Name|Description|DefaultValue|Type|
|----|----|----|----|
|format-classpath|Classpath to format models||String|
|hostname|MQ hostname||String|
|queueManager|MQ queue manager||String|
|channel|MQ channel||String|
|port|MQ port||String|
|username|MQ username||String|
|pwd|MQ password||String|
|receiveTimeout|Time to wait response||String|
|messageExpiredTimeout|Message expiration time||String|
|mq-file|Mq file path||String|

Configuration Example:

``` { .txt .copy }
photon.altair.format-classpath=com.acme.client.domain
photon.altair.server.hostname=mqlocal.paas.isbanbr.dev.corp
photon.altair.server.channel=CHANNEL1
photon.altair.server.port=1414
photon.altair.server.username=username
photon.altair.server.pwd=password
```

#### Channel Configuration

Channel configuration (altair user, request queue and response queue) should be configured
under **photon.altair.channel** like the example below:

``` { .txt .copy }
photon.altair.channel.BHS.altair-user=MQSPAD
photon.altair.channel.BHS.request-queue=ATM.QR.REQUEST.PSX
photon.altair.channel.BHS.response-queue=ATM.QL.ANSWER.PSX
photon.altair.channel.WAY.altair-user=MQSPAD
photon.altair.channel.WAY.request-queue=WAY.QR.REQUEST.PSX
photon.altair.channel.WAY.response-queue=WAY.QL.ANSWER.PSX
```

!!! note "extend configuration with external file"

    It's possible to extend configuration using external files by setting
    **quarkus.config.locations** property in **application.properties** pointing to
    an external file. Check [Quarkus documentation](https://quarkus.io/guides/config-reference#locations)
    for more information.

    Example:

    ``` { .txt .copy }
    # src/main/resources/application.properties
    quarkus.config.locations=altair.properties
    ```

    ``` { .txt .copy }
    # src/main/resources/altair.properties
    photon.altair.channel.BHS.altair-user=MQSPAD
    photon.altair.channel.BHS.request-queue=ATM.QR.REQUEST.PSX
    photon.altair.channel.BHS.response-queue=ATM.QL.ANSWER.PSX
    ```

### Communication with mainframe

To communicate with mainframe, inject **com.altec.bsbr.fw.altair.service.AltairService** to send *nao personado* transactions
and/or **com.altec.bsbr.fw.altair.service.AltairPersonadoService** to send *personado* transactions.
Then prepare the request header and body and use the **executar()** method from the services.
The **executar()** method has 2 implementations so it's possible to pass *channel* string
(then the channel configuration will be retrieved based on this parameter) or
pass directly a *QueueProperties* class. The method signatures are below for reference:

``` { .java .copy }
// com.altec.bsbr.fw.altair.service.AltairService

ResponseDto executar(String channelName, PsFormatEnum formato, String transName, Object dados, HeaderPS headerPS)

ResponseDto executar(QueueProperties queueConfig, PsFormatEnum formato, String transName, Object dados, HeaderPS headerPS)

// com.altec.bsbr.fw.altair.service.AltairPersonadoService

ResponseDto executar(String channelName, PsFormatEnum formato, String transName, Object dados, HeaderPS headerPS, SecurityDto personData)

ResponseDto executar(QueueProperties queueProperties, PsFormatEnum formato, String transName, Object dados, HeaderPS headerPS, SecurityDto personData)
```

Headers parameters are different depending on the format (PS7, PS8, PZI). Below are the fields of each format's header class.

#### Header PS7 (HeaderPS7 class fields)

|Name |Description|Default value|Type|
|----------------------------|----------------------------|----------------------------|----------------------------|
|userAltair|Altair user to execute the transactio at mainframe||String|
|campoDesUso00|Field of Use 00 for PS7 controller||String|
|campoDesUso01|Field of Use 01 for PS7 controller||String|
|controleAltair|Altair controller for PS7 controller||String|
|indicadorImpressao|Print Indicator for PS7 Controller||String|
|sequencia|Sequence for PS7 controller||String|
|teclaFuncao|Function key for PS7 controller||String|
|terminalLogico|Logical Terminal for PS7 controller||String|
|tipoCabecalho|Type Header for PS7 controller||String|

#### Header PS8 (HeaderPS8 class fields)

|Name |Description|Default value|Type|
|----------------------------|----------------------------|----------------------------|----------------------------|
|userAltair|Altair user to execute the transactio at mainframe||String|
|CamposDeUso00|Field of Use 00 for PS8 controller||String|
|codigoAplicativoCanal|Channel Application Code for PS8 controller||String|
|codigoCanal|Channel code for PS8 controller||String|
|codigoTransacaoNegocio|Business Transaction Code for PS8 controller||String|
|controleAltair|Altair controller for PS8 controller||String|
|dadosAplicativo|Data App for PS8 controller||String|
|idCliente|Client Id for PS8 Controller||String|
|indicadorImpressao|Print Indicator for PS8 Controller||String|
|indicadorPreFormato|Pre Format indicator for PS8 controller||String|
|ip|IP for PS8 controller||String|
|numeroUnicoTransacaoCanal|Unique Channel Transaction Number for PS8 controller||String|
|sequencia|Sequence for PS8 controller||String|
|teclaFuncao|Function key for PS8 controller||String|
|terminalLogico|Logical Terminal for PS8 controller||String|
|tipoAutenticacao|Type Authentication for PS8 controller||String|
|tipoCabecalho|Type Header for PS8 controller||String|
|tipoFirma|Type Firm for PS8 controller||String|
|tipoIdCliente|Type Client Id for PS8 controller||String|
|usoInfra|Use Infra for PS8 controller||String|
|versaoMensagem|Message version for PS8 controller||String|

#### Header PZI (HeaderPZI class fields)

|Name |Description|Default value|Type|
|----------------------------|----------------------------|----------------------------|----------------------------|
|userAltair|Altair user to execute the transactio at mainframe||String|
|PRM_NIVEL_LOG|||Integer|
|PRM_PROGRAMA_LEG|||String|
|PRM_LEN_DATOS|||Integer|
|PRM_REPLYTOQ_CLTE|||String|
|PRM_TIP_MENSAJE|||String|
|PRM_TIP_PROCESO|||Integer|
|PRM_ID_CANAL|||String|
|PRM_ID_TX|||String|
|PRM_USUARIO_ALTAIR|||String|
|PRM_USUARIO_CICS|||String|
|PRM_FORMATO_MSG|||String|
|pziENTIDAD1|||String|
|CENTRO|Control center||String|
|TRANSAC|Transaction||String|
|TPOPER|Operation type||String|
|FECHACO|||String|
|CANAL|Channel Code||String|
|REFEROP|REFER-OPER||String|
|MEIPAG|Payment method code||String|
|CHVTRX|Transaction key||String|
|REFERES|REFER-OPER of reversal||String|
|DTORIG|Origin date||String|
|HRORIG|Origin time||String|
|CODCLI|Code Type Client||String|
|INDAGEN|Scheduling Indicator||String|
|NUMAUTE|Authentication number||Integer|
|TPMODUL|Module type||String|
|TPTERMI|Terminal Type||Integer|
|NUMPAB|PAB number||Integer|
|VERSAO|Channel version||Integer|
|NUMTERM|Terminal Number||String|
|SIGLAUS|User Acronym||String|
|NUMOPER|Operator number||Integer|
|MTROPER|Operator registration||Integer|
|NUMSUPE|Supervisor number||Integer|
|MTRSUP|Supervisor registration||Integer|
|MACMSG|MAC of the message||String|
|PAN1|Encrypted PAN||String|
|PANCONT|Encrypted PAN (Continued)||String|
|ENTCONT|Account Entity||String|
|CENTCTA|Account Center||String|
|NUMCTA|Account Number||String|
|TIPOCTA|Account Type||String|
|DADOSCA|||String|

For **personado** transactions, security data (SecurityDto) should also be passed as argument.

|Name |Description|Default value|Type|
|----------------------------|----------------------------|----------------------------|----------------------------|
|user|Personated user to access mainframe||String|
|sessionToken|Personated token session to access mainframe||String|
|ipClient|Personated user's Client IP to access mainframe||String|
|newPassword|New password for the personated user to access the mainframe||String|
|password|Personated user password to access the mainframe||String|
|siglaSis|Acronym for SIS personated user to access the mainframe||String|
|terminal|Personated user terminal to access mainframe||String|

#### Example usage

``` { .java .copy }
public class AltairService {
    @Inject
    private AltairService altairService;

    public PEM2650 sendNaoPersonado() throws PsFormatException {
        HeaderPS7 headerPS = new HeaderPS7();
        headerPS.setControleAltair(1);

        PEM2650 request = new PEM2650();
        request.setPENUMPE("06376468");

        ResponseDto resp = altairService.executar("BHS", PsFormatEnum.PS7, "PE47", request, headerPS);

        return (PEM2650) resp.getObjeto().getListaFormatos().get(0).getFormato();
    }
}
```

A sample application is available at github: [photon-altair-sample](https://github.com/santander-group-shared-assets/gln-back-photon-sample-applications/tree/main/photon-altair-sample)
