import 'package:flutter/material.dart';
import 'package:github/pages/repository/repository_code.dart';
import 'package:github/pages/repository/repository_issues.dart';

class RepositoryPage extends StatefulWidget {

  final String user;
  final String name;

  RepositoryPage({ this.user, this.name });

  @override
  State<StatefulWidget> createState() {
    return _RepositoryPageState();
  }

}

class _RepositoryPageState extends State<RepositoryPage> with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {

  TabController _controller;

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
    ThemeData themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.user}/${widget.name}'),
        elevation: 0,
      ),
      body: Column(
        children: <Widget>[
          Container(
            color: themeData.primaryColor,
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
                  user: widget.user,
                  name: widget.name,
                ),
                RepositoryIssues('${widget.user}/${widget.name}')
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