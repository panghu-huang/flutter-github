import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:github/utils/base64.dart';

enum ContentType {
  File, Dir
}

class RepositoryContent {

  String name;
  String path;
  String sha;
  String url;
  List<String> content;
  String downloadUrl;
  ContentType contentType = ContentType.File;

  RepositoryContent({
    @required this.name,
    this.path,
    this.sha,
    this.url,
    this.contentType,
    this.content,
    this.downloadUrl,
  });

  factory RepositoryContent.fromJson(Map<String, dynamic> json) {
    List<String> content = [];
    String contentString = json['content'];
    if (contentString != null) {
      try {
        List<String> segments = contentString.split('\n');
        content = segments.map((segment) => Base64Utils.decode(segment)).toList();
      } catch (e) {
        content = [
          '内容解码出现错误：',
          e.toString()
        ];
      }
    }
    return RepositoryContent(
      name: json['name'],
      path: json['path'],
      sha: json['sha'],
      url: json['url'],
      contentType: json['type'] == 'dir' ? ContentType.Dir : ContentType.File,
      content: content,
      downloadUrl: json['download_url'],
    );
  }

}