<h1> Guide to generate a sample native Arsenal Backend
application {!include-markdown '../../snippets/versions.md' start='<!tag:back-version-schema>' end='<!end:back-version-schema>'!}</h1>

{!include-markdown '../../snippets/versions.md' start='<!tag:back-current>'
end='<!end:back-current>'!}

## Generate native application using archetype

Starting with version 3.13.x of Arsenal, it is possible to generate an
application by passing a parameter to say whether or not an application should
be compiled natively, it is a boolean that can be true or false.

By default, this parameter is false, but if you want to activate and want your
archetype to have the settings to compile natively, this is the following
parameter:

```shell
native-compilation=true
```

For example, to generate a new application:

```shell
mvn archetype:generate \
-DarchetypeGroupId=com.santander.ars \
-DarchetypeArtifactId=gln-back-arsenal-backend-archetype \
-DarchetypeVersion={!include-markdown '../../snippets/versions.md' start='<!tag:back-version>' end='<!end:back-version>'!} \
-DgroupId=com.santander.ars \
-DartifactId=arsenal-demo \
-DisGluon=true \
-Dnative-compilation=true \
-Dversion=0.1.0-SNAPSHOT
```

## GitHub configurations

You must also configure some properties in the project's on github, to be
compatible with native compilation:

To works with native compilation you need add 3 things to properties.env

* Property: ARTIFACT_NATIVE_COMPILATION=true
* Property: MAVEN_BUILD_GOAL="clean verify -PnativeTest"
* And in JAVA_VERSION use a graalvm version, ie oracle-graalvm-21.0.1. There
  will also be a workflow to run with Java 17 soon.

In version Gluon 5.1.0, some modifications are going to be to improve the
workflows: Removing the necessity of modify MAVEN_BUILD_GOAL="clean verify
-PnativeTest" Remove native compilation from quality workflow

## Manually configure a project to be native compiled

If you already have an application and want to adjust it to be able to compile
natively and generate a binary, just follow the steps below

### Plugin definitions

The first step is to declare the native Spring plugin management inside build in
pom:

```xml
<properties>
  <native-build-tools-plugin.version>0.10.2</native-build-tools-plugin.version>
</properties>

<pluginManagement>
  <plugins>
    <plugin>
      <groupId>org.graalvm.buildtools</groupId>
      <artifactId>native-maven-plugin</artifactId>
      <version>${native-build-tools-plugin.version}</version>
      <extensions>true</extensions>
    </plugin>
  </plugins>
</pluginManagement>
```

Since we are not using the Spring parent, we must declare the native compilation
profile and nativeTest profile:

```xml
<profiles>
  <profile>
    <id>native</id>
    <build>
      <pluginManagement>
        <plugins>
          <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-jar-plugin</artifactId>
            <configuration>
              <archive>
                <manifestEntries>
                  <Spring-Boot-Native-Processed>true</Spring-Boot-Native-Processed>
                </manifestEntries>
              </archive>
            </configuration>
          </plugin>
          <plugin>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-maven-plugin</artifactId>
            <configuration>
              <image>
                <builder>paketobuildpacks/builder:tiny</builder>
                <env>
                  <HTTP_PROXY>http://proxyapp.santanderbr.corp:80</HTTP_PROXY>
                  <HTTPS_PROXY>http://proxyapp.santanderbr.corp:80</HTTPS_PROXY>
                  <BP_NATIVE_IMAGE>true</BP_NATIVE_IMAGE>
                </env>
              </image>
            </configuration>
            <executions>
              <execution>
                <id>process-aot</id>
                <goals>
                  <goal>process-aot</goal>
                </goals>
              </execution>
            </executions>
          </plugin>
          <plugin>
            <groupId>org.graalvm.buildtools</groupId>
            <artifactId>native-maven-plugin</artifactId>
            <configuration>
              <imageName>native-executable</imageName>
              <buildArgs>
                <!-- build standalone image -->
                <buildArg>--verbose</buildArg>
                <buildArg>-Ob</buildArg>
                <buildArg>-H:+ReportExceptionStackTraces</buildArg>
                <buildArg>--libc=musl</buildArg>
                <!-- To compile in java 21, uncomment following properties -->
                <!-- <buildArg>&#45;&#45;static</buildArg>-->
                <!-- <buildArg>&#45;&#45;strict-image-heap</buildArg>-->
              </buildArgs>
              <classesDirectory>${project.build.outputDirectory}</classesDirectory>
              <metadataRepository>
                <enabled>true</enabled>
              </metadataRepository>
              <requiredVersion>22.3</requiredVersion>
            </configuration>
            <executions>
              <execution>
                <id>add-reachability-metadata</id>
                <goals>
                  <goal>add-reachability-metadata</goal>
                </goals>
              </execution>
            </executions>
          </plugin>
        </plugins>
      </pluginManagement>
    </build>
  </profile>
  <profile>
    <id>nativeTest</id>
    <dependencies>
      <dependency>
        <groupId>org.junit.platform</groupId>
        <artifactId>junit-platform-launcher</artifactId>
        <scope>test</scope>
      </dependency>
    </dependencies>
    <build>
      <plugins>
        <plugin>
          <groupId>org.springframework.boot</groupId>
          <artifactId>spring-boot-maven-plugin</artifactId>
          <executions>
            <execution>
              <id>process-test-aot</id>
              <goals>
                <goal>process-test-aot</goal>
              </goals>
            </execution>
          </executions>
        </plugin>
        <plugin>
          <groupId>org.graalvm.buildtools</groupId>
          <artifactId>native-maven-plugin</artifactId>
          <configuration>
            <classesDirectory>${project.build.outputDirectory}</classesDirectory>
            <metadataRepository>
              <enabled>true</enabled>
            </metadataRepository>
            <buildArgs>
              <buildArg>--initialize-at-build-time=ch.qos.logback.core,com.tngtech.archunit</buildArg>
              <!-- build standalone image -->
              <buildArg>--no-fallback</buildArg>
              <!-- allow HTTP and HTTPS -->
              <buildArg>-H:EnableURLProtocols=http,https</buildArg>
              <buildArg>--enable-all-security-services</buildArg>
            </buildArgs>
            <requiredVersion>22.3</requiredVersion>
          </configuration>
          <executions>
            <execution>
              <id>native-test</id>
              <goals>
                <goal>test</goal>
              </goals>
            </execution>
          </executions>
        </plugin>
      </plugins>
    </build>
  </profile>
</profiles>
```

