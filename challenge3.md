# Container CI/CD using jeknins in AKS

   ![flow, Diagrame](https://github.com/svas258/mediawiki/blob/2be7e54ba467cefac44e53ae6f3b7c61c9469e35/Screenshot%202022-11-22%20at%2012.04.52%20PM.png)



## Dataflow
     ## CI with jenkins: (jenkins can be installed and configured in AKS or VM of the same network or network access provided to AKS vnet. 
        
      1. Change application source code. (here changes are likely to be update new parameters to mediawiki customized image)
      2. Commit code to GitHub.
      3. Continuous Integration Trigger to Jenkins.
      4. Jenkins triggers a build job using Azure Kubernetes Service (AKS) for a dynamic build agent.
      5. Jenkins builds and pushes Docker container to Azure Container Registry.
      
![flow, Diagrame](https://github.com/svas258/mediawiki/blob/c7beecff27555d29f421349b8033ea439864d4b9/Screenshot%202022-11-22%20at%201.14.17%20PM.png)
     ## CD with Argocd:
   
        ArgoCD can be configured in the same cluster or will have no of cluster to be managed by argocd. 
         It can be configured in seprate cluster and it should be provided access to other cluster API's to apply the kubernets resoruces.
         Mediawiki & DB yamls will be genterated from  helm charts to upload the helm template to Azure artifact registry to pick by Argocd and initate the CD process in the cluster. 
      
      1. Update helm value files and commit
      2. Jenkins job will generte the helm template with the updated values and push to Azure artifcate registry.
      3. ArgoCD applications should defined to pick the new changes in the artifcate. Based on the update trigger. ArgoCD will apply the helm chats to the cluster. 
      
      
  # Key points: 
        Mediawiki related configuration details based on differnet environments can be handled using helmfiles to use the value files based on the environment/project. 
        (helm files is utility to handle the multiple charts to samecluster/single chart to different clusters. 
        Image scanner tools can be configued to scan the images which are used in the kubernets cluster. Example Aqua. 
        
        
