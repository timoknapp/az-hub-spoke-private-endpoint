# Azure Hub & Spoke using Private Endpoints

<p align="left">
    <a href="https://github.com/timoknapp/az-hub-spoke-private-endpoint/actions/workflows/bicep.yml">
        <img alt="Build Bicep" src="https://github.com/timoknapp/az-hub-spoke-private-endpoint/actions/workflows/bicep.yml/badge.svg">
    </a>
    <a href="https://github.com/timoknapp/az-hub-spoke-private-endpoint/actions/workflows/terraform.yml">
        <img alt="Build Terraform" src="https://github.com/timoknapp/az-hub-spoke-private-endpoint/actions/workflows/terraform.yml/badge.svg">
    </a>
</p>

Proof of concept for a Hub &amp; Spoke topology using private endpoints on Azure

![alt text](https://learn.microsoft.com/en-us/training/wwl-azure/design-implement-private-access-to-azure-services/media/hub-spoke-azure-dns-0b3715ed.png)

## To Do

- Add Spoke with Private Link Service and Load Balancer pointing to the VM

## Prerequisites

- Azure Subscription
- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli) (or Terraform, tbd)

## Deployment

### [Bicep](./arm/)

```bash
# Change Directoy
cd arm

# Create parameters.json
cat <<EOF > parameters.json
{
    "vmPassword": { "value": "A$(openssl rand -hex 6)#" },
    "sqlPassword": { "value": "A$(openssl rand -hex 6)#" }
}
EOF

# Create resource group
LOCATION=westeurope
RG_NAME=rg-hub-spoke

az group create --name $RG_NAME --location $LOCATION

# Deploy infrastructure
az deployment group create \
  -g $RG_NAME \
  -n hub-spoke \
  --template-file main.bicep \
  --parameters parameters.json
```

### [Terraform](./terraform/)

```bash
# Change Directoy
cd terraform

# Set passwords in main.tf
sed -i '' "s/<PW_PLACEHOLDER>/A$(openssl rand -hex 6)#/g" main.tf

# Terraform init (only once)
terraform init

# Terraform validate (optional)
terraform validate

# Terraform plan
terraform plan -out main.tfplan

# Terraform apply
terraform apply main.tfplan
```

## Verify Deployment

- Connect to VM in Spoke 1 or 2 via Bastion
    ```bash
    DB_HOST=SQL_SERVER_NAME.database.windows.net
    DB_USER=sqluser
    DB_PASSWORD=INSERT_PASSWORD_HERE
    # Test Connection and print SQL Server Version
    sqlcmd -S tcp:$DB_HOST,1433 -d db -U $DB_USER -P $DB_PASSWORD -Q "SELECT @@VERSION"
    
    # Result should be similar to:
    Microsoft SQL Azure (RTM) - 12.0.2000.8 
    Jul  8 2023 12:00:47 
    Copyright (C) 2022 Microsoft Corporation
    ```
