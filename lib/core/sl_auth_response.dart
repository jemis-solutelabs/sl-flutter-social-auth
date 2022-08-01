///base response of social auth plugin
class SlAuthResponse<T> {
  ///Defaut construction of the response
  SlAuthResponse({
    required this.msg,
    required this.isAuthenticated,
    required this.authData,
    this.exception,
  });

  ///message of the authentication
  String msg;

  /// return true if authenticated
  bool isAuthenticated;

  ///list of exception if occured
  List<Exception>? exception;

  ///authdata of the authentication function
  T authData;
}
