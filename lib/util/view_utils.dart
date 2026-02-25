import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ViewUtils {
  const ViewUtils._();

  /// 获取当前 WidgetsBinding 实例
  static WidgetsBinding get binding => WidgetsBinding.instance;

  /// 安全执行回调逻辑
  /// 如果当前框架正处于构建/布局/绘制阶段 (persistentCallbacks)，则推迟到下一帧执行；
  /// 如果框架处于空闲状态，则立即执行。
  /// 这对于在 build 期间需要弹出对话框或 setState 的场景非常有用。
  static void safeRun(VoidCallback callback) {
    if (binding.schedulerPhase == SchedulerPhase.persistentCallbacks) {
      binding.addPostFrameCallback((_) => callback());
    } else {
      callback();
    }
  }

  /// 强制下一帧执行
  static void nextFrame(VoidCallback callback) {
    binding.addPostFrameCallback((_) => callback());
  }
}

