import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './models.dart';
import './parser.dart';

class BloCSetting extends State {
  rebuildWidgets(
      {required VoidCallback setStates, required List<State> states}) {
    states.forEach((s) {
      if (s.mounted) s.setState(setStates);
    });
  }

  @override
  Widget build(BuildContext context) {
    print(
        "This build function will never be called. it has to be override here because State interface requires this");
    throw UnimplementedError();
  }
}

class JrnlBloc extends BloCSetting {
  var records = <Record>[];
  String? _filePath;

  open(state, String filePath) async {
    _filePath = filePath;
    await parse(state, filePath);
    await _rememberPath(filePath);
  }

  parse(state, String filePath) async {
    _filePath = filePath;
    final file = File(filePath);
    final content = await file.readAsString();
    final parser = JrnlParser(content);
    rebuildWidgets(
      setStates: () {
        records = List.from(parser.entries());
      },
      states: [state],
    );
  }

  restore(state) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final filePath = prefs.getString('filePath');
    if (filePath != null) {
      parse(state, filePath);
    }
  }

  _rememberPath(filePath) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('filePath', filePath);
  }

  save(state, RecordMomento momento) async {
    rebuildWidgets(
      setStates: () {
        records.remove(momento.origin);
        records.add(momento.state);
        records.sort((a, b) => a.createdAt.isBefore(b.createdAt) ? 1 : -1);
      },
      states: [state],
    );
    await dumpToFile();
  }

  dumpToFile() async {
    if (_filePath == null || _filePath == '') {
      return;
    }
    final file = File(_filePath!);
    await file.writeAsString(render(records));
  }
}

JrnlBloc? jrnlBloc;
