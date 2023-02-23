import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_first_getx_project/image_picker_example/photo_manager_widget/photo_maneger_widget.dart';
import 'package:my_first_getx_project/image_picker_example/preview_viewer/preview_viewer.dart';

import 'image_picker_controller.dart';

class ImagePickerExample extends GetView<ImagePickerController> {
  const ImagePickerExample({super.key});


  @override
  Widget build(BuildContext context) {
    Get.put(ImagePickerController());
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            PreviewViewer(),
            Expanded(
              child: PhotoManagerWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
