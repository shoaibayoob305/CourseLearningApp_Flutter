import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../controller/notification_controller.dart';
import '../model/notification_model.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NotificationController());
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.readAllNotifications();
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Icon(Icons.arrow_back_ios_new),
        ),
        title: const Text('Notifications'),
        centerTitle: true,
      ),
      body: Obx(
        () => controller.isLoading.value == true
            ? Center(
                child: LoadingAnimationWidget.beat(
                  color: Colors.blueGrey.shade700,
                  size: 40,
                ),
              )
            : RefreshIndicator(
                backgroundColor: Colors.white,
                color: const Color(0xff233853),
                onRefresh: () async {
                  await controller.getNotifications();
                },
                child: SingleChildScrollView(
                  controller: controller.scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (controller.unReadNotification.isNotEmpty) ...[
                        const Padding(
                          padding: EdgeInsets.only(
                            left: 15.0,
                            top: 5.0,
                          ),
                          child: Text(
                            'Unread',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ...controller.unReadNotification.map((notification) {
                          return _buildNotificationTile(notification);
                        }).toList(),
                      ],
                      if (controller.readNotification.isNotEmpty) ...[
                        const Padding(
                          padding: EdgeInsets.only(
                            left: 15.0,
                            top: 5.0,
                          ),
                          child: Text(
                            'Previous',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ...controller.readNotification.map((notification) {
                          return _buildNotificationTile(notification);
                        }).toList(),
                        controller.isLoadingMore.value
                            ? Padding(
                                padding: const EdgeInsets.only(
                                    top: 15.0, bottom: 15.0),
                                child: Center(
                                  child: LoadingAnimationWidget.beat(
                                    color: Colors.blueGrey.shade700,
                                    size: 30,
                                  ),
                                ),
                              )
                            : SizedBox.shrink(),
                      ],
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildNotificationTile(Results notification) {
    String datePart = notification.createdAt!.split('T')[0];
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    DateTime parsedDate = formatter.parse(datePart);
    String formattedDate = DateFormat('dd MMMM, yyyy').format(parsedDate);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              blurRadius: 4.0,
              spreadRadius: 1.0,
              color: Colors.grey.shade300,
            ),
          ],
        ),
        child: ListTile(
          title: Text(notification.message!),
          leading: CircleAvatar(
            backgroundColor: Colors.blue.shade200,
            child: const Icon(
              Icons.notifications,
              color: Colors.grey,
            ),
          ), // No leading icon for read notifications
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(formattedDate),
            ],
          ),
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:frontend/app/modules/notification/controller/notification_controller.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:loading_animation_widget/loading_animation_widget.dart';

// class NotificationPage extends StatelessWidget {
//   const NotificationPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(NotificationController());
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       controller.readAllNotifications();
//     });
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         forceMaterialTransparency: true,
//         leading: GestureDetector(
//           onTap: () {
//             Get.back();
//           },
//           child: const Icon(Icons.arrow_back_ios_new),
//         ),
//         title: const Text('Notifications'),
//         centerTitle: true,
//       ),
//       body: Obx(
//         () => controller.isLoading.value == true
//             ? Center(
//                 child: LoadingAnimationWidget.beat(
//                     color: Colors.blueGrey.shade700, size: 40),
//               )
//             : Column(
//                 mainAxisAlignment: controller.isLoading.value
//                     ? MainAxisAlignment.center
//                     : MainAxisAlignment.start,
//                 children: [
//                   Obx(
//                     () => controller.notificationsList.isEmpty
//                         ? const Center(
//                             child: Text(
//                               'No Notifications yet',
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.w500,
//                                 color: Colors.grey,
//                               ),
//                             ),
//                           )
//                         : Expanded(
//                             child: ListView.builder(
//                               itemCount: controller.notificationsList.length,
//                               itemBuilder: (context, index) {
//                                 final notification =
//                                     controller.notificationsList[index];
//                                 String datePart =
//                                     notification.createdAt!.split('T')[0];

//                                 DateFormat formatter = DateFormat('yyyy-MM-dd');
//                                 DateTime parsedDate = formatter.parse(datePart);
//                                 String formattedDate =
//                                     DateFormat('dd-MM-yyyy').format(parsedDate);
//                                 return Padding(
//                                   padding: const EdgeInsets.all(15.0),
//                                   child: Container(
//                                     decoration: BoxDecoration(
//                                       color: Colors.white,
//                                       borderRadius: BorderRadius.circular(8.0),
//                                       boxShadow: [
//                                         BoxShadow(
//                                             blurRadius: 4.0,
//                                             spreadRadius: 1.0,
//                                             color: Colors.grey.shade300)
//                                       ],
//                                     ),
//                                     child: ListTile(
//                                       title: Text(notification.message!),
//                                       leading: notification.read == false
//                                           ? Icon(
//                                               Icons
//                                                   .brightness_1, // Dot icon for unread notifications
//                                               size: 12.0,
//                                               color: Colors.red,
//                                             )
//                                           : null, // No trailing icon for read notifications
//                                       subtitle: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.end,
//                                         children: [
//                                           Text(formattedDate),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 );
//                               },
//                             ),
//                           ),
//                   ),
//                 ],
//               ),
//       ),
//     );
//   }
// }
