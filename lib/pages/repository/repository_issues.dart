import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:github/models/hex_color.dart';
import 'package:github/models/issue.dart';
import 'package:github/models/issue_label.dart';
import 'package:github/services/api_service.dart';
import 'package:github/config/config.dart' as config;

class RepositoryIssues extends StatefulWidget {

  final String fullName;

  RepositoryIssues(this.fullName);

  @override
  State<StatefulWidget> createState() {
    return _RepositoryIssuesState(this.fullName);
  }
}

class _RepositoryIssuesState extends State<RepositoryIssues> with AutomaticKeepAliveClientMixin {

  final String fullName;
  ScrollController _controller;
  int _page = 1;
  bool _loading = false;
  bool _hasMore = true;
  List<Issue> _issues = [];

  _RepositoryIssuesState(this.fullName);

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _controller.addListener(_handleListScroll);
    _fetchIssues();
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    int length = _issues.length;
    return ListView.builder(
      controller: _controller,
      itemCount: length + 1,
      itemBuilder: (ctx, index) {
        if (index == length) {
          if (_loading) {
            return Container(
              padding: EdgeInsets.all(8),
              child: CupertinoActivityIndicator(),
            );
          }
          return null;
        }
        return _buildIssueItem(_issues[index]);
      },
    );
  }

  @override
  dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  Widget _buildIssueItem(Issue issue) {
    List<Widget> labels = _buildIssueLabels(issue.labels);
    return Card(
      child: Container(
        padding: EdgeInsets.all(6),
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              child: Text(
                issue.title,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 16,
                  letterSpacing: 1,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 6, bottom: 6),
              child: Row(
                children: labels,
              ),
            ),
            Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(issue.updatedAt),
                Text(issue.user.login),
              ],
            )
          ],
        ),
      ),
    );
  }

  List<Widget> _buildIssueLabels(List<IssueLabel> labels) {
    List<Widget> widgets = [];
    for (IssueLabel label in labels) {
      widgets.add(
        Container(
          padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
          margin: EdgeInsets.only(right: 6),
          color: HexColor(label.color),
          child: Text(
            label.name,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        )
      );
    }
    return widgets;
  }

  void _fetchIssues() async {
    setState(() => _loading = true);
    ApiService service = ApiService(routeName: 'repos');
    List list = await service.get(
      path: '$fullName/issues',
      params: {
        'page': _page,
        'per_page': config.defaultPageSize,
      },
    );
    if (mounted) {
      List<Issue> issues = [];
      for (var item in list) {
        issues.add(Issue.fromJson(item));
      }
      setState(() {
        _issues.addAll(issues);
        _loading = false;
        _hasMore = issues.length >= config.defaultPageSize;
      });
    }
  }

  void _handleListScroll() {
    double max = _controller.position.maxScrollExtent;
    double current = _controller.position.pixels;
    if (max - current <= 20) {
      if (!_loading && _hasMore) {
        _page++;
        _fetchIssues();
      }
    }
  }

}