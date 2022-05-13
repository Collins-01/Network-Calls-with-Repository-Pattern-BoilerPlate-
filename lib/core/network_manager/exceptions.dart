import 'dart:developer';
import 'package:dio/dio.dart';
import './failure.dart';

class UserDefinedExceptions extends Failure {
  final String _title;
  final String _message;
  UserDefinedExceptions(this._title, this._message);
  @override
  String get message => _message;

  @override
  String get title => _title;
}

/// 400 Response
class BadRequestException extends DioError with Failure {
  final RequestOptions request;
  final Response? serverResponse;
  BadRequestException(this.request, [this.serverResponse])
      : super(requestOptions: request, response: serverResponse);

  @override

  /// The title of your error, returns "An Error Occured if Null"
  String get title => serverResponse?.data['message'] ?? "An Error Occured";

  @override
  String get message =>
      getError(serverResponse?.data['errors']) ?? "Invalid Request";
  @override
  String toString() {
    return "Error was:\nTitle: $title\nMessage: $message ";
  }
}

///500 Response
class InternalServerErrorException extends DioError with Failure {
  final RequestOptions request;
  final Response? serverResponse;
  InternalServerErrorException(this.request, [this.serverResponse])
      : super(requestOptions: request, response: serverResponse);

  @override
  String toString() {
    return "Error was:\nTitle: $title\nMessage: $message ";
  }

  @override
  String get title => "Server Error";
  @override
  String get message => "An Unknown error occcured, please try again later";
}

///409
class ConflictException extends DioError with Failure {
  final RequestOptions request;
  final Response? serverResponse;
  ConflictException(this.request, [this.serverResponse])
      : super(requestOptions: request, response: serverResponse);

  @override
  String toString() {
    return "Error was:\nTitle: $title\nMessage: $message ";
  }

  @override
  String get message =>
      getError(serverResponse?.data["errors"]) ?? "Conflict occurredd.";

  @override
  String get title => serverResponse?.data?["message"] ?? "Network error";
}

///401
class UnAuthorizedException extends DioError with Failure {
  final RequestOptions request;
  final Response? serverResponse;
  UnAuthorizedException(this.request, [this.serverResponse])
      : super(requestOptions: request, response: serverResponse);

  @override
  String toString() {
    return "Error was:\nTitle: $title\nMessage: $message ";
  }

  @override
  String get message =>
      getError(serverResponse?.data["errors"]) ?? "Invalid request.";

  @override
  String get title => serverResponse?.data?["message"] ?? "Access denied.";
}

///404
class NotFoundException extends DioError with Failure {
  final RequestOptions request;
  final Response? serverResponse;
  NotFoundException(this.request, [this.serverResponse])
      : super(requestOptions: request, response: serverResponse);

  @override
  String toString() {
    return "Error was:\nTitle: $title\nMessage: $message ";
  }

  @override
  String get message =>
      getError(serverResponse?.data["errors"]) ??
      "Not Found, please try again.";

  @override
  String get title => serverResponse?.data?["message"] ?? "Not Found.";
}

///No Internet Connection
class NoInternetConnectionException extends DioError with Failure {
  NoInternetConnectionException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'title: $title message: $message';
  }

  @override
  String get message =>
      "No internet connection, please check your internet setting and try again.";

  @override
  String get title => "No Network";
}

///Time Out Exception [When there is a connection timeou with the request]
class DeadlineExceededException extends DioError with Failure {
  DeadlineExceededException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'title: $title message: $message';
  }

  @override
  String get message => "The connection has timed out, please try again.";

  @override
  String get title => "Network error";
}

//* I don't understand the below function yet, LOL
/// errors sent back by the server in json
class ServerCommunicationException extends DioError with Failure {
  ServerCommunicationException(this.r)
      : super(requestOptions: r!.requestOptions);

  /// sustained so that the data sent by the server can be gotten to construct message
  final Response? r;

  @override
  String toString() {
    return 'title: $title message: $message';
  }

  @override
  String get message {
    log(r?.data?.toString() ?? "");
    return getError(r?.data ?? {"message": "Server Error"}) ?? "Server Error";
  }

  @override
  String get title => r?.data?["message"] ?? "Network error";
}
