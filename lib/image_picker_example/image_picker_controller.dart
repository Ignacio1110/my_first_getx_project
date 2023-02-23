import 'package:get/get.dart';

import 'photo_manager_widget/photo_manage_controller.dart';
import 'preview_viewer/preview_controller.dart';

class ImagePickerController extends GetxController {
  final photoManagerController =
      Get.put(PhotoManagerController(maxSelectAssets: 9));
  final previewController = Get.put(PreviewController());
  @override
  void onInit() {
    ever(photoManagerController.selectedAssets, (selectedAssets) {
      previewController.selectedAssets
          .assignAll(selectedAssets.map((e) => AssetWrapper(e)).toList());
    });

    super.onInit();
  }
}
