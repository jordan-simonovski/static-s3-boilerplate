#!/bin/bash

wafenabled='false'
cfntemplate=''
parameterfile=''
stackname=''

while getopts 'ws:' flag; do
    case "${flag}" in
        w) wafenabled='true' ;;
        s) stackname="${OPTARG}" ;;
        *) error "Unexpected option ${flag}" ;;
    esac
done

if [ "$wafenabled" == "true" ]
then
    echo "Deploying Stack with WAF Enabled"
    cfntemplate="templates/waf-cloudformation.yml"
    parameterfile="parameters/waf-parameters.json"
else
    echo "Deploying Stack without WAF Enabled"
    cfntemplate="templates/cloudformation.yml"
    parameterfile="parameters/parameters.json"
fi

aws cloudformation create-stack --stack-name "${stackname}" --template-body "file://${cfntemplate}" --parameters "file://${parameterfile}"