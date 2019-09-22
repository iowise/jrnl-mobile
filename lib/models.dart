class Record {
  final DateTime createdAt;
  final String title;
  final String fullContent;

  Record(this.createdAt, this.title, this.fullContent);
  String toString() {
    return '(\n'
        '  createdAt: $createdAt\n'
        '  title: "$title"\n'
        '  fullContent: "$fullContent"\n'
        ')';
  }

  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Record &&
              runtimeType == other.runtimeType &&
              createdAt == other.createdAt &&
              title == other.title &&
              fullContent == other.fullContent;

}