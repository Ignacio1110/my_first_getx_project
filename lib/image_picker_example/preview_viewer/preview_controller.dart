import 'dart:io';
import 'dart:typed_data';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';

import 'src/crop_editor_helper.dart';

class PreviewController extends GetxController
    with GetSingleTickerProviderStateMixin {
  Rxn<AssetWrapper> previewAsset = Rxn<AssetWrapper>();
  RxList<AssetWrapper> selectedAssets = <AssetWrapper>[].obs;

  /// [AnimationController] for double tap animation.
  /// 双击缩放的动画控制器
  late AnimationController doubleTapAnimationController;

  /// [CurvedAnimation] for double tap.
  /// 双击缩放的动画曲线
  late Animation<double> doubleTapCurveAnimation;

  /// [Animation] for double tap.
  /// 双击缩放的动画
  Animation<double>? doubleTapAnimation;

  /// Callback for double tap.
  /// 双击缩放的回调
  late VoidCallback doubleTapListener;

  /// Initialize animations related to the zooming preview.
  /// 为缩放预览初始化动画
  /// //covariant AssetPickerViewerState<Asset, Path> state
  void initAnimations() {
    // viewerState = state;
    doubleTapAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    doubleTapCurveAnimation = CurvedAnimation(
      parent: doubleTapAnimationController,
      curve: Curves.easeInOut,
    );
  }

  ///
  /// Execute scale animation when double tap.
  /// 双击时执行缩放动画
  void updateAnimation(ExtendedImageGestureState state) {
    final double begin = state.gestureDetails!.totalScale!;
    final double end = state.gestureDetails!.totalScale! == 1.0 ? 2.0 : 1.0;
    final Offset pointerDownPosition = state.pointerDownPosition!;

    doubleTapAnimation?.removeListener(doubleTapListener);
    doubleTapAnimationController
      ..stop()
      ..reset();
    doubleTapListener = () {
      state.handleDoubleTap(
        scale: doubleTapAnimation!.value,
        doubleTapPosition: pointerDownPosition,
      );
    };
    doubleTapAnimation = Tween<double>(
      begin: begin,
      end: end,
    ).animate(doubleTapCurveAnimation)
      ..addListener(doubleTapListener);
    doubleTapAnimationController.forward();
  }

  bool _cropping = false;

  final GlobalKey<ExtendedImageEditorState> editorKey =
      GlobalKey<ExtendedImageEditorState>();
  List editorKeys = [];
  Future<void> cropImage() async {
    if (_cropping) {
      return;
    }
    _cropping = true;
    try {
      final Uint8List fileData = Uint8List.fromList(
          (await cropImageDataWithNativeLibrary(
              state: editorKey.currentState!))!);
      final String? fileFath =
          await ImageSaver.save('extended_image_cropped_image.jpg', fileData);
      // showToast('save image : $fileFath');
    } finally {
      _cropping = false;
    }
  }

  @override
  void onInit() {
    initAnimations();
    super.onInit();
  }
}

class ImageSaver {
  const ImageSaver._();

  static Future<String?> save(String name, Uint8List fileData) async {
    final String title = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final AssetEntity? imageEntity = await PhotoManager.editor.saveImage(
      fileData,
      title: title,
    );
    final File? file = await imageEntity?.file;
    return file?.path;
  }
}

class AssetWrapper {
  AssetWrapper(this.assetEntity);
  final AssetEntity assetEntity;
  final GlobalKey<ExtendedImageEditorState> editorKey =
      GlobalKey<ExtendedImageEditorState>();
}
