class NotificationsModel {
  String? next;
  String? previous;
  List<Results>? results;

  NotificationsModel({this.next, this.previous, this.results});

  NotificationsModel.fromJson(Map<String, dynamic> json) {
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
  int? id;
  String? message;
  String? link;
  String? createdAt;
  bool? read;

  Results({this.id, this.message, this.link, this.createdAt, this.read});

  Results.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    message = json['message'];
    link = json['link'];
    createdAt = json['created_at'];
    read = json['read'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['message'] = this.message;
    data['link'] = this.link;
    data['created_at'] = this.createdAt;
    data['read'] = this.read;
    return data;
  }
}
