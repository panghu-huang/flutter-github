import 'package:flutter/material.dart';
import 'package:github/models/user.dart';
import './pull_up_load_listview.dart';

class UserListView extends StatelessWidget {

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
  Widget build(BuildContext ctx) {
    int length = users.length;
    return PullUpLoadListView(
      loadMore: loadMore,
      loading: loading,
      hasMore: hasMore,
      itemCount: length,
      padding: padding,
      itemBuilder: (ctx, index) {
        return _buildItem(
          users[index], index == length - 1,
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
    );
  }

}