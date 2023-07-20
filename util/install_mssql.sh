#!/bin/bash
dpkg --configure -a
apt-get -y update

# install MSSQL Tools
apt-get -y install mssql-tools18 unixodbc-dev

# add MSSQL Tools to PATH
echo 'export PATH="$PATH:/opt/mssql-tools18/bin"' >> ~/.bashrc
source ~/.bashrc