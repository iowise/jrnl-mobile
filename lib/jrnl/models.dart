class RecordMomento {
  DateTime createdAt = DateTime.now();
  String fullContent = '';
  Record origin;

  RecordMomento();
  RecordMomento.from(Record record) {
    createdAt = record.createdAt;
    fullContent = record.fullContent;
    origin = record;
  }

  Record get state =>
      Record(createdAt, fullContent.split('\n')[0], fullContent); // computed
}

class Record {
  final DateTime createdAt;
  final String title;
  final String fullContent;

  Record(this.createdAt, this.title, this.fullContent);

  get preattyCreated {
    final year = pad(createdAt.year, 4);
    final month = pad(createdAt.month, 2);
    final day = pad(createdAt.day, 2);
    final hour = pad(createdAt.hour, 2);
    final minute = pad(createdAt.minute, 2);
    return "$year-$month-$day $hour:$minute";
  }

  String toString() {
    return '(\n'
        '  createdAt: $createdAt\n'
        '  title: "$title"\n'
        '  fullContent: "$fullContent"\n'
        ')';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Record &&
          runtimeType == other.runtimeType &&
          createdAt == other.createdAt &&
          title == other.title &&
          fullContent == other.fullContent;

  @override
  int get hashCode =>
      createdAt.hashCode ^ title.hashCode ^ fullContent.hashCode;
}

String pad(int i, int padding) => i.toString().padLeft(2, '0');
