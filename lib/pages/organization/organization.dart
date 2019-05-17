import 'package:flutter/material.dart';
import 'package:github/pages/organization/organization_members.dart';
import 'package:github/pages/organization/organization_repositories.dart';

class Organization extends StatefulWidget {

  final String name;

  Organization(this.name);

  @override
  State<StatefulWidget> createState() {
    return _OrganizationState();
  }
}

class _OrganizationState extends State<Organization> with TickerProviderStateMixin {

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
                Tab(text: 'Members'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _controller,
              children: <Widget>[
                OrganizationRepositories(widget.name),
                OrganizationMembers(widget.name),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}