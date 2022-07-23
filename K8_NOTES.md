# Come riavviare una distribuzione in Kubernetes
```
kubectl get deployment

kubectl rollout restart deployment <deployment_name>
```
# Creating a Deployment for a Spring Boot application
In Kubernetes, the recommended way is to describe an object’s desired state in a **manifest** file, typically specified in YAML format. You can then apply the manifest, and Kubernetes will create and maintain the object for you.
A Kubernetes manifest usually comprises four main sections:

* **apiVersion** defines the versioned schema of the specific object representation. Core resources such as Pods or 
  Services follow a versioned schema composed of only a version number (such as v1). Other resources like Deployments or ReplicaSet follow a versioned schema consisting of a group and a version number (for example, apps/v1). If in doubt about which version to use, you can refer to the Kubernetes documentation (kubernetes.io/docs) or use *the kubectl explain <object_name>* command to get more information about the object, including the API version to use.
* **kind** is the type of Kubernetes object you want to create, such as Pod, ReplicaSet, Deployment, or Service. You can 
  use the kubectl api-resources command to list all the objects supported by the cluster.
* **metadata** provides details about the object you want to create, including the name and a set of labels (key/value 
  pairs) used for categorization. For example, you can instruct Kubernetes to replicate all the objects with a specific label attached.
* **spec** is a section specific to each object type and is used to declare the desired configuration.
Ex.:
```
apiVersion: apps/v1                 (1)
kind: Deployment                    (2)
metadata:
    name: catalog-service           (3)
    labels:                         (4)
        app: catalog-service        (5)
```
(1) The API version for Deployment objects.
(2) The type of object to create.
(3) The name of the Deployment.
(4) A set of labels attached to the Deployment.
(5) This Deployment is labeled with "app=catalog-service".

# Service discovery and load balancing
We need to keep track of all the service instances running and store that information in a **service registry**.
Whenever an application needs to call a backing service, it performs a lookup in the registry to know which IP address to call. If multiple instances are available, a strategy is applied to distribute load balancing the workload across
them.

## Server-side service discovery
It move the responsibility to the deployment platform so that developers can focus on the business logic and rely on the platform for providing all the necessary functionality for service discovery and load balancing. Such solutions automatically register and deregister application instances and rely on a load balancer component to route any
incoming request to one of the available instances according to some specific strategy. In this case, the application doesn’t need to interact with the service registry, which is updated and managed by the platform.

The Kubernetes implementation of this service discovery pattern is based on Service objects. A **Service** is an abstract way to expose an application running on a set of Pods as a network service.
A Service object is an abstraction targeting a set of Pods (typically using labels) and defining the access policy. When an application needs to contact a Pod exposed by a Service object, it can use the Service name instead of calling the Pod directly.

After resolving the Service name to its IP address, Kubernetes relies on a proxy (called kube-proxy) which intercepts the connection to the Service object and forwards the request to one of the Pods targeted by the Service. The proxy knows all the replicas available and adopts a load balancing strategy depending on the type of Service and the proxy configuration. In this step, there is no DNS resolution involved, solving the problems I explained earlier.

## Exposing Spring Boot applications with Kubernetes Services
There are different types of Services depending on which access policy you want to enforce for the application. The default and most common type is called ClusterIP and exposes a set of Pods to the cluster. It’s what makes it possible for Pods to communicate with each other.

Four pieces of information characterize a ClusterIP Service:
* the label used to match all the Pods that should be targeted and exposed by the Service (**selector**);
* the network **protocol** used by the Service;
* the **port** on which the Service is listening (we’re going to use port 80 for all Services);
* the **targetPort**, that is the port exposed by the targeted Pods to which Service will forward requests.
Ex.:
```
apiVersion: v1              (1)
kind: Service               (2)
metadata:
  name: catalog-service     (3)
  labels:
    app: catalog-service    (4)
spec:
  type: ClusterIP           (5)
  selector:
    app: catalog-service    (6)
ports:
- protocol: TCP             (7)
  port: 80                  (8)
  targetPort: 9001          (9)
```

