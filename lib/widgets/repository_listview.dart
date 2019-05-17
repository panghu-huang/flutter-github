import 'package:flutter/material.dart';
import 'package:github/models/repository.dart';
import './pull_up_load_listview.dart';
import './repository_item.dart';

class RepositoryListView extends StatelessWidget {

  final List<Repository> repositories;
  final bool loading;
  final bool hasMore;
  final Function loadMore;

  RepositoryListView({
    this.repositories,
    this.loading,
    this.loadMore,
    this.hasMore,
  });

  @override
  Widget build(BuildContext ctx) {
    return PullUpLoadListView(
      loadMore: loadMore,
      loading: loading,
      hasMore: hasMore,
      itemCount: repositories.length,
      itemBuilder: (ctx, index) {
        return RepositoryItem(repositories[index]);
      },
    );
  }

}