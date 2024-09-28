class EventResponse {
  bool? status;
  String? message;
  List<Event>? data;

  EventResponse({this.status, this.message, this.data});

  EventResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Event>[];
      json['data'].forEach((v) {
        data!.add(Event.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Event {
  String? title;
  String? date;
  String? description;

  Event({this.title, this.date, this.description});

  Event.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    date = json['date'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['date'] = date;
    data['description'] = description;
    return data;
  }
}
