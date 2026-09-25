<!--Start front config init-->
### Branches

{!
   include-markdown "./front-configuration.md"
   start="<!--Start Gitflow Branches-->"
   end="<!--End Gitflow Branches-->"
!}

### Configuration Files

{!
   include-markdown "./front-configuration.md"
   start="<!--Start Configuration Files-->"
   end="<!--End Configuration Files-->"
!}

#### Properties

{!
   include-markdown "./front-configuration.md"
   start="<!--Start Location Properties-->"
   end="<!--End Location Properties-->"
!}

<!--End front config init-->

<!--Start front config end-->
{!
   include-markdown "./front-configuration.md"
   start="<!--Start Common Properties-->"
   end="<!--End Common Properties-->"
!}

#### Dockerfile

{!
   include-markdown "./front-configuration.md"
   start="<!--Start Dockerfile-->"
   end="<!--End Dockerfile-->"
!}

#### Continuous Deployment files

{!
   include-markdown "./front-configuration.md"
   start="<!--Start CD-->"
   end="<!--End CD-->"
!}

#### Helm Configuration

???+ info "Disclaimer"

    Please, notice that we are using the Helm Chart from Darwin framework to deploy all our components: Darwin & React.

    This way, unless it sounds a bit weird to use the Helm Chart from `sanes-darwin-san` project to deploy React assets or the way to configure the values are through an object called `darwin`, it is the right way to do that.

    We are committed to converge both frameworks into one, and this is the first step to achieve that.

{!
   include-markdown "./front-configuration.md"
   start="<!--Start Helm Chart-->"
   end="<!--End Helm Chart-->"
!}

### Secrets Configuration

{!
   include-markdown "./front-configuration.md"
   start="<!--Start Github Secrets-->"
   end="<!--End Github Secrets-->"
!}

<!--End front config end-->