# AWS Managed Services

!!! warning "Important"
    As a **Reference Architecture**, this documentation provides **general patterns and recommendations** that should be tailored and customized to meet the specific requirements of each use case.

Amazon Web Services offers many possibilities in order to deploy and consume web applications.
AWS offers different reference architectures and multiple components that can be used to achieve this.

<div class="cards row-2" markdown>

- ### Reference Architecture

    ----

    The Gluon Architecture Team has developed a **Reference Architecture** that complies with the group's security guidelines and is aligned with the needs of the different frameworks/architectures offered by Gluon.

    In this section, you can review this **Reference Architecture** and the configuration recommendations for several managed services involved in it.

    [Reference Architecture](reference-architecture.md)

- ### S3 Buckets | Storage

    ----

    Amazon Simple Storage Service (Amazon S3) is an object storage service offering scalability, data availability, security, and performance.
    It allow to store, manage, analyze, and protect any amount of data for virtually any use case, such as data lakes, cloud-native applications, and web or mobile apps.

    **Gluon workflows** will be able to **deploy static files from an application to an S3 Bucket** (be it an SPA or a Micro Front-End), following the recommendations of the reference architecture. You can find more details in the next sections.

    [Overview](./s3-bucket.md)

    [Reference Architecture](./reference-architecture.md#bucket-naming-convention)

</div>

<div class="cards row-2" markdown>

- ### API Gateway | Exposure

    ----

    Amazon API Gateway is a fully managed service that makes it easy for developers to create, publish, maintain, monitor, and secure APIs at any scale.
    APIs act as the "front door" for applications to access data, business logic, or functionality from your backend services.

    **We will implement a REST API for a specific functional domain**, providing resources and methods that will serve as a proxy for its microfrontend component.
    The API Gateway will be used to **route requests to the designated S3 bucket** according to the URL path.

    Amazon API Gateway should be used for **Intranet** and/or **Internet** applications.

    [Overview](./api-gateway/index.md)

- ### Cloudfront | Exposure

    ----

    Amazon CloudFront is a web service that speeds up distribution of your static and dynamic web content, such as .html, .css, .js, and image files, to your users.
    CloudFront delivers your content through a worldwide network of data centers called edge locations.

    When a user requests content that you're serving with CloudFront, the request is routed to the edge location that provides the lowest latency (time delay), so that content is delivered with the best possible performance.

    The **cloudfront Security policy is in progress**: AWS S3 Cloudfront exposure
    [SP-010](https://santandernet.sharepoint.com/:w:/r/sites/SantanderPlatforms/_layouts/15/Doc.aspx?sourcedoc=%7BAD4CE9D6-234B-4ACC-90F9-D9C9F2BE9B92%7D&file=SP-010%20-%20AWS%20S3%20Cloudfront%20exposure.docx&action=default&mobileredirect=true)
    so **it shouldn't be used yet**.

    Once this policy is approved, the Cloudfront CDN will be used to cache and serve the static assets of **Internet**-facing applications.

    [Overview](./cloudfront/index.md)

</div>
