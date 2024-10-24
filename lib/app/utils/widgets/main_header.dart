import 'package:flutter/material.dart';
import 'package:frontend/app/modules/authentication/controllers/authentication_controller.dart';
import 'package:frontend/app/modules/authentication/model/user_model.dart';
import 'package:frontend/app/modules/home/views/home_bottomnavigation_view.dart';
import 'package:frontend/app/modules/notification/controller/notification_controller.dart';
import 'package:frontend/app/modules/welcome/views/welcome_view.dart';
import 'package:get/get.dart';
import 'package:badges/badges.dart' as badges;

class MainHeader extends StatelessWidget {
  MainHeader({
    super.key,
    this.showAvatar = false,
    this.showBackArrow = true,
    this.title,
    this.icon,
    this.leadingTap,
    this.avatarTap,
    this.logoutIcon = false,
  });

  bool showAvatar;
  String? title;
  String? icon;
  bool? showBackArrow;
  bool? logoutIcon;
  void Function()? leadingTap;
  void Function()? avatarTap;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AuthenticationController());
    final notificationController = Get.put(NotificationController());
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        showBackArrow == true
            ? GestureDetector(
                onTap: leadingTap,
                child: Image(
                  image: AssetImage(icon ?? 'assets/back.png'),
                ),
              )
            : const SizedBox.shrink(),
        Text(
          title ?? '',
          style: const TextStyle(
              fontSize: 20,
              color: Color(0xffFFFFFF),
              fontWeight: FontWeight.w500),
        ),
        showAvatar
            ? GestureDetector(
                onTap: avatarTap,
                child: badges.Badge(
                  badgeStyle: const badges.BadgeStyle(
                    badgeColor: Colors.red,
                    elevation: 0,
                    padding: EdgeInsets.all(5),
                  ),
                  badgeContent: Text(
                    '${notificationController.unreadNotificationsCount}',
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  child: CircleAvatar(
                    backgroundColor: Colors.grey.shade800,
                    radius: 20,
                    child: const ClipOval(
                      child: Icon(Icons.notifications),
                    ),
                  ),
                ),
              )
            : logoutIcon!
                ? GestureDetector(
                    onTap: () {
                      controller.box.remove('token');
                      controller.box.remove('refreshToken');
                      controller.userModel.value = UserModel();
                      controller.userModel.refresh();
                      Get.offAll(() => const HomeBottomNavigationView());
                    },
                    child: const Icon(
                      Icons.logout,
                      color: Colors.white,
                    ))
                : const SizedBox.shrink(),
      ],
    );
  }
}
