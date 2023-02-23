import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_first_getx_project/image_picker_example/photo_manager_widget/photo_manage_controller.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class PhotoManagerWidget extends GetView<PhotoManagerController> {
  const PhotoManagerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        List<AssetEntity>? assets = controller.currentAssets;
        if (assets == null) return Placeholder(color: Colors.red);
        return GridView.builder(
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
          itemCount: assets.length,
          itemBuilder: (BuildContext context, int index) {
            return AssetEntityImage(
              assets[index],
              isOriginal: false,
              thumbnailSize: controller.pathThumbnailSize,
              fit: BoxFit.cover,
              frameBuilder: (
                BuildContext context,
                Widget child,
                int? frame,
                bool wasSynchronouslyLoaded,
              ) {
                return GestureDetector(
                  onTap: () {
                    controller.selectAsset(assets[index]);
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
    );
  }
}