### Native compilation of the application generated by archetype with the initial starters

#### gln-back-arsenal-backend-archetype

* Log4j2 does not have native support, so in the Resource class where there was
  an annotation @Log4j2, it was necessary to change it to @Slf4j

* To make swagger work, it was necessary to add in yaml:

```yaml
springdoc:
  enable-native-support: true
    swagger-ui:
      path: /swagger-ui
```

##### Generate binary using Java native Agent lib

1. mvn -Pnative native:compile
2. java -Dspring.aot.enabled=true
   -agentlib:native-image-agent=config-output-dir=./config -jar
   target/<your-app.jar> (this will create a config folder in the root dir of
   your app)
3. try testing your application with all the possible paths covered so that
   reflection-config.json has all the information regarding the reflection calls
   at run time, once done use Ctrl+C to stop the app
4. create a folder META-INF/native-image in src/main/resources
5. copy all the contents here(META-INF/native-image) from config folder created
   in step 2
6. if you have, remove these classes from reflect-config.json to avoid runtime
   errors

    ``` json
    {
      "name":"jdk.internal.loader.BuiltinClassLoader",
      "allDeclaredFields":true,
      "queryAllDeclaredMethods":true
    },
    {
      "name":"jdk.internal.loader.ClassLoaders$AppClassLoader",
      "allDeclaredFields":true,
      "queryAllDeclaredMethods":true,
      "methods":[{"name":"clearCache","parameterTypes":[] }]
    },
    {
      "name":"jdk.internal.loader.ClassLoaders$PlatformClassLoader",
      "allDeclaredFields":true,
      "queryAllDeclaredMethods":true,
      "methods":[{"name":"clearCache","parameterTypes":[] }]
    },
    {
      "name":"java.lang.module.ModuleReader",
      "queryAllDeclaredMethods":true,
      "methods":[{"name":"list","parameterTypes":[] }]
    },
    {
      "name":"java.lang.module.ModuleReference",
      "allDeclaredFields":true,
      "queryAllDeclaredMethods":true,
      "methods":[{"name":"descriptor","parameterTypes":[] }, {"name":"location","parameterTypes":[] }, {"name":"open","parameterTypes":[] }]
    }
    ```

7. again run mvn -Pnative native:compile OR mvn -Pnative spring-boot:build-image (if you need docker image)
8. finally run target/your-app-name (or docker run...)

##### Generate binary rogrammatically configuring hints

###### Serialization hints configuration

Classes that need binding (mostly when it has JSON
serialization/deserialization), it is necessary to add this
@RegisterReflectionForBinding annotation. It was necessary to add this
annotation to the Resource, as follows:

```java
@RegisterReflectionForBinding({AppArsenalResponseDTO.class, AppArsenalRequestDTO.class})
```

###### Arsenal error starter hints configuration

For the error starter, it is necessary to create a customization for reflection
and to be able to load some resources. This was done by creating a class as
follows:

