// To parse this JSON data, do
//
//     final responseQuestion = responseQuestionFromJson(jsonString);

import 'dart:convert';

ResponseQuestion responseQuestionFromJson(String str) =>
    ResponseQuestion.fromJson(json.decode(str));

String responseQuestionToJson(ResponseQuestion data) =>
    json.encode(data.toJson());

class ResponseQuestion {
  int? id;
  int? course;
  String? courseName;
  Question? question;
  List<String>? answer;
  bool? isCorrect;
  bool? isComplete;
  String? prompt;
  DateTime? createdAt;
  DateTime? lastUpdated;

  ResponseQuestion({
    this.id,
    this.course,
    this.courseName,
    this.question,
    this.answer,
    this.isCorrect,
    this.isComplete,
    this.prompt,
    this.createdAt,
    this.lastUpdated,
  });

  factory ResponseQuestion.fromJson(Map<String, dynamic> json) =>
      ResponseQuestion(
        id: json["id"],
        course: json["course"],
        courseName: json["course_name"],
        question: json["question"] == null
            ? null
            : Question.fromJson(json["question"]),
        answer: json["answer"] == null
            ? []
            : List<String>.from(json["answer"]!.map((x) => x)),
        isCorrect: json["is_correct"],
        isComplete: json["is_complete"],
        prompt: json["prompt"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        lastUpdated: json["last_updated"] == null
            ? null
            : DateTime.parse(json["last_updated"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "course": course,
        "course_name": courseName,
        "question": question?.toJson(),
        "answer":
            answer == null ? [] : List<dynamic>.from(answer!.map((x) => x)),
        "is_correct": isCorrect,
        "is_complete": isComplete,
        "prompt": prompt,
        "created_at": createdAt?.toIso8601String(),
        "last_updated": lastUpdated?.toIso8601String(),
      };
}

class Question {
  int? questionNumber;
  String? questionText;
  List<String>? options;
  List<String>? correctAnswer;
  String? selectionType;
  dynamic image;
  bool? isTrial;

  Question({
    this.questionNumber,
    this.questionText,
    this.options,
    this.correctAnswer,
    this.selectionType,
    this.image,
    this.isTrial,
  });

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        questionNumber: json["question_number"],
        questionText: json["question_text"],
        options: json["options"] == null
            ? []
            : List<String>.from(json["options"]!.map((x) => x)),
        correctAnswer: json["correct_answer"] == null
            ? []
            : List<String>.from(json["correct_answer"]!.map((x) => x)),
        selectionType: json["selection_type"],
        image: json["image"],
        isTrial: json["is_trial"],
      );

  Map<String, dynamic> toJson() => {
        "question_number": questionNumber,
        "question_text": questionText,
        "options":
            options == null ? [] : List<dynamic>.from(options!.map((x) => x)),
        "correct_answer": correctAnswer == null
            ? []
            : List<dynamic>.from(correctAnswer!.map((x) => x)),
        "selection_type": selectionType,
        "image": image,
        "is_trial": isTrial,
      };
}
