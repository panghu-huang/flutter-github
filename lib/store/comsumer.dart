import 'package:flutter/material.dart';
import 'package:github/store/store.dart';
import 'package:github/store/provider.dart';

typedef Builder = Widget Function(BuildContext context, Store store);

class StoreConsumer extends StatelessWidget {

  final Builder builder;

  StoreConsumer({ this.builder });

  @override
  Widget build(BuildContext context) {
    return builder(context, StoreProvider.of(context).store);
  }

}