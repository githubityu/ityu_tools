import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/widgets.dart';

/// 核心优化：直接针对 ImageProvider 进行扩展
extension ImageProviderAspectRatio on ImageProvider {
  /// 获取图片的宽高比
  Future<double> getAspectRatio() {
    final completer = Completer<double>();

    // 1. 获取图片流
    final ImageStream stream = resolve(ImageConfiguration.empty);

    late ImageStreamListener listener;

    // 2. 定义监听器
    listener = ImageStreamListener(
          (ImageInfo imageInfo, bool synchronousCall) {
        final double width = imageInfo.image.width.toDouble();
        final double height = imageInfo.image.height.toDouble();

        final double aspectRatio = height != 0 ? width / height : 0.0;

        // 成功完成
        if (!completer.isCompleted) {
          completer.complete(aspectRatio);
        }

        // 关键：移除监听器防止内存泄漏
        stream.removeListener(listener);
      },
      onError: (dynamic exception, StackTrace? stackTrace) {
        // 错误处理：完成错误或返回默认值
        if (!completer.isCompleted) {
          completer.completeError(exception ?? 'Image resolve error', stackTrace);
        }
        // 关键：发生错误也要移除监听器
        stream.removeListener(listener);
      },
    );

    // 3. 注册监听
    stream.addListener(listener);

    return completer.future;
  }
}

/// 针对 Widget 的简易包装
extension GetImageWidgetAspectRatio on Image {
  Future<double> getAspectRatio() => image.getAspectRatio();
}

/// 针对内存数据的扩展
extension GetImageDataAspectRatio on Uint8List {
  Future<double> getAspectRatio() => MemoryImage(this).getAspectRatio();
}

/// 针对文件路径的扩展
extension GetImageFileAspectRatio on String {
  Future<double> getFileAspectRatio() => FileImage(File(this)).getAspectRatio();
}