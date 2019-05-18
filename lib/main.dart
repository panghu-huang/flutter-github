import 'package:flutter/material.dart';
import 'package:github/store/provider.dart';
import 'package:github/pages/home.dart';
import 'package:github/services/api_service.dart';

class GithubApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      child: MaterialApp(
        home: Home(),
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