/// NetworkException
class NetworkException implements Exception {
  ///
  NetworkException({required this.msg, required this.code});
  /// String message
  String msg;
  /// String code
  String code;
}
