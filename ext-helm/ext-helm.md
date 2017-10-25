# Kubernetes Workshop - Extension: Helm

## Installing Helm

Also [see here](https://docs.helm.sh/using_helm/#installing-helm)

~~~sh
# on mac:
brew install kubernetes-helm

# on linux (do not try this at home - not safe!) :
curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | bash

# on windows:
# install from here: https://github.com/kubernetes/helm/releases

~~~

Initialize Helm:

~~~sh
helm init
~~~

## Creating a Helm chart

A new empty structure from which we can bootstrap writing our Helm chart can be created by executing:

~~~sh
helm create myvote  # create a new empty chart called "myvote"
~~~

To start off clean, delete the contents of the `myvote/templates` directory.  The structure that should leave you with looks like this:

~~~
.
├── Chart.yaml
├── charts
├── templates
└── values.yaml
~~~

Edit the Chart.yaml file into something like this:

~~~yaml
# Chart.yaml
apiVersion: v1
description: A Helm chart for our voting app
name: myvote
version: 0.1.0
~~~ 

Add a template to deploy our voting backend, based on a Redis image:

~~~yaml
# azurevote-back-deploy.yaml
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: {{ .Release.Name }}-azurevote-back
spec:
  replicas: 1
  template:
    metadata:
      labels:
        editor: vscode
        app: {{ .Release.Name }}-azure-vote-back
    spec:
      containers:
      - name: redis
        image: redis
        ports:
        - containerPort: 6379
          name: redis
~~~

Notice the "moustache braces" which inject the name of our release into the template, ensuring unique and recognizable deployment names.

Add the template which exposes our Redis backend internally to the cluster:

~~~yaml
# azurevote-back-svc.yaml
kind: Service
apiVersion: v1
metadata:
  name:  {{ .Release.Name }}-azurevote-back-svc
spec:
  selector:
    app:  {{ .Release.Name }}-azure-vote-back
  type: ClusterIP
  ports:
  - name:  redis
    port:  6379
    targetPort:  redis
~~~

Add the template for deploying our frontend:

~~~yaml
# azurevote-front-deploy.yaml
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: {{ .Release.Name }}-azurevote-front
spec:
  replicas: 2
  template:
    metadata:
      labels:
        editor: vscode
        app: {{ .Release.Name }}-azure-vote-front
    spec:
      containers:
      - name: azure-vote
        image: microsoft/azure-vote-front:redis-v1
        env:
        - name:  REDIS
          value:  {{ .Release.Name }}-azurevote-back-svc
        ports:
        - containerPort:  80
          name:  http
~~~

... and finally, finish by adding the service to expose the frontend to the public internet:

~~~yaml
# azurevote-front-svc.yaml
kind: Service
apiVersion: v1
metadata:
  name:  {{ .Release.Name }}-azurevote-front-svc
spec:
  selector:
    app:  {{ .Release.Name }}-azure-vote-front
  type:  LoadBalancer
  ports:
  - name:  http
    port:  80
    targetPort:  http
~~~

## Installing a Helm chart

Installing the complete application now becomes super easy, as it is packaged in a single Helm chart.  Install it like this:

~~~sh
helm install --name myvotingapp ./myvote
~~~

Verify that it has been installed:
~~~sh
helm ls            # list the installed releases; should list "myvote"
kubectl get pods   # list the pods that our release installed
kubectl get svc    # make note of the public ip and try browsing it
~~~