(1) The API version for Service objects.
(2) The type of object to create.
(3) The name of the Service. It must be a valid DNS name.
(4) A label attached to the Service.
(5) The type of Service.
(6) The label used to match the Pods to target and expose.
(7) The network protocol used by the Service.
(8) The port exposed by the Service.
(9) The port exposed by the Pods targeted by the Service.

To get the info of an specific service, run the command: 
**kubectl get svc -l app=<service_name>**

```
kubectl get svc -l app=catalog-service

NAME            TYPE        CLUSTER-IP      EXTERNAL-IP     PORT(S)     AGE
catalog-service ClusterIP   10.96.155.151   <none>          9001/TCP    11s
```

Since it’s of type ClusterIP, the Service makes it possible for other Pods within the cluster to communicate with the Catalog Service application, either using its IP address (called cluster IP) or through its name.
To expose the application to the outside of the cluster so that we can test it, you’ll rely on the port forwarding feature offered by Kubernetes to expose an object (in this case, a Service) to your local machine.
```
kubectl port-forward service/catalog-service 9001:80
Forwarding from 127.0.0.1:9001 -> 9001
Forwarding from [::1]:9001 -> 9001
```

# Local Kubernetes development with Skaffold and Octant
Set up a local Kubernetes development workflow to automate steps like building images and applying manifests to a Kubernetes cluster.

## Defining a development workflow on Kubernetes with Skaffold
Skaffold is a tool developed by Google that "handles the workflow for building, pushing and deploying your application, allowing you to focus on what matters most: writing code". You can find instructions on how to install it on the official website: **skaffold.dev**.

The goal is to design a workflow that will automate the following steps for you:
* packaging a Spring Boot application as a container image using Cloud Native Buildpacks;
* uploading the image to a Kubernetes cluster created with kind;
* creating all the Kubernetes objects described in the YAML manifests;
* enabling the port-forward functionality to access applications from your local computer;
* collecting the logs from the application and showing them in your console.

### CONFIGURING SKAFFOLD FOR BUILDING AND DEPLOYING
You can initialize Skaffold in a new project using the **skaffold init** command and choosing a strategy for building the application. For Catalog Service, we want to use Cloud Native Buildpacks. Open a Terminal window, navigate to the project root folder, and run the following command.
```
skaffold init --XXenableBuildpacksInit
```

The resulting configuration will be saved in a **skaffold.yaml** file created in your project root folder. Rename it to **skaffold.yml**.
The **build** part describes how you want to package the application. The **deploy** part specifies what you want to deploy. In this case, you can configure it to deploy Catalog Service from kubectl, applying the manifests you defined previously.
```
apiVersion: skaffold/v2beta28                     (1)
kind: Config                                      (2)
metadata:
  name: catalog-service
build:
  artifacts:
  - image: ernestoacostacuba/catalog-service      (3)
    jib:
      args:
        - -Pjib
        - -DskipTests=true
  tagPolicy:
    gitCommit: {
                 variant: AbbrevTreeSha,
                 ignoreChanges: true
    }

  local:
    push: false

deploy:
  kubectl:
    manifests:
    - k8s/deployment.yml

```

### DEPLOYING APPLICATIONS TO KUBERNETES WITH SKAFFOLD
To run Skaffold in development mode:
```
skaffold dev --no-prune=false --cache-artifacts=false --no-prune-children=false --port-forward
```

The **--port-forward** flag will set up automatic port forwarding to your local machine. Information on which port is forwarded is printed out at the end of the task.
Unless it’s not available, Skaffold will use the port you defined for the Service object.
When you’re done working with the application, you can terminate the Skaffold process (Ctrl+C), and all the Kubernetes objects will get deleted automatically.
Another option for running Skaffold is using the **skaffold run** command. skaffold run It works like the development mode, but it doesn’t provide live-reload nor clean up when it terminates. It’s typically used in a CI/CD pipeline.