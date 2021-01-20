# Kubernetes playground
- sping up multi-node Kubernetes cluster using Vagrant
- Use Terraform to deploy a 3-tier application in Kubernetes
- Use ArgoCD to deploy the 3-tier application (use deploymentfiles)


## Spin up a Kubernetes cluster
You need a working Kubernetes cluster to deploy this setup.
One way to create a local (free) multi-node cluster is by using the following repository.
This will spin up a Kubernetes cluster by using Vagrant and Ansible.

```
$ git clone git@github.com:lvthillo/vagrant-ansible-kubernetes.git
$ cd vagrant-ansible-kubernetes
$ vagrant up
$ vagrant scp k8s-master:/home/vagrant/.kube/config ~/.kube/config
$ kubectl get nodes
NAME         STATUS   ROLES                  AGE     VERSION
k8s-master   Ready    control-plane,master   4h46m   v1.20.0
node-1       Ready    <none>                 4h44m   v1.20.0
node-2       Ready    <none>                 4h41m   v1.20.0
```

Check the current context. This context will be used in the Terraform provider configuration.
```
$ kubectl config current-context
kubernetes-admin@kubernetes
```

## Deploy application locally
I will deploy a 3-tier application which can be found [here](https://github.com/lvthillo/angular-go-mongodb)
```
$ git clone https://github.com/lvthillo/angular-go-mongodb.git
$ cd angular-go-mongodb
$ docker-compose up -d
```

## Deploy application in Kubernetes
The Docker images which are build in the example above are also available on Docker Hub.
It's a requirement that our Kubernetes cluster is able to pull the necessary images from an accessible image registry.

* lvthillo/movie-frontend
* lvthillo/movie-backend

The frontend image contains a configuration file (environment.k8s.ts) which points to the backend URL:NodePort
I used terraform to deploy the application (frontend, backend and non-persistent db). 
```
$ cd terraform
$ terraform init
$ terraform apply
```

Check the running application:
```
$ kubectl get pods -n my-demo-namespace
NAME                             READY   STATUS    RESTARTS   AGE
backend-67f4b58957-n7vnv         1/1     Running   0          25s
frontend-6b8f459d7f-6jkjd        1/1     Running   0          29s
mongo-express-5cd59c5cd9-hkcrx   1/1     Running   0          25s
mongodb-bd5769c45-4zdt7          1/1     Running   0          29s

$ kubectl get deployments -n my-demo-namespace
NAME            READY   UP-TO-DATE   AVAILABLE   AGE
backend         1/1     1            1           72s
frontend        1/1     1            1           76s
mongo-express   1/1     1            1           72s
mongodb         1/1     1            1           76s
```

Check services. We had to expose the backend service because Angular will access it from within the browser.

## Deploy ArgoCD
```
$ kubectl get svc -n my-demo-namespace
NAME                TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
svc-backend         NodePort    10.105.145.228   <none>        8080:32001/TCP   3m28s
svc-frontend        NodePort    10.106.142.177   <none>        80:32002/TCP     3m33s
svc-mongo-express   NodePort    10.100.19.174    <none>        8081:32000/TCP   3m29s
svc-mongodb         ClusterIP   10.101.25.154    <none>        27017/TCP        3m45s
```

```
$ kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
$ kubectl port-forward svc/argocd-server -n argocd 8080:443
```

Visit localhost:8080. The username is admin. To get the password run:
```
$ kubectl get pods -n argocd -l app.kubernetes.io/name=argocd-server -o name | cut -d'/' -f 2
argocd-server-846cf6844-bzrp9
```

- [ ] Introduce secrets instead of configmaps
- [ ] Introduce liveness and readiness probes to control pod startup
- [ ] Create a LB + introduce ingress