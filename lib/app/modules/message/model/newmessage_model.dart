// To parse this JSON data, do
//
//     final newMessageModel = newMessageModelFromJson(jsonString);

import 'dart:convert';

NewMessageModel newMessageModelFromJson(String str) =>
    NewMessageModel.fromJson(json.decode(str));

String newMessageModelToJson(NewMessageModel data) =>
    json.encode(data.toJson());

class NewMessageModel {
  String? next;
  String? previous;
  List<Result>? results;

  NewMessageModel({
    this.next,
    this.previous,
    this.results,
  });

  factory NewMessageModel.fromJson(Map<String, dynamic> json) =>
      NewMessageModel(
        next: json["next"],
        previous: json["previous"],
        results: json["results"] == null
            ? []
            : List<Result>.from(
                json["results"]!.map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "next": next,
        "previous": previous,
        "results": results == null
            ? []
            : List<dynamic>.from(results!.map((x) => x.toJson())),
      };
}

class Result {
  String? content;
  int? sender;
  String? senderName;
  String? senderImage;
  DateTime? createdAt;

  Result({
    this.content,
    this.sender,
    this.senderName,
    this.senderImage,
    this.createdAt,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        content: json["content"],
        sender: json["sender"],
        senderName: json["sender_name"],
        senderImage: json["sender_image"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "content": content,
        "sender": sender,
        "sender_name": senderName,
        "sender_image": senderImage,
        "created_at": createdAt?.toIso8601String(),
      };
}
