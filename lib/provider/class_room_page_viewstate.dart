import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:management/common/snack_bar_widget.dart';
import 'package:management/core/base_api_utilities.dart';
import 'package:management/core/manage_api.dart';
import 'package:management/internet_helper/url_endpoints.dart';
import 'package:management/model/classrooms_model.dart';
import 'package:management/model/subjects_model.dart';
import 'package:management/view/app_theme/app_colors.dart';

class ClassRoomViewstate extends ChangeNotifier {
  Future<List<ClassroomModel>> getClassList() async {
    try {
      List<ClassroomModel>? classroomList;
      Response response =
          await ManageApi().get("${AppUrls.classrooms}/").timeout(const Duration(seconds: 60));
      classroomList = (response.data['classrooms'] as List).map((e) => ClassroomModel.fromJson(e)).toList();
      if (classroomList.isNotEmpty) {
        return classroomList;
      }
      return classroomList;
    } catch (_) {
      return getClassList();
    }
  }

  ClassroomModel? _classroom;
  ClassroomModel? get classroom => _classroom;
  set classroom(ClassroomModel? val) {
    _classroom = val;
    notifyListeners();
  }

  bool? _isLoading;
  bool? get isLoading => _isLoading;
  set isLoading(bool? val) {
    _isLoading = val;
    notifyListeners();
  }

  Future getClassroomDetail(int id) async {
    try {
      isLoading = true;
      subject = null;
      classroom = null;
      Response response =
          await ManageApi().get("${AppUrls.classrooms}/$id").timeout(const Duration(seconds: 60));
      if (response.statusCode == 200) {
        classroom = ClassroomModel.fromJson(response.data);
        if (classroom!.subject != null) {
          Response subjectRes = await ManageApi()
              .get("${AppUrls.subjects}/${classroom!.subject}")
              .timeout(const Duration(seconds: 60));
          if (subjectRes.statusCode == 200) {
            subject = SubjectModel.fromJson(subjectRes.data);
          }
        }
      }
      isLoading = false;
      if (response.statusCode == 500) {
        getClassroomDetail(id);
      }
    } catch (_) {
      return null;
    }
  }

  SubjectModel? _subject;
  SubjectModel? get subject => _subject;
  set subject(SubjectModel? val) {
    _subject = val;
    notifyListeners();
  }

  Future updateSubject(ClassroomModel classDetail, BuildContext context) async {
    try {
      Response response = await ManageApi().patch("${AppUrls.classrooms}/${classDetail.id}",
          headers: apiHeaders(), data: {"subject": classDetail.subject}).timeout(const Duration(seconds: 60));

      if (response.statusCode == 200) {
        classroom = ClassroomModel.fromJson(response.data);
        Response subjectRes = await ManageApi()
            .get("${AppUrls.subjects}/${classroom!.subject}")
            .timeout(const Duration(seconds: 60));
        if (subjectRes.statusCode == 200) {
          subject = SubjectModel.fromJson(subjectRes.data);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(snackBarWidget('Subject Updated',
                color: AppColors.greenColor, duration: const Duration(seconds: 3)));
          }
          return true;
        }
        if (subjectRes.statusCode == 500) {
          Response subjectRes = await ManageApi()
              .get("${AppUrls.subjects}/${classroom!.subject}")
              .timeout(const Duration(seconds: 60));

          if (subjectRes.statusCode == 200) {
            subject = SubjectModel.fromJson(subjectRes.data);
            return true;
          }
        }
      }
      if (response.statusCode == 500) {
        if (context.mounted) {
          updateSubject(classDetail, context);
          return false;
        }
      }
    } catch (_) {
      return false;
    }
  }
}
