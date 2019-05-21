import 'package:flutter/material.dart';
import 'package:github/store/comsumer.dart';
import 'package:github/store/provider.dart';
import 'package:github/pages/home.dart';
import 'package:github/services/api_service.dart';
import 'package:github/store/store.dart';

class GithubApp extends StatelessWidget {

  final Store store = Store();

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: StoreConsumer(
        builder: (ctx, store) {
          print('update');
          return MaterialApp(
            home: Home(),
            theme: store.themeData,
          );
        },
      ),
    );
  }

}

void main() {
  ApiService.config(
    baseUrl: 'https://api.github.com'
  );
 runApp(GithubApp());
}