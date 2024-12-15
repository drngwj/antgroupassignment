#!/bin/bash

# 检查集群状态
echo "检查 Kubernetes 集群状态..."
kubectl cluster-info > /dev/null 2>&1
if [ $? -eq 0 ]; then
  echo "集群连接成功！"
else
  echo "无法连接到集群，开始修复..."

  # 启动 Minikube 集群（如果使用 Minikube）
  if command -v minikube &> /dev/null; then
    echo "启动 Minikube 集群..."
    minikube start
  else
    echo "Minikube 未安装，尝试使用其他 Kubernetes 环境..."
    exit 1
  fi

  # 设置正确的上下文
  echo "设置 Minikube 上下文..."
  kubectl config use-context minikube

  # 检查集群信息
  kubectl cluster-info
  if [ $? -eq 0 ]; then
    echo "集群已启动并连接成功！"
  else
    echo "无法连接到集群，请检查网络或 kubeconfig 配置。"
    exit 1
  fi
fi

# 更新应用镜像
echo "更新应用镜像..."
kubectl set image deployment/app app=ngweijiang/app:0508de2ca867f568e1a9ff965f4947b84f3690c5
if [ $? -eq 0 ]; then
  echo "镜像更新成功！"
else
  echo "更新镜像失败，请检查错误日志。"
  exit 1
fi

echo "完成所有操作！"

chmod +x setup_k8s.sh
./setup_k8s.sh
