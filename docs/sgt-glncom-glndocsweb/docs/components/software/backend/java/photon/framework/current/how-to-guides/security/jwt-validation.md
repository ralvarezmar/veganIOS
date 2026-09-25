# JWT Validation Using Authorization Server

This guide shows how to secure endpoints and configure JWT validation in Quarkus.

## Configuration

To use an authorization server to validate token, follow the steps:

1. Ensure that the application security is configured properly. For example,
to permit only authenticated users to access the resources except for health check endpoints,
we can configure by adding these properties to application.properties:

    ``` { .copy .txt }
    quarkus.http.auth.permission.authenticated.paths=/*
    quarkus.http.auth.permission.authenticated.policy=authenticated

    quarkus.http.auth.permission.permit.paths=/q/health/*
    quarkus.http.auth.permission.permit.policy=permit
    ```

    For more information about authorization configuration,
    check [Quarkus Authorization Documentation](https://quarkus.io/version/3.8/guides/security-authorize-web-endpoints-reference)

2. Add dependencies needed to communicate with the authorization server:

    ``` { .copy .xml }
    <dependency>
        <groupId>io.quarkus</groupId>
        <artifactId>quarkus-oidc</artifactId>
    </dependency>

    <dependency>
        <groupId>io.quarkus</groupId>
        <artifactId>quarkus-test-oidc-server</artifactId>
        <scope>test</scope>
    </dependency>
    ```

3. In application properties, add auth server url property. Example:

    ``` { .copy .txt }
    quarkus.oidc.auth-server-url=http://server-address:8443/realms/quarkus
    ```
