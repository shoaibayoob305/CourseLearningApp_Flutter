// To parse this JSON data, do
//
//     final messagesListModel = messagesListModelFromJson(jsonString);

import 'dart:convert';

MessagesListModel messagesListModelFromJson(String str) =>
    MessagesListModel.fromJson(json.decode(str));

String messagesListModelToJson(MessagesListModel data) =>
    json.encode(data.toJson());

class MessagesListModel {
  String? next;
  String? previous;
  List<Result>? results;

  MessagesListModel({
    this.next,
    this.previous,
    this.results,
  });

  factory MessagesListModel.fromJson(Map<String, dynamic> json) =>
      MessagesListModel(
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
  int? id;
  String? name;
  String? otherUserName;
  bool? isCourseGroup;
  bool? isOneToOne;
  bool? isMuted;
  LastMessage? lastMessage;

  Result({
    this.id,
    this.name,
    this.otherUserName,
    this.isCourseGroup,
    this.isOneToOne,
    this.isMuted,
    this.lastMessage,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        name: json["name"],
        otherUserName: json["other_user_name"],
        isCourseGroup: json["is_course_group"],
        isOneToOne: json["is_one_to_one"],
        isMuted: json["is_muted"],
        lastMessage: json["last_message"] == null
            ? null
            : LastMessage.fromJson(json["last_message"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "other_user_name": otherUserName,
        "is_course_group": isCourseGroup,
        "is_one_to_one": isOneToOne,
        "is_muted": isMuted,
        "last_message": lastMessage?.toJson(),
      };
}

class LastMessage {
  String? content;
  DateTime? createdAt;

  LastMessage({
    this.content,
    this.createdAt,
  });

  factory LastMessage.fromJson(Map<String, dynamic> json) => LastMessage(
        content: json["content"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "content": content,
        "created_at": createdAt?.toIso8601String(),
      };
}
