# Using Altair Client Starter

To communicate from microservice to mainframe was develop a library named `gln-back-arsenal-backend-embeddedmainframe` that encapsulates the routines of communication with Altair.
It uses the IBM MQ and do the data binding between a text message from queue to a java model object.

## Steps to configure

1. Import dependencies:

    ``` { .xml .copy }
    <dependency>
        <groupId>com.santander.ars</groupId>
        <artifactId>gln-back-arsenal-backend-embeddedmainframe</artifactId>
    </dependency>
    <dependency>
        <groupId>com.santander.ars</groupId>
        <artifactId>gln-back-arsenal-backend-web-channel-holder-starter</artifactId>
    </dependency>
    ```

    !!! info

        `gln-back-arsenal-backend-web-channel-holder-starter` is used to manage **ChannelHolder**, a
        structure to store the current channel name.

2. Set properties

    To use the library, it is necessary to provide a series of configuration
    parameters in the application.yml file, enabling the connection to an MQ queue
    that will send messages to the Mainframe. Transactions can have 3 possible formats:
    PS7, PS8, PZI.

    !!! tip "Attention"

        We will show only configuration examples, replace all fields with the correct project
        information (packages, formats, hosts, ports,  queues, transactions, etc)!

    Configuration example:

    ``` { .yaml .copy }
    # Library settings arsenal:
    arsenal:
        library:
            altair:
                format-classpath: gln.std.gluon.demo.observability.altair.model
                server:
                    hostname: mqlocal.paas.isbanbr.dev.corp
                    port: 1414
                    channel: CHANNEL1
                    username: username
                    pwd: password
                    message-expired-timeout: 3000
                    receive-timeout: 30000
                    mq-file: altair.yml
    ```

### How to use

