import 'package:flutter/material.dart';
import 'package:jrnl/jrnl/storage.dart';

import './detials.dart';
import './form.dart';
import './journal.dart';
import './jrnl/bloc.dart';
import './jrnl/models.dart';

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    initDropbox();
    loginDropbox();
    jrnlBloc = JrnlBloc();
    jrnlBloc?.restore(this);
  }

  @override
  void dispose() {
    jrnlBloc = null;
    super.dispose();
  }

  void _loadJrnlFile() async {
    final String filePath = await testListFolder();
    jrnlBloc?.open(this, filePath);
  }

  void _pushCreating(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute<void>(builder: (BuildContext context) {
      return RecordForm(onSaved: (momento) => jrnlBloc?.save(this, momento));
    }));
  }

  void _pushDetails(Record record) {
    Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (BuildContext context) =>
            RecordDetail(record, onEdit: this.pushEdit)));
  }

  void pushEdit(Record record) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => RecordForm(
            record: record, onSaved: (momento) => jrnlBloc?.save(this, momento)),
      ),
    );
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
        child: Journal(jrnlBloc!.records, this._pushDetails),
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

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}
