import 'package:flutter/material.dart';

class LogMessage extends StatelessWidget {
  final void Function(String?) onSaved;

  final String initialValue;

  LogMessage({
    required this.initialValue,
    required this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: null,
      decoration: InputDecoration(
        labelText: 'Log Message',
      ),
      initialValue: this.initialValue,
      onSaved: this.onSaved,
      validator: (value) {
        if (value != null && value.isEmpty) {
          return 'Please add a log message';
        }
        return null;
      },
    );
  }
}
