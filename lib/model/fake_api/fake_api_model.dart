class FakeApiModel {
  String? title;
  String? description;
  String? duedate;
  String? priority;
  String? id;
  int? statusCode;

  FakeApiModel({
    this.title,
    this.description,
    this.duedate,
    this.priority,
    this.id,
    this.statusCode,
  });

  FakeApiModel.fromJson(Map<String, dynamic> json, {this.statusCode}) {
    title = json['title'];
    description = json['description'];
    duedate = json['duedate'];
    priority = json['priority'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['description'] = this.description;
    data['duedate'] = this.duedate;
    data['priority'] = this.priority;
    data['id'] = this.id;
    if (this.statusCode != null) {
      data['statusCode'] = this.statusCode;
    }
    return data;
  }
}
