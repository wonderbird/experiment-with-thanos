# Experimenting with Azure

The terraform configuration used herein is targetting Microsoft azure. You can create a [free aws account here](https://azure.microsoft.com/en-us/free/).

**Please be aware** that by running the terraform configuration on a non-free account will result costs.

In order for the setup to work you need to provide valid credentials to the container in the form of environment variables. Please follow the [Azure Provider: Authenticating using a Service Principal with a Client Secret](https://www.terraform.io/docs/providers/azurerm/guides/service_principal_client_secret.html) guide in order to obtain the values.

## Deploying the System

```sh
# Use the following two commands to store AWS secrets in environment variables
# without showing them to others watching your screen
echo -n "Azure client id: " && read -s ARM_CLIENT_ID && echo
echo -n "Azure tenant id: " && read -s ARM_TENANT_ID && echo
echo -n "Azure client secret: " && read -s ARM_CLIENT_SECRET && echo
echo -n "Azure subscription id: " && read -s ARM_SUBSCRIPTION_ID && echo

export ARM_CLIENT_ID
export ARM_CLIENT_SECRET
export ARM_SUBSCRIPTION_ID
export ARM_TENANT_ID

# Run the container
docker run -p 8001:8001 -it \
           -e "ARM_CLIENT_ID=$ARM_CLIENT_ID" \
           -e "ARM_SUBSCRIPTION_ID=$ARM_SUBSCRIPTION_ID" \
           -e "ARM_TENANT_ID=$ARM_TENANT_ID" \
           -e "ARM_CLIENT_SECRET=$ARM_CLIENT_SECRET" \
           -v /Users/stefan/src/experiment-with-thanos/azure:/root/work \
           --entrypoint /bin/bash terraform-aws-azure-cli

# Inside the container
cd /root/work

# ... if this is the first time you run terraform, initialize terraform. Do this only, if you don't have a terraform.tfstate file in the current directory.
terraform init

# ... check the planned changes
terraform plan

# ... if you like the changes, then apply them
terraform apply -var client_id="$ARM_CLIENT_ID" -var client_secret="$ARM_CLIENT_SECRET"

# ... check the results on the azure portal:
# https://portal.azure.com/#home
# ... and using terraform
terraform show
```

A kubernetes cluster is created by terraform apply. To inspect the cluster perform these steps in the terraform-aws-azure-cli docker container:

```sh
# If you are connecting to a running terraform environment without having called
# terraform apply before, you have to log into azure
az login --service-principal --tenant $ARM_TENANT_ID -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET

# Get credentials for kubernetes
az aks get-credentials --resource-group thanosrg --name thanosk8s

# If the dashboard is not installed in your kubernetes cluster yet (i.e. if you
# are trying to connect to the dashboard for the first time after having applied
# the terraform configuration), install the dashboard into the cluster
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-beta8/aio/deploy/recommended.yaml

# Forward the dashboard to http://localhost:8001
kubectl proxy
```

Then you can view the dashboard in your browser at http://localhost:8001/

## Unprovisioning (Deleting) the System

```sh
# ... once you are done, destroy the infrastructure
terraform destroy
```

## References

* HashiCorp: [Learn about provisioning infrastructure with HashiCorp Terraform](https://learn.hashicorp.com/terraform), last visited on Jan. 12, 2020.

* Microsoft: [Azure Portal](https://portal.azure.com/?quickstart=true#blade/Microsoft_Azure_Resources/QuickstartCenterBlade), last visited on Jan. 12, 2020.