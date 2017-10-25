# Kubernetes Workshop - Extension: OMS

## Creating an OMS workspace

Create a new OMS workspace through the Azure portal:
- Let's assume we call the resource "gbbmonitoring" with pricing tier "per node". 
- Make note of both the `Workspace ID` and `Primary Key` in the Advanced pane. 

## Installing the OMS agent on the cluster

There are multiple ways to go about this:
- through the instructions on the github repo: https://github.com/Microsoft/OMS-docker/tree/master/Kubernetes 
- or using a Helm chart: https://kubeapps.com/charts/stable/msoms

To [install Helm](https://github.com/kubernetes/helm/blob/master/docs/install.md):
~~~ 
// on Mac:
brew cask install helm

// on Linux (do not try this at home):
curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | bash
~~~

Using helm, getting the OMS agents installed is as simple as:
~~~
helm install --name omsagent stable/msoms
helm upgrade omsagent \
--set omsagent.secret.wsid=[YOUR-WSID-GOES-HERE] \
--set omsagent.secret.key=[YOUR-SECRET-KEY-GOES-HERE] \
stable/msoms
~~~

## Monitoring the application

Add the Container Monitoring Solution to your workspace and give it some time to start collecting the information which is being sent by the agents.

