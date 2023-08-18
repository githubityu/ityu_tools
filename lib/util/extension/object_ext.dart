import 'package:flutter/material.dart';
import 'package:quiver/strings.dart';
extension GenericExt<T> on T {
  R let<R>(R Function(T t) transform) => transform(this);

  R? safeCast<R>() => this is R ? (this as R) : null;
}

extension OrDefault<T> on T? {
  T get orDefault {
    final value = this;
    if (value == null) {
      return {
        int: 0,
        String: '',
        double: 0.0,
        Map: {},
      }[T] as T;
    } else {
      return value;
    }
  }
}

/// String 空安全处理
extension StringExtension on String? {
  String get nullSafe => this ?? '';

  bool get isNullOrEmpty => isBlank(this);

  bool get isNotNullOrEmpty => isNotBlank(this);

  int? toIntOrNull() => this == null ? null : int.tryParse(this!);

  int toIntOrDefault({int defaultValue = 1}) =>
      this == null ? defaultValue : int.tryParse(this!) ?? defaultValue;

  double? toDoubleOrNull() => this == null ? null : double.tryParse(this!);

  double toDoubleOrDefault({double defaultValue = 1.0}) =>
      this == null ? defaultValue : double.tryParse(this!) ?? defaultValue;

  String toFormatNum({int fixed = 2, String? pre = '\$'}) {
    return '${pre ?? ''}${(toDoubleOrDefault()).toStringAsFixed(fixed)}';
  }

  String get capitalizeFirstLetter => this == null
      ? ''
      : this![0].toUpperCase() + (this!.length > 1 ? this!.substring(1) : '');

  String getStrForDefault({String defaultValue = ''}) {
    if (isNotNullOrEmpty) {
      return this!;
    } else {
      return defaultValue;
    }
  }
}

extension FixAutoLines on String {
  String fixAutoLines() {
    return this + ('\n');
  }
}

extension IterationWithIndex<T> on Iterable<T> {
  Iterable<E> mapWithIndexAndCount<E>(
    E Function(int index, int count, T value) f,
  ) =>
      Iterable.generate(length, (i) => f(i, length, elementAt(i)));

  Iterable<E> mapWithIndex<E>(
    E Function(int index, T value) f,
  ) =>
      Iterable.generate(length, (i) => f(i, elementAt(i)));
}

extension Unwrap<T> on Future<T?> {
  Future<T> unwrap() => then(
        (value) => value != null ? Future<T>.value(value) : Future.any([]),
      );
}

extension SafeSetValue<T> on ValueNotifier<T?> {
  safeSetValue(T newValue) {
    if (value != newValue) {
      value = newValue;
    }
  }
}
