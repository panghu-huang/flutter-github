import 'package:flutter/material.dart';
import 'package:github/widgets/user_repositories.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:github/config/config.dart' as config;

class My extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _MyState();
  }
}

class _MyState extends State<My> with AutomaticKeepAliveClientMixin {

  String _login;
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getLoginName();
  }

  @override
  void didUpdateWidget(My oldWidget) {
    super.didUpdateWidget(oldWidget);
    _login = '2';
  }

  @override
  void deactivate() {
    super.deactivate();
    print('deactivate');
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    if (_login == null) {
      return _buildUnLogin();
    }
    return UserRepositories(_login);
  }

  @override
  bool get wantKeepAlive => true;

  Widget _buildUnLogin() {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 50, 20, 0),
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 40),
            child: Text('Login', style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: Colors.black87
            )),
          ),
          _buildField(
            icon: Icons.insert_emoticon,
            hint: 'Username',
            controller: _controller,
          ),
          _buildField(
            icon: Icons.lock_outline,
            hint: 'Password',
            obscureText: true,
          ),
          Container(
            width: double.infinity,
            height: 48,
            margin: EdgeInsets.only(top: 40),
            child: RaisedButton(
              color: Colors.blue,
              child: Text(
                'Login',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              onPressed: _saveLoginName,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildField({
    IconData icon, String hint, bool obscureText = false, TextEditingController controller,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.black45),
      ),
      padding: EdgeInsets.fromLTRB(10, 4, 10, 4),
      margin: EdgeInsets.only(bottom: 8, top: 8),
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 8),
            child: Icon(icon),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.text,
              obscureText: obscureText,
              decoration: InputDecoration(
                hintText: hint,
                border: null,
                fillColor: Colors.white,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
              ),
            ),
          )
        ],
      ),
    );
  }

  void _getLoginName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _login = prefs.getString(config.savedLoginKey);
    });
  }

  void _saveLoginName() async {
    String login = _controller.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(config.savedLoginKey, login);
    setState(() {
      _login = login;
    });
  }

}