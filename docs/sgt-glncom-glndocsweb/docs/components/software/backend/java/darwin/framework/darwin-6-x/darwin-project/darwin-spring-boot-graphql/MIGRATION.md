# Darwin-spring-boot-graphql Migration guides

## Version 3.2.0-RELEASE

<!tag:320>

- GraphQL autoconfigure classes have been deleted. Check following imports to update:

| Old                                                                                            | New                                                                                                |
|------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------|
| com.santander.darwin.graphql.autoconfigure.GraphQlAutoConfiguration                            | org.springframework.boot.autoconfigure.graphql.GraphQlAutoConfiguration                            |
| com.santander.darwin.graphql.autoconfigure.ConditionalOnGraphQlSchema                          | org.springframework.boot.autoconfigure.graphql.ConditionalOnGraphQlSchema                          |
| com.santander.darwin.graphql.autoconfigure.DefaultGraphQlSchemaCondition                       | org.springframework.boot.autoconfigure.graphql.DefaultGraphQlSchemaCondition                       |
| com.santander.darwin.graphql.autoconfigure.GraphQlCorsProperties                               | org.springframework.boot.autoconfigure.graphql.GraphQlCorsProperties                               |
| com.santander.darwin.graphql.autoconfigure.GraphQlProperties                                   | org.springframework.boot.autoconfigure.graphql.GraphQlProperties                                   |
| com.santander.darwin.graphql.autoconfigure.GraphQlSourceBuilderCustomizer                      | org.springframework.boot.autoconfigure.graphql.GraphQlSourceBuilderCustomizer                      |
| com.santander.darwin.graphql.autoconfigure.data.GraphQlQueryByExampleAutoConfiguration         | org.springframework.boot.autoconfigure.graphql.data.GraphQlQueryByExampleAutoConfiguration         |
| com.santander.darwin.graphql.autoconfigure.data.GraphQlQuerydslAutoConfiguration               | org.springframework.boot.autoconfigure.graphql.data.GraphQlQuerydslAutoConfiguration               |
| com.santander.darwin.graphql.autoconfigure.data.GraphQlReactiveQueryByExampleAutoConfiguration | org.springframework.boot.autoconfigure.graphql.data.GraphQlReactiveQueryByExampleAutoConfiguration |
| com.santander.darwin.graphql.autoconfigure.data.GraphQlReactiveQuerydslAutoConfiguration       | org.springframework.boot.autoconfigure.graphql.data.GraphQlReactiveQuerydslAutoConfiguration       |
| com.santander.darwin.graphql.autoconfigure.data.GraphQlQuerydslSourceBuilderCustomizer         | org.springframework.boot.autoconfigure.graphql.dataGraphQlQuerydslSourceBuilderCustomizer          |
| com.santander.darwin.graphql.autoconfigure.reactive.GraphQlWebFluxAutoConfiguration            | org.springframework.boot.autoconfigure.graphql.reactive.GraphQlWebFluxAutoConfiguration            |
| com.santander.darwin.graphql.autoconfigure.security.GraphQlWebFluxSecurityAutoConfiguration    | org.springframework.boot.autoconfigure.graphql.security.GraphQlWebFluxSecurityAutoConfiguration    |
| com.santander.darwin.graphql.autoconfigure.security.GraphQlWebMvcSecurityAutoConfiguration     | org.springframework.boot.autoconfigure.graphql.security.GraphQlWebMvcSecurityAutoConfiguration     |
| com.santander.darwin.graphql.autoconfigure.servlet.GraphQlWebMvcAutoConfiguration              | org.springframework.boot.autoconfigure.graphql.servlet.GraphQlWebMvcAutoConfiguration              |
| com.santander.darwin.graphql.autoconfigure.rsocket.GraphQlRSocketAutoConfiguration             | org.springframework.boot.autoconfigure.graphql.rsocket;GraphQlRSocketAutoConfiguration             |
| com.santander.darwin.graphql.autoconfigure.rsocket;GraphQlRSocketController                    | org.springframework.boot.autoconfigure.graphql.rsocket;GraphQlRSocketController                    |
| com.santander.darwin.graphql.autoconfigure.rsocket;RSocketGraphQlClientAutoConfiguration       | org.springframework.boot.autoconfigure.graphql.rsocket.RSocketGraphQlClientAutoConfiguration       |

<!end:320>
