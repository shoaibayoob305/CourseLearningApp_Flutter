class AdditionalUserData {
  int? id;
  int? userId;
  String? image;
  AdditionalData? additionalData;

  AdditionalUserData({this.id, this.userId, this.image, this.additionalData});

  AdditionalUserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    image = json['image'];
    additionalData = json['additional_data'] != null
        ? AdditionalData.fromJson(json['additional_data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['image'] = this.image;
    if (this.additionalData != null) {
      data['additional_data'] = this.additionalData!.toJson();
    }
    return data;
  }
}

class AdditionalData {
  Map<String, dynamic>? data;

  AdditionalData({this.data});

  AdditionalData.fromJson(Map<String, dynamic> json) {
    data = json;
  }

  Map<String, dynamic> toJson() {
    return data ?? {};
  }
}
