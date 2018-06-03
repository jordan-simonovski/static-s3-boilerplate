#!/bin/bash

bucketname=''
invalidate=''
distributionid=''

while getopts 'b:id:' flag; do
    case "${flag}" in
        b) bucketname="${OPTARG}" ;;
        i) invalidate='true' ;;
        d) distributionid="${OPTARG}" ;;
        *) error "Unexpected option ${flag}" ;;
    esac
done
aws s3 sync ./dist "s3://${bucketname}"

if [ "$invalidate" == "true" ]
then
    echo "Invalidating Cache"
    echo "${distributionid}"
    aws cloudfront create-invalidation --distribution-id "${distributionid}" --paths "/*"
else
    echo "Not invalidating Cache"
fi

echo "Site Deployment Complete"