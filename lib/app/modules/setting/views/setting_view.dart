import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:frontend/app/modules/account/views/account_mainview.dart';
import 'package:frontend/app/modules/authentication/views/login_view.dart';
import 'package:frontend/app/modules/feedback/views/feedback_view.dart';
import 'package:frontend/app/modules/friends/view/friends_mainview.dart';
import 'package:frontend/app/modules/friends/view/new_friends_tabview.dart';
import 'package:frontend/app/modules/setting/controllers/settings_controller.dart';
import 'package:frontend/app/utils/widgets/new_setting_tile.dart';
import 'package:get/get.dart';
import '../../authentication/model/user_model.dart';
import '../../payments/views/payment_view.dart';
import '../../purchases/view/purchase_view.dart';

class SettingView extends StatelessWidget {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SettingsController());
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                    bottom: 15,
                    top: 20,
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'My Account',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Obx(
                        () {
                          final userModel = controller
                              .authenticationController.userModel.value;

                          final firstNameInitial =
                              userModel.firstName?.isNotEmpty == true
                                  ? userModel.firstName!.substring(0, 1)
                                  : '';
                          final lastNameInitial =
                              userModel.lastName?.isNotEmpty == true
                                  ? userModel.lastName!.substring(0, 1)
                                  : '';

                          return userModel.image == null
                              ? CircleAvatar(
                                  backgroundColor: Colors.grey.shade800,
                                  radius: 40,
                                  child: ClipOval(
                                    child: Center(
                                      child: Text(
                                        "$firstNameInitial$lastNameInitial",
                                        style: const TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : CircleAvatar(
                                  backgroundColor: Colors.grey.shade800,
                                  radius: 40,
                                  child: ClipOval(
                                    child: CachedNetworkImage(
                                      imageUrl: userModel.image ?? '',
                                      width: 120,
                                      height: 120,
                                      fit: BoxFit.cover,
                                      progressIndicatorBuilder: (context, url,
                                              downloadProgress) =>
                                          CircularProgressIndicator(
                                              value: downloadProgress.progress),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                  ),
                                );
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        '${controller.authenticationController.userModel.value.firstName} ${controller.authenticationController.userModel.value.lastName}',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: Get.width,
                        height: 100,
                        decoration: BoxDecoration(
                          color: const Color(0xff5EDE99),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 60),
                          child: Row(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.settings,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    'Study this week',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    '134.4h',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              Spacer(),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '|',
                                    style: TextStyle(
                                      fontSize: 40,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              Spacer(),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.settings,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    'Ranking',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    '01',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      NewSettingTile(
                        onPress: () {
                          Get.to(() => const AccountMainview());
                        },
                        leadingbackgroundColor: const Color(0xffE0FFF0),
                        iconData: Icons.account_box_rounded,
                        iconColor: Colors.green.shade400,
                        title: 'Profile',
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      NewSettingTile(
                        onPress: () {
                          Get.to(() => const NewFriendsTabview());
                        },
                        leadingbackgroundColor: const Color(0xffE0FDFF),
                        iconData: Icons.group,
                        iconColor: Colors.blue.shade400,
                        title: 'Friends',
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      NewSettingTile(
                        onPress: () {
                          Get.to(() => const PaymentView());
                        },
                        leadingbackgroundColor: Colors.grey.shade200,
                        iconData: Icons.payment,
                        title: 'Payment Methods',
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      NewSettingTile(
                        onPress: () {
                          Get.to(() => const PurchaseView());
                        },
                        leadingbackgroundColor: Colors.grey.shade200,
                        iconData: Icons.shopify,
                        title: 'Purchases',
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      NewSettingTile(
                        onPress: () {
                          Get.to(() => const FeedbackView());
                        },
                        leadingbackgroundColor: const Color(0xffFFFCE0),
                        iconData: Icons.feedback_rounded,
                        iconColor: Colors.yellow.shade400,
                        title: 'Feedback',
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      NewSettingTile(
                        onPress: () {
                          Get.to(() => const FriendsMainview());
                        },
                        leadingbackgroundColor: const Color(0xffEECCF6),
                        iconData: Icons.settings,
                        iconColor: Colors.pinkAccent.shade400,
                        title: 'Settings',
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      NewSettingTile(
                        onPress: () {
                          // Get.to(() => const FeedbackView());
                        },
                        leadingbackgroundColor: Colors.blueGrey.shade400,
                        iconData: Icons.question_mark,
                        iconColor: Colors.white,
                        title: 'FAQs',
                      ),

                      const SizedBox(height: 15),
                      NewSettingTile(
                        showRightArrow: false,
                        onPress: () {
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                    'Logout',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xff233853),
                                    ),
                                  ),
                                  content: Text(
                                    'Are you sure you want to logout?',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xff233853),
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text('Cancel'),
                                      onPressed: () {
                                        Get.back();
                                      },
                                    ),
                                    TextButton(
                                      child: Text(
                                        'Logout',
                                        style: TextStyle(
                                          color: Color(0xff233853),
                                        ),
                                      ),
                                      onPressed: () {
                                        // Add your logout logic here
                                        controller.box.remove('token');
                                        controller.box.remove('refreshToken');
                                        controller.box.remove('userData');
                                        controller.googleLogout();
                                        controller.authenticationController
                                            .userModel.value = UserModel();
                                        controller
                                            .authenticationController.userModel
                                            .refresh();
                                        Get.offAll(() => const LoginView());
                                      },
                                    ),
                                  ],
                                );
                              });
                        },
                        leadingbackgroundColor: const Color(0xffC5D7FF),
                        iconData: Icons.logout_rounded,
                        iconColor: Colors.blueGrey.shade400,
                        title: 'Logout',
                      ),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      // SettingTile(
                      //   onTap: () {
                      //     showModalBottomSheet(
                      //       context: context,
                      //       builder: (context) {
                      //         return Padding(
                      //           padding: const EdgeInsets.symmetric(
                      //               horizontal: 10.0),
                      //           child: SizedBox(
                      //             height: 300, // adjust height as needed
                      //             child: Column(
                      //               mainAxisAlignment: MainAxisAlignment.center,
                      //               children: [
                      //                 CustomTile(
                      //                   onTap: () {
                      //                     Get.back();
                      //                     Get.to(() => const AccountView());
                      //                   },
                      //                   title: 'Edit Profile',
                      //                   subTitle: 'Edit Personal Information',
                      //                 ),
                      //                 const SizedBox(
                      //                   height: 10,
                      //                 ),
                      //                 CustomTile(
                      //                   onTap: () {
                      //                     Get.back();
                      //                     Get.to(() => const EditEmailView());
                      //                   },
                      //                   title: 'Change Email',
                      //                   subTitle:
                      //                       'Change email to keep account secure',
                      //                 ),
                      //                 const SizedBox(
                      //                   height: 10,
                      //                 ),
                      //                 CustomTile(
                      //                   onTap: () {
                      //                     Get.back();
                      //                     Get.to(
                      //                         () => const UpdatePasswordView());
                      //                   },
                      //                   title: 'Change Password',
                      //                   subTitle:
                      //                       'Change password to keep account secure',
                      //                 ),
                      //               ],
                      //             ),
                      //           ),
                      //         );
                      //       },
                      //     );
                      //   },
                      //   title: 'Account',
                      //   subTitle: 'Privacy, security, change number',
                      // ),
                      // const SizedBox(
                      //   height: 5,
                      // ),
                      // SettingTile(
                      //   onTap: () {
                      //     showModalBottomSheet(
                      //       context: context,
                      //       builder: (context) {
                      //         return Padding(
                      //           padding: const EdgeInsets.symmetric(
                      //               horizontal: 10.0),
                      //           child: SizedBox(
                      //             height: 200, // adjust height as needed
                      //             child: Column(
                      //               mainAxisAlignment: MainAxisAlignment.center,
                      //               children: [
                      //                 CustomTile(
                      //                   onTap: () {
                      //                     Get.back();
                      //                     Get.to(() => const FriendsListView());
                      //                   },
                      //                   title: 'Friend List',
                      //                   subTitle: 'Add or View friends',
                      //                 ),
                      //                 // const SizedBox(
                      //                 //   height: 10,
                      //                 // ),
                      //                 // CustomTile(
                      //                 //   onTap: () {
                      //                 //     Get.back();
                      //                 //     Get.to(() => const MainMessageView());
                      //                 //   },
                      //                 //   title: 'Messages',
                      //                 //   subTitle:
                      //                 //       'Start or continue conversations.',
                      //                 // ),
                      //                 const SizedBox(
                      //                   height: 10,
                      //                 ),
                      //                 CustomTile(
                      //                   onTap: () {
                      //                     Get.back();
                      //                     Get.to(() => const BlockedUserView());
                      //                   },
                      //                   title: 'Blocked Users',
                      //                   subTitle:
                      //                       'View blocked or unblock users',
                      //                 ),
                      //               ],
                      //             ),
                      //           ),
                      //         );
                      //       },
                      //     );
                      //   },
                      //   image: 'assets/chat1x.png',
                      //   title: 'Chat',
                      //   subTitle: 'Chat history, theme, wallpapers',
                      // ),
                      // // const SizedBox(
                      // //   height: 5,
                      // // ),
                      // // SettingTile(
                      // //   onTap: () {
                      // //     showModalBottomSheet(
                      // //       context: context,
                      // //       builder: (context) {
                      // //         return Padding(
                      // //           padding:
                      // //               const EdgeInsets.symmetric(horizontal: 10.0),
                      // //           child: SizedBox(
                      // //             height: 200, // adjust height as needed
                      // //             child: Column(
                      // //               mainAxisAlignment: MainAxisAlignment.center,
                      // //               children: [
                      // //                 // CustomTile(
                      // //                 //   onTap: () {
                      // //                 //     Get.back();
                      // //                 //     Get.to(() => const SubscriptionsView());
                      // //                 //   },
                      // //                 //   title: 'Subscriptions',
                      // //                 //   subTitle: 'Add or View Subscriptions Plans',
                      // //                 // ),
                      // //                 // const SizedBox(
                      // //                 //   height: 10,
                      // //                 // ),
                      // //                 CustomTile(
                      // //                   onTap: () {
                      // //                     Get.back();
                      // //                     Get.to(() => const PaymentView());
                      // //                   },
                      // //                   title: 'Payments',
                      // //                   subTitle: 'Add, Edit or View Payments',
                      // //                 ),
                      // //                 const SizedBox(
                      // //                   height: 10,
                      // //                 ),
                      // //                 CustomTile(
                      // //                   onTap: () {
                      // //                     Get.back();
                      // //                     Get.to(() => const PurchaseView());
                      // //                   },
                      // //                   title: 'Purchases',
                      // //                   subTitle: 'Create or view old purchases',
                      // //                 ),
                      // //               ],
                      // //             ),
                      // //           ),
                      // //         );
                      // //       },
                      // //     );
                      // //     // Get.to(() => const SubscriptionsView());
                      // //   },
                      // //   image: 'assets/notification1x.png',
                      // //   title: 'Subscriptions',
                      // //   subTitle: 'Subscriptions, View Subscription',
                      // // ),
                      // // const SizedBox(
                      // //   height: 5,
                      // // ),
                      // // SettingTile(
                      // //   onTap: () {
                      // //     Get.to(() => const NotificationPage());
                      // //   },
                      // //   image: 'assets/notification1x.png',
                      // //   title: 'Notifications',
                      // //   subTitle: 'Messages, group and others',
                      // // ),
                      // const SizedBox(
                      //   height: 5,
                      // ),
                      // SettingTile(
                      //   onTap: () {
                      //     Get.to(() => const FeedbackView());
                      //   },
                      //   image: 'assets/help1x.png',
                      //   title: 'Feedback',
                      //   subTitle: 'Give feedback or suggestions',
                      // ),
                      // const SizedBox(
                      //   height: 5,
                      // ),
                      // SettingTile(
                      //   onTap: () {
                      //     Get.to(() => const DeleteAccountView());
                      //   },
                      //   title: 'Delete Account',
                      //   subTitle: 'Delete account permanently',
                      // ),
                      // // const SizedBox(
                      // //   height: 5,
                      // // ),
                      // // SettingTile(
                      // //   image: 'assets/storage1x.png',
                      // //   title: 'Storage and data',
                      // //   subTitle: 'Network usage, storage usage',
                      // // ),
                      // // const SizedBox(
                      // //   height: 5,
                      // // ),
                      // // SettingTile(
                      // //   onTap: () {
                      // //     Share.share('Invite Link');
                      // //   },
                      // //   image: 'assets/invite1x.png',
                      // //   title: 'Invite a friend',
                      // //   subTitle: '',
                      // // ),
                    ],
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
