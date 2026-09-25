# Darwin-spring-boot-archetype-microservice Migration guides

## Version 5.5.0

<!tag:550>

- Plugin `maven-archetype-plugin:3.3.1` is now compatible with previous Velocity versions. However, its use is recommended with a specific version `mvn org.apache.maven.plugins:maven-archetype-plugin:3.3.1:generate` instead of `mvn archetype:generate`.

<!end:550>

## Version 5.3.1

<!tag:531>

- Plugin `maven-archetype-plugin:3.3.0` now uses Velocity 2.3 instead of 1.7, causing incompatibility errors. For this reason, please use `mvn org.apache.maven.plugins:maven-archetype-plugin:3.2.1:generate` instead of `mvn archetype:generate`.

<!end:531>

## Version 3.2.1-RELEASE

<!tag:321>

- A new file with `catalog.properties` cataloging information has been added. In previous versions this information was in the `application.yml` file.

<!end:321>

## Version 3.2.0-RELEASE

<!tag:320>

- As of this version, `org.projectlombok:lombok` dependency will always be added.

<!end:320>

## Version 3.1.0-RELEASE

<!tag:310>

- As of this version it is necessary to specify if the generated micro has an ATLAS classification using ***-DatlasClassification*** parameter. To keep the same behaviour from previous versions use *-DatlasClassification* or
    *-DatlasClassification=Y*.

<!end:310>

## Version 3.0.0-RELEASE

<!tag:300>

- As of this version, packages are refactored from `es.santander.darwin` to `com.santander.darwin`.

<!end:300>

## Version 2.8.0-RELEASE

<!tag:280>

- From this version the parameter to include the Partenon Connector component will be `partenon-component` instead of partenon-trx-op.

<!end:280>

## Version 2.7.0-RELEASE

<!tag:270>

- As of this version, the **microservices archetype can only be used in *Batch*** mode, passing all the parameters when executing the maven command. This is due to certain incompatibilities with interactive mode.

<!end:270>

## NUAR to DARWIN archetype migration guide

<!tag:nuartodarwin>

Regarding the generated archetype, the only change is reflected in the pom.xml file.

