import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../controller/purchase_controller.dart';

class PurchaseView extends StatelessWidget {
  const PurchaseView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PurchaseController());
    return RefreshIndicator(
      backgroundColor: Colors.white,
      color: const Color(0xff233853),
      onRefresh: () async {
        await controller.getAllPurchases();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          title: const Text('Purchases'),
          forceMaterialTransparency: true,
          centerTitle: true,
          // title: GestureDetector(
          //   onTap: () => Get.to(() => const SearchView()),
          //   child: Row(
          //     children: [
          //       Image.asset('assets/search1.png'),
          //       const SizedBox(
          //         width: 10,
          //       ),
          //       const Text(
          //         'Search course',
          //         style: TextStyle(
          //           color: Color(0xff797C7B),
          //           fontSize: 16,
          //           fontWeight: FontWeight.w300,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ),
        body: Obx(
          () => controller.isLoading.value == true
              ? Center(
                  child: LoadingAnimationWidget.beat(
                      color: Colors.blueGrey.shade700, size: 40),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 15, bottom: 30),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Obx(
                              () => Text(
                                '${controller.purchaseList.length} purchases found',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xff000000),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Obx(
                          () => ListView.separated(
                            separatorBuilder: (context, index) => SizedBox(
                              height: 10.0,
                            ),
                            itemCount: controller.purchaseList.length,
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final course = controller.purchaseList[index];
                              return GestureDetector(
                                onTap: () {
                                  controller.selectedPurchaseCourseIdForLater
                                      .value = course.id!;
                                  controller.selectPurchase(course);
                                },
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
                                    title: Text(course.courseName ?? ''),
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.grey.shade300,
                                      child: Image(
                                        image: AssetImage('assets/course.png'),
                                      ),
                                    ),
                                    trailing: const Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
