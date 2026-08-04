import 'dart:async';
import 'package:get/get.dart';
import 'package:internsharks/app/data/models/account/chat_mcq_question_model.dart';
import 'package:internsharks/app/data/models/account/chat_mcq_result_model.dart';
import 'package:internsharks/app/data/models/account/common_login_model.dart';
import 'package:internsharks/app/data/models/account/create_new_resume_model.dart';
import 'package:internsharks/app/data/models/account/student_register_model.dart';
import 'package:internsharks/app/data/providers/student_login_provider.dart';

class StudentLoginController extends GetxController {
  final StudentLoginProvider? loginProvider;

  StudentLoginController(this.loginProvider);

  int getResponseCode() => loginProvider!.responseStatus;

  // ================= TIMER =================
  final seconds = 30.obs;
  final canResend = false.obs;
  Timer? _timer;

  // ================= INPUT =================
  final mobile = ''.obs;
  final email = ''.obs;
  final otp = ''.obs;
  final usertype = ''.obs;

  // ================= OTP STATE =================

  final _otpSent = false.obs;

  bool get otpSent => _otpSent.value;

  set otpSent(bool v) => _otpSent.value = v;

  // ================= TIMER LOGIC =======================
  // =====================================================
  void startTimer() {
    canResend.value = false;
    seconds.value = 30;
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (seconds.value == 0) {
        canResend.value = true;
        t.cancel();
      } else {
        seconds.value--;
      }
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  //Login
  final _loginOtpLoading = false.obs;

  bool get loginOtpLoading => _loginOtpLoading.value;

  set loginOtpLoading(bool value) => _loginOtpLoading.value = value;

  final _commonPostModel = CommonLoginOtpModel().obs;

  CommonLoginOtpModel get commonPostModel => _commonPostModel.value;

  set commonPostModel(CommonLoginOtpModel value) => _commonPostModel.value = value;

  Future<void> sendLoginOtp({required String mobileNumber}) async {
    try {
      otpSent = false;
      loginOtpLoading = true;
      commonPostModel = await loginProvider!.postLoginOtp(
        mobileNumber: mobileNumber,
      );
      if (getResponseCode() == 200 || getResponseCode() == 201) {
        otpSent = true;
        startTimer();
      }
      loginOtpLoading = false;
    } catch (err) {
      loginOtpLoading = false;
      rethrow;
    }
  }

  final _loginVerifyLoading = false.obs;

  bool get loginVerifyLoading => _loginVerifyLoading.value;

  set loginVerifyLoading(bool value) => _loginVerifyLoading.value = value;

  //Model

  final _studentRegisterModel = StudentRegisterModel().obs;

  StudentRegisterModel get studentRegisterModel => _studentRegisterModel.value;

  set studentRegisterModel(StudentRegisterModel value) =>
      _studentRegisterModel.value = value;

  Future<void> verifyLoginOtp({
    required String mobileNumber,
    required String otpNumber,
    required String userType,
    required String fcmToken,
  }) async {
    try {
      loginVerifyLoading = true;
      studentRegisterModel = await loginProvider!.loginVerifyOtp(
        mobileNumber: mobileNumber,
        otpNumber: otpNumber,
        userType: userType,
        fcmToken: fcmToken
      );
      loginVerifyLoading = false;
    } catch (err) {
      loginVerifyLoading = false;
      rethrow;
    }
  }

  //CHAT CREATE NEW RESUME

  final _createNewResumeLoading = false.obs;

  bool get createNewResumeLoading => _createNewResumeLoading.value;

  set createNewResumeLoading(bool value) => _createNewResumeLoading.value = value;

  //Model

  final _createNewResumeModel = CreateNewChatResumeModel().obs;

  CreateNewChatResumeModel get createNewResumeModel => _createNewResumeModel.value;

  set createNewResumeModel(CreateNewChatResumeModel value) =>
      _createNewResumeModel.value = value;

  Future<void> createNewChatResume({
    required Map<String, dynamic> chatRequestData
  }) async {
    try {
      createNewResumeLoading = true;
      createNewResumeModel = await loginProvider!.makeNewChatResume(
          chatRequestData: chatRequestData
      );
      createNewResumeLoading = false;
    } catch (err) {
      createNewResumeLoading = false;
      rethrow;
    }
  }

  //CHAT MCQ QUESTION

  final _chatMcqQuestionLoading = false.obs;

  bool get chatMcqQuestionLoading => _chatMcqQuestionLoading.value;

  set chatMcqQuestionLoading(bool value) => _chatMcqQuestionLoading.value = value;

  //Model

  final _chatMcqQuestionModel = ChatMcqQuestionModel().obs;

  ChatMcqQuestionModel get chatMcqQuestionModel => _chatMcqQuestionModel.value;

  set chatMcqQuestionModel(ChatMcqQuestionModel value) =>
      _chatMcqQuestionModel.value = value;

  Future<void> getChatMcqQuestion({
    required Map<String, dynamic> chatRequestData
  }) async {
    try {
      chatMcqQuestionLoading = true;
      chatMcqQuestionModel = await loginProvider!.fetchChatMcqQuestion(
          chatRequestData: chatRequestData
      );
      chatMcqQuestionLoading = false;
    } catch (err) {
      chatMcqQuestionLoading = false;
      rethrow;
    }
  }

  //CHAT MCQ Result

  final _chatMcqResultLoading = false.obs;

  bool get chatMcqResultLoading => _chatMcqResultLoading.value;

  set chatMcqResultLoading(bool value) => _chatMcqResultLoading.value = value;

  //Model

  final _chatMcqResultModel = ChatMcqResultModel().obs;

  ChatMcqResultModel get chatMcqResultModel => _chatMcqResultModel.value;

  set chatMcqResultModel(ChatMcqResultModel value) =>
      _chatMcqResultModel.value = value;

  Future<void> getChatMcqResult({
    required Map<String, dynamic> chatRequestData
  }) async {
    try {
      chatMcqResultLoading = true;
      chatMcqResultModel = await loginProvider!.fetchChatMcqResult(
          chatRequestData: chatRequestData
      );
      chatMcqResultLoading = false;
    } catch (err) {
      chatMcqResultLoading = false;
      rethrow;
    }
  }
}
