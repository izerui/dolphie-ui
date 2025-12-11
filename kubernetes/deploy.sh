#!/bin/bash

echo "部署 Dolphie UI 到 Kubernetes..."
kubectl apply -f dolphie-ui.yaml

# 等待部署完成
kubectl wait --for=condition=available --timeout=60s deployment/dolphie-ui -n platform && \
echo "部署成功!" && \
echo "=== 访问信息 ===" && \
INGRESS_HOST=$(kubectl get ingress dolphie-ui-ingress -n platform -o jsonpath='{.spec.rules[0].host}' 2>/dev/null) && \
[ ! -z "$INGRESS_HOST" ] && echo "访问地址: https://$INGRESS_HOST" && \
echo "用户名: admin, 密码: admin123"