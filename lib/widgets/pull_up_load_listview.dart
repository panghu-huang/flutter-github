import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PullUpLoadListView extends StatefulWidget {

  final bool hasMore;
  final bool loading;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final Function loadMore;
  final EdgeInsetsGeometry padding;

  PullUpLoadListView({
    this.hasMore = true,
    this.padding,
    this.itemBuilder,
    this.itemCount,
    this.loading,
    this.loadMore,
  });

  @override
  State<StatefulWidget> createState() {
    return _PullUpLoadListViewState();
  }
}

class _PullUpLoadListViewState extends State<PullUpLoadListView> {

  ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _controller.addListener(_handleListViewScroll);
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.loading && widget.itemCount == 0) {
      return _buildEmpty();
    }
    return ListView.builder(
      padding: widget.padding,
      itemCount: widget.itemCount + 1,
      itemBuilder: (BuildContext ctx, int index) {
        if (index == widget.itemCount) {
          if (widget.loading) {
            return Container(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: CupertinoActivityIndicator(),
            );
          }
          return null;
        }
        return widget.itemBuilder(ctx, index);
      },
      controller: _controller,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Widget _buildEmpty() {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(0, 100, 0, 10),
          child: Icon(
            Icons.business,
            size: 80,
            color: Colors.black38,
          ),
        ),
        Text(
          '暂无数据',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black54,
          ),
        )
      ],
    );
  }

  void _handleListViewScroll() {
    double max = _controller.position.maxScrollExtent;
    double current = _controller.position.pixels;
    if (max - current <= 20) {
      if (!widget.loading && widget.hasMore) {
        widget.loadMore?.call();
      }
    }
  }

}