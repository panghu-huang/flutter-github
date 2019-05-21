import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:github/pages/popular.dart';
import 'package:github/pages/search.dart';
import 'package:github/pages/my.dart';
import 'package:github/pages/setting.dart';

class Home extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {

  PageController _controller = PageController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (_controller.page.round() != _currentIndex) {
        setState(() {
          _currentIndex = _controller.page.round();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Github'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      bottomNavigationBar: _buildNavigationBar(),
      body: PageView(
        controller: _controller,
        children: [
          Popular(),
          Search(),
          My(),
          Setting(),
        ],
      ),
    );
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildNavigationBar() {
    return BottomNavigationBar(
      selectedItemColor: Colors.blueAccent,
      unselectedItemColor: Colors.blue,
      currentIndex: _currentIndex,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.code),
          title: Text('Popular')
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          title: Text('Search')
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.insert_emoticon),
          title: Text('My'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          title: Text('Settings'),
        )
      ],
      onTap: (int index) {
        _controller.jumpToPage(index);
        setState(() {
          _currentIndex = index;
        });
      },
    );
  }

}