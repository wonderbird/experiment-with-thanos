# Experiment with Thanos

Experimenting with thanos, multiple prometheus clusters, terraform and related stuff.

This project shows how to run a thanos cluster, connect it to two prometheus clusters and visualize metrics in grafana. To achieve this goal, a common blob storage is created in azure using terraform.

The software in this project is highly experimental. Its only purpose is for me to learn about the setup described.

## Status

In this repository I have
- a Dockerfile to create a container with aws cli, azure cli, terraform and helm installed.
- an example terraform configuration to create a EC2 container in AWS (directory `aws`)
- an example terraform configuration provisioning an Azure Kubernetes Cluster (directory `azure`)

Unfortuntely I am hanging at the point where I `helm install` the prometheus-operator (see [Monitoring Kubernetes workloads with Prometheus and Thanos](https://itnext.io/monitoring-kubernetes-workloads-with-prometheus-and-thanos-4ddb394b32c)). The next steps are described in the subsection "next steps" of [docs/azure.md](docs/azure.md).

I have put this repo aside for now.

## Open Issues / Code Smells

* The terraform script(s) for setting up azure include(s) a "local-exec" provisioner. This is not recommended by the terraform guides.
* The azure storage account key is stored on the local disk in file `local-thanos-storage-config.yaml`.
* The field "resource_group_name" is deprecated in the azure terraform provider.

## Prerequisites

This repository assumes that you have [docker](https://www.docker.com/) installed. The folder terraform-aws-cli provides a container bundling terraform and the aws cli to execute the terraform infrastructure as code.

## Getting Started

To get a docker image containing terraform, the aws cli and the azure cli, build the docker image `thanos-build-env`:

```sh
docker build -t thanos-build-env thanos-build-env
```

Then perform the steps in the following subsections:

* ... on [amazon aws](docs/aws.md)
* ... on [azure](docs/azure.md)

## References

* Idan Levin: [Monitoring Kubernetes workloads with Prometheus and Thanos](https://itnext.io/monitoring-kubernetes-workloads-with-prometheus-and-thanos-4ddb394b32c), ITNEXT, last visited on Jan. 11, 2020.

* Gruntwork.io: [DRY and maintainable Terraform code](https://terragrunt.gruntwork.io/), last visited on Jan. 15, 2020.