# Darwin on Gluon

Darwin in Gluon is essentially the same as the Darwin Classic flavor.

The main differences are:

<div class="cards row-2" markdown>

- #### [**New Security Model**](../../../core/security/index.md)

    ---

    Darwin in Gluon **follows the new Security model** that Gluon provides.

    You can take a look at the front proposal in [this documentation](../../../core/security/index.md).

    There, you will find how to use the new Security Context Manager (SCM) to handle OAuth2 flows and to consume API's.

- #### [**Microfront delegates requests to the Shell**](../../../core/http/index.md)

    ---

    Darwin **Microfronts** in Gluon **will delegate to Shell the execution of their requests**.
    This way, the Microfront will not be responsible for acquiring the token or injecting it.

    The new proposal is to use the Gluon http library (**@santander/http**) to transform (in a transparent way) the request performed by Angular HttpClient into a custom event that will be emitted to the Shell.

    Then, the Shell will listen to it and be responsible for making the final request.
    As this request will be performed at Shell scope, SCM will intercept it and inject the access token.

    Take a look at the [@santander/http documentation](../../../core/http/index.md) to learn more about it.

- #### [**Usage of Flame**](../../../../../../../contribute/cop/flame/index.md)

    ---

    Darwin in Gluon encourages the use of **Flame** to standardize the look'n feel of Santander applications.

    You can take a look at the [Flame documentation](../../../../../../../contribute/cop/flame/index.md) to learn more about it.

- #### [**Usage of Puppetteer**](../../../core/faq/how-to-use-puppeteer.md)

    ---

    Darwin in Gluon will use **Puppeteer to run tests on CI/CD**.

    Darwin SPA's, Shells and Microfronts will **need to install and configure Puppeteer** in order to run tests on the CI/CD workflow.

    This is something that the current scaffolding provides out-of-the-box, but it is important to take it into account if you are migrating an existing Darwin project to Gluon.
    You have more details on how to install or configure Puppeteer in this [Puppeteer guide](../../../core/faq/how-to-use-puppeteer.md).

</div>

You can find more information about how to transform a Darwin Classic project into a Darwin Gluon in:

- [Transform a Darwin Classic SPA into a Darwin Gluon SPA](how-to-transform-a-darwin-classic-spa-into-a-darwin-gluon-spa.md).
- [Transform a Darwin Classic Shell into a Darwin Gluon Shell](how-to-transform-a-darwin-classic-shell-into-a-darwin-gluon-shell.md).
- [Transform a Darwin Classic Microfront into a Darwin Gluon Microfront](how-to-transform-a-darwin-classic-mfe-into-a-darwin-gluon-mfe.md).
