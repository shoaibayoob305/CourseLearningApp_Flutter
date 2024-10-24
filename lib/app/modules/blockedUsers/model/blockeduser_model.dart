class BlockedUserModel {
  int? id;
  int? blocked;
  String? blockedUserName;
  String? createdAt;

  BlockedUserModel(
      {this.id, this.blocked, this.blockedUserName, this.createdAt});

  BlockedUserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    blocked = json['blocked'];
    blockedUserName = json['blocked_user_name'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['blocked'] = this.blocked;
    data['blocked_user_name'] = this.blockedUserName;
    data['created_at'] = this.createdAt;
    return data;
  }
}
