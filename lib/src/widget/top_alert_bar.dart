import 'package:flutter/material.dart';

/// 顶部通知/警告条
class TopAlertBar extends StatelessWidget {
  const TopAlertBar({
    super.key,
    required this.msg,
    this.backgroundColor,
    this.icon,
    this.textStyle,
  });

  final String msg;
  final Color? backgroundColor;
  final IconData? icon;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    // 获取主题和安全区高度
    final theme = Theme.of(context);
    final topPadding = MediaQuery.paddingOf(context).top;

    return Material(
      color: Colors.transparent, // 背景由内部 Container 提供
      child: Container(
        width: double.infinity,
        // 自动计算顶部安全距离并增加额外间距
        padding: EdgeInsets.fromLTRB(20, topPadding + 10, 20, 15),
        decoration: BoxDecoration(
          color: backgroundColor ?? theme.colorScheme.primary,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(
                msg,
                style: textStyle ??
                    const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.none, // 移除黄色双下划线
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}