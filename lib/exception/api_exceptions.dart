class ApiException implements Exception {
  ApiException([this._message, this._prefix]);

  final dynamic _message;
  final dynamic _prefix;

  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends ApiException {
  FetchDataException([String message])
      : super(message, "Error During Communication: ");
}

class BadRequestException extends ApiException {
  BadRequestException([String message]) : super(message, "Invalid Request: ");
}


class NotFoundException extends ApiException {
  NotFoundException([String message]) : super(message, "");
}

class UnauthorisedException extends ApiException {
  UnauthorisedException([String message]) : super(message, "");
}

