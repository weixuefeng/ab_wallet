import 'package:ab_wallet/network/api.dart';

class TransactionRepo {
  // https://mainnet.infura.io/v3/3e92ec988e004b09ad2ad8a677d5e0ef
  Future<dynamic> getTransactionById(String id) async {
    return Api.post("https://api.newtonproject.org/api/v1/health/", {});
  }
}
