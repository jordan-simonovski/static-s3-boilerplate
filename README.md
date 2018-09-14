# Static S3 Boilerplate

## Description

I'm not a fan of making public buckets, and a CDN + WAF setup isn't all too expensive on AWS. So I decided to make a couple of boilerplate templates and corresponding parameter files to get your landing page, or portfolio website, or whatever it is deployed relatively securely.

## How do I deploy my site?

### Prerequisites

1. A Hosted Zone setup in Route 53 (requires buying a domain)
2. A Certificate in ACM us-east-1

Both of those steps are relatively painless to set up in the AWS console.

### Deploy your underlying infrastructure.

1. First you want to determine if you want this publicly accessible to the world or not. Given you're deploying a site to a S3 bucket which doesn't sit in a VPC, if you're setting something up in a testing environment (e.g. staging) and don't want it publicly accessible, you're going to want to use the `waf-cloudformation.yml` which sets up a Web Application Firewall that only allows access to an IP Range.

2. You need to populate your parameter file. If you're setting everything up with a WAF, you're going to want to fill in the variables in the package.json. The variables you need to populate are:
    - AppName
    - HostedZoneName (do not include the full stop at the end of your hosted zone)
    - BucketName (all lowercase characters)
    - SubDomain
    - ACMCertificateARN
    - Environment (optional: defaults to stage if an environment not specified)
    - IPCIDRRange (conditional: only needed when setting up your infra with a WAF)

3. Invoke the setup of your infra with:
```
yarn cfnwaf:staging
OR 
yarn cfn:staging
```
4. Go grab a coffee or some food, or go and watch an episode of one of your favourite TV shows. The initial setup of all resources takes roughly 25min.

5. Once this has all been set up, you're ready to deploy your site. Copy your files to the `dist` directory.

6. Push your files to the bucket with
```
deploy:staging
```

## Cost

You're looking at some relatively cheap hosting costs for your site.

WAF Costs (in USD):
- $5 per web ACL per month
- $1 per rule per web ACL per month
- $0.60 per million web requests

CloudFront Costs:
- 1 GB Data transfer out and out to origin + HTTPS + roughly 100 invalidations === $0.10/month