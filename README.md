# force_wallet

基于组件化进行开发，所有组件都使用组件库内容

## 定义
在本系统中，概念定义如下:

`链`: 一个区块链网络，如 `blockchain`、`ethereum`、`polygon`、`abchain` 等, 代码体现 `ABCahinInfo`.


`代币`: 一个链上的资产，如 `ETH`、`BTC`、`AB` 等, 一个链上可以有多种代币, 代码体现 `ABTokenInfo`.

`钱包`: 一个钱包可以管理多个链，一个链可以有多个钱包

`账户`: 一个钱包中的一个账户，一个账户可以有多个代币

`交易`: 一个账户之间的资产转移

`签名`: 一个交易的签名

`广播`: 一个交易的广播

`查询`: 查询一个账户的资产

`备份`: 备份一个钱包

`恢复`: 恢复一个钱包

`导入`: 导入一个账户

`导出`: 导出一个账户

`删除`: 删除一个账户

`修改`: 修改一个账户

`创建`: 创建一个账户

`转账`: 一个账户向另一个账户转账

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

### 钱包数据库结构

| Field | Type | Desc | 
|:-:|:-:|:-:|
| ||