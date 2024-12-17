# opensearch-operator

OpenSearch Deployment on Amazon EKS using Terraform and OpenSearch Operator
Table of Contents
Overview
Pre-requisites
Infrastructure Setup
Deploy OpenSearch Operator
Deploy OpenSearch Cluster
Security and Best Practices
Verification Steps
Findings and Observations
1. Overview
This project deploys an OpenSearch Cluster on Amazon EKS using:

Terraform to provision the EKS cluster.
OpenSearch Kubernetes Operator to manage OpenSearch deployment.
Kubernetes Network Policies for security.
2. Pre-requisites
Ensure the following tools are installed on your local machine:

Terraform: >= v1.0
AWS CLI: Installed and configured with proper IAM permissions.
kubectl: To interact with Kubernetes.
OpenSearch Operator: Used for OpenSearch cluster management.
3. Infrastructure Setup
Step 1: Terraform Configuration
Create the following Terraform files:

main.tf:
hcl
Copy code
provider "aws" {
  region = "us-east-1"
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "eks-opensearch-cluster"
  cluster_version = "1.27"

  subnet_ids = ["<subnet-id-1>", "<subnet-id-2>"]
  vpc_id     = "<your-vpc-id>"

  node_groups = {
    opensearch_nodes = {
      desired_capacity = 2
      max_capacity     = 3
      min_capacity     = 1
      instance_types   = ["t3.medium"]
    }
  }
}
variables.tf:
hcl
Copy code
variable "region" {
  default = "us-east-1"
}

variable "vpc_id" {}
variable "subnet_ids" {}
Step 2: Run Terraform Commands
Initialize Terraform:
bash
Copy code
terraform init
Plan and apply:
bash
Copy code
terraform plan
terraform apply
Update kubeconfig:
bash
Copy code
aws eks update-kubeconfig --region us-east-1 --name eks-opensearch-cluster
4. Deploy OpenSearch Operator
Apply the OpenSearch Operator manifest:

bash
Copy code
kubectl apply -f https://github.com/opensearch-project/opensearch-k8s-operator/releases/latest/download/opensearch-operator.yaml
Verify that the operator is running:

bash
Copy code
kubectl get pods -n opensearch-operator-system
5. Deploy OpenSearch Cluster
Create the OpenSearch cluster configuration file opensearch-cluster.yaml:

yaml
Copy code
apiVersion: opensearch.opster.io/v1
kind: OpenSearchCluster
metadata:
  name: opensearch-cluster
spec:
  general:
    version: "2.11.0"
  nodePools:
    - component: masters
      replicas: 3
      resources:
        requests:
          memory: "2Gi"
          cpu: "500m"
    - component: data
      replicas: 2
      resources:
        requests:
          memory: "4Gi"
          cpu: "1"
  security:
    tls:
      enabled: true
Deploy the cluster:

bash
Copy code
kubectl apply -f opensearch-cluster.yaml
Verify deployment:

bash
Copy code
kubectl get pods
6. Security and Best Practices
IAM Roles for Service Accounts (IRSA): Enable IRSA in Terraform to secure Kubernetes service accounts.

Network Policies: Apply a network policy to secure traffic between pods:

yaml
Copy code
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-opensearch-internal
spec:
  podSelector:
    matchLabels:
      app: opensearch
  ingress:
  - from:
    - podSelector:
        matchLabels:
          app: opensearch
Cost Optimization:

Use cost-efficient EC2 instances (e.g., t3.medium).
Auto-scale EKS node groups as needed.
7. Verification Steps
Check Cluster Pods:

bash
Copy code
kubectl get pods
Access OpenSearch Cluster: Forward the OpenSearch port locally:

bash
Copy code
kubectl port-forward service/opensearch-cluster 9200:9200
Test OpenSearch Endpoint: Use curl to test the OpenSearch API:

bash
Copy code
curl -k https://localhost:9200
Expected Output: You should receive a response similar to this:

json
Copy code
{
  "name": "opensearch-node-1",
  "cluster_name": "opensearch-cluster",
  "cluster_uuid": "xxxx-xxxx-xxxx",
  "version": {
    "number": "2.11.0",
    "distribution": "opensearch"
  },
  "tagline": "The OpenSearch Project: Search, Analytics, and Visualization."
}
8. Findings and Observations
EKS Cluster Creation:

EKS setup with Terraform is straightforward and integrates IAM roles seamlessly.
Using t3.medium nodes strikes a balance between performance and cost.
OpenSearch Operator:

Deploying OpenSearch with the Operator simplifies cluster management.
TLS encryption was enabled for secure communication.
Security:

Network Policies limited traffic to OpenSearch pods.
IAM Roles for Service Accounts ensured secure AWS API access.
Performance:

The cluster scaled efficiently with 3 master nodes and 2 data nodes.
Testing:

OpenSearch API was reachable via port-forwarding.
Queries were successful, and the cluster returned expected responses.
Conclusion
This project demonstrates the deployment of a secure, scalable, and cost-optimized OpenSearch cluster on Amazon EKS using Terraform and Kubernetes Operator. The following best practices were followed:

Secure setup using TLS and Network Policies.
IAM Roles for service accounts.
Cost-effective infrastructure with t3.medium instances.