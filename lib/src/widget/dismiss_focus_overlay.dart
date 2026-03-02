import 'package:flutter/widgets.dart';


///
/// MaterialApp(
///   builder: (context, child) => DismissFocusOverlay(child: child!),
///
///   home: const HomePage(),
/// );



/// 键盘焦点收起包装器
/// 建议包裹在 MaterialApp 的 builder 中，或者包裹在每个页面的 Scaffold 外层
class DismissFocusOverlay extends StatelessWidget {
  final Widget child;

  const DismissFocusOverlay({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // 点击空白处收起键盘
      onTap: () {
        // 获取当前焦点状态
        final FocusScopeNode currentFocus = FocusScope.of(context);

        // 如果当前有焦点且不是根焦点，则执行失焦
        if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
          // 使用更安全的方法收起键盘
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      // 关键：确保点击空白区域（透明部分）也能触发事件
      behavior: HitTestBehavior.translucent,
      child: child,
    );
  }
}