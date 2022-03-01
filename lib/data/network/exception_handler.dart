part of auth0;

void handleError(DioError error, JsonDecoder _decoder) {
  if (error.error is SocketException)
    throw error.error;
  else if (error.type == DioErrorType.receiveTimeout ||
      error.type == DioErrorType.sendTimeout ||
      error.type == DioErrorType.connectTimeout) {
    throw SocketException(error.toString());
  } else {
    if (error.response != null) {
      var err = error.response!.data["error"] ?? error.response!.data['name'];
      var desc = error.response!.data["error_description"] ??
          error.response!.data["message"] ??
          error.response!.data["description"];
      var status = error.response!.statusCode;
      var statusMsg = error.response!.statusMessage;
      throw AuthException(
          name: err,
          description: desc,
          statusCode: status,
          statusMessage: statusMsg);
    } else
      throw AuthException(description: error.error.toString());
  }
}
