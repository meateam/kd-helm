# Helm Charts

## Service Addition Guide

In order to add a new service to the helm chart follow the steps:

- Copy one of the services folders and change it's name.
  `cp api-gateway <new service name>`

- in `<new service name>\Chart.yaml`
  - Change `name` to be the name of the service.
  - Change version to the version of the service you deploy.

- in `<new service name>\values.yaml`
  - Change `tag`, `nameOverride`, `fullnameOverride` with the new correct values.
  - Change `port` to be the external(cluster-scoped) binded port and the `targetPort` to be the internal binded port (preferd to be identical, if the service is exposed prefer port 80, otherwise use 8080).
  - If the service is not exposed to the internet(outside of the cluster) change:
    ``` 
    ingress:
      enabled: true
    ```
    To be:
    ``` 
    ingress:
      enabled: false
    ```
    and remove `<new service name>\templates\ingress.yaml` by running the following command: `rm <new service name>\templates\ingress.yaml`
  - If it is exposed to the internet(outside of the cluster)
    make sure that ingress is enabled as seen above.

- In `helm-chart\requirements.yaml`
  - Add: 
    ```
    - name: <new service name>
      version: <new service version>
      repository: file://../<new service name>
    ```
**Make sure everything is Indented correctly!**

## Deploy To Kubernetes
  ### After editing the chart, run the following commands:
  - To Initialize Helm run: `helm init --client-only`
  - `./helm-dep-up-umbrella.sh helm-chart/` in the main repo directory.
  - If you are updating the environment or want to deploy your environment with the same deployment name you need to delete your deployment first.
  
    use: 
    ```
    helm del --purge <deployment name>
    ``` 
  - ```
    helm install <chart to deploy> --name <deployment name> --namespace <wanted namespace> --set global.ingress.hosts[0]=<wanted namespace>.northeurope.cloudapp.azure.com
    ```
    In order to deploy all of the services, use `helm-chart` as the chart to deploy.
  
  -  In order to see your deployment status use:
      ```
      helm status <deployment name>
      ```
  ### Update ConfigMap:
  - Delete ConfigMap:
    ```
    kubectl delete configmap kd.config --namespace <wanted namespace>
    ```
  - Recreate your ConfigMap:
    ```
    kubectl create configmap --from-env-file=<location of the env file> kd.config --namespace <wanted namespace>
    ```
  - Restart your deployment:
    ```
    helm upgrade <deployment name> helm-chart --recreate-pods --namespace <wanted namespace>
    ```