1. Create a model java class with the payload expected by the called transaction from Altair. This class must have all the attributes and annotations describing it.

    ??? Tip "Using the robot to create transaction DTOs"

        One way to speed up this step is to use the DTO creation robot for mainframe transactions. With it, it is possible to generate all the necessary classes to call a transaction with just the transaction name.

        [Click here](https://gitlab.santanderbr.corp/arquitetura-de-integracao/altair-dto-generator) to download the automatic DTO generator to use the Altair component more conveniently.
        After downloading, we must prepare the environment for robot use as follows:

        1. Create a directory called dev in the system root (C:)
        2. Create a directory called formats in (C:/dev)
        3. Put the lib directory should be in C:/dev/formatos/
        4. Place the _script.bat, cpappend.bat and create-format-0.0.1-SNAPSHOT.jar file in C:/dev/formatos/
        5. Edit the script.bat and in the JAVA variable="Indicate the location where java is installed"
        6. Run the script.bat
        7. Enter one or more transactions separated by commas. Example: PE46 or PE47, PE39

    Here's an example of model classes generated for PS7. Expand the block to see:

    ??? note

        ```{.java .copy}
        @PsFormat(name = "PEM9210")
        public class PEM9210 {

            @PsFieldString(length = 8, name = "PENUMPE")
            private String penumpe = "";

            @PsFieldString(length = 2, name = "TIPDOC")
            private String tipoDocumento = "";

            @PsFieldString(length = 11, name = "PENUMDO")
            private String numeroDocumento = "";

            @PsFieldString(length = 2, name = "SECDOC")
            private String sequenciaDocumento = "";

            @PsFieldString(length = 3, name = "SECNOM", defaultValue = "")
            private String sequenciaNome;

            @PsFieldString(length = 3, name = "TIPNOM")
            private String tipoNome = "";

            @PsFieldString(length = 1, name = "SEGLLA")
            private String segundaChamada = "";

            @PsFieldString(length = 30, name = "PENOMFA")
            private String nomeFantasia = "";

            @PsFieldString(length = 20, name = "PEPRIAP")
            private String primeiroApelido = "";

            @PsFieldString(length = 20, name = "PESEGAP")
            private String segundoApelido = "";

            @PsFieldString(length = 40, name = "PENOMPE")
            private String nome = "";

            @PsFieldString(length = 10, name = "PEFECNA")
            private String dataNascimento = "";

            @PsFieldString(length = 1, name = "PETIPPE")
            private String tipoPessoa = "";

            @PsFieldString(length = 3, name = "PEESTPE")
            private String estadoPessoa = "";

            @PsFieldString(length = 3, name = "PECONPE")
            private String condicao = "";

            @PsFieldString(length = 1, name = "PENIVAC")
            private String nivelAcesso = "";

            @PsFieldString(length = 1, name = "PEINDRE")
            private String indicadorRelacoes = "";

            @PsFieldString(length = 1, name = "PEINDCO")
            private String temContratos = "";

            @PsFieldString(length = 1, name = "PEINDGR")
            private String pertenceGrupo = "";

            @PsFieldString(length = 1, name = "PEINDAV")
            private String indicadorAvisos = "";

            @PsFieldString(length = 1, name = "PEINDN1")
            private String indicadorUso1 = "";

            @PsFieldString(length = 1, name = "PEINDN2")
            private String indicadorUso2 = "";

            @PsFieldString(length = 1, name = "PEINDN3")
            private String indicadorUso3 = "";

            @PsFieldString(length = 1, name = "PEINDN4")
            private String indicadorUso4 = "";

            @PsFieldString(length = 1, name = "PEINDN5")
            private String indicadorUso5 = "";

            @PsFieldString(length = 2, name = "PETIPVI")
            private String tipoVia = "";

            @PsFieldString(length = 50, name = "PENOMCA")
            private String rua = "";

            @PsFieldString(length = 100, name = "PEOBSE1")
            private String observacoesDOM1 = "";

            @PsFieldString(length = 100, name = "PEOBSE2")
            private String observacoesDOM2 = "";

            @PsFieldString(length = 10, name = "PENUMBL")
            private String blocoNumApdoCorr = ""; // Bloco/ NUM / APDO.CORR

            @PsFieldString(length = 7, name = "PENOMLO")
            private String localizacao = "";

            @PsFieldString(length = 5, name = "PENOMCO")
            private String comum = "";

            @PsFieldString(length = 8, name = "PECODPO")
            private String codigoPostal = "";

            @PsFieldString(length = 9, name = "PERUTCA", defaultValue = "")
            private String numeroCasa;

            @PsFieldString(length = 2, name = "CODPRV")
            private String codigoEstado = "";

            @PsFieldString(length = 3, name = "PECODPA")
            private String codigoPais = "";

            @PsFieldString(length = 1, name = "PEMARNO")
            private String marcaNormalizacion = "";

            @PsFieldString(length = 26, name = "PEHSTAM")
            private String tmaptimes = "";

            public String getPenumpe() {
                return penumpe;
            }

            public void setPenumpe(String penumpe) {
                this.penumpe = penumpe;
            }

            public String getTipoDocumento() {
                return tipoDocumento;
            }

            public void setTipoDocumento(String tipoDocumento) {
                this.tipoDocumento = tipoDocumento;
            }

            public String getNumeroDocumento() {
                return numeroDocumento;
            }

            public void setNumeroDocumento(String numeroDocumento) {
                this.numeroDocumento = numeroDocumento;
            }

            public String getSequenciaDocumento() {
                return sequenciaDocumento;
            }

            public void setSequenciaDocumento(String sequenciaDocumento) {
                this.sequenciaDocumento = sequenciaDocumento;
            }

            public String getSequenciaNome() {
                return sequenciaNome;
            }

            public void setSequenciaNome(String sequenciaNome) {
                this.sequenciaNome = sequenciaNome;
            }

            public String getTipoNome() {
                return tipoNome;
            }

            public void setTipoNome(String tipoNome) {
                this.tipoNome = tipoNome;
            }

            public String getSegundaChamada() {
                return segundaChamada;
            }

            public void setSegundaChamada(String segundaChamada) {
                this.segundaChamada = segundaChamada;
            }

            public String getNomeFantasia() {
                return nomeFantasia;
            }

            public void setNomeFantasia(String nomeFantasia) {
                this.nomeFantasia = nomeFantasia;
            }

            public String getPrimeiroApelido() {
                return primeiroApelido;
            }

            public void setPrimeiroApelido(String primeiroApelido) {
                this.primeiroApelido = primeiroApelido;
            }

            public String getSegundoApelido() {
                return segundoApelido;
            }

            public void setSegundoApelido(String segundoApelido) {
                this.segundoApelido = segundoApelido;
            }

            public String getNome() {
                return nome;
            }

            public void setNome(String nome) {
                this.nome = nome;
            }

            public String getDataNascimento() {
                return dataNascimento;
            }

            public void setDataNascimento(String dataNascimento) {
                this.dataNascimento = dataNascimento;
            }

            public String getTipoPessoa() {
                return tipoPessoa;
            }

            public void setTipoPessoa(String tipoPessoa) {
                this.tipoPessoa = tipoPessoa;
            }

            public String getEstadoPessoa() {
                return estadoPessoa;
            }

            public void setEstadoPessoa(String estadoPessoa) {
                this.estadoPessoa = estadoPessoa;
            }

            public String getCondicao() {
                return condicao;
            }

            public void setCondicao(String condicao) {
                this.condicao = condicao;
            }

            public String getNivelAcesso() {
                return nivelAcesso;
            }

            public void setNivelAcesso(String nivelAcesso) {
                this.nivelAcesso = nivelAcesso;
            }

            public String getIndicadorRelacoes() {
                return indicadorRelacoes;
            }

            public void setIndicadorRelacoes(String indicadorRelacoes) {
                this.indicadorRelacoes = indicadorRelacoes;
            }

            public String getTemContratos() {
                return temContratos;
            }

            public void setTemContratos(String temContratos) {
                this.temContratos = temContratos;
            }

            public String getPertenceGrupo() {
                return pertenceGrupo;
            }

            public void setPertenceGrupo(String pertenceGrupo) {
                this.pertenceGrupo = pertenceGrupo;
            }

            public String getIndicadorAvisos() {
                return indicadorAvisos;
            }

            public void setIndicadorAvisos(String indicadorAvisos) {
                this.indicadorAvisos = indicadorAvisos;
            }

            public String getIndicadorUso1() {
                return indicadorUso1;
            }

            public void setIndicadorUso1(String indicadorUso1) {
                this.indicadorUso1 = indicadorUso1;
            }

            public String getIndicadorUso2() {
                return indicadorUso2;
            }

            public void setIndicadorUso2(String indicadorUso2) {
                this.indicadorUso2 = indicadorUso2;
            }

            public String getIndicadorUso3() {
                return indicadorUso3;
            }

            public void setIndicadorUso3(String indicadorUso3) {
                this.indicadorUso3 = indicadorUso3;
            }

            public String getIndicadorUso4() {
                return indicadorUso4;
            }

            public void setIndicadorUso4(String indicadorUso4) {
                this.indicadorUso4 = indicadorUso4;
            }

            public String getIndicadorUso5() {
                return indicadorUso5;
            }

            public void setIndicadorUso5(String indicadorUso5) {
                this.indicadorUso5 = indicadorUso5;
            }

            public String getTipoVia() {
                return tipoVia;
            }

            public void setTipoVia(String tipoVia) {
                this.tipoVia = tipoVia;
            }

            public String getRua() {
                return rua;
            }

            public void setRua(String rua) {
                this.rua = rua;
            }

            public String getObservacoesDOM1() {
                return observacoesDOM1;
            }

            public void setObservacoesDOM1(String observacoesDOM1) {
                this.observacoesDOM1 = observacoesDOM1;
            }

            public String getObservacoesDOM2() {
                return observacoesDOM2;
            }

            public void setObservacoesDOM2(String observacoesDOM2) {
                this.observacoesDOM2 = observacoesDOM2;
            }

            public String getBlocoNumApdoCorr() {
                return blocoNumApdoCorr;
            }

            public void setBlocoNumApdoCorr(String blocoNumApdoCorr) {
                this.blocoNumApdoCorr = blocoNumApdoCorr;
            }

            public String getLocalizacao() {
                return localizacao;
            }

            public void setLocalizacao(String localizacao) {
                this.localizacao = localizacao;
            }

            public String getComum() {
                return comum;
            }

            public void setComum(String comum) {
                this.comum = comum;
            }

            public String getCodigoPostal() {
                return codigoPostal;
            }

            public void setCodigoPostal(String codigoPostal) {
                this.codigoPostal = codigoPostal;
            }

            public String getNumeroCasa() {
                return numeroCasa;
            }

            public void setNumeroCasa(String numeroCasa) {
                this.numeroCasa = numeroCasa;
            }

            public String getCodigoEstado() {
                return codigoEstado;
            }

            public void setCodigoEstado(String codigoEstado) {
                this.codigoEstado = codigoEstado;
            }

            public String getCodigoPais() {
                return codigoPais;
            }

            public void setCodigoPais(String codigoPais) {
                this.codigoPais = codigoPais;
            }

            public String getMarcaNormalizacion() {
                return marcaNormalizacion;
            }

            public void setMarcaNormalizacion(String marcaNormalizacion) {
                this.marcaNormalizacion = marcaNormalizacion;
            }

            public String getTmaptimes() {
                return tmaptimes;
            }

            public void setTmaptimes(String tmaptimes) {
                this.tmaptimes = tmaptimes;
            }
        }
        ```

2. At the service layer, call the suitable method of
AltairQueueService (sendNaoPersonadoToAltair()/sendPersonadoToAltair())
and use the ResponseDto class (provided by the lib) to receive the generic return format.
The format and the header (HeaderPS7/HeaderPS8/HeaderPZI) are passed as function arguments.
When using sendPersonadoToAltair method, security data should also be passed as argument.
Usage example of AltairQueueService:

``` { .java .copy }
import com.altec.bsbr.fw.altair.dto.HeaderPS7;
import com.altec.bsbr.fw.altair.dto.ResponseDto;
import com.altec.bsbr.fw.ps.enums.PsFormatEnum;
import com.santander.ars.altair.config.ArsenalAltairConfig;
import com.santander.ars.altair.core.AltairQueueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class AppArsenalAltairServiceImpl implements AppArsenalAltairService {

  @Autowired private AltairQueueService queueService;

  public ResponseDto sendMessageAltair(Object data) throws Exception {
    ResponseDto output = new ResponseDto();

    try {
        ResponseDto responseDto = queueService.sendNaoPersonadoToAltair(PsFormatEnum.PS7,"PEC9", data, new HeaderPS7());
        return responseDto;

    } catch (Exception e) {
        e.printStackTrace();
    }
  }
}
```

!!! warning

    For PZI transactions it is necessary to obtain the CICS user and set the value
    in the PZI header.

In the REST endpoint exposure class, we populate the payload object with the transaction information and pass it to the service layer. The return is captured in the response object provided by the lib:

``` { .java .copy }
import com.altec.bsbr.fw.altair.dto.ResponseDto;
import gln.std.gluon.demo.observability.altair.domain.service.AppArsenalAltairService;

@RestController
@RequestMapping("/api/v1/apparsenal")
@Tag(name = "API for performing operations on AppArsenal")
@Log
public class AppArsenalResource {

    @Autowired
    private AppArsenalAltairService appArsenalAltairService;

    @Operation(summary = "Execute a Transaction XXX")
    @GetMapping("/XXX")
    public ResponseDto executePEOF() {
        log.info("Executing a XXX");

        PEM9210 request = new PEM9210();
        request.setPenumpe("06376468");

        ResponseDto  resp;
        try {
            resp = appArsenalAltairService.sendMessageAltair(request);
        } catch (Exception e) {
            throw new ResponseStatusException(
                HttpStatus.INTERNAL_SERVER_ERROR, "Error Found at Altair", e);
        }

        return resp;
    }

}
```

### 1. Configuration (application.yml fields)

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

### 2. Security (SecurityDto class fields)

|Name |Description|Default value|Type|
|----------------------------|----------------------------|----------------------------|----------------------------|
|user|Personated user to access mainframe||String|
|sessionToken|Personated token session to access mainframe||String|
|ipClient|Personated user's Client IP to access mainframe||String|
|newPassword|New password for the personated user to access the mainframe||String|
|password|Personated user password to access the mainframe||String|
|siglaSis|Acronym for SIS personated user to access the mainframe||String|
|terminal|Personated user terminal to access mainframe||String|

### 3. Header PS7 (HeaderPS7 class fields)

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

### 4. Header PS8 (HeaderPS8 class fields)

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

### 5. Header PZI (HeaderPZI class fields)

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

#### Notes

To use the Altair Client library, the application must request an MQ queue infrastructure.

For this, it is necessary to open a ticket in [Service Now](https://santander.service-now.com/)
for the Midrange area.

The tower that meets these demands is the STBR-INFRA-MR MQ.

### Multiple Queues

???+ tip

    It is not necessary to create a response queue in MF.

    ``` { .bash .copy }
    Example request with the respective queue data:
    <sss>.QR.REQUEST.PS7 - is the remote queue (request)
    <sss>.QA.REQUEST.PS7 - is the ALIAS in the MF
    <sss>.QL.ANSWER.PS   - is the answer queue

    where <sss> is the acronym of the system
    ```

If the Alias on the Mainframe does not exist, you must request its creation as follows:

Access the service catalog in Service-Now and select the Mainframe MQSERIES -
Creating MqSeries Channel template.

In the description put the Alias name pointing to the queue AEA.QL.REQUEST.MT.

``` { .bash .copy }
Please create ALIAS <sss>.QA.REQUEST.PS7 pointing to the queue
AEA.QL.REQUEST.MT.PS7
```

???+ tip

    If your infrastructure has an MQ cluster, it must be informed in this petition.

## Scenario using a dynamic user and request/response queue

1. Set path to the user and request/response file (altair.yml):

    The user and request/response queue file path can be set by filling **arsenal.library.altair.server.mq-file**
    property in the properties file or by setting **ALTAIR_MQ_PATH** environment variable.

    !!! warning

        The user and request/response file (altair.yml) is mandatory when using dynamic user

2. In a request must be set the header ``X-appname`` with the key to the configuration file entries. This header must be in the message of the exchange sent to altair component.

    ``` { .yaml .copy title="Example altair.yml"}
    M3:
        altairUser: MQ...
        requestQueue: AEA.QR.REQUEST.....
        responseQueue: AEA.QL.ANSWER.....
    IBF:
        altairUser: MQ...
        requestQueue: AEA.QR.REQUEST.....
        responseQueue: AEA.QL.ANSWER.....
    ```

    For Kubernetes projects, create a volume with the altair.yml file, and add the settings below.

    ``` { .yaml .copy }
    volumes:
      - name: altair-yml
        configMap:
          name: altair.yml

    volumeMounts:
      - name: altair-yml
        readOnly: true
        mountPath: /app/config
    ```

## Custom Health Check

As in the most updated version of the gln-back-arsenal-backend-embeddedmainframe we
do not explicitly specify the Queue Manager, Spring tries to process its JMS health
indicator when invoking the host [http://yourhost:port/actuator/health]
And this call will inevitably result in an error similar to the one below:

!!! warning

    WARN   o.s.boot.actuate.jms.JmsHealthIndicator 82f5269b890c6e1f
    82f5269b890c6e1f : 82f5269b890c6e1f : JMS health check failed
    com.ibm.msg.client.jms.DetailedIllegalStateException: JMSWMQ0018:
    Failed to connect to queue manager 'QM1' with connection mode 'Client'
    and host name 'localhost(1414)'.

We must then customize a health check, so that it is possible to validate a
connection without QueueManager affinity.

### Step-by-Step Guide

1. Create the configuration class below, it will be able to consume the library
resources and provide a Bean for the HealthCheck class that
we will create in the next step.

    ``` { .java .copy }
    import com.altec.bsbr.fw.altair.exception.AltairException;
    import com.altec.bsbr.fw.altair.mq.config.MQServerProperties;
    import com.altec.bsbr.fw.altair.mq.config.QueuePropertiesMap;
    import com.altec.bsbr.fw.altair.mq.gateway.SendAndReceiveMessage;
    import org.slf4j.Logger;
    import org.slf4j.LoggerFactory;
    import org.springframework.beans.factory.annotation.Autowired;
    import org.springframework.context.annotation.Configuration;

    @Configuration
    public class ArsenalServerAltairServiceConfig {
        @Autowired private MQServerProperties mqServerProperties;

        @Autowired private QueuePropertiesMap queuePropertiesMap;

        @Autowired private SendAndReceiveMessage sendAndReceiveMessage;

        private final Logger logger = LoggerFactory.getLogger(ArsenalServerAltairServiceConfig.class);

        public void checkConnectionToQueues(String systemAcronym) throws AltairException {
            logger.info(
                    String.format("Checking connection to queues for system acronym %s", systemAcronym));

            try {
                sendAndReceiveMessage.checkConnectionToQueues(
                        mqServerProperties,
                        queuePropertiesMap.getQueueMap().get(systemAcronym));
            } catch (Exception e) {
                logger.error(e.getMessage());
                throw new AltairException(e.getMessage(), e);
            }
        }
    }
    ```

2. Create a class that implements the
org.springframework.boot.actuate.health.HealthIndicator interface,
and override the health method with the proposed implementation.

    ``` { .java .copy }
    import org.springframework.beans.factory.annotation.Autowired;
    import org.springframework.boot.actuate.health.Health;
    import org.springframework.boot.actuate.health.HealthIndicator;
    import org.springframework.stereotype.Component;

    @Component("altairQueueAEAM3")
    public class AltairQueueHealthIndicator implements HealthIndicator {
        @Autowired private ArsenalServerAltairServiceConfig arsenalServerAltairServiceConfig;

        private String systemAcronym = "AEAM3";

        @Override
        public Health health() {
            try {
                this.arsenalServerAltairServiceConfig.checkConnectionToQueues(this.systemAcronym);

                return Health.up()
                        .withDetail(
                            "statusMessage",
                            "successfully connected to queues for system acronym " + this.systemAcronym)
                        .build();
            } catch (Exception e) {
                return Health.down()
                        .withDetail(
                            "statusMessage",
                            "error while connecting to queues for system acronym "
                                + this.systemAcronym
                                + ": "
                                + e.getMessage())
                        .build();
            }
        }
    }
    ```

    !!! info

        Remember to change the values of **@Component** value and **systemAcronym** value.

3. Still in the application-***.yml file, tell Spring how it should proceed with
your new indicator (and also disregard the common JMS validation):

   ``` { .yaml .copy }
    management:
        health:
            jms:
                enabled: false
        endpoints:
            enabled-by-default: true
            web:
                exposure:
                    include:
                        - health
                        - beans
        endpoint:
            health:
                show-details: ALWAYS
                probes:
                    enabled: true
                group:
                    readiness:
                    include:
                        - readinessState
                        - altairQueueAEAM3 # health indicator customized to altairQueuePampa
                                           # (name defined in @Component value)
   ```
