{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "rustdok.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "rustdok.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "rustdok.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "rustdok.labels" -}}
helm.sh/chart: {{ include "rustdok.chart" . }}
{{ include "rustdok.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "rustdok.selectorLabels" -}}
app.kubernetes.io/name: {{ include "rustdok.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "rustdok.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "rustdok.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Common metadata for all resources
*/}}
{{- define "rustdok.commonMetadata" -}}
name: {{ .name }}
labels:
  app: {{ .name }}
  chart: {{ .Chart.Name }}-{{ .Chart.Version }}
  release: {{ .Release.Name }}
  heritage: {{ .Release.Service }}
{{- end -}}

{{/*
Get namespace name - uses the namespace specified in values if provided, otherwise uses the release namespace
*/}}
{{- define "rustdok.namespaceName" -}}
{{- default .Release.Namespace .Values.namespace -}}
{{- end -}}

{{/*
Validate S3 storage configuration when RookCeph is not enabled
*/}}
{{- define "rustdok.validateS3Config" -}}
{{- if not .Values.server.storage.rookCeph.enabled -}}
  {{- if or (not .Values.server.storage.s3.endpointUrl) (eq .Values.server.storage.s3.endpointUrl "") -}}
    {{- fail "server.storage.s3.endpointUrl is required when RookCeph is not enabled" -}}
  {{- end -}}
  {{- if or (not .Values.server.storage.s3.region) (eq .Values.server.storage.s3.region "") -}}
    {{- fail "server.storage.s3.region is required when RookCeph is not enabled" -}}
  {{- end -}}
  {{- if or (not .Values.server.storage.s3.accessKey) (eq .Values.server.storage.s3.accessKey "") -}}
    {{- fail "server.storage.s3.accessKey is required when RookCeph is not enabled" -}}
  {{- end -}}
  {{- if or (not .Values.server.storage.s3.secretKey) (eq .Values.server.storage.s3.secretKey "") -}}
    {{- fail "server.storage.s3.secretKey is required when RookCeph is not enabled" -}}
  {{- end -}}
{{- end -}}
{{- end -}}

{{/*
Validate RookCeph configuration when enabled
*/}}
{{- define "rustdok.validateRookCephConfig" -}}
{{- if .Values.server.storage.rookCeph.enabled -}}
  {{- if or (not .Values.server.storage.rookCeph.s3.objectStoreUser.secretName) (eq .Values.server.storage.rookCeph.s3.objectStoreUser.secretName "") -}}
    {{- fail "server.storage.rookCeph.s3.objectStoreUser.secretName is required when RookCeph is enabled" -}}
  {{- end -}}
{{- end -}}
{{- end -}}

{{/*
S3 environment variables configuration
*/}}
{{- define "rustdok.s3EnvVars" -}}
# S3 configuration
- name: S3_ENDPOINT_URL
  {{- if .Values.server.storage.rookCeph.enabled }}
  valueFrom:
    secretKeyRef:
      name: {{ .Values.server.storage.rookCeph.s3.objectStoreUser.secretName }}
      key: Endpoint
  {{- else }}
  value: {{ .Values.server.storage.s3.endpointUrl | quote }}
  {{- end }}
- name: S3_ACCESS_KEY
  {{- if .Values.server.storage.rookCeph.enabled }}
  valueFrom:
    secretKeyRef:
      name: {{ .Values.server.storage.rookCeph.s3.objectStoreUser.secretName }}
      key: AccessKey
  {{- else }}
  value: {{ .Values.server.storage.s3.accessKey | quote }}
  {{- end }}
- name: S3_SECRET_KEY
  {{- if .Values.server.storage.rookCeph.enabled }}
  valueFrom:
    secretKeyRef:
      name: {{ .Values.server.storage.rookCeph.s3.objectStoreUser.secretName }}
      key: SecretKey
  {{- else }}
  value: {{ .Values.server.storage.s3.secretKey | quote }}
  {{- end }}
- name: S3_REGION
  value: {{ .Values.server.storage.s3.region | quote }}
{{- end -}}

{{/*
WebUI environment variables configuration
*/}}
{{- define "rustdok.webuiEnvVars" -}}
- name: NEXT_PUBLIC_RUSTDOK_API_URL
  value: "http://{{ .Values.server.name }}:{{ .Values.server.service.port }}"
- name: NEXT_PUBLIC_RUSTDOK_API_VERSION
  value: "v1"
{{- end -}}

{{/*
Server-specific environment variables configuration
*/}}
{{- define "rustdok.serverEnvVars" -}}
- name: RUSTDOK_WEBUI_URL
  {{- if .Values.webui.enabled }}
  value: "http://{{ .Values.webui.name }}:{{ .Values.webui.service.port }}"
  {{- else }}
  value: ""
  {{- end }}
{{- end -}} 