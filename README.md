# RustDok Helm Chart

This Helm chart deploys the RustDok application on a Kubernetes cluster.

## Using the Chart Repository

To use this chart repository, add it to your Helm repositories:

```bash
helm repo add rustdok https://stathis-ditc.github.io/rustdok-helm-chart
helm repo update
```

Then you can install the chart with:

```bash
helm install my-rustdok rustdok/rustdok
```

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+

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

### Server Probes Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `server.livenessProbe.initialDelaySeconds` | Number of seconds after the container has started before the probe is initiated | `30` |
| `server.livenessProbe.periodSeconds` | How often the probe is performed | `10` |
| `server.livenessProbe.timeoutSeconds` | Number of seconds after which the probe times out | `5` |
| `server.livenessProbe.successThreshold` | Minimum consecutive successes for the probe to be considered successful | `1` |
| `server.livenessProbe.failureThreshold` | Number of times the probe will tolerate failure before giving up | `3` |
| `server.readinessProbe.initialDelaySeconds` | Number of seconds after the container has started before the probe is initiated | `10` |
| `server.readinessProbe.periodSeconds` | How often the probe is performed | `10` |
| `server.readinessProbe.timeoutSeconds` | Number of seconds after which the probe times out | `5` |
| `server.readinessProbe.successThreshold` | Minimum consecutive successes for the probe to be considered successful | `1` |
| `server.readinessProbe.failureThreshold` | Number of times the probe will tolerate failure before giving up | `3` |

### Server Gateway API Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `server.gatewayapi.enabled` | Whether to enable Gateway API | `false` |
| `server.gatewayapi.parentRefs` | Parent references for the Gateway API | `[]` |
| `server.gatewayapi.hostnames` | Hostnames for the Gateway API | `[]` |

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

### WebUI Probes Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `webui.livenessProbe.initialDelaySeconds` | Number of seconds after the container has started before the probe is initiated | `30` |
| `webui.livenessProbe.periodSeconds` | How often the probe is performed | `10` |
| `webui.livenessProbe.timeoutSeconds` | Number of seconds after which the probe times out | `5` |
| `webui.livenessProbe.successThreshold` | Minimum consecutive successes for the probe to be considered successful | `1` |
| `webui.livenessProbe.failureThreshold` | Number of times the probe will tolerate failure before giving up | `3` |
| `webui.readinessProbe.initialDelaySeconds` | Number of seconds after the container has started before the probe is initiated | `10` |
| `webui.readinessProbe.periodSeconds` | How often the probe is performed | `10` |
| `webui.readinessProbe.timeoutSeconds` | Number of seconds after which the probe times out | `5` |
| `webui.readinessProbe.successThreshold` | Minimum consecutive successes for the probe to be considered successful | `1` |
| `webui.readinessProbe.failureThreshold` | Number of times the probe will tolerate failure before giving up | `3` |

### WebUI Gateway API Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `webui.gatewayapi.enabled` | Whether to enable Gateway API | `false` |
| `webui.gatewayapi.parentRefs` | Parent references for the Gateway API | `[]` |
| `webui.gatewayapi.hostnames` | Hostnames for the Gateway API | `[]` |

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
helm install my-rustdok rustdok/rustdok --set webui.enabled=false
```

### Using Rook Ceph for storage

```bash
helm install my-rustdok rustdok/rustdok \
  --set server.storage.rookCeph.enabled=true \
  --set server.storage.rookCeph.s3.objectStoreUser.secretName=ceph-objectstore-user-secret
```

### Using generic S3 storage

```bash
helm install my-rustdok rustdok/rustdok \
  --set server.storage.s3.endpointUrl=https://s3.example.com \
  --set server.storage.s3.region=eu-central-1 \
  --set server.storage.s3.accessKey=myaccesskey \
  --set server.storage.s3.secretKey=mysecretkey
```

### Enabling Gateway API

```bash
helm install my-rustdok rustdok/rustdok \
  --set server.gatewayapi.enabled=true \
  --set server.gatewayapi.parentRefs[0].name=tls-gateway \
  --set server.gatewayapi.parentRefs[0].namespace=connectivity \
  --set server.gatewayapi.hostnames[0]=rustdok.example.com \
  --set webui.gatewayapi.enabled=true \
  --set webui.gatewayapi.parentRefs[0].name=tls-gateway \
  --set webui.gatewayapi.parentRefs[0].namespace=connectivity \
  --set webui.gatewayapi.hostnames[0]=rustdok-ui.example.com
```

