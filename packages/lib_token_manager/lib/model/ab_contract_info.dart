class ABContractInfo {
  late String contractAddress;

  ABContractInfo({required this.contractAddress});

  toJson() {
    return {'contractAddress': contractAddress};
  }

  factory ABContractInfo.fromJson(Map<String, dynamic> json) {
    return ABContractInfo(contractAddress: json['contractAddress']);
  }
}
