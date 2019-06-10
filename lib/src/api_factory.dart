import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:kakao_flutter_sdk/main.dart';
import 'package:kakao_flutter_sdk/src/access_token_interceptor.dart';
import 'package:kakao_flutter_sdk/src/constants.dart';
import 'package:kakao_flutter_sdk/src/kakao_error.dart';
import 'package:kakao_flutter_sdk/src/kakao_context.dart';

class ApiFactory {
  static final Dio kauthApi = _kauthApiInstance();
  static final Dio authApi = _authApiInstance();
  static final Dio appKeyApi = _appKeyApiInstance();

  static Dio _kauthApiInstance() {
    var dio = new Dio();
    dio.options.baseUrl = OAUTH_HOST;
    dio.options.contentType =
        ContentType.parse("application/x-www-form-urlencoded");
    dio.interceptors.addAll([kaInterceptor]);
    return dio;
  }

  static Dio _authApiInstance() {
    var dio = new Dio();
    dio.options.baseUrl = API_HOST;
    dio.options.contentType =
        ContentType.parse("application/x-www-form-urlencoded");
    var tokenInterceptor = AccessTokenInterceptor(dio, AuthApi(kauthApi));
    dio.interceptors.addAll([tokenInterceptor, kaInterceptor]);
    return dio;
  }

  static Dio _appKeyApiInstance() {
    var dio = new Dio();
    dio.options.baseUrl = API_HOST;
    dio.options.contentType =
        ContentType.parse("application/x-www-form-urlencoded");
    dio.interceptors.addAll([appKeyInterceptor, kaInterceptor]);
    return dio;
  }

  static Future<T> handleApiError<T>(
      Future<T> Function() requestFunction) async {
    try {
      return await requestFunction();
    } on DioError catch (e) {
      throw transformApiError(e);
    }
  }

  static Error transformApiError(DioError e) {
    debugPrint(e.toString());
    if (e.response == null) return KakaoClientError();
    if (e.request.baseUrl == OAUTH_HOST) {
      debugPrint(e.response.data.toString());
      return KakaoAuthError();
    }
    return KakaoApiError();
  }

  static Interceptor appKeyInterceptor =
      InterceptorsWrapper(onRequest: (RequestOptions options) async {
    var appKey = KakaoContext.clientId;
    options.headers["Authorization"] = "KakaoAK $appKey";
    return options;
  });

  static Interceptor kaInterceptor =
      InterceptorsWrapper(onRequest: (RequestOptions options) async {
    var kaHeader = await KakaoContext.kaHeader;
    options.headers["KA"] = kaHeader;
    return options;
  });
}