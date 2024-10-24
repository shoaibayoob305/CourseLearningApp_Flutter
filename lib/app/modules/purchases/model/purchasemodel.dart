// To parse this JSON data, do
//
//     final purchaseModel = purchaseModelFromJson(jsonString);

import 'dart:convert';

List<PurchaseModel> purchaseModelFromJson(String str) =>
    List<PurchaseModel>.from(
        json.decode(str).map((x) => PurchaseModel.fromJson(x)));

String purchaseModelToJson(List<PurchaseModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PurchaseModel {
  int? id;
  int? course;
  String? courseName;
  dynamic plan;
  dynamic planName;
  double? amount;
  Status? status;
  int? paymentMethod;
  String? paymentMethodCardBrand;
  DateTime? startDate;
  DateTime? endDate;

  PurchaseModel({
    this.id,
    this.course,
    this.courseName,
    this.plan,
    this.planName,
    this.amount,
    this.status,
    this.paymentMethod,
    this.paymentMethodCardBrand,
    this.startDate,
    this.endDate,
  });

  factory PurchaseModel.fromJson(Map<String, dynamic> json) => PurchaseModel(
        id: json["id"],
        course: json["course"],
        courseName: json["course_name"],
        plan: json["plan"],
        planName: json["plan_name"],
        amount: json["amount"]?.toDouble(),
        status: statusValues.map[json["status"]]!,
        paymentMethod: json["payment_method"],
        paymentMethodCardBrand: json["payment_method_card_brand"],
        startDate: json["start_date"] == null
            ? null
            : DateTime.parse(json["start_date"]),
        endDate:
            json["end_date"] == null ? null : DateTime.parse(json["end_date"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "course": course,
        "course_name": courseName,
        "plan": plan,
        "plan_name": planName,
        "amount": amount,
        "status": statusValues.reverse[status],
        "payment_method": paymentMethod,
        "payment_method_card_brand": paymentMethodCardBrand,
        "start_date":
            "${startDate!.year.toString().padLeft(4, '0')}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}",
        "end_date":
            "${endDate!.year.toString().padLeft(4, '0')}-${endDate!.month.toString().padLeft(2, '0')}-${endDate!.day.toString().padLeft(2, '0')}",
      };
}

enum Status { COMPLETED }

final statusValues = EnumValues({"COMPLETED": Status.COMPLETED});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
