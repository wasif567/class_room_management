import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:management/core/manage_api.dart';
import 'package:management/internet_helper/url_endpoints.dart';
import 'package:management/model/registrations_model.dart';

class RegistrationViewstate extends ChangeNotifier {
  List<RegistrationModel>? _regList;
  List<RegistrationModel>? get regList => _regList;
  set regList(List<RegistrationModel>? val) {
    _regList = val;
    notifyListeners();
  }

  Future getRegistrationList() async {
    try {
      isLoading = true;
      regList = [];
      Response response =
          await ManageApi().get("${AppUrls.registration}/").timeout(const Duration(seconds: 60));
      if (response.statusCode == 200) {
        regList = (response.data['registrations'] as List).map((e) => RegistrationModel.fromJson(e)).toList();
      }
      isLoading = false;
    } catch (_) {
      return getRegistrationList();
    }
  }

  RegistrationModel? _registration;
  RegistrationModel? get registration => _registration;
  set registration(RegistrationModel? val) {
    _registration = val;
    notifyListeners();
  }

  bool? _isLoading;
  bool? get isLoading => _isLoading;
  set isLoading(bool? val) {
    _isLoading = val;
    notifyListeners();
  }

  Future getRegisteredDetail(int id) async {
    try {
      isLoading = true;
      RegistrationModel? reg;
      Response response =
          await ManageApi().get("${AppUrls.registration}/$id").timeout(const Duration(seconds: 60));
      if (response.statusCode == 200) {
        reg = RegistrationModel.fromJson(response.data);
        if (reg.id > 0) {
          registration = reg;
        }
      }
      isLoading = false;
    } catch (_) {}
  }

  deleteRegistration(int id) async {
    try {
      Response response = await ManageApi()
          .delete(
            "${AppUrls.registration}/$id",
          )
          .timeout(const Duration(seconds: 60));
      if (response.statusCode == 200) {
        getRegistrationList();
      }
    } catch (_) {}
  }
}
