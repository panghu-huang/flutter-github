import 'package:flutter/material.dart';
import 'package:github/pages/user/user_followers.dart';
import 'package:github/pages/user/user_repositories.dart';

class UserPage extends StatefulWidget {

  final String name;

  UserPage(this.name);

  @override
  State<StatefulWidget> createState() {
    return _UserPageState();
  }
}

class _UserPageState extends State<UserPage> with TickerProviderStateMixin {

  TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(
      length: 3,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(widget.name),
      ),
      body: Column(
        children: <Widget>[
          Container(
            color: Colors.blue,
            child: TabBar(
              controller: _controller,
              indicatorColor: Colors.white,
              tabs: <Widget>[
                Tab(text: 'Repositories'),
                Tab(text: 'Followers'),
                Tab(text: 'Following'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _controller,
              children: <Widget>[
                UserRepositories(widget.name),
                UserFollowers(name: widget.name, type: 'followers'),
                UserFollowers(name: widget.name, type: 'following'),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

}