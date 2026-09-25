# How to troubleshoot "Malformed UTF-8"

Some applications may encounter the following error when trying to decrypt some data returned from the **backend**:

## Contextualization

This failure is due to the version mismatch of the [security component](https://confluence.santanderbr.corp/display/SOLSEG/DLB+Cripto+SDK+-+Criptografia+Adicional) used on the **backend** side to create the resource and the **frontend** to consume it.

The application that consumes an encrypted resource using [@afe/encryption](https://confluence.santanderbr.corp/pages/viewpage.action?pageId=257378534&src=sidebar).

Must have [@afe/dlb-sdk](https://confluence.santanderbr.corp/pages/viewpage.action?pageId=269332231) installed in a version that is compatible with the version of **DLB** used in the **backend** of the service that returns the encrypted data.

If there is a discrepancy between these versions, the content will be encrypted with a different encoding than the application expects to receive, causing the **Malformed UTF-8 data** error.

## Solution

It is necessary to analyze the **backend** of the **API** that is being consumed to identify which version of the ***DLB*** is being used by it.

And then install the corresponding version of the [@afe/dlb-sdk](https://confluence.santanderbr.corp/pages/viewpage.action?pageId=269332231) that is compatible with it.

> You can refer to the compatibility table available in the [@afe/dlb-sdk](https://confluence.santanderbr.corp/pages/viewpage.action?pageId=269332231) documentation to identify which version of the part is compatible with the [DLB Crypto SDK](https://confluence.santanderbr.corp/display/SOLSEG/DLB+Cripto+SDK+-+Criptografia+Adicional).
