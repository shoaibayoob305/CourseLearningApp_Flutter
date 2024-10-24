// To parse this JSON data, do
//
//     final participantsModel = participantsModelFromJson(jsonString);

import 'dart:convert';

List<ParticipantsModel> participantsModelFromJson(String str) =>
    List<ParticipantsModel>.from(
        json.decode(str).map((x) => ParticipantsModel.fromJson(x)));

String participantsModelToJson(List<ParticipantsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ParticipantsModel {
  int? id;
  String? name;
  String? image;

  ParticipantsModel({
    this.id,
    this.name,
    this.image,
  });

  factory ParticipantsModel.fromJson(Map<String, dynamic> json) =>
      ParticipantsModel(
        id: json["id"],
        name: json["name"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
      };
}
