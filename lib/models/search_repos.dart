import 'package:github/models/repository.dart';

class SearchRepositories {

  int total;
  List<Repository> repositories;

  SearchRepositories({
    this.total,
    this.repositories,
  });

  factory SearchRepositories.fromJson(Map<String, dynamic> json) {
    List<Repository> repositories = [];
    List items = json['items'];
    for (Map<String, dynamic> item in items) {
      repositories.add(Repository.fromJson(item));
    }
    return SearchRepositories(
      total: json['total'],
      repositories: repositories,
    );
  }

}