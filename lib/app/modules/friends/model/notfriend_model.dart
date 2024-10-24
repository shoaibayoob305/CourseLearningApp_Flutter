class SpecificUser {
  int? id;
  int? userId;
  String? email;
  String? firstName;
  String? lastName;
  String? image;
  AdditionalData? additionalData;

  SpecificUser(
      {this.id,
      this.userId,
      this.email,
      this.firstName,
      this.lastName,
      this.image,
      this.additionalData});

  SpecificUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    email = json['email'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    image = json['image'];
    additionalData = json['additional_data'] != null
        ? new AdditionalData.fromJson(json['additional_data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['email'] = this.email;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['image'] = this.image;
    if (this.additionalData != null) {
      data['additional_data'] = this.additionalData!.toJson();
    }
    return data;
  }
}

class AdditionalData {
  String? city;
  String? country;
  String? birthdate;

  AdditionalData({this.city, this.country, this.birthdate});

  AdditionalData.fromJson(Map<String, dynamic> json) {
    city = json['city'];
    country = json['country'];
    birthdate = json['birthdate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['city'] = this.city;
    data['country'] = this.country;
    data['birthdate'] = this.birthdate;
    return data;
  }
}
