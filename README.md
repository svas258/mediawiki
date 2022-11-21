#To setup AKS cluster with Azurecli and terraform

##Azure cli steps 
az login

az account list

Using service principal
export SUBSCRIPTION_ID=<your azure subscription id>
az ad sp create-for-rbac --role=“Contributor”.”Owner" --scopes="/subscriptions/$SUBSCRIPTION_ID”
get the 
    client_id,client_secret,tenant_id,subscription_id and pass the values to terraform.tfvars file.

## create cluster with terraform 
   got the mediawiki/Azure
   update the terraform.tfvars files with required values
   terrafrom init <to download the azurerm providers>
   terrafrom plan <verify the output and procced to apply>
   terraform apply <give yes to  resource clearting>
