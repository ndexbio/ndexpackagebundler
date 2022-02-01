#!/usr/bin/env bash

yum install -y epel-release git gzip tar java-11-openjdk java-11-openjdk-devel wget httpd lsof

# install miniconda3
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
chmod a+x Miniconda3-latest-Linux-x86_64.sh

./Miniconda3-latest-Linux-x86_64.sh -p /opt/miniconda3 -b
rm -f Miniconda3-latest-Linux-x86_64.sh
export PATH=/opt/miniconda3/bin:$PATH
echo "export PATH=/opt/miniconda3/bin:\${PATH}" >> /etc/profile.d/miniconda.sh

# install rst 2 pdf
pip install rst2pdf

# install maven
pushd /opt
wget https://www-us.apache.org/dist/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz 
tar -zxf apache-maven-3.6.3-bin.tar.gz

# install Node.js source repo
curl --silent --location https://rpm.nodesource.com/setup_12.x | sudo bash -


# install yarn
curl --silent --location https://dl.yarnpkg.com/rpm/yarn.repo | sudo tee /etc/yum.repos.d/yarn.repo
yum install -y yarn


echo "export JAVA_HOME=/etc/alternatives/java_sdk" > /etc/profile.d/maven.sh
echo "export M2_HOME=/opt/apache-maven-3.6.3" >> /etc/profile.d/maven.sh
echo "export MAVEN_HOME=/opt/apache-maven-3.6.3" >> /etc/profile.d/maven.sh
echo "export PATH=\${M2_HOME}/bin:\${PATH}" >> /etc/profile.d/maven.sh
source /etc/profile.d/maven.sh


echo "Welcome to a test server"
