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
    if (jrnlBloc == null) {
      jrnlBloc = JrnlBloc();
    }
    jrnlBloc?.load(this);
    sync();
  }

  @override
  void dispose() {
    jrnlBloc = null;
    super.dispose();
  }

  Future sync() async {
    jrnlBloc?.sync(this);
  }

  void _pushCreating(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute<void>(builder: (BuildContext context) {
      return RecordForm(onSaved: (momento) async {
        await jrnlBloc?.save(this, momento);
      });
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
          record: record,
          onSaved: (momento) => jrnlBloc?.save(this, momento),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final actions = [
      IconButton(
        icon: Icon(
          jrnlBloc?.hasChanges == true ? Icons.upload : Icons.download,
        ),
        onPressed: sync,
      ),
    ];
    return Scaffold(
      appBar: AppBar(title: Text('jrnl'), actions: actions),
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
