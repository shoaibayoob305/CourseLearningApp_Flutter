import 'dart:convert';

List<CheckGptModel> checkGptModelFromJson(String str) =>
    List<CheckGptModel>.from(
        json.decode(str).map((x) => CheckGptModel.fromJson(x)));

String checkGptModelToJson(List<CheckGptModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CheckGptModel {
  int? courseId;
  String? courseName;
  String? vocabularyLevel;
  String? detailLevel;
  String? explanationStyle;

  CheckGptModel({
    this.courseId,
    this.courseName,
    this.vocabularyLevel,
    this.detailLevel,
    this.explanationStyle,
  });

  factory CheckGptModel.fromJson(Map<String, dynamic> json) => CheckGptModel(
        courseId: json["course_id"],
        courseName: json["course_name"],
        vocabularyLevel: json["vocabulary_level"],
        detailLevel: json["detail_level"],
        explanationStyle: json["explanation_style"],
      );

  Map<String, dynamic> toJson() => {
        "course_id": courseId,
        "course_name": courseName,
        "vocabulary_level": vocabularyLevel,
        "detail_level": detailLevel,
        "explanation_style": explanationStyle,
      };
}