> NUAR

    <?xml version="1.0" encoding="UTF-8"?>
    <project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
        <modelVersion>4.0.0</modelVersion>

        <groupId>es.demo</groupId>
        <artifactId>unoseisonce</artifactId>
        <version>1.0.0-SNAPSHOT</version>
        <packaging>jar</packaging>

        <name>unoseisonce</name>
        <description>Verification of 1.6.11 archetype with 1.6.3 release</description>

        <!-- Use starter parent -->
        <parent>
            <groupId>es.santander.nuar</groupId>
            <artifactId>santander-spring-boot-starter-parent</artifactId>
            <version>1.6.6-SNAPSHOT</version>
        </parent>

        <!-- Uncoment this block if you don't have Nexus configure in your maven
            settings.xml -->
        <!-- <repositories> <repository> <id>maven-group</id> <url>https://nexus.alm.gsnetcloud.corp/repository/maven-group/</url>
            </repository> </repositories> -->

        <dependencies>
            <dependency>
                <groupId>org.springframework.cloud</groupId>
                <artifactId>spring-cloud-starter-config</artifactId>
            </dependency>
            <dependency>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-starter-actuator</artifactId>
            </dependency>
            <dependency>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-starter-web</artifactId>
            </dependency>
            <!-- Swagger al arquetipo -->
            <dependency>
                <groupId>io.springfox</groupId>
                <artifactId>springfox-swagger2</artifactId>
            </dependency>
            <dependency>
                <groupId>io.springfox</groupId>
                <artifactId>springfox-swagger-ui</artifactId>
            </dependency>

            <!-- Santander nuar libraries -->

            <dependency>
                <groupId>es.santander.nuar</groupId>
                <artifactId>santander-nuar-core</artifactId>
            </dependency>

            <dependency>
                <groupId>es.santander.nuar.util</groupId>
                <artifactId>common-library</artifactId>
            </dependency>

            <dependency>
                <groupId>es.santander.nuar.util</groupId>
                <artifactId>exceptions-library</artifactId>
            </dependency>

            <dependency>
                <groupId>es.santander.nuar.util</groupId>
                <artifactId>santander-nuar-security-authentication-library</artifactId>
            </dependency>


            <dependency>
                <groupId>es.santander.nuar.util</groupId>
                <artifactId>santander-nuar-omnichannel-library</artifactId>
            </dependency>


            <dependency>
                <groupId>es.santander.nuar</groupId>
                <artifactId>logging-component</artifactId>
            </dependency>

            <!-- End Santander nuar libraries -->

            <!-- Test -->
            <dependency>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-starter-test</artifactId>
                <exclusions>
                    <exclusion>
                        <groupId>org.springframework.boot</groupId>
                        <artifactId>spring-boot-starter-logging</artifactId>
                    </exclusion>
                </exclusions>
                <scope>test</scope>
            </dependency>

        </dependencies>

        <build>
            <plugins>
                <plugin>
                    <groupId>org.springframework.boot</groupId>
                    <artifactId>spring-boot-maven-plugin</artifactId>
                </plugin>
                <plugin>
                    <groupId>org.apache.maven.plugins</groupId>
                    <artifactId>maven-resources-plugin</artifactId>
                    <configuration>
                        <encoding>${project.build.sourceEncoding}</encoding>
                    </configuration>
                </plugin>
                <plugin>
                    <groupId>org.jacoco</groupId>
                    <artifactId>jacoco-maven-plugin</artifactId>
                    <executions>
                        <execution>
                            <id>default-prepare-agent</id>
                            <goals>
                                <goal>prepare-agent</goal>
                            </goals>
                        </execution>
                        <execution>
                            <id>default-report</id>
                            <goals>
                                <goal>report</goal>
                            </goals>
                        </execution>
                    </executions>
                </plugin>
                <plugin>
                    <groupId>org.apache.maven.plugins</groupId>
                    <artifactId>maven-source-plugin</artifactId>
                    <executions>
                        <execution>
                            <id>attach-sources</id>
                            <goals>
                                <goal>jar</goal>
                            </goals>
                        </execution>
                    </executions>
                </plugin>
                <plugin>
                    <groupId>org.apache.maven.plugins</groupId>
                    <artifactId>maven-javadoc-plugin</artifactId>
                    <executions>
                        <execution>
                            <id>attach-javadocs</id>
                            <goals>
                                <goal>jar</goal>
                            </goals>
                        </execution>
                    </executions>
                </plugin>
                <plugin>
                    <groupId>org.apache.maven.plugins</groupId>
                    <artifactId>maven-site-plugin</artifactId>
                    <configuration>
                        <locales>es</locales>
                    </configuration>
                </plugin>
            </plugins>
            <resources>
                <resource>
                    <directory>${project.basedir}/src/main/resources</directory>
                    <filtering>true</filtering>
                    <includes>
                        <include>**/*.properties</include>
                        <include>**/*.yml</include>
                        <include>**/*.yaml</include>
                        <include>**/banner.txt</include>
                    </includes>
                </resource>
            </resources>
        </build>
    </project>

