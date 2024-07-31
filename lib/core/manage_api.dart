import 'package:dio/dio.dart';
import 'package:management/core/base_api.dart';
import 'package:management/internet_helper/url_endpoints.dart';

class ManageApi extends BaseApi {
  ManageApi() {
    BaseOptions options = BaseOptions(
      baseUrl: AppUrls.baseUrl,
      headers: {},
    );
    dio = Dio(options);
  }
}
