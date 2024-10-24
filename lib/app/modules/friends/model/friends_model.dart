class FriendsModel {
  int? id;
  int? otherUserId;
  String? otherUserName;
  String? otherUserImage;
  int? fromUser;
  int? toUser;
  String? createdAt;
  String? acceptedAt;

  FriendsModel(
      {this.id,
      this.otherUserId,
      this.otherUserName,
      this.otherUserImage,
      this.fromUser,
      this.toUser,
      this.createdAt,
      this.acceptedAt});

  FriendsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    otherUserId = json['other_user_id'];
    otherUserName = json['other_user_name'];
    otherUserImage = json['other_user_image'];
    fromUser = json['from_user'];
    toUser = json['to_user'];
    createdAt = json['created_at'];
    acceptedAt = json['accepted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['other_user_id'] = this.otherUserId;
    data['other_user_name'] = this.otherUserName;
    data['other_user_image'] = this.otherUserImage;
    data['from_user'] = this.fromUser;
    data['to_user'] = this.toUser;
    data['created_at'] = this.createdAt;
    data['accepted_at'] = this.acceptedAt;
    return data;
  }
}
