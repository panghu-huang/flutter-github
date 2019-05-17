import 'package:flutter/material.dart';
import 'package:github/models/user.dart';

class UserInfo extends StatelessWidget {
  final User user;

  UserInfo(this.user);

  @override
  Widget build(BuildContext context) {
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
                      child: Icon(Icons.location_city,
                          size: 14, color: Colors.black45),
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
}
