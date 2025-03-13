#!/bin/bash

echo "begin:根据 .arb 文件生成本地化代码"

# 可以直接运行该flutter 命令
flutter pub run intl_utils:generate

echo "end:生成本地化代码完成"