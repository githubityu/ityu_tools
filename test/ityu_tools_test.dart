import 'package:flutter_test/flutter_test.dart';
import 'package:ityu_tools/exports.dart';
import 'package:ityu_tools/ityu_tools.dart';

void main() {
  test('adds one to input values', () {
    final calculator = Calculator();
    expect(calculator.addOne(2), 3);
    expect(calculator.addOne(-7), -6);
    expect(calculator.addOne(0), 1);
  });

  test('test getStringForDefault', () {
    int? a;
    expect(Utils.getStringForDefault(a), "");
  });
}
