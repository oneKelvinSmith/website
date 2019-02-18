# My Website

Static web content served on [AWS S3](https://aws.amazon.com/s3/) via [terraform](https://www.terraform.io/).

## Requirements

**[Note]** Instructions assume OS X.

I'm using terraform to configure the AWS infrastructure and the AWC CLI client to get static files up to S3. I prefer to use [homebrew](https://brew.sh/) to manage the binaries.

Install the executables with:

```bash
$ brew install terraform awscli
```

You'll also need to have your [AWS credentials](https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#access-keys-and-secret-access-keys) set for an IAM user with permissions to set up and configure S3/Cloudfrount/etc.

I'm using a dotfile `~/.aws/credentials` with this structure:

```conf
[default]
aws_access_key_id = SECRET_KEY_ID
aws_secret_access_key = SECRET_ACCESS_KEY
```

## SSL

In order to serve the site over HTTPS I'm using the [AWS Certificate Manager](https://console.aws.amazon.com/acm/home?region=us-east-1#/) to provision SSL certs and a [Cloudfront](https://console.aws.amazon.com/cloudfront/home?region=us-east-1) distribution. It's important that the bucket and certificate are build in the `us-east-1` region because the Cloudfront distribution cannot be anywhere else.

## Deployment

If this is the first time in a while, initialise terraform with:

```bash
$ terraform init
```

To configure the S3 bucket as a static website run:

```bash
$ cd infrastructure
$ terraform plan
$ terraform apply -auto-approve
```

To push up the static assets including images, javascript and css run:

```bash
$ aws s3 sync ./static/ s3://onekelvinsmith.com
```

Alternatively run the deployment script:

```bash
$ ./scripts/deploy.sh
```
