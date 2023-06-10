import 'package:flutter/material.dart';

import 'fields/log_message.dart';
import 'fields/datetime.dart';
import 'jrnl/models.dart';

class RecordForm extends StatefulWidget {
  final void Function(RecordMomento record) onSaved;
  final Record? record;

  RecordForm({
    Key? key,
    this.record,
    required this.onSaved,
  }) : super(key: key);

  @override
  _RecordFormState createState() => _RecordFormState(
        record == null,
        record == null ? RecordMomento() : RecordMomento.from(record!),
        this.onSaved,
      );
}

class _RecordFormState extends State<RecordForm> {
  final _formKey = GlobalKey<FormState>();
  final void Function(RecordMomento record) onSaved;
  final RecordMomento _data;
  final bool isCreate;

  _RecordFormState(this.isCreate, this._data, this.onSaved);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isCreate ? 'Create a record' : 'Edit the record'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            tooltip: 'Save',
            onPressed: () {
              final currentState = _formKey.currentState;
              if (currentState == null) {
                return;
              }
              if (currentState.validate()) {
                currentState.save();
                onSaved(this._data);
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              BasicDateTimeField(
                initialValue: this._data.createdAt,
                onSaved: (DateTime? value) {
                  if (value == null) {
                    return;
                  }
                  this._data.createdAt = value;
                },
              ),
              LogMessage(
                initialValue: this._data.fullContent,
                onSaved: (String? value) {
                  if (value == null) {
                    return;
                  }
                  this._data.fullContent = value;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
