# Channel from security token

In case you require a channel and it is provided by the claim in your JWT, follow these steps to recover and use it.

## Prerequisites

* [Protecting microservices authenticating the resources and authorizing with Jwt scopes](./authentication-configuration.md)
* A claim has been configured with a channel name.

!!! Claim
    Please ensure to set the claim name as **channel_tp** so we can set the channel holder internally.

After following the steps outlined in the prerequisites section to configure your microservices, the Maven pom.xml file must be updated to set dependencies.

``` { .xml .copy title="pom.xml"}
<dependency>
    <groupId>com.santander.ars</groupId>
    <artifactId>gln-back-arsenal-backend-web-security-channel-holder-starter</artifactId>
</dependency>
```

After updating the dependency, simply inject a Bean named com.santander.ars.core.model.ChannelHolder.

``` { .java .copy linenums="1" hl_lines="8"}

@Service
@RequiredArgsConstructor
public class AppArsenalServiceImpl implements AppArsenalService {

    private final ChannelHolder channelHolder;

    public Page<AppArsenalResponseDTO> getPageable(Pageable pageable) {
        System.out.println(this.channelHolder.getChannelName());
        ...
    }
}

```

**line 8**: Invoke the method that returns the channel set on the claim in the JWT.

!!! warning
    - **ChannelHolder** is a request scope bean.
