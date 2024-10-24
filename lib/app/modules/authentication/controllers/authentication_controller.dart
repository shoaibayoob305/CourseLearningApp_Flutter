import 'dart:convert';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:frontend/app/modules/authentication/model/additional_usermodel.dart';
import 'package:frontend/app/modules/authentication/model/user_model.dart';
import 'package:frontend/app/modules/authentication/views/verification_screen.dart';
import 'package:frontend/app/modules/course/views/course_view.dart';
import 'package:frontend/app/modules/home/views/home_bottomnavigation_view.dart';
import 'package:frontend/app/modules/home/views/home_view.dart';
import 'package:frontend/app/utils/requests/api_endpoints.dart';
import 'package:frontend/app/utils/widgets/defaultsnackbar.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

import '../views/login_view.dart';

class AuthenticationController extends GetxController {
  TextEditingController loginEmailController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();
  TextEditingController forgotEmailController = TextEditingController();
  TextEditingController signupNameController = TextEditingController();
  TextEditingController signupEmailController = TextEditingController();
  TextEditingController signupPasswordController = TextEditingController();
  TextEditingController signupFullNameController = TextEditingController();
  TextEditingController signupConfirmPasswordController =
      TextEditingController();
  TextEditingController pinController = TextEditingController();
  RxBool loginObsecureText = true.obs;
  RxBool signupPasswordObsecureText = true.obs;
  RxBool signupConfirmPasswordObsecureText = true.obs;
  RxBool signupEmailValidator = true.obs;
  RxBool loginEmailValidator = true.obs;
  RxBool forgotEmailValidator = true.obs;
  Rx<UserModel> userModel = UserModel().obs;
  Rx<AdditionalUserData> additionalUserModel = AdditionalUserData().obs;
  final box = GetStorage();
  final Connectivity _connectivity = Connectivity();
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void _updateConnectionStatus(ConnectivityResult connectivityResult) {
    if (connectivityResult == ConnectivityResult.none) {
      Get.rawSnackbar(
          messageText: const Text('PLEASE CONNECT TO THE INTERNET',
              style: TextStyle(color: Colors.white, fontSize: 14)),
          isDismissible: false,
          duration: const Duration(days: 1),
          backgroundColor: Colors.grey,
          icon: const Icon(
            Icons.wifi_off,
            color: Colors.white,
            size: 35,
          ),
          margin: const EdgeInsets.all(10.0),
          snackStyle: SnackStyle.GROUNDED);
    } else {
      if (Get.isSnackbarOpen) {
        Get.closeCurrentSnackbar();
      }
    }
  }

