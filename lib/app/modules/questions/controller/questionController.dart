import 'dart:convert';
import 'dart:developer';

import 'package:frontend/app/modules/authentication/controllers/authentication_controller.dart';
import 'package:frontend/app/modules/course/views/gptconfig_courses.dart';
import 'package:frontend/app/modules/friends/view/friends_mainview.dart';
import 'package:frontend/app/modules/questions/model/questionmodel.dart';
import 'package:frontend/app/modules/questions/model/response_question_model.dart';
import 'package:frontend/app/modules/questions/view/apiquestion_view.dart';
import 'package:frontend/app/modules/questions/view/question_ask2.dart';
import 'package:frontend/app/modules/questions/view/question_ask3.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../../utils/requests/api_endpoints.dart';
import '../../../utils/widgets/defaultsnackbar.dart';
import '../../course/model/gptmodel.dart';

class Questioncontroller extends GetxController {
  RxString question1 = ''.obs;
  RxString question2 = ''.obs;
  RxString question3 = ''.obs;
  RxInt courseId = 0.obs;
  RxBool isQuestion3Available = false.obs;
  Rx<QuestionModel> question = QuestionModel().obs;
  AuthenticationController authenticationController =
      Get.put(AuthenticationController());
  RxBool isLoading = false.obs;
  RxBool isUpdate = false.obs;
  RxList<String> answers = <String>[].obs;
  final box = GetStorage();
  RxList<CheckGptModel> checkgtpList = <CheckGptModel>[].obs;
  RxBool isCorrectAnswer = true.obs;
  RxString wrongQuestionForExplanation = ''.obs;
  RxList<String> wrongOptionsForExplanation = <String>[].obs;
  RxList<String> wrongCorrentAnswerForExplanation = <String>[].obs;
  RxString wrongQuestionPromptForExplanation = ''.obs;
  RxInt wrongQuestionCourseId = 0.obs;
  RxString wrongQuestionExplanation = ''.obs;
  RxBool isExplanationLoaded = false.obs;

  @override
  void onInit() {
    super.onInit();
    authenticationController.userModel.value.id != null
        ? checkgptConfig()
        : null;
  }

  String fixUnicodeIssues(String input) {
    // Regular expression to match letters, numbers, and spaces, and remove anything else
    final RegExp regex = RegExp(r'[^a-zA-Z0-9\s]', unicode: true);

    // Replace everything that is not a letter, number, or space with an empty string
    return input.replaceAll(regex, '');
  }

  // user enrolled courses
  Future<void> checkExplanation() async {
    try {
      isExplanationLoaded.value = true;
      String endpoint = baseUrl + apiResponseEndpoint;
      log('endpoint === $endpoint');
      final token = box.read('token');
      Map<String, String> header = {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token',
      };
      var bodyData = {
        'prompt':
            '\n$wrongQuestionForExplanation\nOptions:$wrongOptionsForExplanation\nCorrect answers:$wrongCorrentAnswerForExplanation\n$wrongQuestionPromptForExplanation',
        'course': wrongQuestionCourseId.value,
      };
      log('api explanation body === $bodyData');
      var response = await http.post(
        Uri.parse(endpoint),
        headers: header,
        body: json.encode(bodyData),
      );
      log('gpt config response === ${response.statusCode}');
      log('gpt config response === ${response.body}');
      if (response.statusCode == 200) {
        var decodedResponse = json.decode(response.body);
        wrongQuestionExplanation.value = decodedResponse['text'];
        isExplanationLoaded.value = false;
      } else {
        DefaultSnackbar.show('Error', 'Something went wrong.');
      }
    } catch (e) {
      log('Error ${e.toString()}');
    } finally {
      isExplanationLoaded.value = false;
    }
  }

