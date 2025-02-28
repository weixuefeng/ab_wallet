#!/bin/bash

# 检查是否提供了参数
if [ -z "$1" ]; then
  echo "请提供文件夹名称作为参数。"
  exit 1
fi

# 进入 packages 文件夹
cd packages/

# 创建文件夹
mkdir -p $1

cd $1

# 创建 flutter package
flutter create -t plugin --org org.ab.newpay.$1 --platforms android,ios,web .