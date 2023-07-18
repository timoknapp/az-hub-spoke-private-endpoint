# Azure Hub & Spoke using Private Endpoints

Proof of concept for a Hub &amp; Spoke topology using private endpoints on Azure

![alt text](https://learn.microsoft.com/en-us/training/wwl-azure/design-implement-private-access-to-azure-services/media/hub-spoke-azure-dns-0b3715ed.png)

## Prerequisites

- Azure Subscription
- Azure CLI (or Terraform, tbd)

## Deployment with Bicep

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
LOCATION_HUB=westeurope
LOCATION_SPOKE1=westeurope
LOCATION_SPOKE2=northeurope
RG_NAME=rg-hub-spoke

az group create --name $RG_NAME --location $LOCATION_HUB

# Deploy infrastructure
az deployment group create \
  -g $RG_NAME \
  -n hub-spoke \
  --template-file main.bicep \
  --parameters parameters.json
```

## Deployment with Terraform

tbd