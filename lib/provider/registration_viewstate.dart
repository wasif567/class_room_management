import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:management/common/snack_bar_widget.dart';
import 'package:management/core/base_api_utilities.dart';
import 'package:management/core/manage_api.dart';
import 'package:management/internet_helper/url_endpoints.dart';
import 'package:management/model/registrations_model.dart';
import 'package:management/model/students_model.dart';
import 'package:management/model/subjects_model.dart';
import 'package:management/view/app_theme/app_colors.dart';

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
      registration = null;
      selectedStudent = null;
      selectedSubject = null;
      Response response =
          await ManageApi().get("${AppUrls.registration}/$id").timeout(const Duration(seconds: 60));
      if (response.statusCode == 200) {
        registration = RegistrationModel.fromJson(response.data);
        registrationData();
        selectedStudent = studentList!.firstWhere((student) => student.id == registration!.student);
        selectedSubject = subjectList!.firstWhere((subject) => subject.id == registration!.subject);
      }
      isLoading = false;
    } catch (_) {}
  }

  Future deleteRegistration(int id, BuildContext context) async {
    try {
      Response response =
          await ManageApi().delete("${AppUrls.registration}/$id").timeout(const Duration(seconds: 60));
      if (response.statusCode == 200) {
        getRegistrationList();
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(snackBarWidget('Deleted Registration Successfully',
              color: AppColors.greenColor, duration: const Duration(seconds: 3)));
        }
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  bool? _isRegLoading;
  bool? get isRegLoading => _isRegLoading;
  set isRegLoading(bool? val) {
    _isRegLoading = val;
    notifyListeners();
  }

  Future newRegistration(BuildContext context) async {
    try {
      isRegLoading = true;
      if (selectedStudent != null && selectedSubject != null) {
        var data = {
          'student': selectedStudent!.id,
          'subject': selectedSubject!.id,
        };
        Response response =
            await ManageApi().post("${AppUrls.registration}/", data: data, headers: apiHeaders());
        if (response.statusCode == 200) {
          getRegistrationList();
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(snackBarWidget('Registered Successfully',
                color: AppColors.greenColor, duration: const Duration(seconds: 3)));
          }
          return true;
        }
        return false;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(snackBarWidget('Select Student & Subject',
            color: AppColors.orangeColor, duration: const Duration(seconds: 3)));
      }
      isRegLoading = false;
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
    selectedStudent = null;
    selectedSubject = null;
    isRegLoading = false;
    isLoading = false;
    Response studentRes = await ManageApi().get(AppUrls.students);
    studentList = (studentRes.data['students'] as List).map((e) => StudentModel.fromJson(e)).toList();
    Response subjectRes = await ManageApi().get(AppUrls.subjects);
    subjectList = (subjectRes.data['subjects'] as List).map((e) => SubjectModel.fromJson(e)).toList();
  }
}
