# CloudFront  | Exposure

!!! warning "Important"
    As a **Reference Architecture**, this documentation provides **general patterns and recommendations** that should be tailored and customized to meet the specific requirements of each use case.

!!! tip "Attention"
    This document is part of an integrated solution comprising two key components: **Exposure** and **Storage**. AWS CloudFront serves as the **Exposure** layer, enabling secure and efficient delivery of static assets to end users.
    For the **Storage** layer, you can explore the use of [Amazon S3](../s3-bucket.md). Together, these components facilitate the seamless deployment and delivery of web applications.

## Overview

This document provides an overview of AWS CloudFront and its integration with S3 Buckets Proxy Distribution, including how to create and consume it.

<br/>

## What is the AWS CloudFront?

AWS CloudFront is a content delivery network (CDN) service that securely delivers data, videos, applications, and APIs to customers globally with low latency and high transfer speeds. Key components of CloudFront include:

- **CloudFront Distribution**: A distribution is a collection of settings that define how content is delivered via CloudFront.

- **Origins**: The origin is the source of the content that CloudFront delivers, such as an S3 bucket or an HTTP server.

- **CloudFront Functions**: Lightweight JavaScript functions that run at the edge to customize content delivery.

<br/>

## What is the S3 Buckets Proxy Distribution?

The **S3 Buckets Proxy Distribution** is a CloudFront distribution designed to serve front-end applications stored in S3 buckets.
It acts as a proxy to facilitate the retrieval of front-end applications, their versions, and associated configuration maps.
This is particularly useful in micro front-end architectures, where multiple independent front-end components are dynamically deployed and consumed.

Key features include:

- **Dynamic Retrieval**: Automatically fetch the latest or specific versions of front-end applications.
- **Configuration Management**: Access configuration maps to separate deployment logic from application settings.
- **Simplified Consumption**: Provides a consistent URL structure for accessing applications and their resources.

<br/>

![Cloudfront diagram](../images/cloudfront-diagram.png)

<br/>

## How to create the S3 Buckets Proxy Distribution?

The process of creating the **S3 Buckets Proxy Distribution** involves setting up a CloudFront distribution and configuring it to serve content from an S3 bucket. Below is a high-level overview of the steps:

1. **Create a CloudFront Distribution**:
   - Go to the **AWS Console**, navigate to **CloudFront**, and click **Create Distribution**.
   - Specify the S3 bucket as the origin and configure settings like caching, security, and Web Application Firewall (WAF).

2. **Configure Function Associations**:
   - Use **CloudFront Functions** to customize content delivery, such as modifying headers or URLs.

3. **Set Access Control and Permissions**:
   - Configure the S3 bucket policy to allow access only through the CloudFront distribution.
   - Use **Origin Access Control (OAC)** to restrict direct access to the S3 bucket.

<br/>

### Create a CloudFront Distribution

- On **AWS Console**, go to **CloudFront** and search for button **Create Distribution**.

    ![Cloudfront create distribution](../images/cloudfront-create-distribution.png)

- On **Create Distribution** page, search for **Origin Domain**.
  
    ![Cloudfront distribution origin domain](../images/cloudfront-distribution-origin-domain.png)

- Choose you bucket

    ![Cloudfront distribution S3 Bucket](../images/cloudfront-function-s3-bucket.png)

- On **Web Application Firewall** field, choose **Enable**
  
    ![Cloudfront distribution firewall](../images/cloudfront-distribution-firewall.png)

- To finish, click on **Create distribution**

    ![Cloudfront create distribution](../images/cloudfront-create-distribution-button.png)

- On **General** page, wait for **Deploying**

    ![Cloudfront deploying](../images/cloudfront-deploying.png)

- When it's done...
  
    ![Cloudfront deployed](../images/cloudfront-deploy-done.png)

- ...your API is available on **Distribution domain name** URL

    ![Cloudfront available](../images/cloudfront-distribution-domain-name.png)

### Function associations

- On **Distribution** page, search for **Behaviors** tab

    ![Cloudfront distribution behaviors](../images/cloudfront-distribution-behaviors.png)

- Select the behavior and click **Edit** button

    ![Cloudfront behavior edit](../images/cloudfront-behavior-edit.png)

- On **Edit behavior** page, search for **Function Associations**, on **Viewer request** filed select **CloudFront Function** as **Function Type** and select your function on **Function ARN / Name** field.

    ![Cloudfront function association](../images/cloudfront-distribution-function-association.png)

- Review inputted data and click on **Save changes** button.
  
    ![Cloudfront save function association](../images/cloudfront-distribution-save-function-association.png)

### Access control and permissions

- On Distribution page, search for **Origins** tab, select the origin and click on **Edit** button

    ![Cloudfront origin edit](../images/cloudfront-distribution-origin-edit.png)

- On **Edit origin** page, search for **Origin access** field and choose **gln-paas-OAC** as **Origin Access Control settings**.

    ![Cloudfront origin access](../images/cloudfront-distribution-origin-access.png)

