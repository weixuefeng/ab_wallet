
class GasServiceException implements Exception {
  final int code;
  final String message;
  final dynamic data;

  GasServiceException({
    this.code = -1,
    this.message = '',
    this.data,
  });
}
