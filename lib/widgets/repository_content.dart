import 'package:flutter/material.dart';
import 'package:github/models/repository_content.dart';
import 'package:github/pages/organization/organization.dart';
import 'package:github/pages/user/user.dart';
import 'package:github/services/api_service.dart';
import 'package:github/widgets/loading.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class RepositoryContentWidget extends StatefulWidget {

  final String fullName;
  final bool isOrganization;

  RepositoryContentWidget(this.fullName, this.isOrganization);
  @override
  State<StatefulWidget> createState() {
    return _RepositoryContentWidgetState();
  }
}

class _RepositoryContentWidgetState extends State<RepositoryContentWidget> {

  String _path;
  List<RepositoryContent> _contents = [];
  RepositoryContent _content;
  bool _loading = false;
  bool _isDirectory = true;

  @override
  void initState() {
    super.initState();
    _fetchRepositoryContents();
  }

  @override
  Widget build(BuildContext context) {
    Widget body = _buildBody();
    return Column(
      children: <Widget>[
        _buildFilePath(),
        Expanded(
          child: body,
        )
      ],
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return Loading();
    }
    if (_isDirectory) {
      return _buildDirectory();
    }
    return _buildFile();
  }

  Widget _buildDirectory() {
    int length = _contents.length;
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
      itemCount: length,
      itemExtent: 46,
      itemBuilder: (ctx, index) {
        return _buildDirectoryItem(
          _contents[index], index == length - 1,
        );
      },
    );
  }

  Widget _buildFile() {
    List<String> contents = _content.content;
    print(_content.name);
    if (_hasImageSuffix(_content.name)) {
      return Container(
        padding: EdgeInsets.all(8),
        child: Image.network(_content.downloadUrl),
      );
    }
    if (_content.name.toLowerCase().endsWith('.md')) {
      return Markdown(data: contents.join('\n'));
    }
    return ListView.builder(
      padding: EdgeInsets.all(8),
      itemCount: contents.length,
      itemBuilder: (ctx, index) {
        return Text(contents[index]);
      },
    );
  }

  Widget _buildDirectoryItem(RepositoryContent content, bool isLast) {
    IconData icon = content.contentType == ContentType.File
      ? Icons.attach_file
      : Icons.store_mall_directory;
    Border border = isLast ? null : Border(
      bottom: BorderSide(width: 1, color: Colors.black12)
    );
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
          border: border,
        ),
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.only(right: 4),
              child: Icon(icon, size: 15),
            ),
            Expanded(
              child: Text(
                content.name,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        if (_hasImageSuffix(content.name)) {
          setState(() {
            _path = _path == null ? content.path : '$_path/${content.path}';
            _isDirectory = false;
            _content = content;
          });
        } else {
          _path = content.path;
          _fetchRepositoryContents();
        }
      },
    );
  }

  Widget _buildFilePath() {
    String path = widget.fullName + (_path == null ? '' : '/$_path');
    List<String> directories = path.split('/');
    List<Widget> widgets = [];
    int length = directories.length;
    for (int i = 0; i < length; i++) {
      String directory = directories[i];
      widgets.add(
        InkWell(
          child: Container(
            padding: EdgeInsets.all(4),
            child: Text(
              directory,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.start,
              style: TextStyle(
                color: Colors.black87,
                letterSpacing: 1,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ),
          onTap: () {
            switch (i) {
              case 0:
                if (widget.isOrganization) {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (ctx) => Organization(directory),
                  ));
                } else {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (ctx) => UserPage(directory),
                  ));
                }
                break;
              case 1:
                _path = null;
                _fetchRepositoryContents();
                break;
              default:
                _path = directories.getRange(2, i + 1).join('/');
                _fetchRepositoryContents();
                break;
            }
          },
        )
      );
      if (i != length - 1) {
        widgets.add(Text('/'));
      }
    }
    return Container(
      child: Row(
        children: widgets,
      ),
    );
  }

  void _fetchRepositoryContents() async {
    setState(() => _loading = true);
    ApiService service = ApiService(
      routeName: 'repos/${widget.fullName}/contents'
    );
    var result = await service.get(
      path: _path,
    );
    if (mounted) {
      if (result is List) {
        List<RepositoryContent> contents = [];
        for (var item in result) {
          contents.add(RepositoryContent.fromJson(item));
        }
        contents.sort((prev, next) {
          if (next.contentType == prev.contentType) {
            if (next.name.startsWith('.')) {
              return 0;
            }
            return 1;
          }
          if (next.contentType == ContentType.Dir) {
            return 1;
          }
          return 0;
        });
        setState(() {
          _contents = contents;
          _loading = false;
          _isDirectory = true;
        });
      } else {
        setState(() {
          _content = RepositoryContent.fromJson(result);
          _loading = false;
          _isDirectory = false;
        });
      }
    }
  }

  bool _hasImageSuffix(String filename) {
    filename = filename.toLowerCase();
    return filename.endsWith('.png') || filename.endsWith('.jpg') || filename.endsWith('.jpeg');
  }

}