import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/app/modules/authentication/views/login_view.dart';
import 'package:frontend/app/modules/course/views/course_view.dart';
import 'package:frontend/app/modules/home/controllers/home_controller.dart';
import 'package:frontend/app/modules/message/views/main_message_view.dart';
import 'package:frontend/app/modules/setting/views/setting_view.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

import '../../mycourses/view/mycourses_tab.dart';

class HomeBottomNavigationView extends StatelessWidget {
  const HomeBottomNavigationView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    final PersistentTabController _navController = PersistentTabController(
      initialIndex: controller.selectedIndex.value,
    ); // Persistent Tab Controller

    // List of views for each tab
    List<Widget> _buildScreens() {
      return [
        const CourseView(),
        const MycoursesTab(),
        const MainMessageView(),
        const SettingView(),
      ];
    }

    // Bottom Nav Bar Items
    List<PersistentBottomNavBarItem> _navBarItems() {
      return [
        PersistentBottomNavBarItem(
          icon: SvgPicture.asset('assets/navbaricons/homenavbar.svg'),
          inactiveIcon:
              SvgPicture.asset('assets/navbaricons/inactivehomenavbar.svg'),
          title: 'Home',
          textStyle: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: Color.fromRGBO(34, 55, 82, 1),
          ),
          activeColorPrimary: const Color.fromRGBO(210, 227, 249, 0.2),
          activeColorSecondary: const Color.fromRGBO(34, 55, 82, 1),
          inactiveColorPrimary: const Color.fromRGBO(151, 151, 151, 1),
          inactiveColorSecondary: const Color.fromRGBO(151, 151, 151, 1),
        ),
        PersistentBottomNavBarItem(
          icon: SvgPicture.asset('assets/navbaricons/mycoursesnavbar.svg'),
          inactiveIcon: SvgPicture.asset(
              'assets/navbaricons/inactivemycoursesnavbar.svg'),
          title: 'My Courses',
          textStyle: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: Color.fromRGBO(34, 55, 82, 1),
          ),
          activeColorPrimary: const Color.fromRGBO(210, 227, 249, 0.2),
          activeColorSecondary: const Color.fromRGBO(34, 55, 82, 1),
          inactiveColorPrimary: const Color.fromRGBO(151, 151, 151, 1),
          inactiveColorSecondary: const Color.fromRGBO(151, 151, 151, 1),
        ),
        PersistentBottomNavBarItem(
          icon: SvgPicture.asset('assets/navbaricons/chatsnavbar.svg'),
          inactiveIcon:
              SvgPicture.asset('assets/navbaricons/inactivechatsnavbar.svg'),
          title: 'Chats',
          textStyle: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: Color.fromRGBO(34, 55, 82, 1),
          ),
          activeColorPrimary: const Color.fromRGBO(210, 227, 249, 0.2),
          activeColorSecondary: const Color.fromRGBO(34, 55, 82, 1),
          inactiveColorPrimary: const Color.fromRGBO(151, 151, 151, 1),
          inactiveColorSecondary: const Color.fromRGBO(151, 151, 151, 1),
        ),
        PersistentBottomNavBarItem(
          icon: SvgPicture.asset('assets/navbaricons/accountnavbar.svg'),
          inactiveIcon:
              SvgPicture.asset('assets/navbaricons/inactiveaccountnavbar.svg'),
          title: 'My Account',
          textStyle: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: Color.fromRGBO(34, 55, 82, 1),
          ),
          activeColorPrimary: const Color.fromRGBO(210, 227, 249, 0.2),
          activeColorSecondary: const Color.fromRGBO(34, 55, 82, 1),
          inactiveColorPrimary: const Color.fromRGBO(151, 151, 151, 1),
          inactiveColorSecondary: const Color.fromRGBO(151, 151, 151, 1),
        ),
      ];
    }

    return WillPopScope(
      onWillPop: () async {
        if (controller.selectedIndex.value != 0) {
          controller.selectedIndex.value = 0;
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        body: Obx(
          () {
            switch (controller.selectedIndex.value) {
              // case 0:
              //   return const HomeView();
              case 0:
                return const CourseView();
              case 1:
                return const MycoursesTab();
              case 2:
                return const MainMessageView();
              case 3:
                return const SettingView();
              default:
                return const CourseView();
            }
          },
        ),
        bottomNavigationBar: Obx(() {
          if (controller.authenticationController.userModel.value.id != null) {
            return PersistentTabView(
              context,
              controller: _navController, // Use the persistent controller
              screens: _buildScreens(),
              items: _navBarItems(),
              navBarStyle: NavBarStyle.style1, // Pick your preferred nav style
              onItemSelected: (index) {
                controller.changeIndex(index);
              },
            );
          } else {
            return Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: GestureDetector(
                    onTap: () {
                      Get.to(() => const LoginView());
                    },
                    child: Container(
                      width: Get.width,
                      height: 56,
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(34, 55, 82, 1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: controller.isLoading.value
                            ? LoadingAnimationWidget.waveDots(
                                color: Colors.white, size: 40)
                            : const Text(
                                "Login",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
        }),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   final controller = Get.put(HomeController());
  //   return WillPopScope(
  //     onWillPop: () async {
  //       if (controller.selectedIndex.value != 0) {
  //         // If not on the Home screen, navigate to the Home screen
  //         controller.selectedIndex.value = 0;
  //         return false; // Prevent the default back button action
  //       } else {
  //         return true; // Allow the back button to close the app
  //       }
  //     },
  //     child: Scaffold(
  //       body: Obx(() {
  //         switch (controller.selectedIndex.value) {
  //           // case 0:
  //           //   return const HomeView();
  //           case 0:
  //             return const CourseView();
  //           case 1:
  //             return const MycoursesTab();
  //           case 2:
  //             return const MainMessageView();
  //           case 3:
  //             return const SettingView();
  //           default:
  //             return const CourseView();
  //         }
  //       }),
  //       bottomNavigationBar: Obx(
  //         () => controller.authenticationController.userModel.value.id != null
  //             ? BottomNavigationBar(
  //                 selectedItemColor: const Color(0xff233853),
  //                 type: BottomNavigationBarType.fixed,
  //                 currentIndex: controller.selectedIndex.value,
  //                 onTap: (index) {
  //                   controller.changeIndex(index);
  //                   // if (index != 2) {
  //                   //   controller.changeIndex(index);
  //                   // }
  //                 },
  //                 items: const [
  //                   // BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
  //                   BottomNavigationBarItem(
  //                       icon: Icon(Icons.home), label: 'Home'),
  //                   BottomNavigationBarItem(
  //                       icon: Icon(Icons.menu_book_outlined), label: 'Courses'),
  //                   BottomNavigationBarItem(
  //                       icon: Icon(Icons.message_sharp), label: 'Chat'),
  //                   BottomNavigationBarItem(
  //                       icon: Icon(Icons.person), label: 'Account'),
  //                 ],
  //               )
  //             : Padding(
  //                 padding: const EdgeInsets.all(16.0),
  //                 child: SizedBox(
  //                   width: double.infinity,
  //                   height: 50,
  //                   child: GestureDetector(
  //                     onTap: controller.authenticationController.userModel.value
  //                                 .id !=
  //                             null
  //                         ? () {}
  //                         : () {
  //                             Get.to(() => const LoginView());
  //                           },
  //                     child: Container(
  //                       width: Get.width,
  //                       height: 50,
  //                       decoration: BoxDecoration(
  //                           color: const Color(0xff233853),
  //                           borderRadius: BorderRadius.circular(100)),
  //                       child: Center(
  //                         child: controller.isLoading.value
  //                             ? LoadingAnimationWidget.waveDots(
  //                                 color: Colors.white, size: 40)
  //                             : const Text(
  //                                 "Login",
  //                                 style: TextStyle(
  //                                   fontSize: 14,
  //                                   fontWeight: FontWeight.w400,
  //                                   color: Colors.white,
  //                                 ),
  //                               ),
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //       ),
  //     ),
  //   );

  // }
}
