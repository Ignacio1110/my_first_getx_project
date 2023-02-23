import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:my_first_getx_project/image_picker_example/preview_viewer/preview_controller.dart';

import 'src/editor_layer_painter.dart';

class PreviewViewer extends GetView<PreviewController> {
  const PreviewViewer({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width,
            child: (controller.selectedAssets.isNotEmpty)
                ? ExtendedImageGesturePageView.builder(
                    itemCount: controller.selectedAssets.length,
                    itemBuilder: (context, index) {
                      return SizedBox(
                        child: ClipRRect(
                          child: FutureBuilder(
                              future: controller.selectedAssets[index]
                                  .assetEntity.originBytes,
                              builder: (context, originBytes) {
                                if (originBytes.data == null) {
                                  return const CircularProgressIndicator();
                                }
                                return ExtendedImage(
                                  enableLoadState: true,
                                  shape: BoxShape.rectangle,
                                  extendedImageEditorKey: controller
                                      .selectedAssets[index].editorKey,
                                  image: ExtendedMemoryImageProvider(
                                      originBytes.data!),
                                  mode: ExtendedImageMode.editor,
                                  fit: BoxFit.contain,
                                  onDoubleTap: controller.updateAnimation,
                                  initGestureConfigHandler:
                                      (ExtendedImageState state) =>
                                          GestureConfig(
                                    minScale: 1.0,
                                    maxScale: 1.0,
                                    // animationMinScale: 0.0,
                                    // animationMaxScale: 1.0,
                                    inPageView: false,
                                  ),
                                  initEditorConfigHandler:
                                      (ExtendedImageState? state) =>
                                          EditorConfig(
                                              cropAspectRatio: 1,
                                              maxScale: 3,
                                              hitTestSize: 0,
                                              cropRectPadding:
                                                  const EdgeInsets.all(0.0),
                                              initCropRectType:
                                                  InitCropRectType.layoutRect,
                                              animationDuration: Duration.zero,
                                              cornerColor: Colors.red,
                                              cropLayerPainter:
                                                  EditorLayerPainter()),
                                  loadStateChanged: (ExtendedImageState state) {
                                    print(state);
                                  },
                                );
                              }),
                        ),
                      );
                    })
                : SizedBox(),
          ),
          SizedBox(
            height: 10,
            child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: controller.selectedAssets.length,
                itemBuilder: (ctx, index) {
                  return SizedBox(
                    width: 5,
                    height: 5,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                          color: Colors.red, shape: BoxShape.circle),
                    ),
                  );
                }),
          ),
          Container(
            height: 30,
            child: TextButton(
              onPressed: () {
                controller.cropImage();
              },
              child: Text("save"),
            ),
          ),
        ],
      ),
    );
  }
}

/// Preview item widgets for images.
// Widget _imagePreviewItem(AssetEntity asset) {
// return ExtendedImageGesturePageView.builder(
//   // controller: ,
//   itemCount: 1,
//   itemBuilder: (BuildContext context, int index) {
//     return ExtendedImage(
//         image: AssetEntityImageProvider(
//           asset,
//           isOriginal: true,
//         ),
//         mode: ExtendedImageMode.gesture,
//         fit: BoxFit.cover,
//         onDoubleTap: preview.updateAnimation,
//         initGestureConfigHandler: (ExtendedImageState state) =>
//             GestureConfig(
//               minScale: 1.0,
//               maxScale: 3.0,
//               animationMinScale: 0.6,
//               animationMaxScale: 4.0,
//               inPageView: false,
//             ),
//         loadStateChanged: (ExtendedImageState state) {
//           print(state);
//           // return widget.delegate.previewWidgetLoadStateChanged(
//           //   context,
//           //   state,
//           //   hasLoaded: state.extendedImageLoadState == LoadState.completed,
//           // );
//         });
//   },
// );
// }
