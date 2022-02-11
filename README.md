# Minecraft server on OCI

This repository contains a set of Terraform and Ansible code to deploy a Minecraft server (also with mods) Java edition on OCI free tier.

The server will be available on the internet but hidden with [Knock](http://www.zeroflux.org/projects/knock).

## Setup

In order to get this project to work fill the missing values in envrc.example and export the variables to the environment.

You can use [direnv](https://github.com/direnv/direnv) as an alternative and copy envrc.example to .envrc.



This project make use of OCI CLI, Ansible and Terraform, be sure that ansible-playbook and terraform command are in you PATH.

### Select ports knock

Env configuration file contains two block with Knock configuration, for example:

```shell
export TF_VAR_ssh_knock='[{"port": 1025, "protocol": "udp"}, {"port": 1026, "protocol": "udp"}, {"port": 1027, "protocol": "udp"}]'
```

Define the ports that need to be called on sequence with knock utility in order to open SSH port from your IP on the server firewall.

## Running

First of all login to OCI with the following command:

```shell
$ oci session authenticate --profile-name $OCI_CLI_PROFILE
```

The account must have permissions to create instances, policies and buckets.

After logging to OCI run Terrafom to create the infrastructure and provision the istance with Terraform:

```shell
$ terraform apply
```
