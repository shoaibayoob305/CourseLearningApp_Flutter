import 'package:get/get.dart';

class SearchControllers extends GetxController {
  RxList courseList = [
    {'course': 'CompTIA CSIS', 'description': 'CompTIA CSIS description'},
    {'course': 'python', 'description': 'python description'},
    {'course': 'java', 'description': 'java description'},
    {'course': 'flutter', 'description': 'flutter description'},
  ].obs;

  RxBool searchStart = false.obs;
  RxList searchedList = [].obs;
}
