class ConversationModel {
  String? name;
  List<Participants>? participants;
  bool? isCourseGroup;
  bool? isOneToOne;
  Messages? messages;

  ConversationModel(
      {this.name,
      this.participants,
      this.isCourseGroup,
      this.isOneToOne,
      this.messages});

  ConversationModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    if (json['participants'] != null) {
      participants = <Participants>[];
      json['participants'].forEach((v) {
        participants!.add(new Participants.fromJson(v));
      });
    }
    isCourseGroup = json['is_course_group'];
    isOneToOne = json['is_one_to_one'];
    messages = json['messages'] != null
        ? new Messages.fromJson(json['messages'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    if (this.participants != null) {
      data['participants'] = this.participants!.map((v) => v.toJson()).toList();
    }
    data['is_course_group'] = this.isCourseGroup;
    data['is_one_to_one'] = this.isOneToOne;
    if (this.messages != null) {
      data['messages'] = this.messages!.toJson();
    }
    return data;
  }
}

class Participants {
  int? id;
  String? name;
  String? image;

  Participants({this.id, this.name, this.image});

  Participants.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    return data;
  }
}

class Messages {
  String? next;
  String? previous;
  List<Results>? results;

  Messages({this.next, this.previous, this.results});

  Messages.fromJson(Map<String, dynamic> json) {
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      results = <Results>[];
      json['results'].forEach((v) {
        results!.add(new Results.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['next'] = this.next;
    data['previous'] = this.previous;
    if (this.results != null) {
      data['results'] = this.results!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Results {
  String? content;
  int? sender;
  String? senderName;
  String? senderImage;
  String? createdAt;

  Results(
      {this.content,
      this.sender,
      this.senderName,
      this.senderImage,
      this.createdAt});

  Results.fromJson(Map<String, dynamic> json) {
    content = json['content'];
    sender = json['sender'];
    senderName = json['sender_name'];
    senderImage = json['sender_image'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['content'] = this.content;
    data['sender'] = this.sender;
    data['sender_name'] = this.senderName;
    data['sender_image'] = this.senderImage;
    data['created_at'] = this.createdAt;
    return data;
  }
}
