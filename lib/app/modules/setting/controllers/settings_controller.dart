import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:frontend/app/modules/authentication/controllers/authentication_controller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class SettingsController extends GetxController {
  late QRViewController qrController;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  AuthenticationController authenticationController =
      Get.put(AuthenticationController());
  final box = GetStorage();

  @override
  void dispose() {
    qrController.dispose();
    super.dispose();
  }

  void googleLogout() async {
    await GoogleSignIn().signOut();
  }

  void onQRViewCreated(QRViewController controller) {
    qrController = controller;
    qrController.scannedDataStream.listen(
      (scanData) {
        log('Scanned data: ${scanData.code}');
        // Handle the scanned data as desired
      },
    );
  }
}
