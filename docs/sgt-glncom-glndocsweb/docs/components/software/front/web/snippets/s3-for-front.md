You have to request the following infrastructure resources.

### S3 Bucket

The workflow will deploy the assets to an S3 Bucket.

This S3 Bucket should be created previously.

You can read more in the [AWS Reference Architecture](../../../../../architecture/reference-architecture/front-web/aws/index.md)

### Cloudfront or AWS API Gateway

The workflow will deploy the static files into an S3 Bucket, but the bucket will not be exposed neither ready to be consumed by a browser.

You'll need a Cloudfront or AWS API Gateway to expose them and several architectural pieces more in order to match the Reference Architecture.

You can read more in the [AWS Reference Architecture](../../../../../architecture/reference-architecture/front-web/aws/index.md)

### How to configure your deployment environment

{!
   include-markdown "../snippets/snippet-oam.md"
   start="<!--Start Infrastructure for S3-->"
   end="<!--End Infrastructure for S3-->"
!}
