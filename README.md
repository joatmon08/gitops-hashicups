# Demo: GitOps on Kubernetes with Consul, Vault & Terraform

## Prerequisites

- Create three Terraform workspaces.
  - `infrastructure`
     - Add HCP credentials to this workspace.
  - `database`
  - `vault`

- Add AWS credentials to all three workspaces.

## Usage

### Create infrastructure

Go to the `infrastructure/terraform` directory.

```shell
cd infrastructure/terraform
```

Set up Terraform with AWS and HCP credentials.

Initialize Terraform.

```shell
terraform init
```

Deploy changes.

```shell
terraform apply
```

### Change Consul's service mesh certificate to use Vault CA

Go to the `infrastructure` directory.

```shell
cd infrastructure
```

Run script to create a Vault policy, token, and rotate
certificate in Consul.

```shell
bash setup_vault_ca.sh
```

### Set up Consul API Gateway

Deploy the API Gateway for Consul to allow
ingress.

```shell
kubectl apply -f api-gateway/
```

**Note** In this example, the API Gateway is using a HTTP listener. The Gateway also supports TCP, TCP+TLS and HTTPS listeners, if you would like to use the HTTPS listener you need to do the following:

* [Generate a TLS Certificate using Vault](https://learn.hashicorp.com/tutorials/vault/kubernetes-cert-manager?in=vault/kubernetes) or another external certificate authority. 
* Change the API Gateway service configuration to the following:
```
apiVersion: gateway.networking.k8s.io/v1alpha2
kind: Gateway
metadata:
  name: <your-gateway-name>
spec:
  gatewayClassName: consul-api-gateway
  listeners:
  - protocol: HTTPS
    port: 443
    name: https
    allowedRoutes:
      namespaces:
        from: Same
    tls:
      certificateRefs:
        - name: <insert-name-of-TLS-k8s-secret>
```

### Create database

Go to the `database/terraform` directory.

```shell
cd database/terraform/
```

Set up Terraform with AWS credentials.

Initialize Terraform.

```shell
terraform init
```

Deploy changes.

```shell
terraform apply
```

### Set up data and Consul ACLs

Go into the `database` folder.

```shell
cd database/
```

Load data into the PostgreSQL database and add an additional policy to the
Consul ACL token for the database.

```shell
bash setup.sh
```

### Configure Vault secrets engines

Go into the `vault/terraform` folder.

```shell
cd vault/terraform
```

Initialize Terraform.

```shell
terraform init
```

Deploy changes.

```shell
terraform apply
```

## GitOps

### Flux

Set a GitHub Personal Access token.

```shell
export GITHUB_TOKEN=<personal access token>
```

Set up Flux and deploy the source and Kustomization for HashiCups.

```shell
bash flux/setup.sh
```

## Clean up

Remove Flux first, revoke Vault leases, and patch finalizers
on the API gateway.

```shell
bash clean.sh
```
