import 'package:flutter/material.dart';
import 'package:frontend/app/modules/setting/controllers/settings_controller.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRCodeScanner extends StatelessWidget {
  const QRCodeScanner({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SettingsController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code Scanner'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: QRView(
              key: controller.qrKey,
              onQRViewCreated: controller.onQRViewCreated,
            ),
          ),
          const Expanded(
            flex: 1,
            child: Center(
              child: Text('Scan a QR code'),
            ),
          ),
        ],
      ),
    );
  }
}
