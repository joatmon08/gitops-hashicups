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
