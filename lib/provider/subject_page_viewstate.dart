import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:management/core/manage_api.dart';
import 'package:management/internet_helper/url_endpoints.dart';
import 'package:management/model/subjects_model.dart';

class SubjectPageViewstate extends ChangeNotifier {
  bool isFromClass = false;

  List<SubjectModel> subList = [];

  Future<List<SubjectModel>> getSubjects() async {
    try {
      List<SubjectModel>? subjectList;
      Response response = await ManageApi().get(AppUrls.subjects).timeout(const Duration(seconds: 60));
      subjectList = (response.data['subjects'] as List).map((e) => SubjectModel.fromJson(e)).toList();
      if (subjectList.isNotEmpty) {
        subList = subjectList;
        return subjectList;
      }
      return subjectList;
    } catch (_) {
      return getSubjects();
    }
  }

  Future<SubjectModel?> getSubjectDetail(int id) async {
    try {
      SubjectModel? subject;
      Response response =
          await ManageApi().get("${AppUrls.subjects}/$id").timeout(const Duration(seconds: 60));
      if (response.statusCode == 200) {
        subject = SubjectModel.fromJson(response.data);
        if (subject.id > 0) {
          return subject;
        }
      }
      return subject;
    } catch (_) {
      return getSubjectDetail(id);
    }
  }
}
