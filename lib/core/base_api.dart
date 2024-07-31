import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:management/common/snack_bar_widget.dart';
import 'package:management/internet_helper/url_endpoints.dart';
import 'package:management/main.dart';

class BaseApi {
  Dio? dio;

  String apiKey = "?api_key=c16fB";

  BaseApi() {
    dio = Dio();
  }

  Future get(url, {queryParameters, Map<String, dynamic>? headers}) async {
    try {
      Options options = Options(headers: headers);
      String resUrl = AppUrls.baseUrl + url + apiKey;
      Response response = await dio!.get(resUrl, queryParameters: queryParameters, options: options);

      if (kDebugMode) {
        log('status code = ${response.statusCode}\nresponse == ${response.data.toString()}', name: url);
      }

      if (response.statusCode == 401) {
        await unAutherized();
      } else {
        return response;
      }
    } on DioException catch (e) {
      log('status code = ${e.response?.statusCode}\nresponse == ${e.response?.data.toString()}', name: url);
      if (e.response?.statusCode == 401) {
        await unAutherized();
      }
      if (e.response != null) {
        return e.response;
      } else {
        return null;
      }
    }
  }

  Future post(url, {queryParameters, data, Map<String, dynamic>? headers}) async {
    try {
      headers ??= {};
      Options options = Options(
        headers: headers,
      );

      log('Form = $data');

      Response response = await dio!.post(url, data: data, options: options);

      log('status code = ${response.statusCode}\nresponse == ${response.data.toString()}', name: url);

      if (response.statusCode == 401) {
        await unAutherized();
      } else {
        return response;
      }
    } on DioException catch (e) {
      log('status code = ${e.response?.statusCode}\nresponse == ${e.response?.data.toString()}', name: url);

      if (e.response?.statusCode == 401) {
        await unAutherized();
      }
      if (e.response != null) {
        return e.response;
      } else {
        return null;
      }
    } catch (e, s) {
      log('Exception: $e', stackTrace: s);
    }
  }

  Future patch(url, {data, Map<String, dynamic>? headers}) async {
    try {
      headers ??= {};
      Options options = Options(
        headers: headers,
      );
      String resUrl = AppUrls.baseUrl + url + apiKey;

      Response response = await dio!.patch(resUrl, data: data, options: options);

      log('status code = ${response.statusCode}\nresponse == ${response.data.toString()}', name: url);
      if (response.statusCode == 401) {
        await unAutherized();
      } else {
        return response;
      }
    } on DioException catch (e) {
      log('status code = ${e.response?.statusCode}\nresponse == ${e.response?.data.toString()}', name: url);
      if (e.response?.statusCode == 401) {
        await unAutherized();
      }
      if (e.response != null) {
        return e.response;
      } else {
        return null;
      }
    }
  }

  Future put(url, {queryParameters, data, Map<String, dynamic>? headers}) async {
    try {
      Options options = Options(headers: headers);
      String resUrl = AppUrls.baseUrl + url + apiKey;
      Response response =
          await dio!.put(resUrl, data: data, queryParameters: queryParameters, options: options);
      if (response.statusCode == 401) {
        await unAutherized();
      } else {
        return response;
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        await unAutherized();
      }
      if (e.response != null) {
      } else {}
    }
  }

  Future delete(url, {data, Map<String, dynamic>? headers}) async {
    try {
      Options options = Options(headers: headers);
      Response response = await dio!.delete(url, data: data, options: options);
      if (response.statusCode == 401) {
        await unAutherized();
      } else {
        return response;
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        await unAutherized();
      }
      if (e.response != null) {
      } else {}
    }
  }

//?========== Unautherized Access ==========
  Future<void> unAutherized() async {
    rootScaffoldMessengerKey.currentState!
        .showSnackBar(snackBarWidget('Unautherized access. Please login again'));
    log('Response - Unautherized access');

    // await rootScaffoldMessengerKey.currentState!.context
    //     .read<AuthController>()
    //     .logout()
    //     .then((value) => navigatorKey.currentState?.pushNamedAndRemoveUntil(
    //         LoginView.routeName, ModalRoute.withName(SplashScreen.routeName)));
  }
}
