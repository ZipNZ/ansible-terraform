# Ansible + Terraform

This repository contains the dockerfile to create an image with [Terraform](https://www.pulumi.com/) and [Ansible](https://www.ansible.com/overview/it-automation) installed

The main use for this is to ready-bake the installation to be used by a gitlab runner.

Currently, this image is hosted on [Dockerhub](https://hub.docker.com/repository/docker/njlnick/ansible-terraform)

## Prerequisites

* [Docker](https://docs.docker.com/get-docker/)

## How to build image

```bash
docker build . --build-arg "TERRAFORM_VERSION=0.14.3" -t zipnz/ansible-terraform:0.14.3
docker build . --build-arg "TERRAFORM_VERSION=0.13.4" -t zipnz/ansible-terraform:0.13.4
```
