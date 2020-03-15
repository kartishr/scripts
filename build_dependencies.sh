#!/bin/bash

# Build dependencies environment for Python Lambda Layers
# This script performs setup of a build environment for Python Lambda Layers
# Each OS is purposely separated to accomodate for minor variance between releases/OSs

echo PYTHON_VERSION=$3
if cat /etc/*release | grep ^NAME | grep Alpine ; then
    echo "==============================================="
    echo "Installing packages on Alpine"
    echo "$(cat /etc/*release | grep ^NAME)"
    echo "$(cat /etc/*release | grep ^VERSION)"
    echo "==============================================="
    apk update
    apk add --no-cache --update \
      git \
      bash \
      libffi-dev \
      openssl-dev \
      bzip2-dev \
      zlib-dev \
      readline-dev \
      sqlite-dev \
      build-base \
      zip \
      linux-headers
    # Set Python version
    export PYENV_VERSION="${PYTHON_VERSION}-dev" # 3.7-dev
    # Set pyenv home
    export PYENV_HOME=/root/.pyenv
    # Install pyenv, then install python versions
    git clone --depth 1 https://github.com/pyenv/pyenv.git $PYENV_HOME
    rm -rfv $PYENV_HOME/.git
    # Update PATH
    export PATH=$PYENV_HOME/shims:$PYENV_HOME/bin:$PATH
    # Install Python
    pyenv install $PYENV_VERSION
    pyenv global $PYENV_VERSION
    # Upgrade pip
    pip install --upgrade pip
    pyenv rehash
    echo "Python version: $(python --version)"
    # Setup tools
    pip install awscli virtualenv --upgrade

elif cat /etc/*release | grep ^NAME | grep Debian ; then
    echo "==============================================="
    echo "Installing packages on Debian"
    echo "==============================================="
    sudo apt-get -y update
    # sudo apt-get -y upgrade
    sudo apt-get install -y awscli
    sudo apt-get install -y build-essential
    sudo apt-get install -y python$PYTHON_VERSION
    alias python=python$PYTHON_VERSION
    sudo apt-get install -y python$PYTHON_VERSION-dev python3-pip
    # pip3 install awscli --upgrade
    pip3 install virtualenv
    sudo apt-get install -y zlib1g-dev
    sudo apt-get install -y zip

elif cat /etc/*release | grep ^NAME | grep Ubuntu; then
    echo "==============================================="
    echo "Installing packages on Ubuntu"
    echo "==============================================="
    sudo apt-get -y update
    # sudo apt-get -y upgrade
    sudo apt-get install -y awscli
    sudo apt-get install -y build-essential
    sudo apt-get install -y python$PYTHON_VERSION
    alias python=python$PYTHON_VERSION
    sudo apt-get install -y python$PYTHON_VERSION-dev python3-pip
    # pip3 install awscli --upgrade
    pip3 install virtualenv
    sudo apt-get install -y zlib1g-dev
    sudo apt-get install -y zip

elif cat /etc/*release | grep ^NAME | grep Mint ; then
    echo "============================================="
    echo "Installing packages on Mint"
    echo "============================================="
    sudo apt-get -y update
    # sudo apt-get -y upgrade
    sudo apt-get install -y awscli
    sudo apt-get install -y build-essential
    sudo apt-get install -y python$PYTHON_VERSION
    alias python=python$PYTHON_VERSION
    sudo apt-get install -y python$PYTHON_VERSION-dev python3-pip
    # pip3 install awscli --upgrade
    pip3 install virtualenv
    sudo apt-get install -y zlib1g-dev
    sudo apt-get install -y zip

elif cat /etc/*release | grep ^NAME | grep Knoppix ; then
    echo "================================================="
    echo "Installing packages on Kanoppix"
    echo "================================================="
    sudo apt-get -y update
    # sudo apt-get -y upgrade
    sudo apt-get install -y awscli
    sudo apt-get install -y build-essential
    sudo apt-get install -y python$PYTHON_VERSION
    alias python=python$PYTHON_VERSION
    sudo apt-get install -y python$PYTHON_VERSION-dev python3-pip
    # pip3 install awscli --upgrade
    pip3 install virtualenv
    sudo apt-get install -y zlib1g-dev
    sudo apt-get install -y zip

elif cat /etc/*release | grep ^NAME | grep CentOS; then
    echo "==============================================="
    echo "Installing packages on CentOS"
    echo "==============================================="
    sudo yum -y update
    # sudo yum -y upgrade
    sudo yum install -y aws-cli
    sudo yum install -y gcc 
    sudo yum install -y gcc-c++
    sudo yum install -y python$PYTHON_VERSION
    alias python=python$PYTHON_VERSION
    sudo yum install -y python$PYTHON_VERSION-devel
    # pip3 install awscli --upgrade
    pip3 install virtualenv
    sudo yum install -y zlib-devel
    sudo yum install zip

elif cat /etc/*release | grep ^NAME | grep Red; then
    echo "==============================================="
    echo "Installing packages on RedHat"
    echo "==============================================="
    sudo yum -y update
    # sudo yum -y upgrade
    sudo yum install -y aws-cli
    sudo yum install -y gcc 
    sudo yum install -y gcc-c++
    sudo yum install -y python$PYTHON_VERSION
    alias python=python$PYTHON_VERSION
    sudo yum install -y python$PYTHON_VERSION-devel
    # pip3 install awscli --upgrade
    pip3 install virtualenv
    sudo yum install -y zlib-devel
    sudo yum install zip

elif cat /etc/*release | grep ^NAME | grep Fedora; then
    echo "================================================"
    echo "Installing packages on Fedorea"
    echo "================================================"
    sudo yum -y update
    # sudo yum -y upgrade
    sudo yum install -y aws-cli
    sudo yum install -y gcc 
    sudo yum install -y gcc-c++
    sudo yum install -y python$PYTHON_VERSION
    alias python=python$PYTHON_VERSION
    sudo yum install -y python$PYTHON_VERSION-devel
    # pip3 install awscli --upgrade
    pip3 install virtualenv
    sudo yum install -y zlib-devel
    sudo yum install zip

elif cat /etc/*release | grep ^NAME | grep Amazon; then
    echo "==============================================="
    echo "Installing packages on Amazon Linux"
    echo "==============================================="
    sudo yum -y update
    # sudo yum -y upgrade
    sudo yum install -y aws-cli
    sudo yum install -y gcc 
    sudo yum install -y gcc-c++
    sudo yum install -y python$PYTHON_VERSION
    alias python=python$PYTHON_VERSION
    sudo yum install -y python$PYTHON_VERSION-devel
    # pip3 install awscli --upgrade
    pip3 install virtualenv
    sudo yum install -y zlib-devel
    sudo yum install zip

else
    echo "==============================================="
    echo "OS NOT DETECTED, couldn't setup environment"
    echo "==============================================="
    exit 1;
fi

exit 0
