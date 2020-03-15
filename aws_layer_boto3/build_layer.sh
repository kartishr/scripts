#!/bin/bash

# Set Variables
layername=$1
workingdir=$2
pythonversion=$3
loadingbucketname=$4
region=$5

# Setup environment
cd /tmp
rm -Rf /tmp/envs/$layername
rm -Rf /tmp/lambdapack
mkdir envs
chmod 777 envs
mkdir -p /tmp/lambdapack/python/lib/python$pythonversion/site-packages
find /tmp/lambdapack -type d -exec chmod 777 {} \;
cd /tmp/envs
python3 -m virtualenv $layername
source $layername/bin/activate

# Install required packages
pip3 install boto3 -U
# Copy 
cd /tmp/lambdapack/python/lib/python$pythonversion/site-packages
cp -R /tmp/envs/$layername/lib/python$pythonversion/site-packages/* .
# cp -R /tmp/envs/$layername/lib64/python$pythonversion/site-packages/* .
find /tmp/lambdapack -type f -exec chmod 777 {} \;

# cleaning
find . -type d -name "tests" -exec rm -rf {} +
# find -name "*.so" | xargs strip
# find -name "*.so.*" | xargs strip
rm -r pip
rm -r pip-*
rm -r wheel
rm -r wheel-*
rm easy_install.py
find . -name __pycache__ -type d -exec rm -rf {} \;
find . -name "*.dist-info" -type d -exec rm -rf {} \;
find . -name \*.pyc -delete
echo "stripped size $(du -sh /tmp/lambdapack | cut -f1)"

# compressing
ls
echo $workingdir
zip -r $workingdir/layer_packages/$layername.zip /tmp/lambdapack/*
echo "compressed size $(du -sh $workingdir/layer_packages/$layername.zip | cut -f1)"

# publish layer version
# cd $workingdir/layer_packages
# aws lambda publish-layer-version --layer-name spacy --zip-file fileb://layerpack.zip --compatible-runtimes python3.7 --region eu-west-1
# aws s3 cp $layername.zip s3://$loadingbucketname
# aws lambda publish-layer-version --layer-n S3Bucket=$loadingbuckeame $layername --content S3Bucket=$loadingbucketname,S3Key=$layername.zip --compatible-runtimes python$pythonversion --region $region

# cleanup
deactivate
rm -Rf /tmp/envs/$layername
