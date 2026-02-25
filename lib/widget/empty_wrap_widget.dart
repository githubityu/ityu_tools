import 'package:flutter/material.dart';

/// 状态包装器
/// 建议在工具包中增加一个全局的默认空界面配置
class EmptyWrapper extends StatelessWidget {
  const EmptyWrapper({
    super.key,
    required this.isEmpty,
    required this.builder,
    this.emptyWidget,
    this.showAnimation = true,
  });

  /// 是否为空
  final bool isEmpty;

  /// 正常显示的构建器
  final WidgetBuilder builder;

  /// 自定义空状态组件（如果不传，建议工具包提供一个默认的占位图）
  final Widget? emptyWidget;

  /// 是否开启简单的渐变动画
  final bool showAnimation;

  @override
  Widget build(BuildContext context) {
    final Widget current;

    if (isEmpty) {
      // 如果没有传入 emptyWidget，建议使用一个项目通用的 EmptyState 组件
      current = emptyWidget ?? const AppEmptyState();
    } else {
      current = builder(context);
    }

    if (!showAnimation) return current;

    // 增加一个简单的渐变切换效果，提升用户体验
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: SizedBox(
        key: ValueKey<bool>(isEmpty),
        child: current,
      ),
    );
  }
}


class AppEmptyState extends StatelessWidget {
  final String title;
  const AppEmptyState({super.key, this.title = "No Data Found"});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.inbox, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(title, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}