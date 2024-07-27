// To parse this JSON data, do
//
//     final classroomModel = classroomModelFromJson(jsonString);

import 'dart:convert';

ClassroomModel classroomModelFromJson(String str) => ClassroomModel.fromJson(json.decode(str));

String classroomModelToJson(ClassroomModel data) => json.encode(data.toJson());

class ClassroomModel {
  int id;
  String layout;
  String name;
  int size;
  String subject;

  ClassroomModel({
    required this.id,
    required this.layout,
    required this.name,
    required this.size,
    required this.subject,
  });

  factory ClassroomModel.fromJson(Map<String, dynamic> json) => ClassroomModel(
        id: json["id"],
        layout: json["layout"],
        name: json["name"],
        size: json["size"],
        subject: json["subject"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "layout": layout,
        "name": name,
        "size": size,
        "subject": subject,
      };
}
