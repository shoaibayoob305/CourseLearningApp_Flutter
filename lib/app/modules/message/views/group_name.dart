import 'package:flutter/material.dart';
import 'package:frontend/app/modules/message/controllers/messages_controller.dart';
import 'package:get/get.dart';

import '../../../utils/widgets/defaultsnackbar.dart';

class EnterGroupNameDialog {
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
                controller: controller.groupNameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  hintText: 'Group Name',
                ),
              ),
              const SizedBox(height: 20.0),
              TextButton(
                onPressed: () {
                  if (controller.groupNameController.text.isEmpty) {
                    DefaultSnackbar.show('Error', 'Enter Group Name first');
                  } else {
                    Get.back(); // Close the dialog
                    controller.makeConversation();
                  }
                },
                child: const Text(
                  'Create Group',
                  style: TextStyle(
                    color: Color(0xff233853),
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


// import 'package:flutter/material.dart';
// import 'package:frontend/app/modules/message/controllers/messages_controller.dart';
// import 'package:get/get.dart';

// import '../../../utils/widgets/defaultsnackbar.dart';

// class EnterGroupNameScreen extends StatelessWidget {
//   const EnterGroupNameScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(MessagesController());
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         centerTitle: true,
//         forceMaterialTransparency: true,
//         actions: [
//           TextButton(
//             onPressed: () {
//               if (controller.groupNameController.text.isEmpty) {
//                 DefaultSnackbar.show('Error', 'Enter Group Name first');
//               } else {
//                 controller.makeConversation();
//               }
//             },
//             child: Text('Create Group'),
//           ),
//         ],
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               const Text(
//                 'Enter Group Name',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 20.0),
//               TextField(
//                 controller: controller.groupNameController,
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10.0),
//                   ),
//                   hintText: 'Group Name',
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
