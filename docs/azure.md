# Experimenting with Azure

The terraform configuration used herein is targetting Microsoft azure. You can create a [free aws account here](https://azure.microsoft.com/en-us/free/).

**Please be aware** that by running the terraform configuration on a non-free account will result costs.

In order for the setup to work you need to provide valid credentials to the container in the form of environment variables. Please follow the [Azure Provider: Authenticating using a Service Principal with a Client Secret](https://www.terraform.io/docs/providers/azurerm/guides/service_principal_client_secret.html) guide in order to obtain the values.

## Deploying the System

```sh
# Use the following two commands to store AWS secrets in environment variables
# without showing them to others watching your screen
echo -n "Azure client id: " && read -s ARM_CLIENT_ID && echo
echo -n "Azure client secret: " && read -s ARM_CLIENT_SECRET && echo
echo -n "Azure subscription id: " && read -s ARM_SUBSCRIPTION_ID && echo
echo -n "Azure tenant id: " && read -s ARM_TENANT_ID && echo

export ARM_CLIENT_ID
export ARM_CLIENT_SECRET
export ARM_SUBSCRIPTION_ID
export ARM_TENANT_ID

# Run the container
docker run -it \
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
terraform plan -var client_id="$ARM_CLIENT_ID" -var client_secret="$ARM_CLIENT_SECRET" --out localplan

# ... if you like the changes, then apply them
terraform apply localplan

# ... check the results on the azure portal:
# https://portal.azure.com/#home
# ... and using terraform
terraform show
```

A kubernetes cluster is created by terraform apply. The [kubernetes web ui (dashboard)](https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/) is enabled. To connect, you need to have the azure cli and
kubectl on your local machine. I have not found out how to run it from a docker
container yet.

To install the azure cli locally, follow the steps described in the [Install Azure CLI](https://docs.microsoft.com/de-de/cli/azure/install-azure-cli?view=azure-cli-latest) manual. Then install the kubernetes commands:

```sh
az aks install-cli
```

Finally you can run the kubernetes proxy as follows:

```sh
az login

# Get the credentials for your cluster
az aks get-credentials --resource-group thanosrg --name thanosk8s

# Forward the dashboard to http://localhost:8001
az aks browse --resource-group thanosrg --name thanosk8s
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

* Microsoft: [Install Azure CLI](https://docs.microsoft.com/de-de/cli/azure/install-azure-cli?view=azure-cli-latest), last visited on Jan. 16, 2020.

* Kubernetes: [Web UI (Dashboard)](https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/), last visited on Jan. 16, 2020.
