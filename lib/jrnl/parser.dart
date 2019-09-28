import 'models.dart';

const datetimeRE = r'\[(\d{4}-\d{2}-\d{2} \d{2}:\d{2})\]';

class JrnlParser {
  String content;

  JrnlParser(this.content);

  RegExp dateBlobRE =
      new RegExp("^$datetimeRE ((?:(?!^$datetimeRE).*\\n*)*)", multiLine: true);

  Iterable<Record> entries() sync* {
    final matches = dateBlobRE.allMatches(content);
    if (matches.isEmpty) {
      yield Record(DateTime.now(), '', '');
    } else {
      for (var match in matches) {
        final dateBlob = match.group(1);
        final text = match.group(2);
        final date = DateTime.parse(dateBlob);
        yield Record(date, text.split('\n')[0], text.trim());
      }
    }
  }
}

String render(List<Record> records) {
  final buffer = new StringBuffer();
  for (var record in records) {
    buffer.write("[${record.preattyCreated}] ${record.fullContent}\n");
  }
  return buffer.toString();
}