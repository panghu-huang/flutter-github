import 'package:flutter/widgets.dart';
import 'package:github/models/user.dart';

class Repository {

  int id;
  String name;
  String fullName;
  String description;
  String url;
  String language;
  String createdAt;
  String updatedAt;
  String pushedAt;
  String homepage;
  User owner;
  int stargazersCount;
  int watchersCount;
  int openIssuesCount;

  Repository({
    @required this.id,
    @required this.name,
    @required this.fullName,
    this.homepage,
    this.description,
    this.url,
    this.language,
    this.createdAt,
    this.updatedAt,
    this.pushedAt,
    this.stargazersCount,
    this.watchersCount,
    this.owner,
    this.openIssuesCount,
  });

  factory Repository.fromJson(Map<String, dynamic> json) {
    return Repository(
      id: json['id'],
      name: json['name'],
      fullName: json['full_name'],
      description: json['description'],
      url: json['url'],
      language: json['language'],
      homepage: json['homepage'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      pushedAt: json['pushed_at'],
      stargazersCount: json['stargazers_count'],
      watchersCount: json['watchers_count'],
      owner: User.fromJson(json['owner']),
      openIssuesCount: json['open_issues_count'],
    );
  }

}