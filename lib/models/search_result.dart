import 'package:github/models/repository.dart';
//
//class SearchRepositories {
//
//  int total;
//  List<Repository> repositories;
//
//  SearchRepositories({
//    this.total,
//    this.repositories,
//  });
//
//  factory SearchRepositories.fromJson(Map<String, dynamic> json) {
//    List<Repository> repositories = [];
//    List items = json['items'];
//    for (Map<String, dynamic> item in items) {
//      repositories.add(Repository.fromJson(item));
//    }
//    return SearchRepositories(
//      total: json['total'],
//      repositories: repositories,
//    );
//  }
//
//}

typedef Formatter<T> = T Function(Map<String, dynamic> value);

class SearchResult<T> {
  int total;
  List<T> list;
  bool incompleteResults;

  SearchResult({
   this.total,
   this.list,
    this.incompleteResults,
  });

  factory SearchResult.fromJson(Map<String, dynamic> json, Formatter<T> formatter) {
    List<T> list = [];
    List items = json['items'];
    for (Map<String, dynamic> item in items) {
      list.add(formatter(item));
    }
    return SearchResult(
      total: json['total'],
      list: list,
      incompleteResults: json['incomplete_results'],
    );
  }

}