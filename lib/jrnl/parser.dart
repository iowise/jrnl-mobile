import 'models.dart';

const legacyDatetimeRE = r'(\d{4}-\d{2}-\d{2} \d{2}:\d{2}(?::\d{2})?)';
const datetimeRE = "\\[$legacyDatetimeRE\\]";

class JrnlParser {
  String content;

  JrnlParser(this.content);

  Iterable<Record> entries() sync* {
    final re = content.startsWith('[') ? datetimeRE : legacyDatetimeRE;
    final dateBlobRE =
        new RegExp("^$re ((?:(?!^$re).*\\n*)*)", multiLine: true);
    final matches = dateBlobRE.allMatches(content);
    if (matches.isEmpty) {
      yield Record(DateTime.now(), '', '');
    } else {
      for (var match in matches) {
        final dateBlob = match.group(1);
        final text = match.group(2);
        if (dateBlob != null && text != null) {
          final date = DateTime.parse(dateBlob);
          yield Record(date, text.split('\n')[0], text.trim());
        }
      }
    }
  }
}

String render(List<Record> records) {
  final buffer = new StringBuffer();
  for (var record in records) {
    buffer.write("[${record.prettyCreated}] ${record.fullContent}\n");
  }
  return buffer.toString();
}
