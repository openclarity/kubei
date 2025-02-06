# openclarity

![Version: 0.0.0](https://img.shields.io/badge/Version-0.0.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: latest](https://img.shields.io/badge/AppVersion-latest-informational?style=flat-square)

OpenClarity is an open source tool for agentless detection and management of
Virtual Machine Software Bill Of Materials (SBOM) and security threats such
as vulnerabilities, exploits, malware, rootkits, misconfigurations and leaked
secrets.

**Homepage:** <https://openclarity.io>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| OpenClarity Maintainers |  | <https://github.com/openclarity/openclarity> |

## Source Code

* <https://github.com/openclarity/openclarity>

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://charts.bitnami.com/bitnami | postgresql | 15.5.38 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| apiserver.containerSecurityContext.allowPrivilegeEscalation | bool | `false` | Force the child process to run as non-privileged |
| apiserver.containerSecurityContext.capabilities.drop | list | `["ALL"]` | List of capabilities to be dropped |
| apiserver.containerSecurityContext.enabled | bool | `true` | Container security context enabled |
| apiserver.containerSecurityContext.privileged | bool | `false` | Whether the container should run in privileged mode |
| apiserver.containerSecurityContext.readOnlyRootFilesystem | bool | `true` | Mounts the container file system as ReadOnly |
| apiserver.containerSecurityContext.runAsGroup | int | `1001` | Group ID which the containers should run as |
| apiserver.containerSecurityContext.runAsNonRoot | bool | `true` | Whether the containers should run as a non-root user |
| apiserver.containerSecurityContext.runAsUser | int | `1001` | User ID which the containers should run as |
| apiserver.database.externalPostgresql.auth.existingSecret | string | `""` | Name of existing secret to use for PostgreSQL credentials that has the following keys: username password database |
| apiserver.database.externalPostgresql.enabled | bool | `false` | Enable/disable external Postgresql database |
| apiserver.database.externalPostgresql.host | string | `""` | External Postgreqsl database host |
| apiserver.database.externalPostgresql.port | int | `5432` | External Postgresql database port |
| apiserver.database.postgresql.enabled | bool | `true` | Enable/disable Postgresql database |
| apiserver.database.sqlite.enabled | bool | `false` | Enable/disable SQLite database |
| apiserver.database.sqlite.persistence.accessMode | string | `"ReadWriteOnce"` | Access mode for PersistentVolumeClaim |
| apiserver.database.sqlite.persistence.size | string | `"1Gi"` | Size for PersistentVolumeClaim |
| apiserver.image.digest | string | `""` | API Server image digest. If set will override the tag. |
| apiserver.image.pullPolicy | string | `"IfNotPresent"` | API Server image pull policy |
| apiserver.image.registry | string | `"ghcr.io"` | API Server image registry |
| apiserver.image.repository | string | `"openclarity/openclarity-api-server"` | API Server image repository |
| apiserver.image.tag | string | `"latest"` | API Server image tag (immutable tags are recommended) |
| apiserver.logLevel | string | `"info"` | API Server log level |
| apiserver.podSecurityContext.enabled | bool | `true` | Pod security context enabled |
| apiserver.podSecurityContext.fsGroup | int | `1001` | Pod security context fsGroup |
| apiserver.replicaCount | int | `1` | Number of replicas for the API Server |
| apiserver.resources.limits | object | `{}` | The resources limits for the apiserver containers |
| apiserver.resources.requests | object | `{}` | The requested resources for the apiserver containers |
| apiserver.serviceAccount.automountServiceAccountToken | bool | `false` | Allows auto mount of ServiceAccountToken on the serviceAccount created. Can be set to false if pods using this serviceAccount do not need to use K8s API. |
| apiserver.serviceAccount.create | bool | `true` | Enable creation of ServiceAccount |
| apiserver.serviceAccount.name | string | `""` | The name of the ServiceAccount to use. If not set and create is true, it will use the component's calculated name. |
| crDiscoveryServer.affinity | object | `{}` |  |
| crDiscoveryServer.containerRuntimePaths[0].name | string | `"containerd"` |  |
| crDiscoveryServer.containerRuntimePaths[0].path | string | `"/var/run/containerd"` |  |
| crDiscoveryServer.containerRuntimePaths[0].readOnly | bool | `true` |  |
| crDiscoveryServer.containerRuntimePaths[1].name | string | `"k3s-containerd"` |  |
| crDiscoveryServer.containerRuntimePaths[1].path | string | `"/run/k3s/containerd"` |  |
| crDiscoveryServer.containerRuntimePaths[1].readOnly | bool | `true` |  |
| crDiscoveryServer.containerRuntimePaths[2].name | string | `"docker"` |  |
| crDiscoveryServer.containerRuntimePaths[2].path | string | `"/var/lib/docker"` |  |
| crDiscoveryServer.containerRuntimePaths[2].readOnly | bool | `true` |  |
| crDiscoveryServer.containerRuntimePaths[3].name | string | `"crio"` |  |
| crDiscoveryServer.containerRuntimePaths[3].path | string | `"/var/run/crio"` |  |
| crDiscoveryServer.containerRuntimePaths[3].readOnly | bool | `true` |  |
| crDiscoveryServer.containerRuntimePaths[4].name | string | `"crio-lib"` |  |
| crDiscoveryServer.containerRuntimePaths[4].path | string | `"/var/lib/containers"` |  |
| crDiscoveryServer.containerRuntimePaths[5].name | string | `"crio-run"` |  |
| crDiscoveryServer.containerRuntimePaths[5].path | string | `"/var/run/containers"` |  |
| crDiscoveryServer.containerRuntimePaths[6].name | string | `"crio-containers"` |  |
| crDiscoveryServer.containerRuntimePaths[6].path | string | `"/etc/containers"` |  |
| crDiscoveryServer.containerRuntimePaths[6].readOnly | bool | `true` |  |
| crDiscoveryServer.containerSecurityContext.allowPrivilegeEscalation | bool | `false` | Force the child process to run as non-privileged |
| crDiscoveryServer.containerSecurityContext.capabilities.drop | list | `["ALL"]` | List of capabilities to be dropped |
| crDiscoveryServer.containerSecurityContext.enabled | bool | `false` | Container security context enabled |
| crDiscoveryServer.containerSecurityContext.privileged | bool | `false` | Whether the container should run in privileged mode |
| crDiscoveryServer.containerSecurityContext.readOnlyRootFilesystem | bool | `true` | Mounts the container file system as ReadOnly |
| crDiscoveryServer.containerSecurityContext.runAsGroup | int | `1001` | Group ID which the containers should run as |
| crDiscoveryServer.containerSecurityContext.runAsNonRoot | bool | `true` | Whether the containers should run as a non-root user |
| crDiscoveryServer.containerSecurityContext.runAsUser | int | `1001` | User ID which the containers should run as |
| crDiscoveryServer.env | list | `[]` | Environment variables to set in the Container Runtime Discovery Server container |
| crDiscoveryServer.image.digest | string | `""` | Container Runtime Discovery Server image digest. If set will override the tag. |
| crDiscoveryServer.image.pullPolicy | string | `"IfNotPresent"` | Container Runtime Discovery Server image pull policy |
| crDiscoveryServer.image.registry | string | `"ghcr.io"` | Container Runtime Discovery Server container registry |
| crDiscoveryServer.image.repository | string | `"openclarity/openclarity-cr-discovery-server"` | Container Runtime Discovery Server container repository |
| crDiscoveryServer.image.tag | string | `"latest"` | Container Runtime Discovery Server container tag |
| crDiscoveryServer.nodeSelector | object | `{}` |  |
| crDiscoveryServer.podSecurityContext.enabled | bool | `false` | Pod security context enabled |
| crDiscoveryServer.podSecurityContext.fsGroup | int | `1001` | Pod security context fsGroup |
| crDiscoveryServer.resources.limits | object | `{}` | The resources limits for the container runtime discovery server containers |
| crDiscoveryServer.resources.requests | object | `{}` | The requested resources for the container runtime discovery server containers |
| crDiscoveryServer.serviceAccount.automountServiceAccountToken | bool | `false` | Allows auto mount of ServiceAccountToken on the serviceAccount created. Can be set to false if pods using this serviceAccount do not need to use K8s API. |
| crDiscoveryServer.serviceAccount.create | bool | `true` | Enable creation of ServiceAccount |
| crDiscoveryServer.serviceAccount.name | string | `""` | The name of the ServiceAccount to use. If not set and create is true, it will use the component's calculated name. |
| crDiscoveryServer.tolerations | list | `[]` |  |
| exploitDBServer.containerSecurityContext.allowPrivilegeEscalation | bool | `false` | Force the child process to run as non-privileged |
| exploitDBServer.containerSecurityContext.capabilities.drop | list | `["ALL"]` | List of capabilities to be dropped |
| exploitDBServer.containerSecurityContext.enabled | bool | `false` | Container security context enabled |
| exploitDBServer.containerSecurityContext.privileged | bool | `false` | Whether the container should run in privileged mode |
| exploitDBServer.containerSecurityContext.readOnlyRootFilesystem | bool | `true` | Mounts the container file system as ReadOnly |
| exploitDBServer.containerSecurityContext.runAsGroup | int | `1001` | Group ID which the containers should run as |
| exploitDBServer.containerSecurityContext.runAsNonRoot | bool | `true` | Whether the containers should run as a non-root user |
| exploitDBServer.containerSecurityContext.runAsUser | int | `1001` | User ID which the containers should run as |
| exploitDBServer.image.digest | string | `""` | Exploit DB Server image digest. If set will override the tag. |
| exploitDBServer.image.pullPolicy | string | `"IfNotPresent"` | Exploit DB Server image pull policy |
| exploitDBServer.image.registry | string | `"ghcr.io"` | Exploit DB Server container registry |
| exploitDBServer.image.repository | string | `"openclarity/exploit-db-server"` | Exploit DB Server container repository |
| exploitDBServer.image.tag | string | `"v0.3.0"` | Exploit DB Server container tag |
| exploitDBServer.podSecurityContext.enabled | bool | `true` | Pod security context enabled |
| exploitDBServer.podSecurityContext.fsGroup | int | `1001` | Pod security context fsGroup |
| exploitDBServer.replicaCount | int | `1` | Number of replicas for the exploit-db-server service |
| exploitDBServer.resources.limits | object | `{}` | The resources limits for the exploit-db-server containers |
| exploitDBServer.resources.requests | object | `{}` | The requested resources for the exploit-db-server containers |
| exploitDBServer.serviceAccount.automountServiceAccountToken | bool | `false` | Allows auto mount of ServiceAccountToken on the serviceAccount created. Can be set to false if pods using this serviceAccount do not need to use K8s API. |
| exploitDBServer.serviceAccount.create | bool | `true` | Enable creation of ServiceAccount |
| exploitDBServer.serviceAccount.name | string | `""` | The name of the ServiceAccount to use. If not set and create is true, it will use the component's calculated name. |
| freshclamMirror.containerSecurityContext.allowPrivilegeEscalation | bool | `false` | Force the child process to run as non-privileged |
| freshclamMirror.containerSecurityContext.capabilities.drop | list | `["ALL"]` | List of capabilities to be dropped |
| freshclamMirror.containerSecurityContext.enabled | bool | `false` | Container security context enabled |
| freshclamMirror.containerSecurityContext.privileged | bool | `false` | Whether the container should run in privileged mode |
| freshclamMirror.containerSecurityContext.readOnlyRootFilesystem | bool | `true` | Mounts the container file system as ReadOnly |
| freshclamMirror.containerSecurityContext.runAsGroup | int | `1001` | Group ID which the containers should run as |
| freshclamMirror.containerSecurityContext.runAsNonRoot | bool | `true` | Whether the containers should run as a non-root user |
| freshclamMirror.containerSecurityContext.runAsUser | int | `1001` | User ID which the containers should run as |
| freshclamMirror.image.digest | string | `""` | Freshclam Mirror image digest. If set will override the tag. |
| freshclamMirror.image.pullPolicy | string | `"IfNotPresent"` | Freshclam Mirror image pull policy |
| freshclamMirror.image.registry | string | `"ghcr.io"` | Freshclam Mirror container registry |
| freshclamMirror.image.repository | string | `"openclarity/freshclam-mirror"` | Freshclam Mirror container repository |
| freshclamMirror.image.tag | string | `"v0.3.1"` | Freshclam Mirror container tag |
| freshclamMirror.podSecurityContext.enabled | bool | `false` | Pod security context enabled |
| freshclamMirror.podSecurityContext.fsGroup | int | `1001` | Pod security context fsGroup |
| freshclamMirror.replicaCount | int | `1` | Number of replicas for the freshclam mirror service |
| freshclamMirror.resources.limits | object | `{}` | The resources limits for the freshclam mirror containers |
| freshclamMirror.resources.requests | object | `{}` | The requested resources for the freshclam mirror containers |
| freshclamMirror.serviceAccount.automountServiceAccountToken | bool | `false` | Allows auto mount of ServiceAccountToken on the serviceAccount created. Can be set to false if pods using this serviceAccount do not need to use K8s API. |
| freshclamMirror.serviceAccount.create | bool | `true` | Enable creation of ServiceAccount |
| freshclamMirror.serviceAccount.name | string | `""` | The name of the ServiceAccount to use. If not set and create is true, it will use the component's calculated name. |
| gateway.containerSecurityContext.allowPrivilegeEscalation | bool | `false` | Force the child process to run as non-privileged |
| gateway.containerSecurityContext.capabilities.drop | list | `["ALL"]` | List of capabilities to be dropped |
| gateway.containerSecurityContext.enabled | bool | `true` | Container security context enabled |
| gateway.containerSecurityContext.privileged | bool | `false` | Whether the container should run in privileged mode |
| gateway.containerSecurityContext.readOnlyRootFilesystem | bool | `true` | Mounts the container file system as ReadOnly |
| gateway.containerSecurityContext.runAsGroup | int | `101` | Group ID which the containers should run as |
| gateway.containerSecurityContext.runAsNonRoot | bool | `false` | Whether the containers should run as a non-root user |
| gateway.containerSecurityContext.runAsUser | int | `101` | User ID which the containers should run as |
| gateway.image.digest | string | `""` | Gateway image digest. If set will override the tag. |
| gateway.image.pullPolicy | string | `"IfNotPresent"` | Gateway service container pull policy |
| gateway.image.registry | string | `"docker.io"` | Gateway service container registry |
| gateway.image.repository | string | `"nginxinc/nginx-unprivileged"` | Gateway service container repository |
| gateway.image.tag | string | `"1.27.3"` | Gateway service container tag |
| gateway.ingress.annotations | object | `{}` |  |
| gateway.ingress.enabled | bool | `false` | Be careful when using ingress. As there is no authentication on openclarity, your instance may be accessible. Make sure the ingress remains internal if you decide to enable it. |
| gateway.ingress.hosts[0].host | string | `"chart-example.local"` |  |
| gateway.ingress.hosts[0].paths | list | `[]` |  |
| gateway.ingress.ingressClassName | string | `""` | Optionally use ingressClassName instead of default ingress class. |
| gateway.ingress.labels | object | `{}` |  |
| gateway.ingress.tls | list | `[]` |  |
| gateway.podSecurityContext.enabled | bool | `true` | Pod security context enabled |
| gateway.podSecurityContext.fsGroup | int | `101` | Pod security context fsGroup |
| gateway.replicaCount | int | `1` | Number of replicas for the gateway |
| gateway.resources.limits | object | `{}` | The resources limits for the gateway containers |
| gateway.resources.requests | object | `{}` | The requested resources for the gateway containers |
| gateway.service.annotations | object | `{}` | Annotations set for service |
| gateway.service.clusterIP | string | `""` | Dedicated IP address used for service |
| gateway.service.externalTrafficPolicy | string | `"Cluster"` | External Traffic Policy configuration Set the field to Cluster to route external traffic to all ready endpoints and Local to only route to ready node local endpoints. |
| gateway.service.nodePorts | object | `{"http":""}` | NodePort configurations |
| gateway.service.ports | object | `{"http":80}` | Port configurations |
| gateway.service.type | string | `"ClusterIP"` | Service type: ClusterIP, NodePort, LoadBalancer |
| gateway.serviceAccount.automountServiceAccountToken | bool | `false` | Allows auto mount of ServiceAccountToken on the serviceAccount created. Can be set to false if pods using this serviceAccount do not need to use K8s API. |
| gateway.serviceAccount.create | bool | `true` | Enable creation of ServiceAccount |
| gateway.serviceAccount.name | string | `""` | The name of the ServiceAccount to use. If not set and create is true, it will use the component's calculated name. |
| global.imageRegistry | string | `""` |  |
| grypeServer.containerSecurityContext.allowPrivilegeEscalation | bool | `false` | Force the child process to run as non-privileged |
| grypeServer.containerSecurityContext.capabilities.drop | list | `["ALL"]` | List of capabilities to be dropped |
| grypeServer.containerSecurityContext.enabled | bool | `true` | Container security context enabled |
| grypeServer.containerSecurityContext.privileged | bool | `false` | Whether the container should run in privileged mode |
| grypeServer.containerSecurityContext.readOnlyRootFilesystem | bool | `true` | Mounts the container file system as ReadOnly |
| grypeServer.containerSecurityContext.runAsGroup | int | `1001` | Group ID which the containers should run as |
| grypeServer.containerSecurityContext.runAsNonRoot | bool | `true` | Whether the containers should run as a non-root user |
| grypeServer.containerSecurityContext.runAsUser | int | `1001` | User ID which the containers should run as |
| grypeServer.image.digest | string | `""` | Grype server image digest. If set will override the tag. |
| grypeServer.image.pullPolicy | string | `"IfNotPresent"` | Grype server image pull policy |
| grypeServer.image.registry | string | `"ghcr.io"` | Grype server container registry |
| grypeServer.image.repository | string | `"openclarity/grype-server"` | Grype server container repository |
| grypeServer.image.tag | string | `"v0.7.5"` | Grype server container tag |
| grypeServer.logLevel | string | `"info"` | Log level for the grype-server service |
| grypeServer.podSecurityContext.enabled | bool | `true` | Pod security context enabled |
| grypeServer.podSecurityContext.fsGroup | int | `1001` | Pod security context fsGroup |
| grypeServer.replicaCount | int | `1` | Number of replicas for the grype server service |
| grypeServer.resources.limits | object | `{}` | The resources limits for the grype server containers |
| grypeServer.resources.requests | object | `{}` | The requested resources for the grype server containers |
| grypeServer.serviceAccount.automountServiceAccountToken | bool | `false` | Allows auto mount of ServiceAccountToken on the serviceAccount created. Can be set to false if pods using this serviceAccount do not need to use K8s API. |
| grypeServer.serviceAccount.create | bool | `true` | Enable creation of ServiceAccount |
| grypeServer.serviceAccount.name | string | `""` | The name of the ServiceAccount to use. If not set and create is true, it will use the component's calculated name. |
| orchestrator.aws.keypairName | string | `""` | KeyPair to use for the scanner instance |
| orchestrator.aws.region | string | `""` | Region where the control plane is running |
| orchestrator.aws.scannerAmiId | string | `""` | AMI to use for the scanner instance |
| orchestrator.aws.scannerInstanceType | string | `""` | InstanceType to use for the scanner instance |
| orchestrator.aws.scannerRegion | string | `""` | Region where the scanners will be created |
| orchestrator.aws.securityGroupId | string | `""` | Security Group to use for the scanner networking |
| orchestrator.aws.subnetId | string | `""` | Subnet where the scanners will be created |
| orchestrator.azure.scannerImageOffer | string | `""` | Scanner VM source image offer |
| orchestrator.azure.scannerImagePublisher | string | `""` | Scanner VM source image publisher |
| orchestrator.azure.scannerImageVersion | string | `""` | Scanner VM source image version |
| orchestrator.azure.scannerLocation | string | `""` | Location where the scanner instances will be run |
| orchestrator.azure.scannerPublicKey | string | `""` | SSH RSA Public Key to configure the scanner instances with |
| orchestrator.azure.scannerResourceGroup | string | `""` | ResourceGroup where the scanner instances will be run |
| orchestrator.azure.scannerSecurityGroup | string | `""` | Scanner VM security group |
| orchestrator.azure.scannerStorageAccountName | string | `""` | Storage account to use for transferring snapshots between regions |
| orchestrator.azure.scannerStorageContainerName | string | `""` | Storage container to use for transferring snapshots between regions |
| orchestrator.azure.scannerSubnetId | string | `""` | Subnet ID where the scanner instances will be run |
| orchestrator.azure.scannerVMArchitectureToImageSkuMapping | string | `""` | Scanner VM source image sku mapping |
| orchestrator.azure.scannerVmArchitecture | string | `""` | Scanner architecture |
| orchestrator.azure.scannerVmArchitectureToSizeMapping | string | `""` | Scanner architecture to VM size mapping |
| orchestrator.azure.subscriptionId | string | `""` | Subscription ID for discovery and scanning |
| orchestrator.containerSecurityContext.allowPrivilegeEscalation | bool | `false` | Force the child process to run as non-privileged |
| orchestrator.containerSecurityContext.capabilities.drop | list | `["ALL"]` | List of capabilities to be dropped |
| orchestrator.containerSecurityContext.enabled | bool | `true` | Container security context enabled |
| orchestrator.containerSecurityContext.privileged | bool | `false` | Whether the container should run in privileged mode |
| orchestrator.containerSecurityContext.readOnlyRootFilesystem | bool | `true` | Mounts the container file system as ReadOnly |
| orchestrator.containerSecurityContext.runAsGroup | int | `1001` | Group ID which the containers should run as |
| orchestrator.containerSecurityContext.runAsNonRoot | bool | `true` | Whether the containers should run as a non-root user |
| orchestrator.containerSecurityContext.runAsUser | int | `1001` | User ID which the containers should run as |
| orchestrator.deleteJobPolicy | string | `"Always"` | Global policy used to determine when to clean up an AssetScan. Possible options are: Always - All AssetScans are cleaned up OnSuccess - Only Successful AssetScans are cleaned up, Failed ones are left for debugging Never - No AssetScans are cleaned up |
| orchestrator.docker | object | `{}` |  |
| orchestrator.exploitsDBAddress | string | `""` | Address that scanners can use to reach back to the Exploits server |
| orchestrator.freshclamMirrorAddress | string | `""` | Address that scanners can use to reach the freshclam mirror |
| orchestrator.gcp.projectId | string | `""` | Project ID for discovery and scanning |
| orchestrator.gcp.scannerMachineArchitecture | string | `""` | Scanner Machine architecture |
| orchestrator.gcp.scannerMachineArchitectureToSourceImageMapping | string | `""` | Scanner source image mapping |
| orchestrator.gcp.scannerMachineArchitectureToTypeMapping | string | `""` | Scanner Machine type mapping |
| orchestrator.gcp.scannerSourceImagePrefix | string | `""` | Scanner source image prefix |
| orchestrator.gcp.scannerSubnet | string | `""` | Subnet where to run the scanner instances |
| orchestrator.gcp.scannerZone | string | `""` | Zone to where the scanner instances should run |
| orchestrator.grypeServerAddress | string | `""` | Address that scanners can use to reach the grype server |
| orchestrator.image.digest | string | `""` | Orchestrator image digest. If set will override the tag. |
| orchestrator.image.pullPolicy | string | `"IfNotPresent"` | Orchestrator image pull policy |
| orchestrator.image.registry | string | `"ghcr.io"` | Orchestrator image registry |
| orchestrator.image.repository | string | `"openclarity/openclarity-orchestrator"` | Orchestrator image repository |
| orchestrator.image.tag | string | `"latest"` | Orchestrator image tag (immutable tags are recommended) |
| orchestrator.kubernetes | object | `{}` |  |
| orchestrator.logLevel | string | `"info"` | Orchestrator service log level |
| orchestrator.podSecurityContext.enabled | bool | `true` | Whether Orchestrator pod security context is enabled |
| orchestrator.podSecurityContext.fsGroup | int | `1001` | Orchestrator pod security context fsGroup |
| orchestrator.provider | string | `"aws"` | Which provider driver to enable. If enabling the Kubernetes provider ensure that the orchestrator serviceAccount section is configured to allow access to the Kubernetes API. |
| orchestrator.replicaCount | int | `1` | Number of replicas for the Orchestrator service Currently 1 supported. |
| orchestrator.resources.limits | object | `{}` | The resources limits for the orchestrator containers |
| orchestrator.resources.requests | object | `{}` | The requested resources for the orchestrator containers |
| orchestrator.scannerApiserverAddress | string | `""` | Address that scanners can use to reach back to the API server |
| orchestrator.scannerImage.digest | string | `""` | Scanner Container image digest. If set will override the tag. |
| orchestrator.scannerImage.registry | string | `"ghcr.io"` | Scanner Container image registry |
| orchestrator.scannerImage.repository | string | `"openclarity/openclarity-cli"` | Scanner Container image repository |
| orchestrator.scannerImage.tag | string | `"latest"` | Scanner Container image tag (immutable tags are recommended) |
| orchestrator.serviceAccount.automountServiceAccountToken | bool | `false` | Allows auto mount of ServiceAccountToken on the serviceAccount created. Can be set to false if pods using this serviceAccount do not need to use K8s API. |
| orchestrator.serviceAccount.create | bool | `true` | Enable creation of ServiceAccount |
| orchestrator.serviceAccount.name | string | `""` | The name of the ServiceAccount to use. If not set and create is true, it will use the component's calculated name. |
| orchestrator.trivyServerAddress | string | `""` | Address that scanners can use to reach trivy server |
| orchestrator.yaraRuleServerAddress | string | `""` | Address that scanner can use to reach the yara rule server |
| postgresql.auth.database | string | `"openclarity"` | Name for a custom database to create |
| postgresql.auth.existingSecret | string | `""` | Name of existing secret to use for PostgreSQL credentials |
| postgresql.auth.password | string | `"password1"` | Password for the custom user |
| postgresql.auth.username | string | `"openclarity"` | Name for a custom user to create |
| postgresql.containerSecurityContext.allowPrivilegeEscalation | bool | `false` | Force the child process to run as non-privileged |
| postgresql.containerSecurityContext.capabilities.drop | list | `["ALL"]` | List of capabilities to be dropped |
| postgresql.containerSecurityContext.enabled | bool | `true` | Container security context enabled |
| postgresql.containerSecurityContext.privileged | bool | `false` | Whether the container should run in privileged mode |
| postgresql.containerSecurityContext.readOnlyRootFilesystem | bool | `true` | Mounts the container file system as ReadOnly |
| postgresql.containerSecurityContext.runAsGroup | int | `1001` | Group ID which the containers should run as |
| postgresql.containerSecurityContext.runAsNonRoot | bool | `true` | Whether the containers should run as a non-root user |
| postgresql.containerSecurityContext.runAsUser | int | `1001` | User ID which the containers should run as |
| postgresql.image.digest | string | `""` | Postgresql image digest. If set will override the tag. |
| postgresql.image.pullPolicy | string | `"IfNotPresent"` | Postgresql container image pull policy |
| postgresql.image.registry | string | `"docker.io"` | Postgresql container registry |
| postgresql.image.repository | string | `"bitnami/postgresql"` | Postgresql container repository |
| postgresql.image.tag | string | `"16.6.0-debian-12-r1"` | Postgresql container tag |
| postgresql.podSecurityContext.enabled | bool | `true` | Pod security context enabled |
| postgresql.podSecurityContext.fsGroup | int | `1001` | Pod security context fsGroup |
| postgresql.primary.resourcesPreset | string | `"small"` | Postgresql container resource preset For more info see: https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15 |
| postgresql.resources.limits | object | `{}` | The resources limits for the postgresql containers |
| postgresql.resources.requests | object | `{}` | The requested resources for the postgresql containers |
| postgresql.service.ports.postgresql | int | `5432` | PostgreSQL service port |
| postgresql.serviceAccount.automountServiceAccountToken | bool | `false` | Allows auto mount of ServiceAccountToken on the serviceAccount created. Can be set to false if pods using this serviceAccount do not need to use K8s API. |
| postgresql.serviceAccount.create | bool | `true` | Enable creation of ServiceAccount |
| postgresql.serviceAccount.name | string | `""` | The name of the ServiceAccount to use. If not set and create is true, it will use the component's calculated name. |
| swaggerUI.containerSecurityContext.allowPrivilegeEscalation | bool | `false` | Force the child process to run as non-privileged |
| swaggerUI.containerSecurityContext.capabilities.drop | list | `["ALL"]` | List of capabilities to be dropped |
| swaggerUI.containerSecurityContext.enabled | bool | `false` | Container security context enabled |
| swaggerUI.containerSecurityContext.privileged | bool | `false` | Whether the container should run in privileged mode |
| swaggerUI.containerSecurityContext.readOnlyRootFilesystem | bool | `true` | Mounts the container file system as ReadOnly |
| swaggerUI.containerSecurityContext.runAsGroup | int | `0` | Group ID which the containers should run as |
| swaggerUI.containerSecurityContext.runAsNonRoot | bool | `false` | Whether the containers should run as a non-root user |
| swaggerUI.containerSecurityContext.runAsUser | int | `0` | User ID which the containers should run as |
| swaggerUI.image.digest | string | `""` | Swagger UI image digest. If set will override the tag. |
| swaggerUI.image.pullPolicy | string | `"IfNotPresent"` | Swagger UI image pull policy |
| swaggerUI.image.registry | string | `"docker.io"` | Swagger UI container registry |
| swaggerUI.image.repository | string | `"swaggerapi/swagger-ui"` | Swagger UI container repository |
| swaggerUI.image.tag | string | `"v5.18.2"` | Swagger UI container tag |
| swaggerUI.podSecurityContext.enabled | bool | `false` | Pod security context enabled |
| swaggerUI.podSecurityContext.fsGroup | int | `101` | Pod security context fsGroup |
| swaggerUI.replicaCount | int | `1` | Number of replicas for the swagger-ui service |
| swaggerUI.resources.limits | object | `{}` | The resources limits for the swagger ui containers |
| swaggerUI.resources.requests | object | `{}` | The requested resources for the swagger ui containers |
| swaggerUI.serviceAccount.automountServiceAccountToken | bool | `false` | Allows auto mount of ServiceAccountToken on the serviceAccount created. Can be set to false if pods using this serviceAccount do not need to use K8s API. |
| swaggerUI.serviceAccount.create | bool | `true` | Enable creation of ServiceAccount |
| swaggerUI.serviceAccount.name | string | `""` | The name of the ServiceAccount to use. If not set and create is true, it will use the component's calculated name. |
| trivyServer.containerSecurityContext.allowPrivilegeEscalation | bool | `false` | Force the child process to run as non-privileged |
| trivyServer.containerSecurityContext.capabilities.drop | list | `["ALL"]` | List of capabilities to be dropped |
| trivyServer.containerSecurityContext.enabled | bool | `true` | Container security context enabled |
| trivyServer.containerSecurityContext.privileged | bool | `false` | Whether the container should run in privileged mode |
| trivyServer.containerSecurityContext.readOnlyRootFilesystem | bool | `true` | Mounts the container file system as ReadOnly |
| trivyServer.containerSecurityContext.runAsGroup | int | `1001` | Group ID which the containers should run as |
| trivyServer.containerSecurityContext.runAsNonRoot | bool | `true` | Whether the containers should run as a non-root user |
| trivyServer.containerSecurityContext.runAsUser | int | `1001` | User ID which the containers should run as |
| trivyServer.image.digest | string | `""` | Trivy Server image digest. If set will override the tag. |
| trivyServer.image.pullPolicy | string | `"IfNotPresent"` | Trivy Server image pull policy |
| trivyServer.image.registry | string | `"docker.io"` | Trivy Server container registry |
| trivyServer.image.repository | string | `"aquasec/trivy"` | Trivy Server container repository |
| trivyServer.image.tag | string | `"0.58.2"` | Trivy Server container tag |
| trivyServer.podSecurityContext.enabled | bool | `true` | Pod security context enabled |
| trivyServer.podSecurityContext.fsGroup | int | `1001` | Pod security context fsGroup |
| trivyServer.replicaCount | int | `1` | Number of replicas for the trivy server service |
| trivyServer.resources.limits | object | `{}` | The resources limits for the trivy server containers |
| trivyServer.resources.requests | object | `{}` | The requested resources for the trivy server containers |
| trivyServer.serviceAccount.automountServiceAccountToken | bool | `false` | Allows auto mount of ServiceAccountToken on the serviceAccount created. Can be set to false if pods using this serviceAccount do not need to use K8s API. |
| trivyServer.serviceAccount.create | bool | `true` | Enable creation of ServiceAccount |
| trivyServer.serviceAccount.name | string | `""` | The name of the ServiceAccount to use. If not set and create is true, it will use the component's calculated name. |
| ui.containerSecurityContext.allowPrivilegeEscalation | bool | `false` | Force the child process to run as non-privileged |
| ui.containerSecurityContext.capabilities.drop | list | `["ALL"]` | List of capabilities to be dropped |
| ui.containerSecurityContext.enabled | bool | `true` | Container security context enabled |
| ui.containerSecurityContext.privileged | bool | `false` | Whether the container should run in privileged mode |
| ui.containerSecurityContext.readOnlyRootFilesystem | bool | `true` | Mounts the container file system as ReadOnly |
| ui.containerSecurityContext.runAsGroup | int | `101` | Group ID which the containers should run as |
| ui.containerSecurityContext.runAsNonRoot | bool | `true` | Whether the containers should run as a non-root user |
| ui.containerSecurityContext.runAsUser | int | `101` | User ID which the containers should run as |
| ui.image.digest | string | `""` | UI image digest. If set will override the tag |
| ui.image.pullPolicy | string | `"IfNotPresent"` | UI Image pull policy |
| ui.image.registry | string | `"ghcr.io"` | UI image registry |
| ui.image.repository | string | `"openclarity/openclarity-ui"` | UI image repository |
| ui.image.tag | string | `"latest"` | UI image tag |
| ui.podSecurityContext.enabled | bool | `true` | Pod security context enabled |
| ui.podSecurityContext.fsGroup | int | `101` | Pod security context fsGroup |
| ui.replicaCount | int | `1` | Number of replicas for the UI service |
| ui.resources.limits | object | `{}` | The resources limits for the UI containers |
| ui.resources.requests | object | `{}` | The requested resources for the UI containers |
| ui.serviceAccount.automountServiceAccountToken | bool | `false` | Allows auto mount of ServiceAccountToken on the serviceAccount created. Can be set to false if pods using this serviceAccount do not need to use K8s API. |
| ui.serviceAccount.create | bool | `true` | Enable creation of ServiceAccount |
| ui.serviceAccount.name | string | `""` | The name of the ServiceAccount to use. If not set and create is true, it will use the component's calculated name. |
| uibackend.containerSecurityContext.allowPrivilegeEscalation | bool | `false` | Force the child process to run as non-privileged |
| uibackend.containerSecurityContext.capabilities.drop | list | `["ALL"]` | List of capabilities to be dropped |
| uibackend.containerSecurityContext.enabled | bool | `true` | Container security context enabled |
| uibackend.containerSecurityContext.privileged | bool | `false` | Whether the container should run in privileged mode |
| uibackend.containerSecurityContext.readOnlyRootFilesystem | bool | `true` | Mounts the container file system as ReadOnly |
| uibackend.containerSecurityContext.runAsGroup | int | `1001` | Group ID which the containers should run as |
| uibackend.containerSecurityContext.runAsNonRoot | bool | `true` | Whether the containers should run as a non-root user |
| uibackend.containerSecurityContext.runAsUser | int | `1001` | User ID which the containers should run as |
| uibackend.image.digest | string | `""` | UI Backend image digest. If set will override the tag. |
| uibackend.image.pullPolicy | string | `"IfNotPresent"` | UI Backend image pull policy |
| uibackend.image.registry | string | `"ghcr.io"` | UI Backend image registry |
| uibackend.image.repository | string | `"openclarity/openclarity-ui-backend"` | UI Backend image repository |
| uibackend.image.tag | string | `"latest"` | UI Backend image tag |
| uibackend.logLevel | string | `"info"` | Log level for the UI backend service |
| uibackend.podSecurityContext.enabled | bool | `true` | Pod security context enabled |
| uibackend.podSecurityContext.fsGroup | int | `1001` | Pod security context fsGroup |
| uibackend.replicaCount | int | `1` | Number of replicas for the UI Backend service |
| uibackend.resources.limits | object | `{}` | The resources limits for the UI backend containers |
| uibackend.resources.requests | object | `{}` | The requested resources for the UI backend containers |
| uibackend.serviceAccount.automountServiceAccountToken | bool | `false` | Allows auto mount of ServiceAccountToken on the serviceAccount created. Can be set to false if pods using this serviceAccount do not need to use K8s API. |
| uibackend.serviceAccount.create | bool | `true` | Enable creation of ServiceAccount |
| uibackend.serviceAccount.name | string | `""` | The name of the ServiceAccount to use. If not set and create is true, it will use the component's calculated name. |
| yaraRuleServer.containerSecurityContext.allowPrivilegeEscalation | bool | `false` | Force the child process to run as non-privileged |
| yaraRuleServer.containerSecurityContext.capabilities.drop | list | `["ALL"]` | List of capabilities to be dropped |
| yaraRuleServer.containerSecurityContext.enabled | bool | `false` | Container security context enabled |
| yaraRuleServer.containerSecurityContext.privileged | bool | `false` | Whether the container should run in privileged mode |
| yaraRuleServer.containerSecurityContext.readOnlyRootFilesystem | bool | `true` | Mounts the container file system as ReadOnly |
| yaraRuleServer.containerSecurityContext.runAsGroup | int | `1001` | Group ID which the containers should run as |
| yaraRuleServer.containerSecurityContext.runAsNonRoot | bool | `true` | Whether the containers should run as a non-root user |
| yaraRuleServer.containerSecurityContext.runAsUser | int | `1001` | User ID which the containers should run as |
| yaraRuleServer.image.digest | string | `""` | Yara Rule Server image digest. If set will override the tag. |
| yaraRuleServer.image.pullPolicy | string | `"IfNotPresent"` | Yara Rule Server image pull policy |
| yaraRuleServer.image.registry | string | `"ghcr.io"` | Yara Rule Server container registry |
| yaraRuleServer.image.repository | string | `"openclarity/yara-rule-server"` | Yara Rule Server container repository |
| yaraRuleServer.image.tag | string | `"v0.3.0"` | Yara Rule Server container tag |
| yaraRuleServer.podSecurityContext.enabled | bool | `false` | Pod security context enabled |
| yaraRuleServer.podSecurityContext.fsGroup | int | `1001` | Pod security context fsGroup |
| yaraRuleServer.replicaCount | int | `1` | Number of replicas for the Yara Rule Server service |
| yaraRuleServer.resources.limits | object | `{}` | The resources limits for the Yara Rule Server containers |
| yaraRuleServer.resources.requests | object | `{}` | The requested resources for the Yara Rule Server containers |
| yaraRuleServer.serviceAccount.automountServiceAccountToken | bool | `false` | Allows auto mount of ServiceAccountToken on the serviceAccount created. Can be set to false if pods using this serviceAccount do not need to use K8s API. |
| yaraRuleServer.serviceAccount.create | bool | `true` | Enable creation of ServiceAccount |
| yaraRuleServer.serviceAccount.name | string | `""` | The name of the ServiceAccount to use. If not set and create is true, it will use the component's calculated name. |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
