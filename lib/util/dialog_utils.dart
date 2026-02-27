import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class DialogUtils {
  const DialogUtils._();

  /// 基础配置：建议在工具包中提供一个全局配置项，或者通过 context 获取主题
  static BorderRadius get _defaultRadius => BorderRadius.circular(12);

  // --- 1. 提示类弹窗 (基于 SmartDialog) ---

  static Future<bool?> showTipsDialog(
      BuildContext context, {
        String? title,
        String? content,
        Widget? contentWidget,
        String confirmText = 'Confirm',
        String cancelText = 'Cancel',
        bool isSingleBtn = false,
      }) async {
    final theme = Theme.of(context);

    return SmartDialog.show(builder: (_) {
      return AlertDialog(
        title: title != null ? Text(title, style: const TextStyle(fontSize: 18)) : null,
        shape: RoundedRectangleBorder(borderRadius: _defaultRadius),
        backgroundColor: theme.dialogTheme.backgroundColor,
        content: contentWidget ?? (content != null ? Text(content) : null),
        actions: [
          if (!isSingleBtn)
            TextButton(
              onPressed: () => SmartDialog.dismiss(result: false),
              child: Text(cancelText, style: TextStyle(color: theme.hintColor)),
            ),
          TextButton(
            onPressed: () => SmartDialog.dismiss(result: true),
            child: Text(confirmText, style: TextStyle(fontWeight: FontWeight.bold, color: theme.primaryColor)),
          ),
        ],
      );
    });
  }

  // --- 2. 列表选择器 (底部弹出) ---

  /// 使用 Dart 3 的记录 (Record) 返回结果：(index, value)
  static Future<(int, String)?> showBottomList(
      BuildContext context, {
        required List<String> options,
        int initialItem = 0,
        String title = 'Please Select',
        double height = 280,
      }) async {
    int selectedIndex = initialItem;
    final theme = Theme.of(context);

    return showCupertinoModalPopup<(int, String)>(
      context: context,
      builder: (context) => Container(
        height: height,
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          children: [
            _buildActionHeader(
              context,
              onConfirm: () => Navigator.pop(context, (selectedIndex, options[selectedIndex])),
            ),
            Expanded(
              child: CupertinoPicker(
                scrollController: FixedExtentScrollController(initialItem: initialItem),
                itemExtent: 42,
                onSelectedItemChanged: (i) => selectedIndex = i,
                children: options.map((e) => Center(child: Text(e, style: TextStyle(color: theme.textTheme.bodyLarge?.color)))).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- 3. 日期选择器 ---

  static Future<DateTime?> showBottomDate(
      BuildContext context, {
        DateTime? initialDateTime,
        DateTime? minimumDate,
        DateTime? maximumDate,
        CupertinoDatePickerMode mode = CupertinoDatePickerMode.date,
      }) async {
    DateTime tempDt = initialDateTime ?? DateTime.now();
    final theme = Theme.of(context);

    return showCupertinoModalPopup<DateTime>(
      context: context,
      builder: (context) => Container(
        height: 300,
        color: theme.scaffoldBackgroundColor,
        child: Column(
          children: [
            _buildActionHeader(
              context,
              onConfirm: () => Navigator.pop(context, tempDt),
            ),
            Expanded(
              child: CupertinoDatePicker(
                mode: mode,
                initialDateTime: tempDt,
                minimumDate: minimumDate,
                maximumDate: maximumDate,
                onDateTimeChanged: (dt) => tempDt = dt,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- 辅助私有组件：抽取头部确定/取消栏 ---

  static Widget _buildActionHeader(BuildContext context, {required VoidCallback onConfirm}) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: theme.dividerColor, width: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: theme.hintColor, fontSize: 16)),
          ),
          GestureDetector(
            onTap: onConfirm,
            child: Text('Confirm', style: TextStyle(color: theme.primaryColor, fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}