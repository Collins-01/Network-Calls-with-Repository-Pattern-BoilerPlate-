import 'package:dio/dio.dart';
import 'package:network_calls_with_repository_pattern/core/network_manager/failure.dart';
import 'package:network_calls_with_repository_pattern/core/network_manager/network_interceptors.dart';
import 'package:network_calls_with_repository_pattern/core/services/auth_service.dart';

const String _baseUrl = "";

class NetworkClient {
  ///Making the class a singleton
  NetworkClient._();
  static final _singleton = NetworkClient._();
  factory NetworkClient() => _singleton;

  ///Assigns the Value to the Initialsed Dio variable
  final Dio _dio = createDio();

  ///Initialises the Dio Variable
  static Dio createDio() {
    var dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      receiveTimeout: 30000, // 15 seconds
      connectTimeout: 30000,
      sendTimeout: 30000,
    ));

    /// Adds our Custom Interceptos to the DIO Interceptors
    dio.interceptors.addAll({
      NetworkInterceptors(dio),
    });
    return dio;
  }

  ///Get Request
  /// Expects a URL:[String]
  ///  CancelToken: To cancel the
  Future<T> get<T>(
    /// the api route path without the base url
    ///
    String uri, {
    Map<String, dynamic> queryParameters = const {},
    // Options options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _authenticationService = AuthService.instance;
    try {
      Response response = await _dio.get(
        uri,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
        options: Options(
          headers: {
            "Authorization":
                "Bearer ${_authenticationService.currentUser?.token}",
          },
        ),
      );
      // checkRequest(response);
      return response.data;
    } on Failure {
      rethrow;
    }
  }

  ///POST
  Future<dynamic> post(
    /// the api route without the base url
    String uri, {

    ///this are query parameters that would
    /// be attached to the url
    /// [e.g]=>{"a":"yes"}
    /// https://she.com/getPeople?a=yes
    Map<String, dynamic> queryParameters = const {},
    Object? body,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _authenticationService = AuthService.instance;

    try {
      Response response = await _dio.post(
        uri,
        queryParameters: queryParameters,
        data: body,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
        options: Options(
          headers: {
            // "Authorization": _authenticationService.currentUser?.token ?? "",
            "Authorization":
                "Bearer ${_authenticationService.currentUser?.token}",
          },
        ),
      );
      // checkRequest(response);
      return response.data;
    } on Failure {
      rethrow;
    }
  }
}
