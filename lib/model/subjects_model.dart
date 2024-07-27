// To parse this JSON data, do
//
//     final subjectModel = subjectModelFromJson(jsonString);

import 'dart:convert';

SubjectModel subjectModelFromJson(String str) => SubjectModel.fromJson(json.decode(str));

String subjectModelToJson(SubjectModel data) => json.encode(data.toJson());

class SubjectModel {
  int credits;
  int id;
  String name;
  String teacher;

  SubjectModel({
    required this.credits,
    required this.id,
    required this.name,
    required this.teacher,
  });

  factory SubjectModel.fromJson(Map<String, dynamic> json) => SubjectModel(
        credits: json["credits"],
        id: json["id"],
        name: json["name"],
        teacher: json["teacher"],
      );

  Map<String, dynamic> toJson() => {
        "credits": credits,
        "id": id,
        "name": name,
        "teacher": teacher,
      };
}
