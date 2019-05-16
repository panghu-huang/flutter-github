import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:github/widgets/pull_up_load_listview.dart';
import 'package:github/widgets/repository_item.dart';
import 'package:github/models/repository.dart';
import 'package:github/models/search_repos.dart';
import 'package:github/services/api_service.dart';
import 'package:github/config/config.dart' as config;

class Popular extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _PopularState();
  }
}

class _PopularState extends State<Popular> with AutomaticKeepAliveClientMixin {

  ScrollController _controller;
  List<Repository> _repositories = [];
  int _page = 0;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _controller.addListener(_handleListScroll);
    _fetchRepositories();
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return PullUpLoadListView(
      loading: _loading,
      itemCount: _repositories.length,
      itemBuilder: (BuildContext ctx, int index) {
        return RepositoryItem(_repositories[index]);
      },
      loadMore: _fetchRepositories,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.removeListener(_handleListScroll);
    _controller.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  Widget _buildLoading() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
      child: Center(
        child: CupertinoActivityIndicator(),
      ),
    );
  }

  void _handleListScroll() {
    double max = _controller.position.maxScrollExtent;
    double current = _controller.position.pixels;
    if (max - current <= 20) {
      if (!_loading) {
        _page++;
        _fetchRepositories();
      }
    }
  }

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
    SearchRepositories searchRepos = SearchRepositories.fromJson(result);
    if (mounted) {
      setState(() {
        _loading = false;
        _repositories.addAll(searchRepos.repositories);
      });
    }
  }

}