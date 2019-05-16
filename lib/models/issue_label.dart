class IssueLabel {

  int id;
  String url;
  String name;
  String color;
  bool isDefault;

  IssueLabel({
    this.id,
    this.url,
    this.name,
    this.color,
    this.isDefault,
  });

  factory IssueLabel.fromJson(Map<String, dynamic> json) {
    return IssueLabel(
      id: json['id'],
      url: json['url'],
      name: json['name'],
      color: json['color'],
      isDefault: json['default'],
    );
  }

}