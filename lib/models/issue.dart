import 'package:github/models/issue_label.dart';
import 'package:github/models/user.dart';

enum IssueStatus {
  Open, Close,
}

class Issue {

  String title;
  String url;
  String repositoryUrl;
  User user;
  List<IssueLabel> labels;
  IssueStatus status = IssueStatus.Open;
  String updatedAt;

  Issue({
    this.title,
    this.url,
    this.repositoryUrl,
    this.user,
    this.labels,
    this.status,
    this.updatedAt,
  });

  factory Issue.fromJson(Map<String, dynamic> json) {
    List list = json['labels'];
    List<IssueLabel> labels = [];
    for (var item in list) {
      labels.add(IssueLabel.fromJson(item));
    }
    return Issue(
      title: json['title'],
      url: json['url'],
      repositoryUrl: json['repository_url'],
      user: User.fromJson(json['user']),
      labels: labels,
      updatedAt: json['updated_at'],
      status: json['status'] == 'open' ? IssueStatus.Open : IssueStatus.Close,
    );
  }

}