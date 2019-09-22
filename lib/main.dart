// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:jrnl/parser.dart';
import 'package:jrnl/models.dart';

String _jrnlData = """[2020-02-05 12:54] Note 1
# Markdown Example
Markdown allows you to easily include formatted text, images, and even formatted Dart code in your app. 

[2020-02-05 13:54] Note 2
# Markdown Example 2
""";

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'jrnl',
      home: Scaffold(
        appBar: AppBar(
          title: Text('jrnl'),
        ),
        //body: const Markdown(data: _markdownData)
        body: Center(
          child: Journal(),
        ),
      ),
    );
  }
}

class JournalState extends State<Journal> {
  final _parserData = List.from(JrnlParser(_jrnlData).entries());

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: /*1*/ (context, i) {
          if (i.isOdd) return Divider();
          /*2*/

          final index = i ~/ 2; /*3*/
          return _buildRow(_parserData[index]);
        },
        itemCount: _parserData.length * 2 - 1);
  }

  Widget _buildRow(Record row) {
    return ListTile(
      title: Text(row.title),
      subtitle: Text(row.createdAt.toString()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildSuggestions();
  }
}

class Journal extends StatefulWidget {
  @override
  JournalState createState() => JournalState();
}
