import 'package:lib_network/impl/ab_api_network_impl.dart';

class Api {
  // 在这一层做数据解析
  static final dio = ABApiNetworkImpl();

  static Future<dynamic> get(String url) async {
    return dio.get(path: url);
  }

  static Future<dynamic> post(String path, Map<String, dynamic> params) async {
    return dio.post(path: path, parameters: params);
  }
}
