import 'package:flutter/material.dart';
import 'package:github/models/user.dart';
import 'package:github/services/api_service.dart';
import 'package:github/config/config.dart' as config;
import 'package:github/widgets/user_listview.dart';

class OrganizationMembers extends StatefulWidget {

  final String name;

  OrganizationMembers(this.name);

  @override
  State<StatefulWidget> createState() {
    return _OrganizationMembersState();
  }
}

class _OrganizationMembersState extends State<OrganizationMembers> with AutomaticKeepAliveClientMixin {

  List<User> _users = [];
  bool _loading = false;
  bool _hasMore = true;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    _fetchOrganizationMembers();
  }

  @override
  Widget build(BuildContext context) {
    return UserListView(
      loading: _loading,
      hasMore: _hasMore,
      loadMore: _fetchOrganizationMembers,
      users: _users,
      padding: EdgeInsets.all(8)
    );
  }

  @override
  bool get wantKeepAlive => true;

  void _fetchOrganizationMembers() async {
    setState(() => _loading = true);
    ApiService service = ApiService(routeName: 'orgs');
    List list = await service.get(
      path: '${widget.name}/members',
      params: {
        'page': ++_page,
        'per_page': config.defaultPageSize,
      },
    );
    if (mounted) {
      List<User> users = [];
      for (var item in list) {
        users.add(User.fromJson(item));
      }
      setState(() {
        _users.addAll(users);
        _loading = false;
        _hasMore = users.length >= config.defaultPageSize;
      });
    }
  }

}