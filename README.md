# RustDok Helm Chart

This Helm chart deploys the RustDok application on a Kubernetes cluster.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+

## Installing the Chart

To install the chart with the release name `my-rustdok`:

```bash
helm install my-rustdok ./k8s/rustdok
```

## Uninstalling the Chart

To uninstall/delete the `my-rustdok` deployment:

```bash
helm delete my-rustdok
```

## Configuration

The following table lists the configurable parameters of the RustDok chart and their default values. All values in the chart are now thoroughly documented with detailed descriptions in the `values.yaml` file.

### Namespace Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `namespace` | Whether to create the namespace where the chart is installed | `""` |

### Server Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `server.name` | Name of the server deployment | `rustdok-server` |
| `server.replicaCount` | Number of server replicas to deploy | `1` |
| `server.image.repository` | Docker image repository for the server | `ghcr.io/devs-in-the-cloud/rustdok-server` |
| `server.image.tag` | Docker image tag for the server | `latest` |
| `server.image.pullPolicy` | Image pull policy for the server container | `IfNotPresent` |
| `server.service.type` | Kubernetes service type for the server | `ClusterIP` |
| `server.service.port` | Port the service will be exposed on | `8080` |
| `server.service.targetPort` | Port the service will target in the pod | `8080` |
| `server.resources` | Resource requests and limits for the server container | See values.yaml |
| `server.podAnnotations` | Annotations to add to the server pods | `{}` |
| `server.nodeSelector` | Node selector for the server pods | `{}` |
| `server.tolerations` | Tolerations for the server pods | `[]` |
| `server.affinity` | Affinity settings for the server pods | `{}` |
| `server.env.extraEnvs` | Additional environment variables to add to the server container | `[]` |

### Storage Configuration

| Parameter | Description | Default | Required |
|-----------|-------------|---------|----------|
| `server.storage.s3.endpointUrl` | S3 endpoint URL (leave empty for AWS S3) | `""` | Yes, if RookCeph is disabled |
| `server.storage.s3.region` | S3 region (required even for S3-compatible storage that doesn't use regions) | `eu-central-1` | Yes, if RookCeph is disabled |
| `server.storage.s3.accessKey` | S3 access key | `""` | Yes, if RookCeph is disabled |
| `server.storage.s3.secretKey` | S3 secret key | `""` | Yes, if RookCeph is disabled |
| `server.storage.rookCeph.enabled` | Whether to enable Rook Ceph storage integration | `false` | No |
| `server.storage.rookCeph.namespace` | The namespace where the CephObjectStoreUser is created | `rook-ceph` | Yes, if RookCeph is enabled |
| `server.storage.rookCeph.s3.objectStoreUser.secretName` | The secret where Ceph keeps the credentials of the object store user | `""` | Yes, if RookCeph is enabled |
| `server.storage.rookCeph.s3.objectStoreUser.copySecret` | Whether to copy the secret to the chart namespace | `false` | No |

### WebUI Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `webui.enabled` | Whether to enable the WebUI component | `true` |
| `webui.name` | Name of the WebUI deployment | `rustdok-webui` |
| `webui.replicaCount` | Number of WebUI replicas to deploy | `1` |
| `webui.image.repository` | Docker image repository for the WebUI | `ghcr.io/devs-in-the-cloud/rustdok-webui` |
| `webui.image.tag` | Docker image tag for the WebUI | `latest` |
| `webui.image.pullPolicy` | Image pull policy for the WebUI container | `Always` |
| `webui.service.type` | Kubernetes service type for the WebUI | `ClusterIP` |
| `webui.service.port` | Port the service will be exposed on | `3000` |
| `webui.service.targetPort` | Port the service will target in the pod | `3000` |
| `webui.resources` | Resource requests and limits for the WebUI container | See values.yaml |
| `webui.podAnnotations` | Annotations to add to the WebUI pods | `{}` |
| `webui.nodeSelector` | Node selector for the WebUI pods | `{}` |
| `webui.tolerations` | Tolerations for the WebUI pods | `[]` |
| `webui.affinity` | Affinity settings for the WebUI pods | `{}` |
| `webui.env.extraEnvs` | Additional environment variables to add to the WebUI container | `[]` |


## Mandatory Values

The chart implements validation for mandatory values. Depending on your configuration, certain values are required:

1. If RookCeph is disabled (default):
   - `server.storage.s3.endpointUrl`
   - `server.storage.s3.region`
   - `server.storage.s3.accessKey`
   - `server.storage.s3.secretKey`

2. If RookCeph is enabled:
   - `server.storage.rookCeph.s3.objectStoreUser.secretName`

## Examples

### Deploying with WebUI disabled

```bash
helm install my-rustdok ./k8s/rustdok --set webui.enabled=false
```

### Using Rook Ceph for storage

```bash
helm install my-rustdok ./k8s/rustdok \
  --set server.storage.rookCeph.enabled=true \
  --set server.storage.rookCeph.s3.objectStoreUser.secretName=ceph-objectstore-user-secret
```

### Using generic S3 storage

```bash
helm install my-rustdok ./k8s/rustdok \
  --set server.storage.s3.endpointUrl=https://s3.example.com \
  --set server.storage.s3.region=eu-central-1\
  --set server.storage.s3.accessKey=myaccesskey \
  --set server.storage.s3.secretKey=mysecretkey
```

## Documentation

The chart's `values.yaml` file now includes comprehensive descriptions for all configuration parameters. These descriptions provide detailed information about:

- What each parameter does
- Expected values or formats
- Dependencies between parameters
- Usage recommendations

This improved documentation makes it easier to understand and configure the chart for your specific needs. 