  // google sign in method
  Future<void> handleSignIn() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await GoogleSignIn().signIn();
      if (googleSignInAccount != null) {
        // Signed in successfully, now authenticate further with api or whatever
        final GoogleSignInAuthentication authentication =
            await googleSignInAccount.authentication;
        final idToken = authentication.idToken;
        // log('response from google id login $authentication');
        log('response from google id login $idToken');
        log('response from google login $googleSignInAccount');
        // log('response from google access login $accessToken');
        googleApi(
          googleSignInAccount.displayName!,
          googleSignInAccount.email,
          googleSignInAccount.photoUrl!,
          idToken!,
        );
      } else {
        // User cancelled the sign-in process
      }
    } catch (error) {
      log('Error signing in with Google: $error');
    }
  }

  // signup endpoint
  Future<void> forgotPasswordApi() async {
    log('pressed');
    if (forgotEmailController.text.isEmpty) {
      DefaultSnackbar.show('Error', 'Enter Email');
    } else if (forgotEmailValidator.isFalse) {
      DefaultSnackbar.show('Error', 'Enter Valid Email');
    } else {
      try {
        isLoading.value = true;
        String endpoint = baseUrl + forgotEndpoint;
        log('endpoint === $endpoint');
        Map<String, String> header = {
          'Content-Type': 'application/json',
        };
        var bodyData = {
          'receiver_email': forgotEmailController.text,
        };
        var response = await http.post(
          Uri.parse(endpoint),
          headers: header,
          body: json.encode(bodyData),
        );
        log('endpoint === $bodyData');
        log('response === ${response.body}');
        log('response === ${response.statusCode}');
        if (response.statusCode == 200) {
          DefaultSnackbar.show('Success', 'Email sent successfully');
          forgotEmailController.clear();
          isLoading.value = false;
          Get.off(() => const LoginView());
        } else {
          DefaultSnackbar.show('Error', 'Something went wrong');
        }
      } catch (e) {
        log('Error ${e.toString()}');
      } finally {
        isLoading.value = false;
      }
    }
  }

  // to take out first name and last name
  Map<String, String> splitFullName(String fullName) {
    List<String> nameParts = fullName.split(' ');
    String firstName = '';
    String lastName = '';
    if (nameParts.isNotEmpty) {
      firstName = nameParts[0];
    }
    if (nameParts.length > 1) {
      lastName = nameParts.sublist(1).join(' ');
    }
    return {'firstName': firstName, 'lastName': lastName};
  }

  // auth editable fields
  Future<void> sendVerificationEmailApi() async {
    if (signupFullNameController.text.isEmpty) {
      DefaultSnackbar.show('Error', 'Enter Full Name');
    } else if (signupEmailValidator.isFalse) {
      DefaultSnackbar.show('Error', 'Enter Valid Email');
    } else if (signupPasswordController.text !=
        signupConfirmPasswordController.text) {
      DefaultSnackbar.show('Error', 'Passwords do not match');
    } else {
      try {
        isLoading.value = true;
        String endpoint = baseUrl + sendVerificationEmail;
        log('endpoint === $endpoint');
        Map<String, String> names =
            splitFullName(signupFullNameController.text);
        Map<String, String> header = {
          'Content-Type': 'application/json',
        };
        var bodyData = {
          'receiver_email': signupEmailController.text,
          'first_name': names['firstName'] ?? ''
        };
        var response = await http.post(
          Uri.parse(endpoint),
          headers: header,
          body: json.encode(bodyData),
        );
        log('endpoint === $header');
        log('response === ${response.body}');
        log('response === ${response.statusCode}');
        if (response.statusCode == 200) {
          DefaultSnackbar.show('Success', 'Check Your Email');
          Get.to(() => VerificationScreen());
        } else if (response.statusCode == 400) {
          DefaultSnackbar.show('Error', 'This email already exists.');
        } else {
          DefaultSnackbar.show('Error', 'Something went wrong.');
        }
      } catch (e) {
        log('Error ${e.toString()}');
      } finally {
        isLoading.value = false;
      }
    }
  }

  // check pin code fields
  Future<void> checkPinCodeApi() async {
    if (pinController.text.isEmpty || pinController.text.length < 4) {
      DefaultSnackbar.show('Error', 'Kindly enter pin to verify');
    } else {
      try {
        isLoading.value = true;
        String endpoint = baseUrl + verifyPinEmail;
        log('endpoint === $endpoint');
        Map<String, String> header = {
          'Content-Type': 'application/json',
        };
        var bodyData = {
          'email': signupEmailController.text,
          'code': pinController.text,
        };
        var response = await http.post(
          Uri.parse(endpoint),
          headers: header,
          body: json.encode(bodyData),
        );
        // log('endpoint === $header');
        // log('response === ${response.body}');
        // log('response === ${response.statusCode}');
        if (response.statusCode == 200) {
          log('response ${response.body}');
          signupApi();
        } else if (response.statusCode == 400) {
          DefaultSnackbar.show('Error', 'This email already exists.');
        } else {
          DefaultSnackbar.show('Error', 'Something went wrong.');
        }
      } catch (e) {
        log('Error ${e.toString()}');
      } finally {
        isLoading.value = false;
      }
    }
  }

  // check pin code fields
  Future<void> confirmSignedUpApi(String email, String firstName) async {
    try {
      isLoading.value = true;
      String endpoint = baseUrl + accountSignedUpEndpoint;
      log('endpoint === $endpoint');
      Map<String, String> header = {
        'Content-Type': 'application/json',
      };
      var bodyData = {
        'receiver_email': email,
        'firstname': firstName,
      };
      var response = await http.post(
        Uri.parse(endpoint),
        headers: header,
        body: json.encode(bodyData),
      );
      log('response of send === $bodyData');
      log('response of send === ${response.body}');
      log('response of send === ${response.statusCode}');
      if (response.statusCode == 200) {
        log('response ${response.body}');
      } else {
        DefaultSnackbar.show('Error', 'Something went wrong.');
      }
    } catch (e) {
      log('Error ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  // signup endpoint
  Future<void> signupApi() async {
    log('pressed');

    try {
      isLoading.value = true;
      String endpoint = baseUrl + signupEndpoint;
      log('endpoint === $endpoint');
      Map<String, String> names = splitFullName(signupFullNameController.text);
      var bodyData = {
        'first_name': names['firstName'] ?? '',
        'last_name': names['lastName'] ?? '',
        'email': signupEmailController.text,
        'password': signupPasswordController.text,
      };
      var response = await http.post(Uri.parse(endpoint), body: bodyData);
      log('signup endpoint === $bodyData');
      log('response === ${response.body}');
      log('response === ${response.statusCode}');
      if (response.statusCode == 201) {
        await confirmSignedUpApi(
            signupEmailController.text, names['firstName'] ?? '');
        await loginApi(isSignUp: true);
        // isLoading.value = false;
        // signupFullNameController.clear();
        // signupEmailController.clear();
        // signupPasswordController.clear();
        // signupConfirmPasswordController.clear();
        // Get.off(() => const LoginView());
      } else {
        DefaultSnackbar.show('Error', 'Something went wrong');
      }
    } catch (e) {
      log('Error ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  // login endpoint
  Future<void> loginApi({bool? isSignUp}) async {
    if (isSignUp == false && loginEmailValidator.isFalse) {
      DefaultSnackbar.show('Error', 'Enter Valid Email');
    } else if (isSignUp == false && loginPasswordController.text.isEmpty) {
      DefaultSnackbar.show('Error', 'Enter Password');
    } else {
      try {
        isLoading.value = true;
        String endpoint = baseUrl + createTokenEndpoint;
        log('endpoint === $endpoint');
        var bodyData = {
          'email': isSignUp == true
              ? signupEmailController.text
              : loginEmailController.text,
          'password': isSignUp == true
              ? signupPasswordController.text
              : loginPasswordController.text,
        };
        var response = await http.post(Uri.parse(endpoint), body: bodyData);
        log('endpoint === $bodyData');
        log('response === ${response.statusCode}');
        if (response.statusCode == 200) {
          var decodeResponse = json.decode(response.body);
          if (isSignUp == true) {
            signupFullNameController.clear();
            signupEmailController.clear();
            signupPasswordController.clear();
            signupConfirmPasswordController.clear();
            pinController.clear();
            signupPasswordObsecureText.value = true;
            signupConfirmPasswordObsecureText.value = true;
          }
          log('response === $decodeResponse');
          box.write('token', decodeResponse['access']);
          box.write('refreshToken', decodeResponse['refresh']);
          getAdditionalUserData();
          getUserData();
          isLoading.value = false;
          // DefaultSnackbar.show('Success', 'Logged in Successfully');
          loginEmailController.clear();
          loginPasswordController.clear();
          loginObsecureText.value = true;
        } else {
          DefaultSnackbar.show('Error', 'Something went wrong.');
        }
      } catch (e) {
        log('Error ${e.toString()}');
      } finally {
        isLoading.value = false;
      }
    }
  }

  // auth editable fields
  Future<void> getUserData() async {
    try {
      String endpoint = baseUrl + loginEndpoint;
      log('endpoint === $endpoint');
      final token = box.read('token');
      Map<String, String> header = {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token',
      };
      var response = await http.get(
        Uri.parse(endpoint),
        headers: header,
      );
      log('endpoint === $header');
      log('response === ${response.body}');
      log('response === ${response.statusCode}');
      if (response.statusCode == 200) {
        box.write('userData', response.body);
        UserModel user = UserModel.fromJson(json.decode(response.body));
        userModel.value = user;
        Get.offAll(() => const HomeBottomNavigationView());
      } else {
        DefaultSnackbar.show('Error', 'Something went wrong.');
      }
    } catch (e) {
      log('Error ${e.toString()}');
    }
  }

  // for google apis
  Future<void> googleApi(
    String displayName,
    String email,
    String photoUrl,
    String idToken,
  ) async {
    try {
      isLoading.value = true;
      String endpoint = baseUrl + googleEndpoint;
      log('endpoint === $endpoint');
      final token = box.read('token');
      Map<String, String> header = {
        'Content-Type': 'application/json',
      };
      final bodyData = {
        'displayName': displayName,
        'email': email,
        'photoUrl': photoUrl,
        'idToken': idToken,
      };
      var response = await http.post(
        Uri.parse(endpoint),
        headers: header,
        body: json.encode(bodyData),
      );
      log('endpoint === $header');
      log('endpoint body === $bodyData');
      log('google response === ${response.body}');
      log('google response === ${response.statusCode}');
      if (response.statusCode == 200) {
        var decodeResponse = json.decode(response.body);
        log('response === $decodeResponse');
        box.write('token', decodeResponse['access']);
        box.write('refreshToken', decodeResponse['refresh']);
        getAdditionalUserData();
        getUserData();
        isLoading.value = false;
        // DefaultSnackbar.show('Success', 'Logged in Successfully');
      } else {
        DefaultSnackbar.show('Error', 'Something went wrong.');
      }
    } catch (e) {
      log('Error ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  // user additional fields
  Future<void> getAdditionalUserData() async {
    try {
      String endpoint = baseUrl + userDataEndpoint;
      log('endpoint === $endpoint');
      final token = box.read('token');
      Map<String, String> header = {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token',
      };
      var response = await http.get(
        Uri.parse(endpoint),
        headers: header,
      );
      log('endpoint === $header');
      log('response === ${response.body}');
      log('Additional response === ${response.statusCode}');
      if (response.statusCode == 200) {
        AdditionalUserData user =
            AdditionalUserData.fromJson(json.decode(response.body));
        additionalUserModel.value = user;
        // Get.offAll(() => const HomeView());
      } else {
        DefaultSnackbar.show('Error', 'Something went wrong.');
      }
    } catch (e) {
      log('Error ${e.toString()}');
    }
  }

  Future<void> verifyToken() async {
    try {
      String endpoint = baseUrl + verifyTokenEndpoint;
      log('endpoint === $endpoint');
      final token = box.read('token');
      Map<String, String> bodyData = {
        'token': '$token',
      };
      var response = await http.post(Uri.parse(endpoint), body: bodyData);
      log('endpoint === $bodyData');
      log('response === ${response.body}');
      log('response === ${response.statusCode}');
      if (response.statusCode == 200) {
        getAdditionalUserData();
        getUserData();
      } else {
        DefaultSnackbar.show('Error', 'Refreshing Token...');
        refreshToken();
      }
    } catch (e) {
      log('Error ${e.toString()}');
    }
  }

  Future<void> refreshToken() async {
    try {
      String endpoint = baseUrl + refreshTokenEndpoint;
      log('endpoint === $endpoint');
      final token = box.read('refreshToken');
      Map<String, String> bodyData = {
        'refresh': token,
      };
      var response = await http.post(Uri.parse(endpoint), body: bodyData);
      log('endpoint === $bodyData');
      log('response === ${response.body}');
      log('response === ${response.statusCode}');
      if (response.statusCode == 200) {
        var decodeResponse = json.decode(response.body);
        box.write('token', decodeResponse['access']);
        getAdditionalUserData();
        getUserData();
      } else {
        DefaultSnackbar.show('Error', 'Something went wrong.');
      }
    } catch (e) {
      log('Error ${e.toString()}');
    }
  }
}
