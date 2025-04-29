# openshift-pipelines-and-openshift-gitops
OpenShift Pipelines and OpenShift GitOps

# pipelines-gitops

oc adm policy add-role-to-group  <role> <Group_name>  -n  <Project-name>

oc adm policy remove-cluster-role-from-user clustertasks system:serviceaccount:openshift-gitops:openshift-gitops-argocd-application-controller

oc adm policy remove-cluster-role-from-user create system:serviceaccount:openshift-gitops:openshift-gitops-argocd-application-controller

oc adm policy add-cluster-role-to-user admin system:serviceaccount:openshift-gitops:openshift-gitops-argocd-application-controller

oc adm policy remove-cluster-role-from-user admin system:serviceaccount:openshift-gitops:openshift-gitops-argocd-application-controller

oc adm policy add-cluster-role-to-user cluster-admin system:serviceaccount:openshift-gitops:openshift-gitops-argocd-application-controller

#
oc adm policy add-scc-to-user privileged -z pipeline -n apps-dev

oc adm policy add-cluster-role-to-user cluster-admin system:serviceaccount:openshift-gitops:openshift-gitops-argocd-application-controller

# Colocar esse trecho no manifesto do recurso Application do ArgoCD, que gerencia o Helm
ignoreDifferences:
  - group: ""
    kind: Secret
    name: git-auth-.*
    namespace: apps-dev
    jsonPointers:
      - /data