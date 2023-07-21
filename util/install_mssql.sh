#!/bin/bash
sudo dpkg --configure -a
sudo curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
sudo sh -c 'curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list > /etc/apt/sources.list.d/mssql-release.list'
sudo apt-get -y update

# install MSSQL Tools
sudo ACCEPT_EULA=Y apt-get install -y mssql-tools18 unixodbc-dev

# add MSSQL Tools to PATH
echo 'export PATH="$PATH:/opt/mssql-tools18/bin"' >> /home/azureuser/.bashrc
