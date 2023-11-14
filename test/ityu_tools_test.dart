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
  test('test str 0x - >0x', () {
    final str = "0xe03a";
    final num = str.toIntOrNull();
    final d = num?.toRadixString(16).toString();
    print("num=$num d=$d");
  });
  test('test index->page', () {
    int index = 36;
    int pageSize = 10;
    int page = ((index + 1) ~/ pageSize)+1;
    expect(page, 1);
  });
}
