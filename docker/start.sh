#!/bin/bash

# Dolphie Docker 启动脚本
CONFIG_FILE="./rds.conf"

# 清理旧容器
docker ps -a --format '{{.Names}}' | grep -q "^dolphie-ui$" && \
    docker stop dolphie-ui && docker rm dolphie-ui

# 启动新容器
echo "拉取镜像并启动容器..."
docker pull izerui/dolphie-ui
docker run -d -p 7681:7681 \
    -v "$(pwd)/$CONFIG_FILE":/home/linuxbrew/rds.conf \
    --name dolphie-ui \
    izerui/dolphie-ui \
    ttyd -p 7681 --writable -c admin:admin123 dolphie --config-file rds.conf --hostgroup rds_cluster --tab-setup

# 检查启动结果
sleep 2
if docker ps --format '{{.Names}}' | grep -q "^dolphie-ui$"; then
    echo "启动成功! 访问: http://localhost:7681 (admin:admin123)"
else
    echo "启动失败! 查看日志: docker logs dolphie-ui"
    exit 1
fi