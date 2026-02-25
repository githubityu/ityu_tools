import 'dart:async';
import 'package:flutter/material.dart';

typedef LibraryLoader = Future<void> Function();
typedef DeferredWidgetBuilder = Widget Function();

/// 延迟加载组件封装
class DeferredWidget extends StatefulWidget {
  const DeferredWidget(
      this.libraryLoader,
      this.createWidget, {
        super.key,
        this.placeholder,
      });

  final LibraryLoader libraryLoader;
  final DeferredWidgetBuilder createWidget;
  final Widget? placeholder;

  /// 已缓存的加载任务
  static final Map<LibraryLoader, Future<void>> _moduleLoaders = {};
  /// 已成功加载的模块记录
  static final Set<LibraryLoader> _loadedModules = {};

  /// 预加载某个模块
  static Future<void> preload(LibraryLoader loader) {
    return _moduleLoaders.putIfAbsent(loader, () {
      return loader().then((_) => _loadedModules.add(loader));
    });
  }

  @override
  State<DeferredWidget> createState() => _DeferredWidgetState();
}

class _DeferredWidgetState extends State<DeferredWidget> {
  Widget? _loadedChild;
  DeferredWidgetBuilder? _loadedCreator;

  @override
  void initState() {
    super.initState();
    if (DeferredWidget._loadedModules.contains(widget.libraryLoader)) {
      _onLibraryLoaded();
    } else {
      DeferredWidget.preload(widget.libraryLoader).then((_) {
        if (mounted) _onLibraryLoaded();
      });
    }
  }

  void _onLibraryLoaded() {
    setState(() {
      _loadedCreator = widget.createWidget;
      _loadedChild = _loadedCreator!();
    });
  }

  @override
  Widget build(BuildContext context) {
    // 如果构造器发生变化且已加载过，则重新创建实例
    if (_loadedCreator != widget.createWidget && _loadedCreator != null) {
      _loadedCreator = widget.createWidget;
      _loadedChild = _loadedCreator!();
    }
    return _loadedChild ?? widget.placeholder ?? const DeferredLoadingPlaceholder();
  }
}

/// 优化后的加载占位符 (适配 Material 3)
class DeferredLoadingPlaceholder extends StatelessWidget {
  const DeferredLoadingPlaceholder({
    super.key,
    this.name = 'Module',
  });

  final String name;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxWidth: 280),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withValues(alpha:0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colorScheme.outlineVariant),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: theme.primaryColor,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Installing $name...',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'This module is being downloaded and installed at runtime.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}