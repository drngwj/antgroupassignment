#!/bin/bash

# Step 1: 检查集群状态
echo "检查 Kubernetes 集群状态..."
kubectl cluster-info > /dev/null 2>&1
if [ $? -eq 0 ]; then
  echo "集群连接成功！"
else
  echo "无法连接到集群，检查集群是否已启动。"

  # Step 2: 启动 Minikube（如果使用 Minikube）
  if command -v minikube &> /dev/null; then
    echo "启动 Minikube 集群..."
    minikube start
  else
    echo "Minikube 未安装，您可以通过 Homebrew 安装它，或者使用其他 Kubernetes 提供商。"
    exit 1
  fi

  # Step 3: 确保正确配置 Kubernetes 上下文
  echo "设置 Kubernetes 上下文..."
  kubectl config use-context minikube

  # Step 4: 验证集群连接
  kubectl cluster-info
  if [ $? -eq 0 ]; then
    echo "集群已启动并连接成功！"
  else
    echo "无法连接到集群。请检查集群配置。"
    exit 1
  fi
fi

# Step 5: 更新应用镜像
echo "更新应用镜像..."
kubectl set image deployment/app app=ngweijiang/app:0508de2ca867f568e1a9ff965f4947b84f3690c5
if [ $? -eq 0 ]; then
  echo "镜像更新成功！"
else
  echo "更新镜像失败，请检查错误日志。"
  exit 1
fi

echo "完成所有操作！"
