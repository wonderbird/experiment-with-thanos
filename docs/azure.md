# Experimenting with Azure

The terraform configuration used herein is targetting Microsoft azure. You can create a [free aws account here](https://azure.microsoft.com/en-us/free/).

**Please be aware** that by running the terraform configuration on a non-free account will result costs.

In order for the setup to work you need to provide valid credentials to the container in the form of environment variables. Please follow the [Azure Provider: Authenticating using a Service Principal with a Client Secret](https://www.terraform.io/docs/providers/azurerm/guides/service_principal_client_secret.html) guide in order to obtain the values.

## Deploying the System

```sh
# Use the following two commands to store AWS secrets in environment variables
# without showing them to others watching your screen
echo -n "Azure client id: " && read -s ARM_CLIENT_ID
echo -n "Azure subscription id: " && read -s ARM_SUBSCRIPTION_ID
echo -n "Azure tenant id: " && read -s ARM_TENANT_ID
echo -n "Azure client secret: " && read -s ARM_CLIENT_SECRET

export ARM_CLIENT_ID
export ARM_SUBSCRIPTION_ID
export ARM_TENANT_ID
export ARM_CLIENT_SECRET

# Run the container
docker run -it \
           -e "ARM_CLIENT_ID=$ARM_CLIENT_ID" \
           -e "ARM_SUBSCRIPTION_ID=$ARM_SUBSCRIPTION_ID" \
           -e "ARM_TENANT_ID=$ARM_TENANT_ID" \
           -e "ARM_CLIENT_SECRET=$ARM_CLIENT_SECRET" \
           -v /Users/stefan/src/experiment-with-thanos/azure:/root/work \
           --entrypoint /bin/bash terraform-aws-cli

# Inside the container
cd /root/work

# ... if this is the first time you run terraform, initialize terraform. Do this only, if you don't have a terraform.tfstate file in the current directory.
terraform init

# ... check the planned changes
terraform plan

# ... if you like the changes, then apply them
terraform apply

# ... check the results on the amazon aws console:
# https://eu-central-1.console.aws.amazon.com/ec2/v2/home?region=eu-central-1#Instances:sort=instanceId
# ... and using terraform
terraform show

```

## Unprovisioning (Deleting) the System

```sh
# ... once you are done, destroy the infrastructure
terraform destroy
```

## References

* HashiCorp: [Learn about provisioning infrastructure with HashiCorp Terraform](https://learn.hashicorp.com/terraform), last visited on Jan. 12, 2020.

* Microsoft: [Azure Portal](https://portal.azure.com/?quickstart=true#blade/Microsoft_Azure_Resources/QuickstartCenterBlade), last visited on Jan. 12, 2020.