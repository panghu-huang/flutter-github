import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:github/models/repository.dart';
import 'package:github/services/api_service.dart';
import 'package:github/widgets/repository_content.dart';

class RepositoryCodePage extends StatefulWidget {

  final String user;
  final String name;

  RepositoryCodePage({ this.name, this.user });

  @override
  State<StatefulWidget> createState() {
    return _RepositoryCodePageState();
  }
}

class _RepositoryCodePageState extends State<RepositoryCodePage> with AutomaticKeepAliveClientMixin {

  Repository _repository;

  @override
  void initState() {
    super.initState();
    _repository = Repository(
      id: null,
      name: widget.name,
      fullName: '${widget.user}/${widget.name}',
      watchersCount: 0,
      stargazersCount: 0,
      openIssuesCount: 0,
    );
    _fetchRepository();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 8, bottom: 8),
          child: _buildBasicInfo(),
        ),
        Expanded(
          child: RepositoryContentWidget('${widget.user}/${widget.name}'),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;

  Widget _buildBasicInfo() {
    return Row(
      children: <Widget>[
        _buildBasicInfoItem(
          icon: Icons.remove_red_eye,
          title: 'Watch',
          data: _repository.watchersCount,
        ),
        _buildBasicInfoItem(
          icon: Icons.star,
          title: 'Star',
          data: _repository.stargazersCount,
        ),
        _buildBasicInfoItem(
          icon: Icons.call_missed_outgoing,
          title: 'Issues',
          data: _repository.openIssuesCount,
        )
      ],
    );
  }

  Widget _buildBasicInfoItem({ IconData icon, String title, int data }) {
    return Container(
      height: 30,
      margin: EdgeInsets.only(left: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26, width: 1)
      ),
      child: Container(
        color: Colors.black12,
        padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.only(right: 3),
              child: Icon(icon, size: 16),
            ),
            Text(title, style: TextStyle(fontSize: 12)),
            Container(
              margin: EdgeInsets.only(left: 8),
              height: 30,
              padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
              color: Colors.white,
              child: Center(
                child: Text(
                  _formatNumber(data),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _fetchRepository() async {
    ApiService service = ApiService(routeName: 'repos');
    Map<String, dynamic> result = await service.get(
      path: '${widget.user}/${widget.name}',
    );
    Repository repository = Repository.fromJson(result);
    if (mounted) {
      setState(() {
        _repository = repository;
      });
    }
  }

  String _formatNumber(int number) {
    if (number > 1000) {
      return '${(number / 1000).floor()}K';
    }
    return number.toString();
  }

}