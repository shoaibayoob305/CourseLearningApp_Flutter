import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend/app/modules/account/views/verify_otp.dart';
import 'package:frontend/app/modules/authentication/controllers/authentication_controller.dart';
import 'package:frontend/app/modules/authentication/model/user_model.dart';
import 'package:frontend/app/modules/home/controllers/home_controller.dart';
import 'package:frontend/app/modules/home/views/home_bottomnavigation_view.dart';
import 'package:frontend/app/modules/setting/views/setting_view.dart';
import 'package:frontend/app/modules/welcome/views/welcome_view.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import '../../../utils/requests/api_endpoints.dart';
import '../../../utils/widgets/defaultsnackbar.dart';

class AccountController extends GetxController {
  final ImagePicker picker = ImagePicker();
  TextEditingController editNameController = TextEditingController();
  TextEditingController editFullNameController = TextEditingController();
  // TextEditingController editLastNameController = TextEditingController();
  TextEditingController editEmailController = TextEditingController();
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController newConfirmPasswordController = TextEditingController();
  TextEditingController editEmailPasswordController = TextEditingController();
  TextEditingController deleteAccountPasswordController =
      TextEditingController();
  AuthenticationController authenticationController =
      Get.put(AuthenticationController());
  HomeController homeController = Get.put(HomeController());
  RxBool editEmailPasswordEye = true.obs;
  RxBool updateCurrentPasswordEye = true.obs;
  RxBool updateNewPasswordEye = true.obs;
  RxBool updateNewConfirmPasswordEye = true.obs;
  RxBool editEmailValidator = true.obs;
  RxBool deletePasswordEye = true.obs;
  RxBool isLoading = false.obs;
  RxBool imageLoading = false.obs;
  final box = GetStorage();
  Rx<File?> image = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();
  TextEditingController pinController = TextEditingController();
  RxBool isEmail = false.obs;

  @override
  void onReady() {
    if (authenticationController.userModel.value.id != null) {
      editNameController.text =
          authenticationController.userModel.value.username!;
      editEmailController.text =
          authenticationController.userModel.value.email!;
      editFullNameController.text =
          '${authenticationController.userModel.value.firstName!} ${authenticationController.userModel.value.lastName!}';
    }
  }

  pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      image.value = File(pickedFile.path);
      updateProfileApi(image: image.value);
    } else {
      // User canceled the picker
      return null;
    }
  }

  pickImageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      image.value = File(pickedFile.path);
      updateProfileApi(image: image.value);
    } else {
      // User canceled the picker
      return null;
    }
  }

  // check pin code fields
  // Future<void> checkPinCodeApi() async {
  //   if (pinController.text.isEmpty || pinController.text.length < 4) {
  //     DefaultSnackbar.show('Error', 'Kindly enter pin to verify');
  //   } else {
  //     try {
  //       isLoading.value = true;
  //       String endpoint = baseUrl + verifyPinEmail;
  //       log('endpoint === $endpoint');
  //       Map<String, String> header = {
  //         'Content-Type': 'application/json',
  //       };
  //       var bodyData = {
  //         'email': signupEmailController.text,
  //         'code': pinController.text,
  //       };
  //       var response = await http.post(
  //         Uri.parse(endpoint),
  //         headers: header,
  //         body: json.encode(bodyData),
  //       );
  //       // log('endpoint === $header');
  //       // log('response === ${response.body}');
  //       // log('response === ${response.statusCode}');
  //       if (response.statusCode == 200) {
  //         log('response ${response.body}');
  //       } else if (response.statusCode == 400) {
  //         DefaultSnackbar.show('Error', 'This email already exists.');
  //       } else {
  //         DefaultSnackbar.show('Error', 'Something went wrong.');
  //       }
  //     } catch (e) {
  //       log('Error ${e.toString()}');
  //     } finally {
  //       isLoading.value = false;
  //     }
  //   }
  // }

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

  // update email endpoint
  Future<void> updateEmailApi() async {
    try {
      isLoading.value = true;
      String endpoint = baseUrl + editEmailEndpoint;
      log('endpoint === $endpoint');
      final token = box.read('token');
      Map<String, String> header = {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token',
      };
      var bodyData = {
        'new_email': editEmailController.text,
        'current_password': editEmailPasswordController.text,
      };
      var response = await http.post(
        Uri.parse(endpoint),
        headers: header,
        body: json.encode(bodyData),
      );
      log('endpoint === $bodyData');
      log('response === ${response.body}');
      log('response === ${response.statusCode}');
      if (response.statusCode == 204) {
        DefaultSnackbar.show('Success', 'Email updated Successfully');
        authenticationController.userModel.value.email =
            editEmailController.text;
        authenticationController.userModel.refresh();
        editEmailPasswordController.clear();
        homeController.selectedIndex.value = 3;
        Get.off(() => const HomeBottomNavigationView());
      } else {
        DefaultSnackbar.show('Error', 'Something went wrong');
      }
    } catch (e) {
      log('Error ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  // delete user image update user profile
  Future<void> deleteImageUpdateProfile() async {
    try {
      isLoading.value = true;
      imageLoading.value = true;
      String endpoint = baseUrl + loginEndpoint;
      log('endpoint === $endpoint');
      final token = box.read('token');
      Map<String, String> names = splitFullName(editFullNameController.text);
      Map<String, String> header = {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token',
      };
      var bodyData = {
        'username': editNameController.text,
        'first_name': names['firstName'] ?? '',
        'last_name': names['lastName'] ?? '',
        'image': null,
      };
      var response = await http.patch(
        Uri.parse(endpoint),
        headers: header,
        body: json.encode(bodyData),
      );
      log('endpoint === $bodyData');
      log('response === ${response.body}');
      log('response === ${response.statusCode}');
      if (response.statusCode == 200) {
        authenticationController.userModel.value.firstName =
            names['firstName'] ?? '';
        authenticationController.userModel.value.lastName =
            names['lastName'] ?? '';
        authenticationController.userModel.value.username =
            editNameController.text;
        authenticationController.userModel.value.image = null;
        authenticationController.userModel.refresh();
        DefaultSnackbar.show(
            'Success', 'Personal Information updated Successfully');
        homeController.selectedIndex.value = 3;
        Get.off(() => const HomeBottomNavigationView());
      } else {
        DefaultSnackbar.show('Error', 'Something went wrong');
      }
    } catch (e) {
      log('Error ${e.toString()}');
    } finally {
      isLoading.value = false;
      imageLoading.value = true;
    }
  }

  // update User Profile endpoint
  Future<void> updateProfileApi({File? image}) async {
    if (editFullNameController.text.isEmpty) {
      DefaultSnackbar.show('Error', 'Enter Full Name');
    }
    if (image == null) {
      try {
        isLoading.value = true;
        String endpoint = baseUrl + loginEndpoint;
        log('endpoint === $endpoint');
        final token = box.read('token');
        Map<String, String> names = splitFullName(editFullNameController.text);
        Map<String, String> header = {
          'Content-Type': 'application/json',
          'authorization': 'Bearer $token',
        };
        var bodyData = {
          'username': editNameController.text,
          'first_name': names['firstName'] ?? '',
          'last_name': names['lastName'] ?? '',
        };
        var response = await http.patch(
          Uri.parse(endpoint),
          headers: header,
          body: json.encode(bodyData),
        );
        log('endpoint === $bodyData');
        log('response === ${response.body}');
        log('response === ${response.statusCode}');
        if (response.statusCode == 200) {
          authenticationController.userModel.value.firstName =
              names['firstName'] ?? '';
          authenticationController.userModel.value.lastName =
              names['lastName'] ?? '';
          authenticationController.userModel.value.username =
              editNameController.text;
          authenticationController.userModel.refresh();
          DefaultSnackbar.show(
              'Success', 'Personal Information updated Successfully');
          homeController.selectedIndex.value = 3;
          Get.off(() => const HomeBottomNavigationView());
        } else {
          DefaultSnackbar.show('Error', 'Something went wrong');
        }
      } catch (e) {
        log('Error ${e.toString()}');
      } finally {
        isLoading.value = false;
      }
    } else {
      try {
        isLoading.value = true;
        imageLoading.value = true;
        String endpoint = baseUrl + loginEndpoint;
        log('endpoint === $endpoint');
        final token = box.read('token');
        Map<String, String> names = splitFullName(editFullNameController.text);
        Map<String, String> header = {
          'Content-Type': 'application/json',
          'authorization': 'Bearer $token',
        };
        final request = http.MultipartRequest(
          'PATCH',
          Uri.parse(endpoint),
        );

        //headers for request
        request.headers.addAll(header);

        // Add the username field
        request.fields['first_name'] = editNameController.text;
        request.fields['username'] = names['firstName'] ?? '';
        request.fields['last_name'] = names['lastName'] ?? '';

        // Add the image file
        final mimeTypeData =
            lookupMimeType(image!.path, headerBytes: [0xFF, 0xD8])?.split('/');
        final file = await http.MultipartFile.fromPath(
          'image',
          image.path,
          contentType: MediaType(mimeTypeData![0], mimeTypeData[1]),
        );
        request.files.add(file);
        // Send the request
        final response = await request.send();
        if (response.statusCode == 200) {
          final responseBody = await response.stream.bytesToString();
          final decodedResponse = json.decode(responseBody);
          log('response body === $decodedResponse');
          authenticationController.userModel.value.image =
              decodedResponse['image'];
          authenticationController.userModel.refresh();
          isLoading.value = false;
          imageLoading.value = false;
          DefaultSnackbar.show(
              'Success', 'Personal Information updated Successfully');
          homeController.selectedIndex.value = 3;
          Get.off(() => const HomeBottomNavigationView());
        } else {
          DefaultSnackbar.show('Error',
              'Image upload failed with status: ${response.statusCode}');
          print('Image upload failed with status: ${response.statusCode}');
        }
      } catch (e) {
        log('Error ${e.toString()}');
      } finally {
        isLoading.value = false;
        imageLoading.value = false;
      }
    }
  }

  Future<void> sendEmailCode() async {
    if (!isEmail.value) {
      if (editEmailController.text.isEmpty) {
        DefaultSnackbar.show('Error', 'Enter Email');
      } else if (editEmailPasswordController.text.isEmpty) {
        DefaultSnackbar.show('Error', 'Enter Password to update email');
      } else if (editEmailValidator.isFalse) {
        DefaultSnackbar.show('Error', 'Enter Valid Email');
      } else {
        emailCodeSend();
      }
    } else {
      if (currentPasswordController.text.isEmpty) {
        DefaultSnackbar.show('Error', 'Enter Current Password');
      } else if (newPasswordController.text.isEmpty) {
        DefaultSnackbar.show('Error', 'Enter New Password');
      } else if (newConfirmPasswordController.text.isEmpty) {
        DefaultSnackbar.show('Error', 'Enter Confirm Password');
      } else if (currentPasswordController.text == newPasswordController.text) {
        DefaultSnackbar.show(
            'Error', 'Current password and new password can\'t be same');
      } else if (newPasswordController.text !=
          newConfirmPasswordController.text) {
        DefaultSnackbar.show(
            'Error', 'New password and confirm password should be same');
      } else {
        emailCodeSend();
      }
    }
  }

  // update Password endpoint
  Future<void> emailCodeSend() async {
    try {
      String endpoint = baseUrl + resendEmailEndpoint;
      log('endpoint === $endpoint');
      final token = box.read('token');
      Map<String, String> header = {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token',
      };
      var bodyData = {
        'receiver_email': !isEmail.value
            ? editEmailController.text
            : authenticationController.userModel.value.email,
        'first_name': authenticationController.userModel.value.firstName,
        'skip_email_check': isEmail.value,
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
        Get.to(() => VerifyOtp());
      } else {
        DefaultSnackbar.show('Error', 'Something went wrong');
      }
    } catch (e) {
      log('Error ${e.toString()}');
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
          'email': !isEmail.value
              ? editEmailController.text
              : authenticationController.userModel.value.email,
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
          !isEmail.value ? updateEmailApi() : updatePasswordApi();
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

  // update Password endpoint
  Future<void> updatePasswordApi() async {
    try {
      String endpoint = baseUrl + updatePasswordEndpoint;
      log('endpoint === $endpoint');
      final token = box.read('token');
      Map<String, String> header = {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token',
      };
      var bodyData = {
        'current_password': currentPasswordController.text,
        'new_password': newPasswordController.text,
        're_new_password': newConfirmPasswordController.text,
      };
      var response = await http.post(
        Uri.parse(endpoint),
        headers: header,
        body: json.encode(bodyData),
      );
      log('endpoint === $bodyData');
      log('response === ${response.body}');
      log('response === ${response.statusCode}');
      if (response.statusCode == 204) {
        DefaultSnackbar.show('Success', 'Password updated Successfully');
        currentPasswordController.clear();
        newPasswordController.clear();
        newConfirmPasswordController.clear();
        homeController.selectedIndex.value = 3;
        Get.off(() => const HomeBottomNavigationView());
        // Get.off(() => const SettingView());
      } else {
        DefaultSnackbar.show('Error', 'Something went wrong');
      }
    } catch (e) {
      log('Error ${e.toString()}');
    }
  }

  // update email endpoint
  Future<void> deletePasswordApi() async {
    log('pressed');
    if (deleteAccountPasswordController.text.isEmpty) {
      DefaultSnackbar.show('Error', 'Enter Password for account deletion');
    } else {
      try {
        isLoading.value = true;
        String endpoint = baseUrl + loginEndpoint;
        log('endpoint === $endpoint');
        final token = box.read('token');
        Map<String, String> header = {
          'Content-Type': 'application/json',
          'authorization': 'Bearer $token',
        };
        var bodyData = {
          "current_password": deleteAccountPasswordController.text,
        };
        var response = await http.delete(
          Uri.parse(endpoint),
          headers: header,
          body: json.encode(bodyData),
        );
        log('endpoint === $bodyData');
        log('response === ${response.body}');
        log('response === ${response.statusCode}');
        if (response.statusCode == 204) {
          DefaultSnackbar.show('Success', 'Account deleted Successfully');
          deleteAccountPasswordController.clear();
          authenticationController.userModel.value = UserModel();
          authenticationController.userModel.refresh();
          Get.offAll(() => const HomeBottomNavigationView());
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
}
