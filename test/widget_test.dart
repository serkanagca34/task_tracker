import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

void main() {
  setUpAll(() async {
    Hive.init('Database');
  });

  test('Hive Init', () async {
    final tasksBox = await Hive.openBox('tasksBox');
    await tasksBox.add('task 1');

    expect(tasksBox.values.last, 'task 1');
  });

  tearDownAll(() async {
    await Hive.close();
  });
}
