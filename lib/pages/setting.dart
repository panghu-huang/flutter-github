import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:github/config/config.dart' as config;

class Setting extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _SettingState();
  }

}

class _SettingState extends State<Setting> {

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.color_lens),
          title: Text('Theme'),
          onTap: _changeThemeColor,
        ),
        ListTile(
          leading: Icon(Icons.settings_backup_restore),
          title: Text('清除登录名'),
          onTap: _removeLoginName,
        )
      ],
    );
  }

  void _changeThemeColor() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext ctx) {
        return Column(
          children: [
            _buildThemeColorItem('Blue', Colors.blue),
            _buildThemeColorItem('Red', Colors.red),
            _buildThemeColorItem('Amber', Colors.amber)
          ],
        );
      }
    );
  }

  Widget _buildThemeColorItem(String label, Color color) {
    return InkWell(
      child: Container(
        padding: EdgeInsets.all(12),
        child: Row(
          children: <Widget>[
            Container(
              color: color,
              margin: EdgeInsets.only(right: 12),
              width: 20,
              height: 20,
            ),
            Text(label)
          ],
        ),
      ),
    );
  }

  void _removeLoginName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(config.savedLoginKey);
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text('清除登录信息成功'),
    ));
  }

}