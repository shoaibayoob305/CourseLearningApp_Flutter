import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:frontend/app/modules/subscriptions/controllers/subscription_controller.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SubscriptionsView extends StatelessWidget {
  const SubscriptionsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SubscriptionsController());
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: const Text('Subscriptions'),
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
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Subscription Plans',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                              color: Color(0xff000000),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Obx(
                            () => Text(
                              '${controller.subscriptionList.length} plans found',
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
                        () => GridView.builder(
                          itemCount: controller.subscriptionList.length,
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 20,
                            crossAxisSpacing: 15,
                            mainAxisExtent: 250,
                          ),
                          itemBuilder: (context, index) {
                            final course = controller.subscriptionList[index];
                            return GestureDetector(
                              onTap: () {
                                log('index is ${course.id}');
                              },
                              child: Container(
                                padding: const EdgeInsets.only(
                                    left: 12, right: 12, top: 10, bottom: 10),
                                width: 180,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: const Color(0xffF2F2F2),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 125,
                                      child: Stack(
                                        children: [
                                          Image(
                                            image: const AssetImage(
                                                'assets/course.png'),
                                            height: Get.height,
                                            width: Get.width,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      course.name ?? '',
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontStyle: FontStyle.italic,
                                        color: const Color(0xff000000),
                                      ),
                                    ),
                                    Text(
                                      course.description ?? '',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Color(0xff7C7A7A),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      '\$ ${course.price.toString()}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontStyle: FontStyle.italic,
                                        color: Color(0xff000000),
                                      ),
                                    ),
                                  ],
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
    );
  }
}
