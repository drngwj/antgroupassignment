#!/bin/bash

# 检查 Kubernetes 集群状态
echo "检查 Kubernetes 集群状态..."
kubectl cluster-info > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "无法连接到 Kubernetes 集群，尝试修复配置..."

  # 启动 Minikube 集群（如果使用 Minikube）
  if command -v minikube &> /dev/null; then
    echo "启动 Minikube 集群..."
    minikube start
    minikube update-context
  elif command -v kind &> /dev/null; then
    echo "启动 Kind 集群..."
    kind create cluster
  else
    echo "没有找到 Minikube 或 Kind，请检查 Kubernetes 集群是否已启动。"
    exit 1
  fi
fi

# 验证集群连接
kubectl cluster-info > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "仍然无法连接到集群，请手动检查 kubeconfig 配置。"
  exit 1
else
  echo "成功连接到 Kubernetes 集群！"
fi

# 尝试更新应用镜像
echo "更新应用镜像..."
kubectl set image deployment/app app=ngweijiang/app:efd9b303b9321395f55e39428835f0a3744353f9
if [ $? -eq 0 ]; then
  echo "镜像更新成功！"
else
  echo "镜像更新失败，请检查错误日志。"
  exit 1
fi
