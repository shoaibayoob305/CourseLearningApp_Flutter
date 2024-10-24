import 'dart:developer';

import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class WelcomeController extends GetxController {
  static WelcomeController get instance => Get.find();

  // google sign in method
  Future<void> handleSignIn() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await GoogleSignIn().signIn();
      if (googleSignInAccount != null) {
        // Signed in successfully, now authenticate further with api or whatever
      } else {
        // User cancelled the sign-in process
      }
    } catch (error) {
      log('Error signing in with Google: $error');
    }
  }
}
