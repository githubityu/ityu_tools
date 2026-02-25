# ityu_tools

Flutter 常用组件工具库，提供丰富的 UI 组件和实用工具。

## 📦 安装

```yaml
dependencies:
  ityu_tools: ^最新版本
```

## 🚀 快速开始

```dart
import 'package:ityu_tools/exports.dart';

// 使用组件
final widget = RoundWidget(
  child: Text('Hello World'),
  radius: 8.0,
);
```

## 🎨 组件分类

### 🔧 基础组件

| 文件 | 组件名 | 说明 |
|------|--------|------|
| round_widget.dart | RoundWidget, RoundImage, CircleImage | 圆角容器、圆角图片、圆形图片 |
| dash_line.dart | DashLine | 水平/垂直虚线组件 |
| gaps.dart | Gap | 设置上下左右间隙 |
| text_icon.dart | TextIconX | 文字图标组合布局 |
| text_button_icon_x.dart | TextButtonX, OutlinedButtonX | 带图标的按钮组件 |
| animate_icons.dart | AnimateIcons, AnimatedIconButton | 图标切换动画 |

### 📱 交互组件

| 文件 | 组件名 | 说明 |
|------|--------|------|
| switch_list_title_x.dart | SwitchListTileX | 增强型开关行组件 |
| radio_x.dart | RadioX | 单选框组件 |
| segment_control_x.dart | SegmentControlX | 分段控制器 |
| popup_window_dialog.dart | PopupWindowDialog | 弹出窗口对话框 |
| send_code_button.dart | SendCodeButton | 获取验证码按钮 |
| count_down_time.dart | CountDownTime | 倒计时组件 |

### 🔄 加载与状态

| 文件 | 组件名 | 说明 |
|------|--------|------|
| loading_dialog.dart | LoadingStateViewModelDialog | 全局加载弹框 |
| app_button.dart | AppButton | 统一样式加载按钮 |
| error_message_widget.dart | ErrorMessageWidget | 统一错误提示组件 |
| empty_wrap_widget.dart | EmptyWrapper, AppEmptyState | 空状态包装器 |
| deferred_widget.dart | DeferredWidget | 延迟加载组件 |
| lazy_indexed_stack.dart | LazyIndexedStack | 懒加载 IndexedStack |

### 📋 列表与滚动

| 文件 | 组件名 | 说明 |
|------|--------|------|
| scroll/sliver_list_load_more.dart | SliverListLoadMore | 支持分页加载的列表组件 |
| scroll/sliver_grid_load_more.dart | SliverGridLoadMore | 支持分页加载的网格组件 |
| scroll/load_more_wrapper.dart | LoadMoreWrapper | 加载更多包装器 |
| scroll/refresh_nested_wrapper.dart | RefreshNestedWrapper | 嵌套下拉刷新组件 |

### 🌐 网络与媒体

| 文件 | 组件名 | 说明 |
|------|--------|------|
| my_iframe/my_iframe.dart | MyIFrame | 移动端适配的 iframe 组件 |
| cache_image.dart | CacheImage | 图片缓存加载组件 |

### 🎯 辅助工具

| 文件 | 组件名 | 说明 |
|------|--------|------|
| dismiss_focus_overlay.dart | DismissFocusOverlay | 失去焦点自动隐藏键盘 |
| auto_hide_by_keyboard.dart | AutoHideByKeyboard | 键盘自动隐藏辅助 |
| top_alert_bar.dart | TopAlertBar | 顶部警告栏 |
| wd_underlinetabindicator.dart | WDUnderlineTabIndicator | 自定义下划线 Tab 指示器 |
| responsive.dart | ResponsiveHelper | 响应式布局助手 |
| safe_area_widget.dart | SafeAreaWidget | 安全区域组件 |
| child_size_reporter.dart | ChildSizeReporter | 子组件尺寸报告器 |
| sticky_child_delegate.dart | StickyChildDelegate | 粘性子组件委托 |

## 💡 使用示例

### 基础圆角组件

```dart
// 圆角卡片
RoundWidget(
  radius: 12.0,
  color: Colors.white,
  elevation: 4.0,
  padding: EdgeInsets.all(16.0),
  child: Text('卡片内容'),
  onTap: () {
    print('卡片被点击');
  },
)
```

### 增强型开关组件

```dart
SwitchListTileX(
  title: Text('启用通知'),
  subtitle: Text('接收推送通知'),
  value: _notificationEnabled,
  switchScale: 0.8, // 缩放开关
  onChanged: (bool value) {
    setState(() {
      _notificationEnabled = value;
    });
  },
)
```

### 分页加载列表

```dart
SliverListLoadMore(
  itemCount: items.length,
  hasMore: hasMoreData,
  onRefresh: _refreshData,
  onLoadMore: _loadMoreData,
  separatorBuilder: (context, index) => Divider(),
  itemBuilder: (context, index) {
    return ListTile(
      title: Text(items[index].title),
      subtitle: Text(items[index].description),
    );
  },
)
```

### 统一错误处理

```dart
ErrorMessageWidget(
  errorMessage: '网络连接失败',
  icon: Icons.wifi_off,
  onRetry: () {
    // 重新加载数据
    _loadData();
  },
)
```

### 空状态处理

```dart
EmptyWrapper(
  isEmpty: items.isEmpty,
  builder: (context) => ListView.builder(
    itemCount: items.length,
    itemBuilder: (context, index) => ListTile(
      title: Text(items[index]),
    ),
  ),
  emptyWidget: AppEmptyState(
    title: '暂无数据',
    message: '点击刷新试试',
  ),
)
```

## 🏗️ 项目结构

```
lib/
├── exports.dart              # 导出所有组件
├── mixins.dart               # 混入工具
├── util/                     # 工具类
├── models/                   # 数据模型
├── widget/                   # 组件目录
│   ├── scroll/              # 滚动相关组件
│   ├── my_iframe/           # iframe 组件
│   └── export_widget.dart   # 组件导出文件
└── main.dart
```

## 📱 特性

- ✅ **Material Design 3** 兼容
- ✅ **响应式设计** 支持
- ✅ **空安全** (Null Safety)
- ✅ **可扩展** 组件设计
- ✅ **统一主题** 色彩适配
- ✅ **性能优化** 懒加载机制
- ✅ **国际化** 支持

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

## 📄 许可证

MIT License