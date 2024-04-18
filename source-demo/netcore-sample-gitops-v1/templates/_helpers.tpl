{{/*
Selector labels
*/}}
{{- define "argocd.defaultLabels" -}}
argocd.argoproj.io/managed-by: openshift-gitops
{{- end }}