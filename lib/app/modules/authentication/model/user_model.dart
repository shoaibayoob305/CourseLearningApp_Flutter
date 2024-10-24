class UserModel {
  int? id;
  String? username;
  String? email;
  String? firstName;
  String? lastName;
  String? image;

  UserModel(
      {this.id,
      this.username,
      this.email,
      this.firstName,
      this.lastName,
      this.image});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['email'] = this.email;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['image'] = this.image;
    return data;
  }
}
