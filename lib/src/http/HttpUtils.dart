import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';

class HttpUtils {
  Dio _dio;
  BaseOptions _options;
  static HttpUtils _instance;
  static InterceptorsWrapper _interceptorsWrapper;
  static LogInterceptor _logInterceptor;
  //当App运行在Release环境时，inProduction为true；当App运行在Debug和Profile环境时，inProduction为false。
  bool inProduction = const bool.fromEnvironment('dart.vm.product');
  factory HttpUtils({bool needAuthor}) => _getInstance(needAuthor ?? true);

  HttpUtils._internal() {
    _options = BaseOptions(); //不可加超时，否则下载文件会失败
    _dio = Dio(_options);
    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) {
        return true; //无条件允许https证书通行
      };
    };
    _logInterceptor = LogInterceptor(
        request: false,
        requestHeader: false,
        requestBody: false,
        responseHeader: false,
        responseBody: !inProduction);
    _interceptorsWrapper =
        InterceptorsWrapper(onRequest: (RequestOptions options) {
      if (options.headers["Authorization"] == null) {
        String token = SpUtil.getString('token');
        if (token.isNotEmpty)
          options.headers["Authorization"] = "Bearer $token";
      }
      return options;
    }, onResponse: (Response response) {
      return response;
    }, onError: (DioError e) {
      return e;
    });
  }

  static HttpUtils _getInstance(bool needAuthor) {
    if (_instance == null) {
      _instance = HttpUtils._internal();
    }
    _instance._dio.interceptors.clear();
    _instance._dio.interceptors.add(_logInterceptor);
    if (needAuthor) {
      _instance._dio.interceptors.add(_interceptorsWrapper);
    }
    return _instance;
  }

  Future get(String path, {data, Options options, CancelToken cancelToken}) {
    return _dio
        .get(path, queryParameters: data, options: options)
        .then((response) {
      return response.data;
    });
  }

  Future<dynamic> post(String path,
      {data,
      Options options,
      Map<String, dynamic> queryParameters,
      CancelToken cancelToken}) {
    return _dio
        .post(path,
            data: data, options: options, queryParameters: queryParameters)
        .then((response) {
      return response.data;
    });
  }

  Future<Map> put(String path,
      {data, Options options, CancelToken cancelToken}) {
    return _dio.put(path, data: data, options: options).then((response) {
      return response.data;
    });
  }

  Future<Map> delete(String path,
      {data, Options options, CancelToken cancelToken}) {
    return _dio.delete(path, data: data, options: options).then((response) {
      return response.data;
    });
  }

  Future<Response> downloadFile(String urlPath, String savePath,
      {Options option, ProgressCallback onReceiveProgress}) {
    return _dio
        .download(urlPath, savePath,
            options: option, onReceiveProgress: onReceiveProgress)
        .then((response) {
      return response;
    });
  }
}
