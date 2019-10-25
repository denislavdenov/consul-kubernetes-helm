## Learning deploy consul on k8s with helm
### https://learn.hashicorp.com/consul/day-1-operations/kubernetes-deployment-guide

This is a learning activity following the guide in the link above.
Guide is not very clear and actually this code and isntructions are the only workaround 
I found to make `helm install` command work at all.


Currently pods are deployed, but never leave pending status.

```

NAME                     READY   STATUS    RESTARTS   AGE
consul-consul-8gtzj      0/1     Running   0          10m
consul-consul-server-0   0/1     Pending   0          10m
consul-consul-server-1   0/1     Pending   0          10m
consul-consul-server-2   0/1     Pending   0          10m
[centos@ip-172-31-38-136 consul-helm]$ 

```

## Steps to reproduce:

1. Clone 
2. Create a `terraform.tfvars` file and fill in those variables:

```

aws_access_key = ""
aws_secret_key = ""

```

3. Adjust the security group as per your AWS account.
4. `terraform init` `terraform apply`

Once both servers are up and running ssh into both of them.

Executed manually with regular user:

Onto master:

5. sudo kubeadm init --pod-network-cidr=192.168.0.0/16 --kubernetes-version=v1.15.3 > /home/centos/kubetoken.txt
6. mkdir -p $HOME/.kube
7. sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
8. sudo chown $(id -u):$(id -g) $HOME/.kube/config
9. kubectl apply -f https://docs.projectcalico.org/v3.8/manifests/calico.yaml
10. Copy the command with token for joining the other cluster node and execute it on second server.


11. git clone https://github.com/hashicorp/consul-helm.git
12. kubectl create serviceaccount --namespace kube-system tiller
13. kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
14. helm init --upgrade --service-account tiller

Note: If those commands are not executed exactly in that way, helm is complaining that tiller is not installed

Note2: In learning guide is mentioned that we can change values.yaml as per our needs, but if we do so, errors are reported:

```
Error: render error in "consul/templates/tests/test-runner.yaml": template: consul/templates/tests/test-runner.yaml:1:14: executing "consul/templates/tests/test-runner.yaml" at <.Values.tests.enabled>: nil pointer evaluating interface {}.enabled

```
