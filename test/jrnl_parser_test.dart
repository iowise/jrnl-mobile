import 'package:test/test.dart';
import 'package:jrnl/jrnl/parser.dart';
import 'package:jrnl/jrnl/models.dart';

void main() {
  test('parse empty string', () {
    final parser = JrnlParser('');
    expect(parser.entries(), equals([anything]));
  });

  group("empty entry parsing", () {
    test("'[2020-02-05 12:54] '", () {
      expect(JrnlParser('[2020-02-05 12:54] ').entries(),
          [Record(DateTime(2020, 02, 05, 12, 54), '', '')]);
    });
    test("'[2020-02-05 12:54]  '", () {
      expect(JrnlParser('[2020-02-05 12:54]  ').entries(),
          [Record(DateTime(2020, 02, 05, 12, 54), ' ', '')]);
    });
    test("'[2020-02-05 12:54]   '", () {
      expect(JrnlParser('[2020-02-05 12:54:05]    ').entries(),
          [Record(DateTime(2020, 02, 05, 12, 54, 05), '   ', '')]);
    });
  });

  test('parse simple record', () {
    final parser = JrnlParser('[2020-02-05 12:54] Hello World');
    expect(parser.entries(), [
      Record(DateTime(2020, 02, 05, 12, 54), 'Hello World', 'Hello World'),
    ]);
  });

  test('parse multiline record', () {
    final parser = JrnlParser('''[2020-02-05 12:54] Hello World
I'm fine
Everything is OK
[2020-02-10 12:54] Hello World five days latter''');
    expect(parser.entries(), [
      Record(DateTime(2020, 02, 05, 12, 54), 'Hello World',
          "Hello World\nI'm fine\nEverything is OK"),
      Record(DateTime(2020, 02, 10, 12, 54), 'Hello World five days latter',
          'Hello World five days latter'),
    ]);
  });
  test('parse multiline record with square brackets', () {
    final parser = JrnlParser('''[2020-02-05 12:54] Hello World
[1] line with 1
Everything is OK
[2020-02-10 12:54] Hello World five days latter''');
    expect(parser.entries(), [
      Record(DateTime(2020, 02, 05, 12, 54), 'Hello World',
          "Hello World\n[1] line with 1\nEverything is OK"),
      Record(DateTime(2020, 02, 10, 12, 54), 'Hello World five days latter',
          'Hello World five days latter'),
    ]);
  });
  test('render', () {
    final original = '''[2020-02-05 12:54] Hello World
[1] line with 1
Everything is OK
[2020-02-10 12:54] Hello World five days latter
''';
    final parser = JrnlParser(original);
    expect(render(List.of(parser.entries())), original);
  });
}
