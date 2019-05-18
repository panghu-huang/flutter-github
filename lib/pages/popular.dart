import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:github/models/repository.dart';
import 'package:github/models/search_result.dart';
import 'package:github/services/api_service.dart';
import 'package:github/config/config.dart' as config;
import 'package:github/widgets/repository_listview.dart';

class Popular extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _PopularState();
  }
}

class _PopularState extends State<Popular> with AutomaticKeepAliveClientMixin {

  List<Repository> _repositories = [];
  int _page = 0;
  bool _loading = false;

  @override
  void initState() {
    _fetchRepositories();
    super.initState();
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return RepositoryListView(
      loading: _loading,
      repositories: _repositories,
      loadMore: _fetchRepositories,
    );
  }

  @override
  bool get wantKeepAlive => true;

  void _fetchRepositories() async {
    setState(() => _loading = true);
    ApiService service = ApiService(routeName: 'search/repositories');
    Map<String, dynamic> result = await service.get(
      params: {
        'q': 'JavaScript',
        'sort': 'stars',
        "per_page": config.defaultPageSize,
        "page": ++_page,
      },
    );
    SearchResult<Repository> searchRepos = SearchResult.fromJson(result, (v) => Repository.fromJson(v));
    if (mounted) {
      setState(() {
        _loading = false;
        _repositories.addAll(searchRepos.list);
      });
    }
  }

}