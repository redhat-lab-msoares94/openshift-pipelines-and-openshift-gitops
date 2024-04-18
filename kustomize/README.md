# How this repo works
The main idea of this repository is use the Openshift Pipelines(Tekton) for CI and Openshift GitOps(Argo) for CD.

There are   projects that we need to this sample:
- hello-spring-dev
- hello-spring-prod
- spring-pipeline
- nexus
- sonarqube

### Deploy and create a Nexus instance
[NEXUS](https://github.com/msoares94/openshift-pipeline-tekton-and-openshift-gitops/blob/main/nexus/README.md)


### Deploy SonarQube
[SONARQUBE](https://github.com/msoares94/openshift-pipeline-tekton-and-openshift-gitops/blob/main/sonarqube/sonarqube.adoc)


### Create the springs projects.
- hello-spring-dev
- hello-spring-prod
- spring-pipeline

We're gonna use the *spring-pipeline* project to build and run the openshift pipeline, so for that we have to give the right permission for the service account *pipeline* then it will be able to execute the necessaries tasks on the other two springs projects.

```shell
    oc policy add-role-to-user \
    edit \
    system:serviceaccount:spring-pipeline:pipeline \
    --rolebinding-name=pipeline-edit \
    -n hello-spring-dev
```
```shell
    oc policy add-role-to-user \
    edit \
    system:serviceaccount:spring-pipeline:pipeline \
    --rolebinding-name=pipeline-edit \
    -n hello-spring-prod
```

Ok, without futher ado, we can finally start the Continuous Integration, so we're gonna create the pipeline as img below:

![Pipeline](https://github.com/msoares94/openshift-pipeline-tekton-and-openshift-gitops/blob/main/imgs/pipeline.png)

Now let's follow the steps below: 
1- Create a persistent volume for the workspace
```shell
oc apply -f https://raw.githubusercontent.com/msoares94/openshift-pipeline-tekton-and-openshift-gitops/main/pipelines-src/pvc.yaml
```
2- Create all required tasks
```shell
oc apply -f https://raw.githubusercontent.com/msoares94/openshift-pipeline-tekton-and-openshift-gitops/main/pipelines-src/task/sonarqube-scanner.yaml
oc apply -f https://raw.githubusercontent.com/msoares94/openshift-pipeline-tekton-and-openshift-gitops/main/pipelines-src/task/generate-tag.yaml
oc apply -f https://raw.githubusercontent.com/msoares94/openshift-pipeline-tekton-and-openshift-gitops/main/pipelines-src/task/update-kustomize-repo.yaml
```

3- Create a secret with the github credential
```shell
    oc create secret generic github-personal-access-token \
    --from-literal=username=${GITHUB_USER} \
    --from-literal=password=${GITHUB_TOKEN} \
    --type "kubernetes.io/basic-auth" \
    -n spring-pipeline
```
4- OpenShift pipelines associate credentials with URLs via an annotation on the secret
```shell
    oc annotate secret github-personal-access-token "tekton.dev/git-0=${GITHUB_URL}" -n spring-pipeline
```
5- Attach that secret to pipeline service account
```shell
    oc secrets link pipeline github-personal-access-token -n spring-pipeline
```

6- Let's do the same with nexus credentials
```shell
    oc create secret generic nexus-access \
   --from-literal=username=admin \
   --from-literal=password=admin123 \
   --type "kubernetes.io/basic-auth" \
   -n spring-pipeline

    # Annotate the secret to specify a container registry URL, you can use the service, but the ideia here was to use an external registry
    oc annotate secret nexus-access "tekton.dev/docker-0=${NEXUS_URL}" -n spring-pipeline

    # Link the secret to the pipeline service account
    oc secrets link pipeline nexus-access

    # Quay.io
    oc create secret docker-registry quay.io --docker-username=${USERNAME} --docker-server=quay.io --docker-email=${EMAIL} --docker-password=${PASSWORD}
    
    oc secrets link default quay.io --for=pull --namespace=spring-pipeline
    oc secrets link pipeline quay.io --namespace=spring-pipeline
```

7- Create the pipeline
```shell
    oc apply -f https://raw.githubusercontent.com/msoares94/openshift-pipeline-tekton-and-openshift-gitops/main/pipelines-src/pipeline/pipeline-hello-service-spring-dev-ci.yaml
```

### Triggers - TKN
https://dzone.com/articles/building-a-multi-feature-pipeline-with-openshift-pipelines