import 'package:flutter/material.dart';
import 'package:github/models/user.dart';
import 'package:github/pages/user/user_item.dart';
import 'package:github/services/api_service.dart';
import 'package:github/config/config.dart' as config;
import 'package:github/widgets/pull_up_load_listview.dart';

class UserFollowers extends StatefulWidget {

  final String name;
  final String type;

  UserFollowers({
    this.name, 
    this.type = 'followers'
  });
  
  @override
  State<StatefulWidget> createState() {
    return _UserFollowersState();
  }
}

class _UserFollowersState extends State<UserFollowers> {

  List<User> _followers = [];
  bool _loading = false;
  bool _hasMore = true;
  int _page = 0;
  
  @override
  void initState() {
    super.initState();
    _fetchUserFollowers();
  }

  @override
  Widget build(BuildContext context) {
    return PullUpLoadListView(
      hasMore: _hasMore,
      loading: _loading,
      loadMore: _fetchUserFollowers,
      itemCount: _followers.length,
      itemBuilder: (ctx, index) {
        return UserItem(_followers[index]);
      },
    );
  }

  void _fetchUserFollowers() async {
    setState(() => _loading = true);
    ApiService service = ApiService(routeName: 'users');
    List users = await service.get(
      path: '${widget.name}/${widget.type}',
      params: {
        'per_page': config.defaultPageSize,
        'page': ++_page,
      },
    );
    if (mounted) {
      List<User> followers = [];
      for (var user in users) {
        followers.add(User.fromJson(user));
      }
      setState(() {
        _followers.addAll(followers);
        _hasMore = followers.length >= config.defaultPageSize;
       _loading = false; 
      });
    }
  }

}