import 'package:flutter/material.dart';

import './jrnl/models.dart';

class Journal extends StatelessWidget {
  final List<Record> _parserData;

  final void Function(Record) _showDetails;

  Journal(this._parserData, this._showDetails);

  Widget _buildRow(Record row) {
    return ListTile(
      title: Text(row.title),
      subtitle: Text(row.createdAt.toString()),
      onTap: () => this._showDetails(row),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        if (i.isOdd) return Divider();

        final index = i ~/ 2;
        return _buildRow(_parserData[index]);
      },
      itemCount: _parserData.length > 0 ? _parserData.length * 2 - 1 : 0,
    );
  }
}
