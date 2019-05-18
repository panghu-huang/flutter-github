import 'package:flutter/material.dart';
import 'package:github/models/repository.dart';
import 'package:github/models/search_result.dart';
import 'package:github/models/user.dart';
import 'package:github/services/api_service.dart';
import 'package:github/config/config.dart' as config;
import 'package:github/widgets/repository_listview.dart';
import 'package:github/widgets/user_listview.dart';

class Search extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _SearchState();
  }
}

const filterItems = ['repositories','users'];

class _SearchState extends State<Search> with AutomaticKeepAliveClientMixin {

  String _searchTarget = 'repositories';
  List _list = [];
  int _page = 0;
  bool _loading = false;
  bool _hasMore = true;
  String _keyword;

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _buildFilterBar(),
        Expanded(
          child: _buildListView(),
        )
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;

  Widget _buildListView() {
    switch (_searchTarget) {
      case 'repositories':
        return RepositoryListView(
          loadMore: _fetchList,
          hasMore: _hasMore,
          loading: _loading,
          repositories: _list.cast<Repository>(),
        );
      case 'users':
        return UserListView(
          loadMore: _fetchList,
          hasMore: _hasMore,
          loading: _loading,
          users: _list.cast<User>(),
        );
    }
    return null;
  }
  
  Widget _buildFilterBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(6, 0, 6, 0),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.black12),
      ),
      child: Row(
        children: <Widget>[
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _searchTarget,
              items: _buildFilterItems(),
              onChanged: (String value) {
                setState(() {
                  _list = [];
                  this._searchTarget = value;
                });
              },
            ),
          ),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                border: null,
                fillColor: Colors.white,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
              ),
              onSubmitted: _search,
            ),
          )
        ],
      ),
    );
  }

  List<DropdownMenuItem> _buildFilterItems() {
    List<DropdownMenuItem<String>> items = [];
    for (var filterItem in filterItems) {
      items.add(
        DropdownMenuItem(
          value: filterItem,
          child: Text(
            filterItem.replaceRange(0, 1, filterItem[0].toUpperCase())
          ),
        )
      );
    }
    return items;
  }

  void _search(String keyword) {
    setState(() {
      _loading = true;
      _page = 0;
      _list = [];
      _keyword = keyword;
    });
    _fetchList();
  }

  void _fetchList() async {
    setState(() => _loading = true);
    ApiService service = ApiService(routeName: 'search');
    Map<String, dynamic> original = await service.get(
      path: _searchTarget,
      params: {
        'page': ++_page,
        'per_page': config.defaultPageSize,
        'q': _keyword,
      }
    );
    if (mounted) {
      SearchResult result = SearchResult.fromJson(original, _formatJson);
      setState(() {
        _list.addAll(result.list);
        _loading = false;
        _hasMore = !result.incompleteResults;
      });
    }
  }

  dynamic _formatJson(Map<String, dynamic> json) {
    switch (_searchTarget) {
      case 'repositories':
        return Repository.fromJson(json);
      case 'users':
        return User.fromJson(json);
    }
  }

}