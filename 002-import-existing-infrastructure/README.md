# Import existing infrastructure

In this example, we'll create some Azure infrastucture _outside_ of Terraform to simulate a brownfield scenario:

``` bash
# Create a new Azure Resource Group
az group create \
    --name octozen-resource-group \
    --location westus
```

```bash
# Create a new storage account
az storage account create \
    --name octozenstorage \
    --resource-group octozen-resource-group \
    --location westus \
    --sku Standard_RAGRS \
    --kind StorageV2
```

```bash
# Enable static web hosting
az storage blob service-properties update \
    --account-name octozenstorage \
    --static-website \
    --404-document error.html \
    --index-document index.html
```

```bash
# Upload files
az storage blob upload-batch \
    --account-name octozenstorage \
    -s 'site' \
    -d '$web'
```

and then import it into Terraform as follows:

1. Create Terraform configuration. (main.tf)
1. `terraform init`
1. `terraform import`
  * `terraform import azurerm_resource_group.rg /subscriptions/<subscription-id>/resourceGroups/octozen-resource-group`
  * `terraform import azurerm_storage_account.octozenstorage /subscriptions/<subscription-id>/resourceGroups/octozen-resource-group/providers/Microsoft.Storage/storageAccounts/octozenstorage`
1. `terraform plan`
1. `terraform apply`

now you can upload your files as before – this time, to your Terraform-managed infrastructure!

## Resources
* https://docs.microsoft.com/en-us/azure/storage/blobs/storage-blob-static-website-how-to?tabs=azure-cli
* https://learn.hashicorp.com/tutorials/terraform/state-import