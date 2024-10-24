// To parse this JSON data, do
//
//     final courseModel = courseModelFromJson(jsonString);

import 'dart:convert';

List<CourseModel> courseModelFromJson(String str) => List<CourseModel>.from(
    json.decode(str).map((x) => CourseModel.fromJson(x)));

String courseModelToJson(List<CourseModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CourseModel {
  int? id;
  String? name;
  String? description;
  double? price1;
  double? price3;
  double? price12;
  dynamic image;
  int? questionsCount;

  CourseModel({
    this.id,
    this.name,
    this.description,
    this.price1,
    this.price3,
    this.price12,
    this.image,
    this.questionsCount,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) => CourseModel(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        price1: json["price_1"],
        price3: json["price_3"],
        price12: json["price_12"],
        image: json["image"],
        questionsCount: json["questions_count"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "price_1": price1,
        "price_3": price3,
        "price_12": price12,
        "image": image,
        "questions_count": questionsCount,
      };
}
