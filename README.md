# terraform-kubernetes-playground
Terraform used to deploy a 3-tier application in Kubernetes


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

Check the current context
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

The Docker images which are build in the example above are also available on Docker Hub.
It's a requirement that our Kubernetes cluster is able to pull the necessary images from an accessible image registry.

* lvthillo/movie-frontend
* lvthillo/movie-backend


