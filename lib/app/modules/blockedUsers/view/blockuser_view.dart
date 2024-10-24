import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../controller/blockuser_controller.dart';

class BlockedUserView extends StatelessWidget {
  const BlockedUserView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BlockedUserController());

    return RefreshIndicator(
      backgroundColor: Colors.white,
      color: const Color(0xff233853),
      onRefresh: () async {
        await controller.getBlockedUserList(true);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          forceMaterialTransparency: true,
          title: const Text('Blocked User'),
          centerTitle: true,
        ),
        body: Obx(
          () => controller.isLoading.value == true
              ? Center(
                  child: LoadingAnimationWidget.beat(
                      color: Colors.blueGrey.shade700, size: 40),
                )
              : controller.blockedUserList.isEmpty
                  ? const Center(
                      child: Text(
                        'No Blocked User yet',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: controller.blockedUserList.length,
                        separatorBuilder: (context, index) => SizedBox(
                          height: 10.0,
                        ),
                        itemBuilder: (context, index) {
                          final friend = controller.blockedUserList[index];
                          return GestureDetector(
                            onTap: () {},
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.0),
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 4.0,
                                      spreadRadius: 1.0,
                                      color: Colors.grey.shade300)
                                ],
                              ),
                              child: ListTile(
                                title: Text(friend.blockedUserName ?? ''),
                                leading: CircleAvatar(
                                  backgroundColor: Colors.grey.shade400,
                                  child: const Icon(Icons.person),
                                ),
                                trailing: controller.isUnblocking.value
                                    ? const CircularProgressIndicator()
                                    : TextButton(
                                        onPressed: () {
                                          controller.unBlockUser(friend.id!);
                                        },
                                        child: const Text(
                                          'Unblock',
                                          style: TextStyle(color: Colors.red),
                                        )),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
        ),
      ),
    );
  }
}
