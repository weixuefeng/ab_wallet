class TransactionModel {
  TransactionModel({
    required this.blockHash,
    required this.blockNumber,
    required this.confirmations,
    required this.contractAddress,
    required this.cumulativeGasUsed,
    required this.from,
    required this.gas,
    required this.gasPrice,
    required this.gasUsed,
    required this.hash,
    required this.input,
    required this.isError,
    required this.nonce,
    required this.timeStamp,
    required this.to,
    required this.transactionIndex,
    required this.txreceiptStatus,
    required this.value,
  });
  late final String blockHash;
  late final String blockNumber;
  late final String confirmations;
  late final String contractAddress;
  late final String cumulativeGasUsed;
  late final String from;
  late final String gas;
  late final String gasPrice;
  late final String gasUsed;
  late final String hash;
  late final String input;
  late final String isError;
  late final String nonce;
  late final String timeStamp;
  late final String to;
  late final String transactionIndex;
  late final String txreceiptStatus;
  late final String value;

  TransactionModel.fromJson(Map<String, dynamic> json) {
    blockHash = json['blockHash'];
    blockNumber = json['blockNumber'];
    confirmations = json['confirmations'];
    contractAddress = json['contractAddress'];
    cumulativeGasUsed = json['cumulativeGasUsed'];
    from = json['from'];
    gas = json['gas'];
    gasPrice = json['gasPrice'];
    gasUsed = json['gasUsed'];
    hash = json['hash'];
    input = json['input'];
    isError = json['isError'];
    nonce = json['nonce'];
    timeStamp = json['timeStamp'];
    to = json['to'];
    transactionIndex = json['transactionIndex'];
    txreceiptStatus = json['txreceipt_status'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['blockHash'] = blockHash;
    _data['blockNumber'] = blockNumber;
    _data['confirmations'] = confirmations;
    _data['contractAddress'] = contractAddress;
    _data['cumulativeGasUsed'] = cumulativeGasUsed;
    _data['from'] = from;
    _data['gas'] = gas;
    _data['gasPrice'] = gasPrice;
    _data['gasUsed'] = gasUsed;
    _data['hash'] = hash;
    _data['input'] = input;
    _data['isError'] = isError;
    _data['nonce'] = nonce;
    _data['timeStamp'] = timeStamp;
    _data['to'] = to;
    _data['transactionIndex'] = transactionIndex;
    _data['txreceipt_status'] = txreceiptStatus;
    _data['value'] = value;
    return _data;
  }
}
