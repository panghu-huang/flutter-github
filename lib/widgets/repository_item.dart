import 'package:flutter/material.dart';
import 'package:github/models/repository.dart';
import 'package:github/pages/repository/repository.dart';

class RepositoryItem extends StatelessWidget {

  final Repository _repository;
  RepositoryItem(this._repository);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(8, 4, 8, 8),
      child: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            Center(
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      child: Text(
                        _repository.fullName,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.4,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (ctx) => RepositoryPage(
                            name: _repository.name,
                            user: _repository.owner.login,
                          )
                        ));
                      },
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.grey, size: 16),
                      Text(
                        _formatStars(_repository.stargazersCount)
                      )
                    ],
                  )
                ],
              ),
            ),
            _buildDescription(_repository.description),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 2, 8, 2),
                  child: Text(
                    _repository.language == null ? '' : _repository.language
                  ),
                ),
                Expanded(
                  child: Text(
                    _repository.updatedAt,
                    textAlign: TextAlign.right,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDescription(String description) {
    if (description == null) {
      return Container();
    }
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 10, bottom: 10),
      child: Text(
        description,
        textAlign: TextAlign.start,
      ),
    );
  }

  String _formatStars(int stars) {
    if (stars > 1000) {
      return '${(stars / 1000).floor()}K';
    }
    return stars.toString();
  }

}