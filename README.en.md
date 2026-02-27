# ityu_tools

Flutter utility library providing rich UI components and practical tools.

## 📦 Installation

```yaml
dependencies:
  ityu_tools: ^latest_version
```

## 🚀 Quick Start

```dart
import 'package:ityu_tools/exports.dart';

// Using components
final widget = RoundWidget(
  child: Text('Hello World'),
  radius: 8.0,
);
```

## 🎨 Component Categories

### 🔧 Basic Components

| File | Component | Description |
|------|-----------|-------------|
| round_widget.dart | RoundWidget, RoundImage, CircleImage | Rounded containers, rounded images, circular images |
| dash_line.dart | DashLine | Horizontal/vertical dashed line component |
| gaps.dart | Gap | Set top, bottom, left, right gaps |
| text_icon.dart | TextIconX | Text and icon combination layout |
| text_button_icon_x.dart | TextButtonX, OutlinedButtonX | Button components with icons |
| animate_icons.dart | AnimateIcons, AnimatedIconButton | Icon switching animations |

### 📱 Interactive Components

| File | Component | Description |
|------|-----------|-------------|
| switch_list_title_x.dart | SwitchListTileX | Enhanced switch list tile component |
| radio_x.dart | RadioX | Radio button component |
| segment_control_x.dart | SegmentControlX | Segment controller |
| popup_window_dialog.dart | PopupWindowDialog | Popup window dialog |
| send_code_button.dart | SendCodeButton | Verification code button |
| count_down_time.dart | CountDownTime | Countdown component |

### 🔄 Loading & Status

| File | Component | Description |
|------|-----------|-------------|
| loading_dialog.dart | LoadingStateViewModelDialog | Global loading dialog |
| app_button.dart | AppButton | Unified style loading button |
| error_message_widget.dart | ErrorMessageWidget | Unified error message component |
| empty_wrap_widget.dart | EmptyWrapper, AppEmptyState | Empty state wrapper |
| deferred_widget.dart | DeferredWidget | Deferred loading component |
| lazy_indexed_stack.dart | LazyIndexedStack | Lazy loading IndexedStack |

### 📋 Lists & Scrolling

| File | Component | Description |
|------|-----------|-------------|
| scroll/sliver_list_load_more.dart | SliverListLoadMore | List component with pagination loading |
| scroll/sliver_grid_load_more.dart | SliverGridLoadMore | Grid component with pagination loading |
| scroll/load_more_wrapper.dart | LoadMoreWrapper | Load more wrapper |
| scroll/refresh_nested_wrapper.dart | RefreshNestedWrapper | Nested pull-to-refresh component |

### 🌐 Network & Media

| File | Component | Description |
|------|-----------|-------------|
| my_iframe/my_iframe.dart | MyIFrame | Mobile-adapted iframe component |
| cache_image.dart | CacheImage | Image caching and loading component |

### 🎯 Utility Tools

| File | Component | Description |
|------|-----------|-------------|
| dismiss_focus_overlay.dart | DismissFocusOverlay | Auto-hide keyboard on focus loss |
| auto_hide_by_keyboard.dart | AutoHideByKeyboard | Keyboard auto-hide assistant |
| top_alert_bar.dart | TopAlertBar | Top alert bar |
| wd_underlinetabindicator.dart | WDUnderlineTabIndicator | Custom underline Tab indicator |
| responsive.dart | ResponsiveHelper | Responsive layout helper |
| safe_area_widget.dart | SafeAreaWidget | Safe area component |
| child_size_reporter.dart | ChildSizeReporter | Child component size reporter |
| sticky_child_delegate.dart | StickyChildDelegate | Sticky child delegate |

## 💡 Usage Examples

### Basic Rounded Component

```dart
// Rounded card
RoundWidget(
  radius: 12.0,
  color: Colors.white,
  elevation: 4.0,
  padding: EdgeInsets.all(16.0),
  child: Text('Card Content'),
  onTap: () {
    print('Card clicked');
  },
)
```

### Enhanced Switch Component

```dart
SwitchListTileX(
  title: Text('Enable Notifications'),
  subtitle: Text('Receive push notifications'),
  value: _notificationEnabled,
  switchScale: 0.8, // Scale the switch
  onChanged: (bool value) {
    setState(() {
      _notificationEnabled = value;
    });
  },
)
```

### Paginated List Loading

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

### Unified Error Handling

```dart
ErrorMessageWidget(
  errorMessage: 'Network connection failed',
  icon: Icons.wifi_off,
  onRetry: () {
    // Reload data
    _loadData();
  },
)
```

### Empty State Handling

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
    title: 'No Data',
    message: 'Try refreshing',
  ),
)
```

## 🏗️ Project Structure

```
lib/
├── exports.dart              # Export all components
├── mixins.dart               # Mixin utilities
├── util/                     # Utility classes
├── models/                   # Data models
├── widget/                   # Component directory
│   ├── scroll/              # Scroll-related components
│   ├── my_iframe/           # iframe components
│   └── export_widget.dart   # Component export file
└── main.dart
```

## 📱 Features

- ✅ **Material Design 3** compatible
- ✅ **Responsive design** support
- ✅ **Null Safety**
- ✅ **Extensible** component design
- ✅ **Unified theme** color adaptation
- ✅ **Performance optimized** lazy loading
- ✅ **Internationalization** support

## 🤝 Contribution

Welcome to submit Issues and Pull Requests!

## 📄 License

MIT License
