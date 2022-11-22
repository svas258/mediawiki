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
  
   The kubernets manifest files should be applied under challenge2 path to deploy the DB and Mediawiki app
   applicate url : http://20.241.217.119/index.php/Main_Page
   
## Security & Best practices 
   Azure AD and rolse can created for developers. Based on the roles the Azure api access can be limited. 
   
   If the Namespace itself should be handled by development team, they create multiple namespace under the main namesapce it can be achieved by HNC (https://github.com/kubernetes-sigs/hierarchical-namespaces). 
   
   Each resoruces AKS cluster & storage should be created with customer encription key. The keys can be manged in AZure key valut. (keys can be roated based requirment) 
   
   Opensource Terraform statefile should be maninted in Azure storage with locking state (https://learn.microsoft.com/en-us/azure/developer/terraform/store-state-in-azure-storage?tabs=azure-cli).
   
   Enterprice TF manages the statefile and workespace. We can configure it from console. 
   
   for Producation where there is no need of CD. We can implement with manual CD part here with kub8 manifest yaml's integrating form SCM. 
   
   

       
   
            
