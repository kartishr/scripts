#!/bin/bash

current=`pwd`
echo $current
DIR=$(dirname "$0")
export LAYER_NAMES=$1
export WORKING_DIR=$current
export PYTHON_VERSION=$2
export BUCKET_NAME=$3
export REGION=$4

# Check variables
if [ -n "$LAYER_NAMES" ]; then
    echo 'LAYER_NAMES found = ' $LAYER_NAMES
else
    export LAYER_NAMES="zero"
    echo "LAYER_NAMES set = " $LAYER_NAMES
fi

if [ WORKING_DIR != "" ]; then
    echo 'WORKING_DIR found = ' $WORKING_DIR
else
    export WORKING_DIR=$(pwd)
    echo "WORKING_DIR set = " $(pwd)
fi

if [ PYTHON_VERSION != "" ]; then
    echo 'PYTHON_VERSION found = ' $PYTHON_VERSION
else
    export PYTHON_VERSION="3.7"
    echo "PYTHON_VERSION set = " $PYTHON_VERSION
fi

if [ BUCKET_NAME != "" ]; then
    echo 'BUCKET_NAME found = ' $BUCKET_NAME
else
    export BUCKET_NAME="baby-yodas-bucket"
    echo "BUCKET_NAME set = " $BUCKET_NAME
fi

if [ REGION != "" ]; then
    echo 'REGION found = ' $REGION
else
    export REGION="zero"
    echo "REGION set = " $REGION
fi

# Build dependencies environment for Python Lambda Layers
# This script performs setup of a build environment for Python Lambda Layers
$WORKING_DIR/build_dependencies.sh $LAYER_NAMES $WORKING_DIR $PYTHON_VERSION $BUCKET_NAME $REGION

if cat /etc/*release | grep ^NAME | grep Alpine ; then
    echo "==============================================="
    echo "Setting pyenv VARs on Alpine"
    echo "==============================================="
    # Set Python version
    export PYENV_VERSION="${PYTHON_VERSION}-dev" # 3.7-dev
    # Set pyenv home
    export PYENV_HOME=/root/.pyenv
    # Update PATH
    export PATH=$PYENV_HOME/shims:$PYENV_HOME/bin:$PATH
    # Install Python
    pyenv global $PYENV_VERSION
    # Upgrade pip
    pyenv rehash
    echo "==============================================="
    echo "Python version: $(python --version)"
    echo "==============================================="

else
    echo "==============================================="
    echo "Alpine NOT DETECTED, continuing..."
    echo "==============================================="
fi

# Init Packages Directory
mkdir -p layer_packages/

# Build list of layer names from comma separated string
IFS=',' read -ra LAYER_NAMES_LIST <<< "$LAYER_NAMES"

# Building layers
for i in "${LAYER_NAMES_LIST[@]}"
do
    echo "==============================================="
    echo "Building lambda Layer $i"
    echo "==============================================="
    $WORKING_DIR/aws_layer_$i/build_layer.sh $i $WORKING_DIR $PYTHON_VERSION $BUCKET_NAME $REGION
done
