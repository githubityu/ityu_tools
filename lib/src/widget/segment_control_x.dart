import 'package:flutter/material.dart';

class SegmentedControlX<T extends Object> extends StatelessWidget {
  const SegmentedControlX({
    super.key,
    required this.children,
    required this.groupValue,
    required this.onValueChanged,
    this.selectedColor,
    this.unselectedColor,
    this.selectedTextColor,
    this.unselectedTextColor,
    this.borderRadius = 8.0,
    this.padding = const EdgeInsets.all(4),
  });

  final Map<T, String> children;
  final T groupValue;
  final ValueChanged<T> onValueChanged;

  final Color? selectedColor;
  final Color? unselectedColor;
  final Color? selectedTextColor;
  final Color? unselectedTextColor;
  final double borderRadius;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // 默认颜色配置
    final selBg = selectedColor ?? theme.primaryColor;
    final unselBg = unselectedColor ?? Colors.grey[200]!;
    final selText = selectedTextColor ?? Colors.white;
    final unselText = unselectedTextColor ?? Colors.black54;

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: unselBg,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: children.entries.map((entry) {
          final isSelected = entry.key == groupValue;
          return Expanded(
            child: GestureDetector(
              onTap: () => onValueChanged(entry.key),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? selBg : Colors.transparent,
                  borderRadius: BorderRadius.circular(borderRadius - 2),
                  boxShadow: isSelected
                      ? [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4)]
                      : [],
                ),
                child: Center(
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: TextStyle(
                      color: isSelected ? selText : unselText,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    child: Text(entry.value),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}