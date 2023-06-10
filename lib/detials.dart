import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'jrnl/models.dart';

class RecordDetail extends StatelessWidget {
  final Record record;
  final void Function(Record) onEdit;

  const RecordDetail(this.record, { Key? key, required this.onEdit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${record.prettyCreated} ${record.title}"),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.edit), onPressed: this.openEdit),
        ],
      ),
      body: Markdown(data: record.fullContent),
    );
  }

  openEdit() {
    onEdit(record);
  }
}
