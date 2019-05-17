import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:github/pages/popular.dart';
import 'package:github/pages/waiting.dart';

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
          Waiting(),
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
          icon: Icon(Icons.panorama_wide_angle),
          title: Text('Wating'),
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