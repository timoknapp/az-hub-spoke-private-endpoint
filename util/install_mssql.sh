#!/bin/bash
sudo dpkg --configure -a
sudo curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
sudo curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list > /etc/apt/sources.list.d/mssql-release.list
sudo apt-get -y update

# install MSSQL Tools
sudo apt-get -y install mssql-tools18
# unixodbc-dev

# add MSSQL Tools to PATH
echo 'export PATH="$PATH:/opt/mssql-tools18/bin"' >> ~/.bashrc
source ~/.bashrc