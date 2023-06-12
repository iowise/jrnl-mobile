import 'dart:io';

import 'package:mutex/mutex.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './storage.dart';
import './models.dart';
import './parser.dart';

class BloCSetting extends State {
  rebuildWidgets({
    required VoidCallback setStates,
    required List<State> states,
  }) {
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

// TODO: implement sync in here
class JrnlBloc extends BloCSetting {
  var records = <Record>[];
  var _hasChanges = false;
  String? _filePath;
  SharedPreferences? prefs;
  final syncMutex = Mutex();

  String? get filePath {
    return _filePath;
  }

  bool get hasChanges {
    return _hasChanges;
  }

  Future sync(state) async {
    await syncMutex.protect(() => _sync(state));
  }

  Future load(state) async {
    await syncMutex.protect(() => _load(state));
  }

  Future save(state, RecordMomento momento) async {
    await syncMutex.protect(() => _save(state, momento));
  }

  Future _sync(state) async {
    if (!await isLoggedIn()) {
      await loginDropbox();
      await initialPull(state);
      return;
    }

    if (filePath != null && hasChanges) {
      await push(state);
    } else {
      await initialPull(state);
    }
  }

  Future _load(state) async {
    prefs = await SharedPreferences.getInstance();
    final filePath = prefs!.getString('filePath');
    if (filePath != null) {
      final file = File(filePath);
      if (!await file.exists()) {
        _filePath = null;
        await prefs!.clear();
        return;
      }
      _filePath = filePath;
      await parse(state, filePath);
    }
    _hasChanges = prefs!.getBool('hasChanges') ?? false;
  }

  Future push(state) async {
    final filePath = this.filePath;
    if (!hasChanges || filePath == null) {
      return;
    }
    final remoteJournal = await fetchRemoteFileMetadata();
    final hasConflict =
        remoteJournal.serverModified != getStoredServerModified();
    final suffix = hasConflict ? " ${DateTime.now().toIso8601String()}" : "";
    await upload(filePath, suffix: suffix);

    if (hasConflict) {
      await initialPull(state);
    } else {
      final updatedJournal = await fetchRemoteFileMetadata();
      _saveFileMetadata(updatedJournal);
    }
    ;
  }

  Future initialPull(state) async {
    final downloaded = await download(null);
    return _open(state, downloaded);
  }

  Future _open(state, DropboxFile file) async {
    _filePath = file.localPath;
    await parse(state, file.localPath!);
    _saveFileMetadata(file);
  }

  Future parse(state, String filePath) async {
    final file = File(filePath);
    final content = await file.readAsString();
    final parser = JrnlParser(content);
    print(state);
    rebuildWidgets(
      setStates: () {
        records = List.from(parser.entries());
        records.sort(_showOrder);
        print(records.length);
      },
      states: [state],
    );
  }

  Future _saveFileMetadata(final DropboxFile file) async {
    await prefs!.setString('filePath', file.localPath!);
    await prefs!.setString('fileModified', file.serverModified);
  }

  getStoredServerModified() {
    prefs!.getString('fileModified');
  }

  Future _save(state, RecordMomento momento) async {
    _hasChanges = true;
    await prefs!.setBool('hasChanges', true);

    rebuildWidgets(
      setStates: () {
        records.remove(momento.origin);
        records.add(momento.state);
        records.sort(_showOrder);
      },
      states: [state],
    );
    await dumpToFile();
    await push(state);
  }

  Future dumpToFile() async {
    if (_filePath == null || _filePath == '') {
      return;
    }
    final file = File(_filePath!);
    final List<Record> toWrite = List.from(records);
    toWrite.sort(_writeOrder);
    await file.writeAsString(render(toWrite));
  }
}

JrnlBloc? jrnlBloc;

int _showOrder(a, b) => a.createdAt.isBefore(b.createdAt) ? 1 : -1;

int _writeOrder(a, b) => -_showOrder(a, b);
