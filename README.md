# Ansible + Terraform

This repository contains the dockerfile to create an image with [Terraform](https://www.pulumi.com/) and [Ansible](https://www.ansible.com/overview/it-automation) installed

The main use for this is to ready-bake the installation to be used by a gitlab runner.

Currently, this image is hosted on [Dockerhub](https://hub.docker.com/repository/docker/zipnz/ansible-terraform)

## Prerequisites

* [Docker](https://docs.docker.com/get-docker/)

---

## How to build image

```bash
docker build \
  --build-arg TERRAFORM_VERSION=1.11.4 \
  --build-arg ANSIBLE_VERSION=2.18.7 \
  -t ansible-control .
```

---

### Run the Container

Start the container with volume mount to access playbooks:

```bash
# Run from the ansible directory
docker run --rm -it \
  -v $(pwd):/ansible \
  -w /ansible \
  ansible-control \
  bash
```