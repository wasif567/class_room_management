import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:management/core/manage_api.dart';
import 'package:management/internet_helper/url_endpoints.dart';
import 'package:management/model/students_model.dart';

class StudentViewState extends ChangeNotifier {
  Future<List<StudentModel>> getStudents() async {
    try {
      List<StudentModel>? studentList;
      Response response = await ManageApi().get("${AppUrls.students}/").timeout(const Duration(seconds: 60));
      // final decode = json.decode(response.data);
      if (response.statusCode == 200) {
        studentList = (response.data['students'] as List).map((e) => StudentModel.fromJson(e)).toList();
        if (studentList.isNotEmpty) {
          return studentList;
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

  Future<StudentModel?> getStudentDetail(int id) async {
    try {
      StudentModel? student;
      Response response =
          await ManageApi().get("${AppUrls.students}/$id").timeout(const Duration(seconds: 60));

      student = StudentModel.fromJson(response.data);
      if (student.id > 0) {
        return student;
      }
      return student;
    } catch (_) {
      return getStudentDetail(id);
    }
  }
}
