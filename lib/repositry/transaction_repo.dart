import 'package:ab_wallet/network/api.dart';
import 'package:ab_wallet/repositry/model/transaction_mode.dart';
import 'package:lib_network/impl/ab_api_network_impl.dart';

class TransactionRepo {
  // https://mainnet.infura.io/v3/3e92ec988e004b09ad2ad8a677d5e0ef
  Future<dynamic> getTransactionById(String id) async {
    return Api.post("https://api.newtonproject.org/api/v1/health/", {});
  }
}
