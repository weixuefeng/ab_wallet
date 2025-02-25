# force_wallet

基于组件化进行开发，所有组件都使用组件库内容

## 组件说明

创建组件脚本: `lib_xxx`

```
./scripts/create_package.sh ${组件库名称}
```

### `lib_base`: 基础库

提供基础能力，包括：
- 日志组件: `ABLogger`


### `lib_network`: 网络库

提供网络请求能力，包括：
- 网络请求: `ABApiNetwork` 封装请求自己服务的 api，包括签名认证

### `lib_router`: 路由库



###  `lib_uikit`: ui 组件库

TODO://

### `lib_storage`: 存储库
提供数据存储，包括

- 普通键值对存储: `GTStorageKV`
- 安全加密存储: `ABStorageSecureKV`


### `lib_wallet_manager`: 钱包管理


### `lib_chain_manager`: 链管理


### `lib_token_manager`: 代币管理


### `lib_wallet_manager`: 钱包管理 

