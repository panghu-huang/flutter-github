import 'package:flutter/material.dart';
import 'package:github/models/repository.dart';
import 'package:github/services/api_service.dart';
import 'package:github/config/config.dart' as config;
import 'package:github/widgets/repository_listview.dart';

class OrganizationRepositories extends StatefulWidget {

  final String name;

  OrganizationRepositories(this.name);

  @override
  State<StatefulWidget> createState() {
    return _OrganizationRepositoriesState();
  }
}

class _OrganizationRepositoriesState extends State<OrganizationRepositories> with AutomaticKeepAliveClientMixin {

  List<Repository> _repositories = [];
  bool _loading = false;
  bool _hasMore = true;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    _fetchOrganizationRepositories();
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryListView(
      loading: _loading,
      hasMore: _hasMore,
      loadMore: _fetchOrganizationRepositories,
      repositories: _repositories,
    );
  }

  @override
  bool get wantKeepAlive => true;

  void _fetchOrganizationRepositories() async {
    setState(() => _loading = true);
    ApiService service = ApiService(routeName: 'orgs');
    List list = await service.get(
      path: '${widget.name}/repos',
      params: {
        'page': ++_page,
        'per_page': config.defaultPageSize,
      },
    );
    if (mounted) {
      List<Repository> repositories = [];
      for (var item in list) {
        repositories.add(Repository.fromJson(item));
      }
      setState(() {
        _repositories.addAll(repositories);
        _loading = false;
        _hasMore = repositories.length >= config.defaultPageSize;
      });
    }
  }
}