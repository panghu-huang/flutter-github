import 'package:flutter/material.dart';
import 'package:github/models/user.dart';

class UserItem extends StatelessWidget {

  final User user;

  UserItem(this.user);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(6),
      child: Text(
        user.login,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
  
}