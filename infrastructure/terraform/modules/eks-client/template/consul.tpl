global:
  enabled: false
  name: consul
  datacenter: ${datacenter}
  acls:
    manageSystemACLs: true
    bootstrapToken:
      secretName: ${cluster_id}-hcp
      secretKey: bootstrapToken
  tls:
    enabled: true
    enableAutoEncrypt: true
    caCert:
      secretName: ${cluster_id}-hcp
      secretKey: caCert
  gossipEncryption:
    secretName: ${cluster_id}-hcp
    secretKey: gossipEncryptionKey

externalServers:
  enabled: true
  hosts: ${consul_hosts}
  httpsPort: 443
  useSystemRoots: true
  k8sAuthMethodHost: ${k8s_api_endpoint}

server:
  enabled: false

client:
  enabled: true
  join: ${consul_hosts}
  nodeMeta:
    terraform-module: "hcp-eks-client"

connectInject:
  enabled: true

controller:
  enabled: true

apiGateway:
  enabled: true
  image: "hashicorp/consul-api-gateway:0.2.0"
  managedGatewayClass:
    serviceType: LoadBalancer
    useHostPorts: true

terminatingGateways:
  enabled: true
  defaults:
    replicas: 1