  // user enrolled courses
  Future<void> checkgptConfig() async {
    try {
      isLoading.value = true;
      String endpoint = baseUrl + checkGptConfig;
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
      log('gpt config response === ${response.statusCode}');
      log('gpt config response === ${response.body}');
      if (response.statusCode == 200) {
        checkgtpList.clear();
        var decodedResponse = json.decode(response.body);
        log('response === $decodedResponse');
        for (var i = 0; i < decodedResponse.length; i++) {
          checkgtpList.add(CheckGptModel.fromJson(decodedResponse[i]));
        }
        checkgtpList.refresh();
        isLoading.value = false;
      } else {
        DefaultSnackbar.show('Error', 'Something went wrong.');
      }
    } catch (e) {
      log('Error ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  void selectQuestion1(String? value) {
    question1.value = value!;
    Get.to(() => const QuestionAsk2());
  }

  void selectQuestion2(String? value) {
    question2.value = value!;
    Get.to(() => const QuestionAsk3());
  }

  void selectQuestion3(String? value) {
    question3.value = value!;
    if (question3.isNotEmpty) {
      isQuestion3Available.value = true;
    } else {
      isQuestion3Available.value = false;
    }
  }

  void selectAnswer(String answer, bool singleValue) {
    print('value is $answer');
    print('value is $singleValue');
    if (singleValue) {
      if (answers.contains(answer)) {
        answers.remove(answer);
      } else {
        answers.clear();
        answers.add(answer);
      }
    } else {
      if (answers.contains(answer)) {
        answers.remove(
            answer); // If the answer is already selected, remove it (toggle behavior)
      } else {
        answers.add(answer); // Otherwise, add the answer
      }
    }
    print('Current answers: $answers');
    print('Current answers: ${answers.length}');
  }

  // get datasets questions
  Future<void> onlyUpdateConfiguration() async {
    try {
      isLoading.value = true;
      String endpoint = baseUrl + gptConfig;
      log('endpoint === $endpoint');
      final token = box.read('token');
      Map<String, String> header = {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token',
      };
      var bodyData = {
        "course_id": courseId.value,
        "vocabulary_level": question1.value,
        "detail_level": question2.value,
        "explanation_style": question3.value,
      };
      log('body of gpt is ${json.encode(bodyData)}');
      var response = await http.patch(
        Uri.parse(endpoint),
        headers: header,
        body: json.encode(bodyData),
      );
      log('endpoint === $header');
      log('messages response === ${response.body}');
      log('response === ${response.statusCode}');
      if (response.statusCode == 200) {
        question1.value = '';
        question2.value = '';
        question3.value = '';
        await checkgptConfig();
        Get.until((route) =>
            (route as GetPageRoute).routeName == '/GptconfigCourses');

        isLoading.value = false;
      } else {
        DefaultSnackbar.show('Error', 'Something went wrong.');
      }
    } catch (e) {
      log('Error ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  // get datasets questions
  Future<void> updateConfiguration() async {
    try {
      isLoading.value = true;
      String endpoint = baseUrl + gptConfig;
      log('endpoint === $endpoint');
      final token = box.read('token');
      Map<String, String> header = {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token',
      };
      var bodyData = {
        "course_id": courseId.value,
        "vocabulary_level": question1.value,
        "detail_level": question2.value,
        "explanation_style": question3.value,
      };
      log('body of gpt is ${json.encode(bodyData)}');
      var response = await http.patch(
        Uri.parse(endpoint),
        headers: header,
        body: json.encode(bodyData),
      );
      log('endpoint === $header');
      log('messages response === ${response.body}');
      log('response === ${response.statusCode}');
      if (response.statusCode == 200) {
        question1.value = '';
        question2.value = '';
        question3.value = '';
        checkgptConfig();
        await getQuestionDataset();
        isLoading.value = false;
      } else {
        DefaultSnackbar.show('Error', 'Something went wrong.');
      }
    } catch (e) {
      log('Error ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  // CHECK ANSWERS
  Future<void> checkAnswers() async {
    try {
      isLoading.value = true;
      String endpoint =
          '$baseUrl$questions${question.value.results!.first.id}/';
      log('endpoint === $endpoint');
      final token = box.read('token');
      Map<String, String> header = {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token',
      };
      var bodyData = {
        "answer": answers,
        "is_correct": isCorrectAnswer.value,
        "is_complete": true,
      };
      var response = await http.patch(
        Uri.parse(endpoint),
        headers: header,
        body: json.encode(bodyData),
      );
      log('body data === $bodyData');
      log('endpoint === $header');
      log('answer response === ${response.body}');
      log('response === ${response.statusCode}');
      if (response.statusCode == 200) {
        var decodedResponse = json.decode(response.body);
        ResponseQuestion apiResponse =
            ResponseQuestion.fromJson(decodedResponse);
        log('Parsed apiResponse: ${apiResponse.question!.questionText}');
        if (isCorrectAnswer.value == true) {
          nextQuestion();
        } else {
          print('entered for wrong');
          wrongQuestionForExplanation.value =
              apiResponse.question?.questionText ?? 'No question text';
          wrongQuestionPromptForExplanation.value =
              apiResponse.prompt ?? 'No prompt available';
          wrongOptionsForExplanation.value =
              apiResponse.question?.options ?? [];
          wrongCorrentAnswerForExplanation.value =
              apiResponse.question?.correctAnswer ?? [];
          wrongQuestionCourseId.value = apiResponse.course ?? 0;
        }
        isLoading.value = false;
      } else {
        DefaultSnackbar.show('Error', 'Something went wrong.');
      }
    } catch (e) {
      log('Error ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

// CHECK ANSWERS
  Future<void> nextQuestion() async {
    try {
      isLoading.value = true;
      String endpoint = question.value.next!;
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
      log('next question response === ${response.body}');
      log('response === ${response.statusCode}');
      if (response.statusCode == 200) {
        var decodedResponse = json.decode(response.body);
        QuestionModel apiResponse = QuestionModel.fromJson(decodedResponse);
        question.value = apiResponse;
        question.refresh();
        isLoading.value = false;
      } else {
        DefaultSnackbar.show('Error', 'Something went wrong.');
      }
    } catch (e) {
      log('Error ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  // get datasets questions
  Future<void> getQuestionDataset() async {
    try {
      isLoading.value = true;
      String endpoint = '$baseUrl$questions?course=${courseId.value}';
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
      log('messages response === ${response.body}');
      log('response === ${response.statusCode}');
      if (response.statusCode == 200) {
        var decodedResponse = json.decode(response.body);
        QuestionModel apiResponse = QuestionModel.fromJson(decodedResponse);
        question.value = apiResponse;
        question.refresh();
        Get.offUntil(
          GetPageRoute(
            page: () => const ApiquestionView(),
          ),
          (route) => (route as GetPageRoute).routeName == '/CourseDetail',
        );
        isLoading.value = false;
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
