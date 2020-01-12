# Experiment with Thanos

Experimenting with thanos, multiple prometheus clusters, terraform and related stuff.

This project shows how to run a thanos cluster, connect it to two prometheus clusters and visualize metrics in grafana. To achieve this goal, a common blob storage is created in azure using terraform.

The software in this project is highly experimental. Its only purpose is for me to learn about the setup described.

## Status

The repository has just been created. Nothing is working properly yet. Please come back later. The documentation below is work in progress.

## Prerequisites

This repository assumes that you have [docker](https://www.docker.com/) installed. The folder terraform-aws-cli provides a container bundling terraform and the aws cli to execute the terraform infrastructure as code.

The terraform configuration used herein is targetting amazon aws. You can create a [free aws account here](https://aws.amazon.com/free/).

**Please be aware** that by running the terraform configuration on a non-free account will result costs.

In order for the setup to work you need to provide a valid Access Key ID and Secret Access Key to the container in the form of environment variables. You can obtain these values from [your aws identity management page](https://console.aws.amazon.com/iam/home?region=eu-central-1#/security_credentials).

## Deploying the System

```sh
# Build the terraform-aws-cli docker container
docker build -t terraform-aws-cli terraform-aws-cli
```

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
           -v /Users/stefan/src/experiment-with-thanos:/root/work \
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

* Idan Levin: [Monitoring Kubernetes workloads with Prometheus and Thanos](https://itnext.io/monitoring-kubernetes-workloads-with-prometheus-and-thanos-4ddb394b32c), ITNEXT, last visited on Jan. 11, 2020.

* HashiCorp: [Getting Started: Installing Terraform](https://learn.hashicorp.com/terraform/getting-started/install), last visited on Jan. 11, 2020.

* HashiCorp: [terraform Docker Container](https://hub.docker.com/r/hashicorp/terraform), Docker Hub, last visited on Jan. 11, 2020.

* HashiCorp: [Terraform Configuration Language](https://www.terraform.io/docs/configuration/index.html), last visited on Jan. 11, 2020.

* Canonical: [Amazon EC2 AMI Locator](https://cloud-images.ubuntu.com/locator/ec2/),last visited on Jan. 12, 2020.