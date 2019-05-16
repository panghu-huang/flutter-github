import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:github/models/repository.dart';
import 'package:github/models/user.dart';
import 'package:github/services/api_service.dart';
import 'package:github/widgets/repository_item.dart';
import 'package:github/config/config.dart' as config;

class UserRepositories extends StatefulWidget {

  final String name;

  UserRepositories(this.name);

  @override
  State<StatefulWidget> createState() {
    return _UserRepositoriesState(this.name);
  }
}

class _UserRepositoriesState extends State<UserRepositories> with AutomaticKeepAliveClientMixin {

  final String name;
  int _page = 1;
  bool _loading = false;
  bool _hasMore = true;
  List<Repository> _repositories = [];
  ScrollController _controller;
  User _user;

  _UserRepositoriesState(this.name);

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _controller.addListener(_handleListScroll);
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
  void dispose() {
    super.dispose();
    _controller.dispose();
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
    int length = _repositories.length;
    return Expanded(
      child: ListView.builder(
        controller: _controller,
        itemCount: length + 1,
        itemBuilder: (ctx, index) {
          if (index == length) {
            if (!_loading) {
              return null;
            }
            return Container(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: CupertinoActivityIndicator(),
            );
          }
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
      path: name
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
      path: '$name/repos',
      params: {
        'sort': 'pushed',
        'page': _page,
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

  void _handleListScroll() {
    double max = _controller.position.maxScrollExtent;
    double current = _controller.position.pixels;
    if (max - current <= 20) {
      if (!_loading && _hasMore) {
        _page++;
        _fetchUserRepositories();
      }
    }
  }

}