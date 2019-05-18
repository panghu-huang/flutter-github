import 'package:flutter/material.dart';
import 'package:github/models/user.dart';
import 'package:github/pages/user/user.dart';
import './pull_up_load_listview.dart';

class UserListView extends StatefulWidget {
  final List<User> users;
  final bool loading;
  final bool hasMore;
  final Function loadMore;
  final EdgeInsetsGeometry padding;

  UserListView({
    this.users,
    this.loading,
    this.loadMore,
    this.hasMore,
    this.padding,
  });

  @override
  State<StatefulWidget> createState() {
    return _UserListViewState();
  }

}

class _UserListViewState extends State<UserListView> {

  @override
  Widget build(BuildContext ctx) {
    int length = widget.users.length;
    return PullUpLoadListView(
      loadMore: widget.loadMore,
      loading: widget.loading,
      hasMore: widget.hasMore,
      itemCount: length,
      padding: widget.padding,
      itemBuilder: (ctx, index) {
        return _buildItem(
          widget.users[index], index == length - 1,
        );
      },
    );
  }

  Widget _buildItem(User user, bool isLast) {
    Border bottomBorder = isLast
      ? null
      : Border(
        bottom: BorderSide(width: 1, color: Colors.black12)
      );
    return InkWell(
      child: Container(
        padding: EdgeInsets.fromLTRB(6, 12, 6, 12),
        decoration: BoxDecoration(
          border: bottomBorder,
        ),
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 12),
              child: CircleAvatar(
                child: Image.network(user.avatarUrl),
              ),
            ),
            Text(
              user.login,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
      ),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (ctx) => UserPage(user.login),
        ));
      },
    );
  }

}