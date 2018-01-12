# My Website

Static web content served on [AWS S3](https://aws.amazon.com/s3/) via [terraform](https://www.terraform.io/).


## Requirements

*[Note]** Instructions assume OS X.

I'm using terraform to configure the AWS infrastructure and the AWC CLI client to get static files up to S3. I prefer to use [homebrew](https://brew.sh/) to manage the binaries.

Install the executables with:
```
$ brew install terraform awscli
```

You'll also need to have your [AWS credentials](https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#access-keys-and-secret-access-keys) set for an IAM user with permissions to set up and configure S3/Cloudfrount/etc.

I'm using a dotfile `~/.aws/credentials` with this structure:
```
[default]
aws_access_key_id = SECRET_KEY_ID
aws_secret_access_key = SECRET_ACCESS_KEY
```

## Deployment

To configure the S3 bucket as a static website run:
```
$ cd infrastructure
$ terraform plan
$ terraform apply -auto-approve
```

To push up the static assets including images, javascript and css run:
```
$ aws s3 sync ./static/ s3://onekelvinsmith.com
```

Alternatively run the deployment script:
```
$ ./scripts/deploy.sh
```