- On same page, click on **Go to S3 Bucket permissions** link, to configure your bucket.

    ![S3 Bucket Permissions](../images/cloudfront-distribution-s3-bucket-permissions.png)

- On bucket page, search for **Bucket Policy** and click on **Edit** button.

    ![S3 Bucket Policy](../images/cloudfront-distribution-s3-bucket-policy.png)

- Create your own policy by replace the values from two fields:
    ??? example "S3 Bucket policy"

```JSON
{
    "Version": "2008-10-17",
    "Id": "PolicyForCloudFrontPrivateContent",
    "Statement": [
        {
            "Sid": "AllowCloudFrontServicePrincipal",
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudfront.amazonaws.com"
            },
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::s3-demo-sa-snapshots/*",
            "Condition": {
                "StringEquals": {
                    "AWS:SourceArn": "arn:aws:cloudfront::533267329486:distribution/E1QELH4MRZCKYN"
                }
            }
        }
    ]
}
```

    - the **Resource** field should be replaced by the ARN of your bucket, followed by "/*".

    - the **AWS:SourceArn** field should be replaced by your Distribution's ARN

!!! warning "Attention"
    **S3 Buckets Proxy Distribution** requires **'index.html'** file has the tag **'base'**, attribute **'href'** properly filled.

<br/>

## How to consume the S3 Buckets Proxy Distribution?

To open an application there are two required parameters **application name** and the **component name** and three optional parameters, **version number**, **language** and **file name**.

- If **version number** is missing, the latest version will be retrieved.
- If **language** is missing, the browser's language will be retrieved.
- If **file name** is missing, the default file **index.html**, will be retrieved
- If **file name** is equal to **application.properties**, the config map will be retrieved

<br/>

### API acceptable patterns

`(domain)/(app-name)/(comp-name)/(version-number)/(language)/(file-name.extension)`

??? "Latest Versions"
    - <www.api-domain.com/application-name/component-name>
    - <www.api-domain.com/application-name/component-name/file-name.extension>
    - <www.api-domain.com/application-name/component-name/language>
    - <www.api-domain.com/application-name/component-name/language/file-name.extension>
    - <www.api-domain.com/application-name/component-name/application.properties>

??? "Snapshot Versions"
    - <www.api-domain.com/application-name/component-name/version-number>
    - <www.api-domain.com/application-name/component-name/version-number/file-name.extension>
    - <www.api-domain.com/application-name/component-name/version-number/language>
    - <www.api-domain.com/application-name/component-name/version-number/language/file-name.extension>
    - <www.api-domain.com/application-name/component-name/version-number/application.properties>

<br/>

### Front-End Application Consumption

To consume a front-end application using the **S3 Buckets Proxy Distribution**, the sequence of requests typically follows this flow:

- First, the user sends a request for the main application by specifying the application and component names (and optionally version, language, or file name).

- Once the main application is retrieved, it makes a subsequent request to the API to fetch its configuration map, which contains details about the micro front-ends and their versions.

- Finally, based on the configuration map, the application makes additional requests to retrieve the required micro front-end components, required by application.

<br/>

![Front-end consumption sequence diagram](../images/cloudfront-front-end-consumption-sequence-diagram.png)

<br/>

The **S3 Buckets Proxy Distribution** provides several features to simplify the consumption of front-end applications:

1. **Auto-Find `index.html`**  
   When a front-end application is requested, the API automatically resolves the `index.html` file if no specific file is provided in the request.

2. **Auto-Find Default Language**  
   The API can automatically determine and serve the default language for the requested application.

3. **Retrieve Specific Versions**  
   Users can request specific versions of a front-end application by specifying the version in the request.

4. **Config-Map Requests**  
   Front-end applications can request configuration maps to retrieve settings and configurations dynamically.

<br/>

### Consuming Configuration Maps

Configuration maps allow front-end applications to separate their deployment logic from their configuration. These maps can be retrieved via the API to dynamically adjust application behavior without redeploying the application itself.

The **Config map file** can contains the list of all micro front-ends and his versions, required to run a front-end application.

#### Config Map file example

```BASH
# Please, fill the variables with the correct values for pro environment
# i.e:
# env.variable=value
applicationName=rost
componentName=rost-app-shell
version=1.0.0
domain=https://myapp.corp.br
microFrontEnd={ "list": [ { "component": "angular-bucket-mfe-01", "version": "latest", "localUrl": "http://localhost:1001" }, { "component": "angular-bucket-mfe-02", "version": "2.22.222", "localUrl": "http://localhost:1002" } ] }
```

#### How front-end application request config-map?

- request to get the latest configuration:

  `www.api-domain.com/application-name/component-name/application.properties`

- request to get a specific version:

  `www.api-domain.com/application-name/component-name/version-number/application.properties`

The API will retrieve the config map of your application's environment.

<br/>
