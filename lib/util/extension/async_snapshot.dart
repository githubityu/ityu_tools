import 'package:flutter/cupertino.dart';

extension AsyncSnapshotExt<T> on AsyncSnapshot<T> {
  /// 正在加载状态（等待中或活跃中且无数据）
  bool get isLoading =>
      connectionState == ConnectionState.waiting ||
          connectionState == ConnectionState.active;

  /// 加载完成且拥有数据
  bool get isSuccess =>
      connectionState == ConnectionState.done && hasData && !hasError;

  /// 加载完成但出错了
  bool get isFailure =>
      connectionState == ConnectionState.done && hasError;

  /// 快捷获取错误信息字符串
  String get errorString => error?.toString() ?? 'Unknown Error';
}