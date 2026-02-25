import 'package:flutter/material.dart';

/// 增强型开关行组件
class SwitchListTileX extends StatelessWidget {
  const SwitchListTileX({
    super.key,
    required this.value,
    required this.onChanged,
    this.title,
    this.subtitle,
    this.secondary,
    this.activeColor,
    this.activeTrackColor,
    this.inactiveThumbColor,
    this.inactiveTrackColor,
    this.switchScale = 0.7, // 核心增强：默认缩放 0.7
    this.contentPadding,
    this.controlAffinity = ListTileControlAffinity.platform,
    this.selected = false,
    this.isAdaptive = true,
    this.dense,
    this.shape,
    this.tileColor,
    this.selectedTileColor,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final Widget? title;
  final Widget? subtitle;
  final Widget? secondary;
  final Color? activeColor;
  final Color? activeTrackColor;
  final Color? inactiveThumbColor;
  final Color? inactiveTrackColor;
  final double switchScale;
  final EdgeInsetsGeometry? contentPadding;
  final ListTileControlAffinity controlAffinity;
  final bool selected;
  final bool isAdaptive;
  final bool? dense;
  final ShapeBorder? shape;
  final Color? tileColor;
  final Color? selectedTileColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // 1. 构建开关控件
    Widget control = isAdaptive
        ? Switch.adaptive(
      value: value,
      onChanged: onChanged,
      activeThumbColor: activeColor,
      activeTrackColor: activeTrackColor,
      inactiveThumbColor: inactiveThumbColor,
      inactiveTrackColor: inactiveTrackColor,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    )
        : Switch(
      value: value,
      onChanged: onChanged,
      activeThumbColor: activeColor,
      activeTrackColor: activeTrackColor,
      inactiveThumbColor: inactiveThumbColor,
      inactiveTrackColor: inactiveTrackColor,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );

    // 2. 应用缩放 (核心视觉增强)
    if (switchScale != 1.0) {
      control = Transform.scale(
        scale: switchScale,
        child: control,
      );
    }

    // 3. 处理对齐逻辑
    final (Widget? leading, Widget? trailing) = switch (controlAffinity) {
      ListTileControlAffinity.leading => (control, secondary),
      _ => (secondary, control), // 默认（platform/trailing）开关在右
    };

    return ListTile(
      leading: leading,
      trailing: trailing,
      title: title,
      subtitle: subtitle,
      contentPadding: contentPadding,
      dense: dense,
      enabled: onChanged != null,
      selected: selected,
      selectedColor: activeColor ?? theme.colorScheme.primary,
      shape: shape,
      tileColor: tileColor,
      selectedTileColor: selectedTileColor,
      onTap: onChanged != null ? () => onChanged!(!value) : null,
    );
  }
}