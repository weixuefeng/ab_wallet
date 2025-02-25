import 'package:dio/dio.dart';
import 'package:lib_network/interface/ab_api_network.dart';

class ABApiNetworkImpl extends ABApiNetwork {
  ABApiNetworkImpl._internal();

  static final ABApiNetworkImpl _instance = ABApiNetworkImpl._internal();

  factory ABApiNetworkImpl() {
    return _instance;
  }

  static final Dio _dio = _createDio();

  static Dio _createDio() {
    var options = BaseOptions(
      connectTimeout: Duration(seconds: 60),
      receiveTimeout: Duration(seconds: 60),
    );
    return Dio(options);
  }

  @override
  Future<Response<T>> get<T>({required String path}) {
    return _dio.get(path);
  }

  @override
  Future<Response<T>> post<T>({
    required String path,
    required Map<String, dynamic> parameters,
  }) {
    return _dio.post(path, data: parameters);
  }
}
