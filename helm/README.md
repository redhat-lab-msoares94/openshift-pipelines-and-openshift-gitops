# openshift-pipelines-and-openshift-gitops
OpenShift Pipelines and OpenShift GitOps

# pipelines-gitops

oc adm policy add-role-to-group  <role> <Group_name>  -n  <Project-name>

oc adm policy remove-cluster-role-from-user clustertasks system:serviceaccount:openshift-gitops:openshift-gitops-argocd-application-controller

oc adm policy remove-cluster-role-from-user create system:serviceaccount:openshift-gitops:openshift-gitops-argocd-application-controller

oc adm policy add-cluster-role-to-user admin system:serviceaccount:openshift-gitops:openshift-gitops-argocd-application-controller

oc adm policy remove-cluster-role-from-user admin system:serviceaccount:openshift-gitops:openshift-gitops-argocd-application-controller

oc adm policy add-cluster-role-to-user cluster-admin system:serviceaccount:openshift-gitops:openshift-gitops-argocd-application-controller


apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: tekton-cluster-task-creator
rules:
- apiGroups: ["tekton.dev"]
  resources: ["clustertasks"]
  verbs: ["create", "get", "list", "watch", "update", "patch", "delete"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: tekton-cluster-task-creator-binding
subjects:
- kind: ServiceAccount
  name: openshift-gitops-argocd-application-controller
  namespace: openshift-gitops # Verifique se o namespace está correto
roleRef:
  kind: ClusterRole
  name: tekton-cluster-task-creator
  apiGroup: rbac.authorization.k8s.io
