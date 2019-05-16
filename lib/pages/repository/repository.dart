import 'package:flutter/material.dart';
import 'package:github/pages/repository/repository_code.dart';
import 'package:github/pages/repository/repository_issues.dart';

class RepositoryPage extends StatefulWidget {

  final String user;
  final String name;

  RepositoryPage({ this.user, this.name });

  @override
  State<StatefulWidget> createState() {
    return _RepositoryPageState(
      user: this.user,
      name: this.name,
    );
  }

}

class _RepositoryPageState extends State<RepositoryPage> with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {

  final String user;
  final String name;

  TabController _controller;
  _RepositoryPageState({ this.user, this.name });

  @override
  void initState() {
    super.initState();
    _controller = TabController(
      length: 2,
      vsync: this,
    );
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$user/$name'),
        elevation: 0,
      ),
      body: Column(
        children: <Widget>[
          Container(
            color: Colors.blue,
            child: TabBar(
              controller: _controller,
              indicatorColor: Colors.white,
              tabs: <Widget>[
                Tab(text: 'Code'),
                Tab(text: 'Issues'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _controller,
              children: <Widget>[
                RepositoryCodePage(
                  user: user,
                  name: name,
                ),
                RepositoryIssues('$user/$name')
              ],
            ),
          )
        ],
      )
    );
  }

  @override
  bool get wantKeepAlive => true;

}