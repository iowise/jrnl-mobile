import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'form.dart';
import 'journal.dart';

class Home extends StatelessWidget {
  void _loadJrnlFile() async {
    String filePath;
    filePath = await FilePicker.getFilePath(
        type: FileType.CUSTOM, fileExtension: 'txt');
    final file = File(filePath);
    final content = await file.readAsString();
    print(content);
  }

  void _pushCreating(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute<void>(builder: (BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('lorem ipsum'),
        ),
        body: RecordForm(),
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('jrnl'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.save), onPressed: _loadJrnlFile),
        ],
      ),
      body: Center(
        child: Journal(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _pushCreating(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
