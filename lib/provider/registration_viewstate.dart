import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:management/core/manage_api.dart';
import 'package:management/internet_helper/url_endpoints.dart';
import 'package:management/model/registrations_model.dart';

class RegistrationViewstate extends ChangeNotifier {
  Future<List<RegistrationModel>> getStudents() async {
    try {
      List<RegistrationModel>? regList;
      Response response =
          await ManageApi().get("${AppUrls.registration}/").timeout(const Duration(seconds: 60));
      // final decode = json.decode(response.data);
      if (response.statusCode == 200) {
        regList = (response.data['registrations'] as List).map((e) => RegistrationModel.fromJson(e)).toList();
        if (regList.isNotEmpty) {
          return regList;
        } else {
          return [];
        }
      } else {
        return [];
      }
    } catch (e) {
      return getStudents();
    }
  }

  Future<RegistrationModel?> getStudentDetail(int id) async {
    try {
      RegistrationModel? reg;
      Response response =
          await ManageApi().get("${AppUrls.registration}/$id").timeout(const Duration(seconds: 60));
      reg = RegistrationModel.fromJson(response.data);
      if (reg.id > 0) {
        return reg;
      }
      return reg;
    } catch (_) {
      return getStudentDetail(id);
    }
  }

  deleteRegistration(int id) async {
    try {
      Response response = await ManageApi()
          .delete(
            "${AppUrls.registration}/$id",
          )
          .timeout(const Duration(seconds: 60));
    } catch (_) {}
  }
}
