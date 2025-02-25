import 'package:dio/dio.dart';

abstract class ABApiNetwork {
  Future<Response<T>> get<T>({required String path});

  Future<Response<T>> post<T>({
    required String path,
    required Map<String, dynamic> parameters,
  });
}
