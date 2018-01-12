#! /bin/bash -e

cd infrastructure

echo 'Updating infrastucture...'
terraform plan
terraform apply -auto-approve

echo 'Syncing...'
aws s3 sync ../static/ s3://onekelvinsmith.com

echo 'Deployed'
