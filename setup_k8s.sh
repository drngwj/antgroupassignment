#!/bin/bash

set -e

# Step 1: Start Minikube
echo "Starting Minikube..."
minikube start --nodes=2 --cpus=4 --memory=4g

# Step 2: Configure kubectl
echo "Configuring kubectl context..."
kubectl config use-context minikube

# Verify Cluster Connection
echo "Verifying Kubernetes cluster..."
kubectl cluster-info

# Step 3: Create Deployment YAML (inline for simplicity)
echo "Creating Deployment YAML..."
cat <<EOF > deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: app
  template:
    metadata:
      labels:
        app: app
    spec:
      containers:
      - name: app
        image: ngweijiang/app:efd9b303b9321395f55e39428835f0a3744353f9
        ports:
        - containerPort: 80
EOF

# Step 4: Apply Deployment
echo "Deploying application..."
kubectl apply -f deployment.yaml

# Step 5: Expose the Deployment
echo "Exposing the deployment..."
kubectl expose deployment app --type=NodePort --port=80

# Step 6: Verify Deployment and Service
echo "Verifying deployment and service..."
kubectl get deployments
kubectl get services

# Step 7: Fetch Application URL
echo "Fetching application URL..."
APP_URL=$(minikube service app --url)
echo "Application is accessible at: $APP_URL"

# Step 8: Rolling Update
echo "Performing rolling update..."
kubectl set image deployment/app app=ngweijiang/app:latest --record
kubectl rollout status deployment/app

# Step 9: Rollback (Optional)
# Uncomment the following lines if you want to demonstrate rollback
# echo "Performing rollback..."
# kubectl rollout undo deployment/app

# Step 10: Cleanup Resources (Optional)
# Uncomment the following lines to clean up resources
# echo "Cleaning up resources..."
# kubectl delete deployment app
# kubectl delete service app
# minikube delete

echo "All steps completed successfully!"
