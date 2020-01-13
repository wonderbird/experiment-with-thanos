# Experimenting with AWS

The terraform configuration used herein is targetting amazon aws. You can create a [free aws account here](https://aws.amazon.com/free/).

**Please be aware** that by running the terraform configuration on a non-free account will result costs.

In order for the setup to work you need to provide a valid Access Key ID and Secret Access Key to the container in the form of environment variables. You can obtain these values from [your aws identity management page](https://console.aws.amazon.com/iam/home?region=eu-central-1#/security_credentials).

## Deploying the System

```sh
# Use the following two commands to store AWS secrets in environment variables
# without showing them to others watching your screen
echo -n "AWS access key id: " && read -s AWS_ACCESS_KEY_ID
echo -n "AWS secret access key: " && read -s AWS_SECRET_ACCESS_KEY

export AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY

# Run the container
docker run -it \
           -e "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID" \
           -e "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" \
           -v /Users/stefan/src/experiment-with-thanos/aws:/root/work \
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

## Interesting Information

* To search ubuntu images for EC2 which can be used on the free aws account, I am using the search string `hvm ebs amd64 eu-central-1` in the [Amazon EC2 AMI Locator](https://cloud-images.ubuntu.com/locator/ec2/).

## References

* HashiCorp: [Learn about provisioning infrastructure with HashiCorp Terraform](https://learn.hashicorp.com/terraform), last visited on Jan. 12, 2020.

* HashiCorp: [terraform Docker Container](https://hub.docker.com/r/hashicorp/terraform), Docker Hub, last visited on Jan. 11, 2020.

* HashiCorp: [Terraform Configuration Language](https://www.terraform.io/docs/configuration/index.html), last visited on Jan. 11, 2020.

* Canonical: [Amazon EC2 AMI Locator](https://cloud-images.ubuntu.com/locator/ec2/), last visited on Jan. 12, 2020.