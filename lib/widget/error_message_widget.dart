import 'package:flutter/material.dart';

/// 统一的错误提示组件
/// ErrorMessageWidget(
///   errorMessage: "Failed to load data",
///   onRetry: () => _fetchData(),
/// );
class ErrorMessageWidget extends StatelessWidget {
  const ErrorMessageWidget({
    super.key,
    required this.errorMessage,
    this.icon,
    this.onRetry,
  });

  final String errorMessage;
  final IconData? icon;

  /// 点击重试的回调，如果不传则不显示重试按钮
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 1. 错误图标
            Icon(
              icon ?? Icons.error_outline_rounded,
              color: colorScheme.error,
              size: 48,
            ),
            const SizedBox(height: 16),

            // 2. 错误文本
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.error,
                fontWeight: FontWeight.bold,
              ),
            ),

            // 3. 重试按钮
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('Retry'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: colorScheme.error,
                  side: BorderSide(color: colorScheme.error),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}