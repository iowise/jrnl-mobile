import 'package:test/test.dart';
import 'package:jrnl/parser.dart';
import 'package:jrnl/models.dart';

void main() {
  test('parse empty string', () {
    final parser = JrnlParser('');
    expect(parser.entries(), equals([anything]));
  });

  group("empty entry parsing", () {
    var inputsToExpected = {
      "[2020-02-05 12:54] ": [DateTime(2020, 02, 05, 12, 54), ''],
      "[2020-02-05 12:54]  ": [DateTime(2020, 02, 05, 12, 54), ' '],
      "[2020-02-05 12:54:05]     ": [
        DateTime(2020, 02, 05, 12, 54, 05),
        '    '
      ],
    };
    inputsToExpected.forEach((input, expected) {
      test("$input -> $expected", () {
        expect(JrnlParser(input).entries(),
            [Record(expected[0], expected[1], '')]);
      });
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
}
