import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:github/models/repository.dart';
import 'package:github/models/user.dart';
import 'package:github/services/api_service.dart';
import 'package:github/widgets/pull_up_load_listview.dart';
import 'package:github/widgets/repository_item.dart';
import 'package:github/widgets/user_info.dart';
import 'package:github/config/config.dart' as config;

class UserRepositories extends StatefulWidget {

  final String name;

  UserRepositories(this.name);

  @override
  State<StatefulWidget> createState() {
    return _UserRepositoriesState();
  }
}

class _UserRepositoriesState extends State<UserRepositories> with AutomaticKeepAliveClientMixin {

  int _page = 0;
  bool _loading = false;
  bool _hasMore = true;
  List<Repository> _repositories = [];
  User _user;

  @override
  void initState() {
    super.initState();
    _fetchUserDetail();
    _fetchUserRepositories();
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        UserInfo(_user),
        _buildUseRepositories()
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;

  Widget _buildUseRepositories() {
    return Expanded(
      child: PullUpLoadListView(
        loading: _loading,
        hasMore: _hasMore,
        loadMore: _fetchUserRepositories,
        itemCount: _repositories.length,
        itemBuilder: (ctx, index) {
          return RepositoryItem(
            _repositories[index]
          );
        },
      ),
    );
  }

  void _fetchUserDetail() async {
    ApiService service = ApiService(routeName: 'users');
    var result = await service.get(
      path: widget.name,
    );
    if (mounted) {
      setState(() {
        _user = User.fromJson(result);
      });
    }
  }

  void _fetchUserRepositories() async {
    setState(() => _loading = true);
    ApiService service = ApiService(routeName: 'users');
    var result = await service.get(
      path: '${widget.name}/repos',
      params: {
        'sort': 'pushed',
        'page': ++_page,
        'per_page': config.defaultPageSize,
      }
    );
    if (mounted) {
      List<Repository> repositories = [];
      for (var item in result) {
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