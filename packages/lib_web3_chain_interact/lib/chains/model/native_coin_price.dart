// {
// "code": 0,
// "message": "success",
// "data": [
// {
// "chain": "ton",
// "symbol": "TON",
// "decimal": 9,
// "current_price": "6.034794232941249"
// },
// {
// "chain": "sui",
// "symbol": "SUI",
// "decimal": 9,
// "current_price": "4.765518170368709"
// },
// {
// "chain": "eth",
// "symbol": "ETH",
// "decimal": 18,
// "current_price": "4022.7794335144445"
// }
// ]
// }

class NativeCoinPriceModel {
  final String chain;
  final String symbol;
  final int decimal;
  final String currentPrice;

  NativeCoinPriceModel({
    required this.chain,
    required this.symbol,
    required this.decimal,
    required this.currentPrice,
  });

  factory NativeCoinPriceModel.fromJson(Map<String, dynamic> json) => NativeCoinPriceModel(
        chain: json['chain'].toString(),
        symbol: json['symbol'].toString(),
        decimal: int.parse(json['decimal'].toString()),
        currentPrice: json['current_price'].toString(),
      );
}

class NativeCoinPriceListModel {
  final List<NativeCoinPriceModel> data;

  NativeCoinPriceListModel({
    required this.data,
  });

  factory NativeCoinPriceListModel.fromJsonList(List<Map<String, dynamic>> json) {
    final data = json
        .map(
          (e) => NativeCoinPriceModel(
            chain: e['chain'].toString(),
            symbol: e['symbol'].toString(),
            decimal: int.parse(e['decimal'].toString()),
            currentPrice: e['current_price'].toString(),
          ),
        )
        .toList();

    return NativeCoinPriceListModel(data: data);
  }
}
