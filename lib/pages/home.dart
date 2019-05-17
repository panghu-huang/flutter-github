import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:github/pages/popular.dart';
import 'package:github/pages/search.dart';
import 'package:github/pages/my.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Github'),
      ),
      bottomNavigationBar: _buildNavigationBar(),
      body: PageView(
        controller: _controller,
        children: [
          Popular(),
          Search(),
          My(),
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