> DARWIN

    <?xml version="1.0" encoding="UTF-8"?>
    <project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
        <modelVersion>4.0.0</modelVersion>

        <groupId>com.demo.arq</groupId>
        <artifactId>microdemo2</artifactId>
        <version>1.0.0-SNAPSHOT</version>
        <packaging>jar</packaging>

        <name>microdemo2</name>
        <description>asd</description>

        <!-- Use starter parent -->
        <parent>
            <groupId>es.santander.darwin</groupId>
            <artifactId>darwin-spring-boot-starter-parent</artifactId>
            <version>2.0.0-RELEASE</version>
        </parent>

        <dependencies>
            <dependency>
                <groupId>org.springframework.cloud</groupId>
                <artifactId>spring-cloud-starter-config</artifactId>
            </dependency>
            <dependency>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-starter-actuator</artifactId>
            </dependency>
            <dependency>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-starter-web</artifactId>
            </dependency>
            <!-- Swagger al arquetipo -->
            <dependency>
                <groupId>io.springfox</groupId>
                <artifactId>springfox-swagger2</artifactId>
            </dependency>
            <dependency>
                <groupId>io.springfox</groupId>
                <artifactId>springfox-swagger-ui</artifactId>
            </dependency>

            <!-- Santander nuar libraries -->

            <dependency>
                <groupId>es.santander.darwin</groupId>
                <artifactId>darwin-spring-boot-core</artifactId>
            </dependency>

            <dependency>
                <groupId>es.santander.darwin</groupId>
                <artifactId>darwin-spring-boot-cache-jbossdatagrid</artifactId>
            </dependency>


            <dependency>
                <groupId>es.santander.darwin</groupId>
                <artifactId>darwin-spring-boot-starter-authentication</artifactId>
            </dependency>


            <dependency>
                <groupId>es.santander.darwin</groupId>
                <artifactId>darwin-spring-boot-starter-omnichannel</artifactId>
            </dependency>


            <dependency>
                <groupId>es.santander.darwin</groupId>
                <artifactId>darwin-spring-boot-starter-logging</artifactId>
            </dependency>

            <!-- End Santander nuar libraries -->

            <!-- Test -->
            <dependency>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-starter-test</artifactId>
                <exclusions>
                    <exclusion>
                        <groupId>org.springframework.boot</groupId>
                        <artifactId>spring-boot-starter-logging</artifactId>
                    </exclusion>
                </exclusions>
                <scope>test</scope>
            </dependency>

        </dependencies>

        <build>
            <plugins>
                <plugin>
                    <groupId>org.springframework.boot</groupId>
                    <artifactId>spring-boot-maven-plugin</artifactId>
                </plugin>
                <plugin>
                    <groupId>org.apache.maven.plugins</groupId>
                    <artifactId>maven-resources-plugin</artifactId>
                    <configuration>
                        <encoding>${project.build.sourceEncoding}</encoding>
                    </configuration>
                </plugin>
                <plugin>
                    <groupId>org.jacoco</groupId>
                    <artifactId>jacoco-maven-plugin</artifactId>
                    <executions>
                        <execution>
                            <id>default-prepare-agent</id>
                            <goals>
                                <goal>prepare-agent</goal>
                            </goals>
                        </execution>
                        <execution>
                            <id>default-report</id>
                            <goals>
                                <goal>report</goal>
                            </goals>
                        </execution>
                    </executions>
                </plugin>
                <plugin>
                    <groupId>org.apache.maven.plugins</groupId>
                    <artifactId>maven-source-plugin</artifactId>
                    <executions>
                        <execution>
                            <id>attach-sources</id>
                            <goals>
                                <goal>jar</goal>
                            </goals>
                        </execution>
                    </executions>
                </plugin>
                <plugin>
                    <groupId>org.apache.maven.plugins</groupId>
                    <artifactId>maven-javadoc-plugin</artifactId>
                    <executions>
                        <execution>
                            <id>attach-javadocs</id>
                            <goals>
                                <goal>jar</goal>
                            </goals>
                        </execution>
                    </executions>
                </plugin>
                <plugin>
                    <groupId>org.apache.maven.plugins</groupId>
                    <artifactId>maven-site-plugin</artifactId>
                    <configuration>
                        <locales>es</locales>
                    </configuration>
                </plugin>
            </plugins>
            <resources>
                <resource>
                    <directory>${project.basedir}/src/main/resources</directory>
                    <filtering>true</filtering>
                    <includes>
                        <include>**/*.properties</include>
                        <include>**/*.yml</include>
                        <include>**/*.yaml</include>
                        <include>**/banner.txt</include>
                    </includes>
                </resource>
            </resources>
        </build>
    </project>

As you can see the changes come in the definition of the parent and the main dependencies that are now "starters" as well as the fact that now the library of "exceptions" does not exist.

<!end:nuartodarwin>
