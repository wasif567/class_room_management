import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:management/core/base_api_utilities.dart';
import 'package:management/core/manage_api.dart';
import 'package:management/internet_helper/url_endpoints.dart';
import 'package:management/model/registrations_model.dart';
import 'package:management/model/students_model.dart';
import 'package:management/model/subjects_model.dart';
import 'package:management/view/app_theme/app_typography.dart';

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

  newRegistration() async {
    try {
      if (selectedStudent != null && selectedSubject != null) {
        var data = {
          'student': selectedStudent!.id,
          'subject': selectedSubject!.id,
        };
        Response response =
            await ManageApi().post("${AppUrls.registration}/", data: data, headers: apiHeaders());
        if (response.statusCode == 200) {
          getRegistrationList();
          return true;
        }
        return false;
      } else {
        ScaffoldMessengerState().showSnackBar(SnackBar(
          content: Text(
            "Select Student & Subject",
            style: AppTypography.sfProMedium.copyWith(
              fontSize: 16,
            ),
          ),
        ));
      }
    } catch (_) {
      return false;
    }
  }

  List<StudentModel>? _studentList;
  List<StudentModel>? get studentList => _studentList;
  set studentList(List<StudentModel>? val) {
    _studentList = val;
    notifyListeners();
  }

  StudentModel? _selectedStudent;
  StudentModel? get selectedStudent => _selectedStudent;
  set selectedStudent(StudentModel? val) {
    _selectedStudent = val;
    notifyListeners();
  }

  List<SubjectModel>? _subjectList;
  List<SubjectModel>? get subjectList => _subjectList;
  set subjectList(List<SubjectModel>? val) {
    _subjectList = val;
    notifyListeners();
  }

  SubjectModel? _selectedSubject;
  SubjectModel? get selectedSubject => _selectedSubject;
  set selectedSubject(SubjectModel? val) {
    _selectedSubject = val;
    notifyListeners();
  }

  registrationData() async {
    Response studentRes = await ManageApi().get(AppUrls.students);
    studentList = (studentRes.data['students'] as List).map((e) => StudentModel.fromJson(e)).toList();
    Response subjectRes = await ManageApi().get(AppUrls.subjects);
    subjectList = (subjectRes.data['subjects'] as List).map((e) => SubjectModel.fromJson(e)).toList();
  }
}
