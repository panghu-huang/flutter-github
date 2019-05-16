import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PullUpLoadListView extends StatefulWidget {

  final bool hasMore;
  final bool loading;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final Function loadMore;

  PullUpLoadListView({
    this.hasMore = true,
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
    return ListView.builder(
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