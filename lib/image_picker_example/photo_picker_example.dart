import 'dart:io';
import 'dart:typed_data';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_first_getx_project/image_picker_example/src/editor_painter.dart';
import 'package:my_first_getx_project/image_picker_example/photo_manage_controller.dart';
import 'package:photo_manager/photo_manager.dart';

import 'src/image_page_view.dart';
import 'preview_controller.dart';

class PhotoPickerExample extends GetView<AssetPickerController> {
  final bloc = Get.put(AssetPickerController());
  final preview = Get.put(PreviewController());

  /// Preview item widgets for images.
  /// 图片的底部预览部件
  Widget _imagePreviewItem(AssetEntity asset) {
    return FutureBuilder(
        future: asset.originBytes,
        builder: (context, originBytes) {
          if (originBytes.data == null) {
            return CircularProgressIndicator();
          }
          return ExtendedImage(
            enableLoadState: true,
            shape: BoxShape.rectangle,
            extendedImageEditorKey: preview.editorKey,
            image: ExtendedMemoryImageProvider(originBytes.data!),
            mode: ExtendedImageMode.editor,
            fit: BoxFit.contain,
            onDoubleTap: preview.updateAnimation,
            initGestureConfigHandler: (ExtendedImageState state) =>
                GestureConfig(
              minScale: 1.0,
              maxScale: 1.0,
              // animationMinScale: 0.0,
              // animationMaxScale: 1.0,
              inPageView: false,
            ),
            initEditorConfigHandler: (ExtendedImageState? state) =>
                EditorConfig(
                    cropAspectRatio: 1,
                    maxScale: 3,
                    hitTestSize: 0,
                    cropRectPadding: const EdgeInsets.all(20.0),
                    initCropRectType: InitCropRectType.layoutRect,
                    animationDuration: Duration.zero,
                    cornerColor: Colors.red,
                    cropLayerPainter: MyLayerPainter()),
            loadStateChanged: (ExtendedImageState state) {
              print(state);
            },
          );
        });
    return ExtendedImageGesturePageView.builder(
      // controller: ,
      itemCount: 1,
      itemBuilder: (BuildContext context, int index) {
        return ExtendedImage(
            image: AssetEntityImageProvider(
              asset,
              isOriginal: true,
            ),
            mode: ExtendedImageMode.gesture,
            fit: BoxFit.cover,
            onDoubleTap: preview.updateAnimation,
            initGestureConfigHandler: (ExtendedImageState state) =>
                GestureConfig(
                  minScale: 1.0,
                  maxScale: 3.0,
                  animationMinScale: 0.6,
                  animationMaxScale: 4.0,
                  inPageView: false,
                ),
            loadStateChanged: (ExtendedImageState state) {
              print(state);
              // return widget.delegate.previewWidgetLoadStateChanged(
              //   context,
              //   state,
              //   hasLoaded: state.extendedImageLoadState == LoadState.completed,
              // );
            });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(
          () => Column(
            children: [
              Expanded(
                child: (bloc.selectedAssets.value.isNotEmpty)
                    ? SizedBox(
                        child: _imagePreviewItem(bloc.selectedAssets.first))
                    : SizedBox(),
              ),
              // Container(
              //   height: MediaQuery.of(context).size.height * .4,
              //   child: bloc.selectedAssets.isNotEmpty
              //       ? ImagePageBuilder(
              //           asset: bloc.selectedAssets.first,
              //           // delegate: this,
              //           // previewThumbnailSize: bloc.previewThumbnailSize,
              //         )
              //       : SizedBox(),
              // ),
              Container(
                height: 30,
                child: TextButton(
                  onPressed: () {
                    preview.cropImage();
                  },
                  child: Text("save"),
                ),
              ),
              Expanded(
                child: Builder(
                  builder: (ctx) {
                    List<AssetEntity>? assets = bloc.currentAssetsRx.value;
                    if (assets == null) return Placeholder(color: Colors.red);
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4),
                      itemCount: assets.length,
                      itemBuilder: (BuildContext context, int index) {
                        final AssetEntityImageProvider imageProvider =
                            AssetEntityImageProvider(
                          assets[index],
                          isOriginal: false,
                          thumbnailSize: bloc.pathThumbnailSize,
                        );
                        return AssetEntityImage(
                          assets[index],
                          isOriginal: false,
                          thumbnailSize: bloc.pathThumbnailSize,
                          fit: BoxFit.cover,
                          frameBuilder: (
                            BuildContext context,
                            Widget child,
                            int? frame,
                            bool wasSynchronouslyLoaded,
                          ) {
                            return GestureDetector(
                              onTap: () {
                                bloc.selectedAssets.clear();
                                bloc.selectedAssets.add(assets[index]);
                              },
                              child: Container(
                                  padding: EdgeInsets.all(8.0),
                                  color: Colors.deepOrange.withOpacity(0.4),
                                  child: child),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
