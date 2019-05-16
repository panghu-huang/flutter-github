import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:github/models/repository.dart';
import 'package:github/models/user.dart';
import 'package:github/services/api_service.dart';
import 'package:github/widgets/pull_up_load_listview.dart';
import 'package:github/widgets/repository_item.dart';
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
        _buildUserInfo(_user),
        _buildUseRepositories()
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;

  Widget _buildUserInfo(User user) {
    if (user == null) {
      return Container();
    }
    return Card(
      child: Container(
        height: 70,
        margin: EdgeInsets.only(top: 8),
        padding: EdgeInsets.only(left: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 8),
              child: CircleAvatar(
                child: Image.network(user.avatarUrl),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 6),
                  child: Text(
                    '${user.name}(${user.login})',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(right: 2),
                      child: Icon(
                        Icons.location_city,
                        size: 14,
                        color: Colors.black45
                      ),
                    ),
                    Text(user.location),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

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
      path: '${widget.name}}/repos',
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