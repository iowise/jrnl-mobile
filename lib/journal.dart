import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'parser.dart';

import 'models.dart';

String _jrnlData = """[2020-02-05 12:54] Note 1
# Markdown Example
Markdown allows you to easily include formatted text, images,

 and even formatted Dart code in your app. 

# Markdown Example
Markdown allows you to easily include formatted text, images,

 and even formatted Dart code in your app. 
# Markdown Example
# Markdown Example
# Markdown Example
# Markdown Example
# Markdown Example
# Markdown Example
# Markdown Example
Markdown allows you to easily include formatted text, images, 
and even formatted Dart code in your app. 
# Markdown Example
Markdown allows you to easily include formatted text, images, and even formatted Dart code in your app. 
# Markdown Example
Markdown allows you to easily include formatted text, images, and even formatted Dart code in your app. 
# Markdown Example
Markdown allows you to easily include formatted text, images, and even formatted Dart code in your app. 

[2020-02-05 13:54] Note 2
# Markdown Example 2
""";

class JournalState extends State<Journal> {
  final _parserData = List.from(JrnlParser(_jrnlData).entries());

  void _pushDetails(Record record) {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text(record.createdAt.toString() + ' ' + record.title),
        ),
        body: Markdown(data: record.fullContent),
      );
    }));
  }

  Widget _buildRow(Record row) {
    return ListTile(
      title: Text(row.title),
      subtitle: Text(row.createdAt.toString()),
      onTap: () {
        _pushDetails(row);
      },
    );
  }

  Widget _buildJrnlRecords() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        if (i.isOdd) return Divider();

        final index = i ~/ 2; /*3*/
        return _buildRow(_parserData[index]);
      },
      itemCount: _parserData.length * 2 - 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildJrnlRecords();
  }
}

class Journal extends StatefulWidget {
  @override
  JournalState createState() => JournalState();
}
