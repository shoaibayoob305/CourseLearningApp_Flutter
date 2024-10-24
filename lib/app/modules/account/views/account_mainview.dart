import 'package:flutter/material.dart';
import 'package:frontend/app/modules/account/views/account_view.dart';
import 'package:frontend/app/modules/account/views/delete_account_view.dart';
import 'package:frontend/app/modules/account/views/editemail_view.dart';
import 'package:frontend/app/modules/account/views/update_password_view.dart';
import 'package:frontend/app/utils/widgets/new_setting_tile.dart';
import 'package:get/get.dart';

class AccountMainview extends StatelessWidget {
  const AccountMainview({super.key});

  @override
  Widget build(BuildContext context) {
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
        surfaceTintColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            NewSettingTile(
              onPress: () {
                Get.to(() => const AccountView());
              },
              leadingbackgroundColor: Colors.grey.shade200,
              iconData: Icons.edit,
              title: 'Edit Personal',
            ),
            const SizedBox(
              height: 15,
            ),
            NewSettingTile(
              onPress: () {
                Get.to(() => const EditEmailView());
              },
              leadingbackgroundColor: Colors.grey.shade200,
              iconData: Icons.mail,
              title: 'Edit Email',
            ),
            const SizedBox(
              height: 15,
            ),
            NewSettingTile(
              onPress: () {
                Get.to(() => const UpdatePasswordView());
              },
              leadingbackgroundColor: Colors.grey.shade200,
              iconData: Icons.lock,
              title: 'Change Password',
            ),
            const SizedBox(
              height: 15,
            ),
            NewSettingTile(
              onPress: () {
                Get.to(() => const DeleteAccountView());
              },
              leadingbackgroundColor: Colors.grey.shade200,
              iconColor: Colors.red,
              iconData: Icons.delete,
              title: 'Delete Account',
            ),
          ],
        ),
      ),
    );
  }
}
