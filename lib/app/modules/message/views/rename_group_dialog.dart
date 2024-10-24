import 'package:flutter/material.dart';
import 'package:frontend/app/modules/message/controllers/messages_controller.dart';
import 'package:get/get.dart';

import '../../../utils/widgets/defaultsnackbar.dart';

class RenameGroupDialog {
  static void showGroupNameDialog() {
    final controller = Get.put(MessagesController());

    Get.dialog(
      Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Enter Group Name',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20.0),
              TextField(
                controller: controller.renameGroupController,
                style: const TextStyle(
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  hintText: 'Group Name',
                ),
              ),
              const SizedBox(height: 20.0),
              Obx(
                () => TextButton(
                  onPressed: () async {
                    if (controller.isRenameLoading.value) {
                    } else if (controller.renameGroupController.text.isEmpty) {
                      DefaultSnackbar.show('Error', 'Enter Group Name first');
                    } else {
                      await controller.renameGroup();
                      Get.back(); // Close the dialog
                    }
                  },
                  child: controller.isRenameLoading.value
                      ? Center(
                          child: CircularProgressIndicator(
                            color: Color(0xff233853),
                          ),
                        )
                      : const Text(
                          'Rename',
                          style: TextStyle(
                            color: Color(0xff233853),
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }
}
