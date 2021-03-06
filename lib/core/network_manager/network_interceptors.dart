import 'package:dio/dio.dart';
import 'package:network_calls_with_repository_pattern/core/network_manager/exceptions.dart';
import 'package:network_calls_with_repository_pattern/core/network_manager/failure.dart';

class NetworkInterceptors extends Interceptor {
  final Dio dio;
  NetworkInterceptors(this.dio);
  @override
  onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    return handler.next(options);
  }

  @override
  Future<dynamic> onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    checkStatusCode(response.requestOptions, response);
    return handler.next(response);
  }

  ///on Error
  @override
  Future onError(
    DioError err,
    ErrorInterceptorHandler handler,
  ) async {
    // log("=====error start======");
    // log(err.response?.data.toString() ?? "");
    // log(err.response?.statusCode.toString() ?? "");
    // log("=====error end======");
    // switch (err.type) {
    //   case DioErrorType.connectTimeout:
    //   case DioErrorType.sendTimeout:
    //   case DioErrorType.receiveTimeout:
    //     // reasign err variable
    //     err = DeadlineExceededException(err.requestOptions);
    //     break;
    //   case DioErrorType.response:
    //     try {
    //       checkStatusCode(err.requestOptions, err.response);
    //     } on DioError catch (failure) {
    //       // reasign err variable
    //       err = failure;
    //     }

    //     break;
    //   case DioErrorType.cancel:
    //     break;
    //   case DioErrorType.other:
    //     // _log.e(err.message);
    //     err = NoInternetConnectionException(err.requestOptions);
    // }
    switch (err.type) {
      case DioErrorType.connectTimeout:
      case DioErrorType.sendTimeout:
      case DioErrorType.receiveTimeout:
        err = DeadlineExceededException(err.requestOptions);
        break;
      case DioErrorType.response:
        if (err.response != null) {
          switch (err.response?.statusCode) {
            case 400:
              err = BadRequestException(err.requestOptions, err.response);
              break;
            case 401:
              err = UnAuthorizedException(err.requestOptions, err.response);
              break;
            case 403:
              err = UnAuthorizedException(err.requestOptions, err.response);
              break;
            case 404:
              err = NotFoundException(err.requestOptions, err.response);
              break;
            case 409:
              err = ConflictException(err.requestOptions, err.response);
              break;
            case 500:
              err = InternalServerErrorException(
                  err.requestOptions, err.response);
              break;
            case 503:
              err = ServerCommunicationException(err.response);
              break;
            default:
              err = RequestUnknownExcpetion(err.requestOptions, err.response);
              break;
          }
        } else {
          err = RequestUnknownExcpetion(err.requestOptions, err.response);
        }
        break;
      case DioErrorType.cancel:
        break;
      case DioErrorType.other:
        err = NoInternetConnectionException(err.requestOptions);
        break;
    }
    //continue
    return handler.next(err);
  }

  ///Checks for the Status Codes, and throws our custom-exceptions based on the status code
  void checkStatusCode(RequestOptions requestOptions, Response? response) {
    try {
      switch (response?.statusCode) {
        case 200:
        case 204:
        case 201:
          break;
        case 400:
          throw BadRequestException(requestOptions, response);
        case 401:
          throw UnAuthorizedException(requestOptions, response);
        case 404:
          throw NotFoundException(requestOptions);
        case 409:
          throw ConflictException(requestOptions, response);
        case 500:
          throw InternalServerErrorException(requestOptions);
        default:
          throw ServerCommunicationException(response);
      }
    } on Failure {
      rethrow;
    }
  }
}