```java
import org.springframework.aot.hint.RuntimeHints;
import org.springframework.aot.hint.RuntimeHintsRegistrar;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.ImportRuntimeHints;

@ImportRuntimeHints(ErrorStarterHintsConfig.ErrorStarterRegistrar.class)
@Configuration
public class ErrorStarterHintsConfig {

  static class ErrorStarterRegistrar implements RuntimeHintsRegistrar {
    @Override
    public void registerHints(RuntimeHints hints, ClassLoader classLoader) {
      // Register resources
      hints.resources().registerPattern("arsenal-messages.properties");
    }
  }
}
```

###### Hibernate version

The release of Spring Boot 3.2.x upgrades to Hibernate 6.4.4.Final. While it
contains a number of valuable bug fixes, it does not work correctly in a native
image. If you are using GraalVM, Hibernate should be temporarily downgraded to
6.4.2.Final using the hibernate.version property.

## Compile some of our specific libraries

### Ehcache configuration

add the following tag to native-maven-plugin configuration to avoid runtime
error:

``` xml
<configuration>
  <jvmArgs>
    <arg>--add-opens=java.base/java.lang=ALL-UNNAMED</arg>
  </jvmArgs>
</configuration>
```

### Embedded Crypto

For native compilation of the
gln-back-arsenal-backend-lib-embeddedcrypto-starter, just do the steps on [Hints configuration using json files](#generate-binary-using-java-native-agent-lib) or
Programmatically:

```java
hints.serialization().registerType(DLCrypto.class);
hints.serialization().registerType(DLECC.class);
```

### Altair Client

To use the gln-back-arsenal-backend-embeddedmainframe altair client, simply
declare its dependencies, and exclude org.bouncycastle version 15, since we are
using version 17 and beans conflict may occur, resulting in that way:

```xml
<dependency>
  <groupId>com.santander.ars</groupId>
  <artifactId>gln-back-arsenal-backend-embeddedmainframe</artifactId>
  <exclusions>
    <exclusion>
      <artifactId>bcpkix-jdk15on</artifactId>
      <groupId>org.bouncycastle</groupId>
    </exclusion>
    <exclusion>
      <artifactId>bcprov-jdk15on</artifactId>
      <groupId>org.bouncycastle</groupId>
    </exclusion>
  </exclusions>
</dependency>
<dependency>
  <groupId>com.santander.ars</groupId>
  <artifactId>gln-back-arsenal-backend-web-channel-holder-starter</artifactId>
</dependency>
```

Then, simply perform the steps contained in [Generate hints by java
command](#generate-binary-using-java-native-agent-lib)

## Libraries that do not compile natively so far

* ***Log4j2***: does not have native support, so in the Resource class where
  there was an annotation @Log4j2, it was necessary to change it to @Slf4j
* ***Spring Cloud Streams***: There is no support for native compilation. It
  will be available in spring boot version 3.2.0,
  spring-cloud-stream-binder-kafka version 4.1.0. Follow-up for the open issue:
  <https://github.com/spring-cloud/spring-cloud-stream/issues/2323>
* ***Telemetry Starter Brazil***: because of use of Janino, it won't compile
  natively. <https://github.com/spring-projects/spring-boot/issues/33758>
* ***Cucumber***: Even after the update of maven surefire do 3.2.2. Update
  cucumber to version 7.14 the Class with steps definition of the BDD test, in
  arsenal archetype (CucumberFeatures.class) is not available at runtime. The
  class is load during compile time but even with @ConfigurationParameter
  GLUE_PROPERTY_NAME with the package of the class is not found. Due to this
  incompatibility the `<execution><id>test-native</id>...` doesn't work.

### Arsenal archetype (gln-back-arsenal-backend-archetype) with Oracle database

After upgrading the dependency from ojdbc8 to ojdbc11 to be compatible with java
17. The native compilation occurs successfully. But was not able to test because
we don't have a instance of oracle database to connect.

### Repository

The applications used to native compilation with the archetype
*gln-back-arsenal-backend-archetype* with the databases ***h2, postgresql and
oracle*** are available at
[GitHub](https://github.com/santander-group-gluon/gln-back-java-internal-poc/tree/feature/GLUON-12674_native_compile_databases).

In each project has README_CHANGES.md that contains the modifications applied to
the application generated by the archetype to enable/test native compilation.

## Overall tips

To speed up the process of native compile use:

* Enable More CPU Features (`-march=native`)
* Quick build mode (`-Ob`)

that options can be enable using the arguments:

``` xml
<plugin>
  <groupId>org.graalvm.buildtools</groupId>
  <artifactId>native-maven-plugin</artifactId>
  ...
  <configuration>
    ...
    <buildArgs>
      <arg>-march=native</arg>
      <arg>-Ob</arg>
      ...
```

Source:
<https://www.graalvm.org/latest/reference-manual/native-image/overview/BuildOutput/#recommendations>

To speed up a little bit more is **close** other applications during native
compile to **reduce** the number of Garbage Collection executions and the time
spent.
