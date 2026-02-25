import 'package:flutter_test/flutter_test.dart';
import 'package:ityu_tools/exports.dart';
import 'package:ityu_tools/ityu_tools.dart';

sealed class TestA {}

class TestA1 extends TestA {
  String title = "TestA1";

  void  testA1() {
    print(title);
  }
}


class TestA2 extends TestA {
  String title = "TestA2";
  void testA2() {
    print(title);
  }
}

void testSealed(TestA testA) {
  switch (testA) {
    case TestA1 a:
      a.testA1();
      break;
    case TestA2 b:
      b.testA2();
      break;
  }
}

void main() {
  test("getSeconds", () {
    final dt = "2024-05-25-18-13".parse(pattern: "yyyy-MM-dd-HH-mm");
   final s =  "2024-05-25-18-13".getSecondsUntil(pattern: "yyyy-MM-dd-HH-mm");
    print('dt=$dt===s=${s/60}');
  });

  test('adds one to input values', () {
    final calculator = Calculator();
    expect(calculator.addOne(2), 3);
    expect(calculator.addOne(-7), -6);
    expect(calculator.addOne(0), 1);
  });

  test('test getStringForDefault', () {
    int? a;

    expect(a.toSafeString(), "");
  });
  test('test str 0x - >0x', () {
    final str = "0xe03a";
    final num = str.toIntOrNull();
    final d = num?.toRadixString(16).toString();
    print("num=$num d=$d");
  });
  test('test index->page', () {
     final dt1 =  DateTime.now();
     final dt2 =  DateTime.now().add(Duration(days: 1));
     var max = dt1.max(dt2);
     expect(max, dt2);
  });
}


class Single{
  static final Single _instance = Single._internal();
  factory Single() => _instance;
  Single._internal();
}
