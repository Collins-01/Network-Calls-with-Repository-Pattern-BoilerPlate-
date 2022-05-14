import 'dart:io';
import 'package:mime/mime.dart';
import 'package:dio/dio.dart';
import 'package:network_calls_with_repository_pattern/core/enums/form_data_type.dart';
import 'package:network_calls_with_repository_pattern/core/network_manager/failure.dart';
import 'package:network_calls_with_repository_pattern/core/network_manager/network_interceptors.dart';
import 'package:network_calls_with_repository_pattern/core/services/auth_service.dart';
import 'package:http_parser/src/media_type.dart';

const String _baseUrl = "https://jsonplaceholder.typicode.com";

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

  ///Sends Form data to the server
  Future<dynamic> sendFormData(
    String url,
    FormDataType requestType, {
    Map<String, dynamic> queryParameters = const {},
    Map<String, dynamic> body = const {},
    Map<String, File> images = const {},
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _authenticationService = AuthService.instance;
    Map<String, MultipartFile> multipartImages = {};

    ///Looping through each entry of the images, with an  async await
    await Future.forEach<MapEntry<String, File>>(images.entries, (item) async {
      ///Creating a mime DataType out of each item, where each item is of type [<String,File>{}]
      final mimeTypeData =
          lookupMimeType(item.value.path, headerBytes: [0xFF, 0xD8])
              ?.split("/");
      multipartImages[item.key] = await MultipartFile.fromFile(
        item.value.path,
        contentType: MediaType(mimeTypeData![0], mimeTypeData[1]),
      );
    });
    FormData formData = FormData.fromMap({...body, ...multipartImages});

    try {
      ///sends request to the server
      if (requestType == FormDataType.patch) {
        await _dio.patch(url,
            data: formData,
            cancelToken: cancelToken,
            queryParameters: queryParameters,
            options: Options(headers: {
              "Authorization":
                  "Bearer ${_authenticationService.currentUser?.token ?? ""}"
            }));
      } else {
        await _dio.post(
          url,
          data: formData,
          cancelToken: cancelToken,
          queryParameters: queryParameters,
        );
      }
    } on Failure {
      rethrow;
    }
  }
}
