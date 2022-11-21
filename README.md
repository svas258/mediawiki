# To setup AKS cluster with Azurecli and terraform

## Azure cli steps 
az login

az account list

Using service principal
export SUBSCRIPTION_ID=<your azure subscription id>
az ad sp create-for-rbac --role=“Contributor”.”Owner" --scopes="/subscriptions/$SUBSCRIPTION_ID”
get the 
    client_id,client_secret,tenant_id,subscription_id and pass the values to terraform.tfvars file.

## create cluster with terraform 
   go to the mediawiki/Azure the cluster and nginx/ingress controller will be setup.
    
   update the terraform.tfvars files with required values
   
    terrafrom init <to download the azurerm providers>
   
    terrafrom plan <verify the output and procced to apply>
   
    terraform apply <give yes to  resource clearting>

## Mediawiki applicaiton deployment 
  
   the kubernets manifest files should be applied under challenge2 path to deploy the DB and Mediawiki app
   applicate url : http://20.241.217.119/index.php/Main_Page
   
## CI/CD plan: In-progress

       Applicaiton & DB yaml's can be defined in helmcharts to define better CI/CD plan. 
       
       Tools are in concidration : Arogcd/Gitlabs/AzureDevops
   
            
