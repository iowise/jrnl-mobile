import 'package:jrnl/models.dart';

class JrnlParser {
  JrnlParser(this.content);

  String content;

  RegExp dateBlobRE =
      new RegExp(r"^\[([^\\\]]+)\] ((?:(?!^\[).*\n*)*)", multiLine: true);

  Iterable<Record> entries() sync* {
    final matches = this.dateBlobRE.allMatches(this.content);
    if (matches.isEmpty) {
      yield Record(DateTime.now(), '', '');
    } else {
      for (var match in this.dateBlobRE.allMatches(this.content)) {
        final date_blob = match.group(1);
        final text = match.group(2);
        final date = DateTime.parse(date_blob);
        yield Record(date, text.split('\n')[0], text.trim());
      }
    }
  }
}
