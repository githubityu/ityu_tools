import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'extension/image_aspect_ratio.dart';
class ImageUtils {
  const ImageUtils._();

  // --- Base64 转换 ---

  static MemoryImage base64ToImage(String base64String) {
    return MemoryImage(base64Decode(base64String));
  }

  static Uint8List base64ToUint8List(String base64String) {
    return base64Decode(base64String);
  }

  /// 异步将文件转为 Base64（避免阻塞 UI）
  static Future<String> fileToBase64(File imgFile) async {
    final bytes = await imgFile.readAsBytes();
    return base64Encode(bytes);
  }

  /// 将 Asset 转为 Base64
  static Future<String> assetToBase64(String assetPath) async {
    final data = await rootBundle.load(assetPath);
    return base64Encode(data.buffer.asUint8List());
  }

  // --- 低级加载 ---

  /// 加载 Asset 图片为 ui.Image 对象
  static Future<ui.Image> loadAssetImage(String asset, {int? width, int? height}) async {
    final data = await rootBundle.load(asset);
    final codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
      targetHeight: height,
    );
    final fi = await codec.getNextFrame();
    return fi.image;
  }

  // --- Provider 获取 ---

  /// 获取统一的 ImageProvider
  static ImageProvider getProvider(String? path, {int? maxWidth, int? maxHeight}) {
    if (path == null || path.isEmpty) {
      // 返回一个透明图片占位或默认图
      return const AssetImage('assets/images/placeholder.png');
    }

    if (path.startsWith('http')) {
      return CachedNetworkImageProvider(path, maxWidth: maxWidth, maxHeight: maxHeight);
    } else if (path.startsWith('assets/')) {
      return AssetImage(path);
    } else {
      return FileImage(File(path));
    }
  }
}



/// 一个能够根据图片真实比例自动调整高度的组件
class AutoAspectRatioImage extends StatelessWidget {
  final String url;
  final double? width;
  final BoxFit fit;
  final Widget? placeholder;
  final double minRatio; // 最小比例限制
  final double maxRatio; // 最大比例限制

  const AutoAspectRatioImage({
    super.key,
    required this.url,
    this.width,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.minRatio = 0.5,
    this.maxRatio = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    // 假设你之前已经写好了 ImageProvider 的 getAspectRatio 扩展
    return FutureBuilder<double>(
      future: CachedNetworkImageProvider(url).getAspectRatio(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          double ratio = snapshot.data!;

          // 可以在这里进行业务上的比例微调
          // 比如防止图片过长或过宽
          ratio = ratio.clamp(minRatio, maxRatio);

          return AspectRatio(
            aspectRatio: ratio,
            child: CachedNetworkImage(
              imageUrl: url,
              width: width,
              fit: fit,
              placeholder: (context, url) => placeholder ?? const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          );
        }

        // 加载比例时的占位
        return placeholder ?? const AspectRatio(aspectRatio: 1, child: SizedBox());
      },
    );
  }
}