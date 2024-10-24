class SpecificFriendUser {
  int? id;
  int? otherUserId;
  String? otherUserName;
  String? otherUserImage;
  String? otherUserMemberSince;
  List<int>? otherUserCoursesTaken; // List of int instead of Course
  int? fromUser;
  int? toUser;
  String? createdAt;
  String? acceptedAt;

  SpecificFriendUser({
    this.id,
    this.otherUserId,
    this.otherUserName,
    this.otherUserImage,
    this.otherUserMemberSince,
    this.otherUserCoursesTaken,
    this.fromUser,
    this.toUser,
    this.createdAt,
    this.acceptedAt,
  });

  SpecificFriendUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    otherUserId = json['other_user_id'];
    otherUserName = json['other_user_name'];
    otherUserImage = json['other_user_image'];
    otherUserMemberSince = json['other_user_member_since'];
    if (json['other_user_courses_taken'] != null) {
      otherUserCoursesTaken = List<int>.from(json['other_user_courses_taken']);
    }
    fromUser = json['from_user'];
    toUser = json['to_user'];
    createdAt = json['created_at'];
    acceptedAt = json['accepted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['other_user_id'] = otherUserId;
    data['other_user_name'] = otherUserName;
    data['other_user_image'] = otherUserImage;
    data['other_user_member_since'] = otherUserMemberSince;
    if (otherUserCoursesTaken != null) {
      data['other_user_courses_taken'] = otherUserCoursesTaken;
    }
    data['from_user'] = fromUser;
    data['to_user'] = toUser;
    data['created_at'] = createdAt;
    data['accepted_at'] = acceptedAt;
    return data;
  }
}
