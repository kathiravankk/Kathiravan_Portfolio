import 'package:get/get.dart';
import 'package:internsharks/app/data/models/account/common_login_model.dart';
import 'package:internsharks/app/data/models/recruiter_flow/ai_chat_response_model.dart';
import 'package:internsharks/app/data/models/recruiter_flow/applicants_list_model.dart';
import 'package:internsharks/app/data/models/recruiter_flow/application_status_update_model.dart';
import 'package:internsharks/app/data/models/recruiter_flow/create_stipend_order_model.dart';
import 'package:internsharks/app/data/models/recruiter_flow/intern_student_profile_model.dart';
import 'package:internsharks/app/data/models/recruiter_flow/internship_post_model.dart';
import 'package:internsharks/app/data/models/recruiter_flow/issued_certificate_model.dart';
import 'package:internsharks/app/data/models/recruiter_flow/new_internship_data_model.dart';
import 'package:internsharks/app/data/models/recruiter_flow/recruiter_review_model.dart';
import 'package:internsharks/app/data/models/recruiter_flow/recruiter_transaction_history_model.dart';
import 'package:internsharks/app/data/models/recruiter_flow/send_request_model.dart';
import 'package:internsharks/app/data/models/recruiter_flow/syllabus_chat_response_model.dart';
import 'package:internsharks/app/data/models/recruiter_flow/syllabus_generate_model.dart';

import '../../../../data/models/recruiter_flow/syllabus_view_data_model.dart';
import '../../../../data/providers/recruiter_flow/internship_post_provider.dart';

class InternshipPostController extends GetxController {
  final InternshipPostProvider? internshipPostProvider;

  InternshipPostController(this.internshipPostProvider);

  int getResponseCode() => internshipPostProvider!.responseStatus;

  // GET RECRUITER PROFILE

  final _internPostLoading = false.obs;

  bool get internPostLoading => _internPostLoading.value;

  set internPostLoading(bool value) => _internPostLoading.value = value;

  // Model

  final _internPostModel = InternshipPostModel().obs;

  InternshipPostModel get internPostModel => _internPostModel.value;

  set internPostModel(InternshipPostModel value) =>
      _internPostModel.value = value;

  Future<void> getPostedInternships({required String recruiterId}) async {
    try {
      internPostLoading = true;
      internPostModel = await internshipPostProvider!.fetchPostedInternships(
        recruiterId: recruiterId,
      );
      internPostLoading = false;
    } catch (err) {
      internPostLoading = false;
      rethrow;
    }
  }

  // GET APPLICANTS

  final _applicantsLoading = false.obs;

  bool get applicantsLoading => _applicantsLoading.value;

  set applicantsLoading(bool value) => _applicantsLoading.value = value;

  // Model

  final _applicantsModel = ApplicantsListModel().obs;

  ApplicantsListModel get applicantsModel => _applicantsModel.value;

  set applicantsModel(ApplicantsListModel value) =>
      _applicantsModel.value = value;

  Future<void> getApplicants({
    required String jobId,
    required String status,
  }) async {
    try {
      applicantsLoading = true;
      applicantsModel = await internshipPostProvider!.fetchApplicants(
        jobId: jobId,
        status: status,
      );
      applicantsLoading = false;
    } catch (err) {
      applicantsLoading = false;
      rethrow;
    }
  }

  // GET INTERNS PROFILE DATA

  final _studentProfileLoading = false.obs;

  bool get studentProfileLoading => _studentProfileLoading.value;

  set studentProfileLoading(bool value) => _studentProfileLoading.value = value;

  // Model

  final _internStudentProfileModel = InternStudentProfileModel().obs;

  InternStudentProfileModel get internStudentProfileModel =>
      _internStudentProfileModel.value;

  set internStudentProfileModel(InternStudentProfileModel value) =>
      _internStudentProfileModel.value = value;

  Future<void> getInternStudentProfile({
    required String jobId,
    required String studentId,
  }) async {
    try {
      studentProfileLoading = true;
      internStudentProfileModel = await internshipPostProvider!
          .fetchInternStudentProfile(jobId: jobId, studentId: studentId);
      studentProfileLoading = false;
    } catch (err) {
      studentProfileLoading = false;
      rethrow;
    }
  }

  //  CREATE NEW INTERNSHIP

  final _createInternshipLoading = false.obs;

  bool get createInternshipLoading => _createInternshipLoading.value;

  set createInternshipLoading(bool value) =>
      _createInternshipLoading.value = value;

  // Model

  final _createInternshipModel = NewInternshipDataModel().obs;

  NewInternshipDataModel get createInternshipModel =>
      _createInternshipModel.value;

  set createInternshipModel(NewInternshipDataModel value) =>
      _createInternshipModel.value = value;

  Future<void> createNewInternship({
    required Map<String, dynamic> internshipData,
  }) async {
    try {
      createInternshipLoading = true;
      createInternshipModel = await internshipPostProvider!.createNewInternship(
        internshipData: internshipData,
      );
    } catch (err) {
      rethrow;
    } finally {
      createInternshipLoading = false;
    }
  }

  //  UPDATE NEW INTERNSHIP

  final _updateInternshipLoading = false.obs;

  bool get updateInternshipLoading => _updateInternshipLoading.value;

  set updateInternshipLoading(bool value) =>
      _updateInternshipLoading.value = value;

  Future<void> updateNewInternship({
    required Map<String, dynamic> internshipData,
    required String jobId,
  }) async {
    try {
      updateInternshipLoading = true;
      createInternshipModel = await internshipPostProvider!.updateNewInternship(
        internshipData: internshipData,
        jobId: jobId,
      );
    } catch (err) {
      rethrow;
    } finally {
      updateInternshipLoading = false;
    }
  }

  //  SEND INTERNSHIP REQUEST

  final _sendRequestLoading = false.obs;

  bool get sendRequestLoading => _sendRequestLoading.value;

  set sendRequestLoading(bool value) => _sendRequestLoading.value = value;

  // Model

  final _sendRequestModel = SendRequestModel().obs;

  SendRequestModel get sendRequestModel => _sendRequestModel.value;

  set sendRequestModel(SendRequestModel value) =>
      _sendRequestModel.value = value;

  Future<void> sendInternshipRequest({
    required Map<String, dynamic> internshipData,
  }) async {
    try {
      sendRequestLoading = true;
      sendRequestModel = await internshipPostProvider!.sendInternshipRequest(
        internshipData: internshipData,
      );
    } catch (err) {
      rethrow;
    } finally {
      sendRequestLoading = false;
    }
  }

  //  UPDATE APPLICATION STATUS

  final _applicationStatusLoading = false.obs;

  bool get applicationStatusLoading => _applicationStatusLoading.value;

  set applicationStatusLoading(bool value) =>
      _applicationStatusLoading.value = value;

  // Model

  final _applicationStatusModel = ApplicationStatusUpdateModel().obs;

  ApplicationStatusUpdateModel get applicationStatusModel =>
      _applicationStatusModel.value;

  set applicationStatusModel(ApplicationStatusUpdateModel value) =>
      _applicationStatusModel.value = value;

  Future<void> updateApplicationStatus({
    required String applicationId,
    required String status,
    required String syllabusId,
  }) async {
    try {
      applicationStatusLoading = true;
      applicationStatusModel = await internshipPostProvider!
          .updateApplicationStatus(
            applicationId: applicationId,
            status: status,
            syllabusId: syllabusId,
          );
    } catch (err) {
      rethrow;
    } finally {
      applicationStatusLoading = false;
    }
  }

  //  GET RECRUITER REVIEW

  final _recruiterReviewLoading = false.obs;

  bool get recruiterReviewLoading => _recruiterReviewLoading.value;

  set recruiterReviewLoading(bool value) =>
      _recruiterReviewLoading.value = value;

  // Model

  final _recruiterReviewModel = RecruiterReviewModel().obs;

  RecruiterReviewModel get recruiterReviewModel => _recruiterReviewModel.value;

  set recruiterReviewModel(RecruiterReviewModel value) =>
      _recruiterReviewModel.value = value;

  Future<void> getRecruiterReview({required String jobId}) async {
    try {
      recruiterReviewLoading = true;
      recruiterReviewModel = await internshipPostProvider!.fetchRecruiterReview(
        jobId: jobId,
      );
    } catch (err) {
      rethrow;
    } finally {
      recruiterReviewLoading = false;
    }
  }

  //  GET ISSUED CERTIFICATE

  final _issuedCertificateLoading = false.obs;

  bool get issuedCertificateLoading => _issuedCertificateLoading.value;

  set issuedCertificateLoading(bool value) =>
      _issuedCertificateLoading.value = value;

  // Model

  final _certificateModel = IssuedCertificateModel().obs;

  IssuedCertificateModel get certificateModel => _certificateModel.value;

  set certificateModel(IssuedCertificateModel value) =>
      _certificateModel.value = value;

  Future<void> getIssuedCertificate({
    required String jobId,
    required String studentId,
  }) async {
    try {
      issuedCertificateLoading = true;
      certificateModel = await internshipPostProvider!.fetchIssuedCertificate(
        jobId: jobId,
        studentId: studentId,
      );
    } catch (err) {
      rethrow;
    } finally {
      issuedCertificateLoading = false;
    }
  }

  //  GET SYLLABUS CHAT DATA

  final _syllabusChatLoading = false.obs;

  bool get syllabusChatLoading => _syllabusChatLoading.value;

  set syllabusChatLoading(bool value) => _syllabusChatLoading.value = value;

  // Model

  final _syllabusChatModel = SyllabusChatResponseModel().obs;

  SyllabusChatResponseModel get syllabusChatModel => _syllabusChatModel.value;

  set syllabusChatModel(SyllabusChatResponseModel value) =>
      _syllabusChatModel.value = value;

  Future<void> getSyllabusChatData({
    required SyllabusViewData syllabusData,
  }) async {
    try {
      syllabusChatLoading = true;
      syllabusChatModel = await internshipPostProvider!.fetchSyllabusChatData(
        syllabusData: syllabusData,
      );
    } catch (err) {
      rethrow;
    } finally {
      syllabusChatLoading = false;
    }
  }

  //  GET SYLLABUS CHAT DATA

  final _chatMessageLoading = false.obs;

  bool get chatMessageLoading => _chatMessageLoading.value;

  set chatMessageLoading(bool value) => _chatMessageLoading.value = value;

  // Model

  final _aiChatResponseModel = AiChatResponseModel().obs;

  AiChatResponseModel get aiChatResponseModel => _aiChatResponseModel.value;

  set aiChatResponseModel(AiChatResponseModel value) =>
      _aiChatResponseModel.value = value;

  Future<void> syllabusChatMessage({
    required String message,
    required String chatId,
  }) async {
    try {
      chatMessageLoading = true;
      aiChatResponseModel = await internshipPostProvider!.syllabusChatMessage(
        message: message,
        chatId: chatId,
      );
    } catch (err) {
      rethrow;
    } finally {
      chatMessageLoading = false;
    }
  }

  //  UPDATE SYLLABUS CHAT DATA

  final _updateChatLoading = false.obs;

  bool get updateChatLoading => _updateChatLoading.value;

  set updateChatLoading(bool value) => _updateChatLoading.value = value;

  // Model

  final _updateSyllabusModel = SyllabusViewDataModel().obs;

  SyllabusViewDataModel get updateSyllabusModel => _updateSyllabusModel.value;

  set updateSyllabusModel(SyllabusViewDataModel value) =>
      _updateSyllabusModel.value = value;

  Future<void> updateSyllabusChatMessage({
    required SyllabusGenerateModel syllabusData,
    required String studentId,
    required String jobId,
  }) async {
    try {
      updateChatLoading = true;
      updateSyllabusModel = await internshipPostProvider!.updateSyllabusChatMessage(
        syllabusData: syllabusData,
        studentId: studentId,
        jobId: jobId,
      );
    } catch (err) {
      rethrow;
    } finally {
      updateChatLoading = false;
    }
  }

  //  CHECK STIPEND STATUS

  final _checkStatusLoading = false.obs;

  bool get checkStatusLoading => _checkStatusLoading.value;

  set checkStatusLoading(bool value) => _checkStatusLoading.value = value;

  // Model

  final _statusCheckModel = CommonLoginOtpModel().obs;

  CommonLoginOtpModel get statusCheckModel => _statusCheckModel.value;

  set statusCheckModel(CommonLoginOtpModel value) =>
      _statusCheckModel.value = value;

  Future<void> checkStipendStatus({
    required String studentId,
    required String jobId,
  }) async {
    try {
      checkStatusLoading = true;
      statusCheckModel = await internshipPostProvider!.checkStipendStatus(
        studentId: studentId,
        jobId: jobId,
      );
    } catch (err) {
      rethrow;
    } finally {
      checkStatusLoading = false;
    }
  }

  //  CREATE STIPEND PAYMENT ORDER

  final _createStipendLoading = false.obs;

  bool get createStipendLoading => _createStipendLoading.value;

  set createStipendLoading(bool value) => _createStipendLoading.value = value;

  // Model

  final _createStipendOrderModel = CreateStipendOrderModel().obs;

  CreateStipendOrderModel get createStipendOrderModel => _createStipendOrderModel.value;

  set createStipendOrderModel(CreateStipendOrderModel value) =>
      _createStipendOrderModel.value = value;

  Future<void> createStipendPaymentOrder({
    required String studentId,
    required String jobId,
  }) async {
    try {
      createStipendLoading = true;
      createStipendOrderModel = await internshipPostProvider!.createStipendPaymentOrder(
        studentId: studentId,
        jobId: jobId,
      );
    } catch (err) {
      rethrow;
    } finally {
      createStipendLoading = false;
    }
  }


  //  VERIFY STIPEND PAYMENT ORDER

  final _verifyStipendLoading = false.obs;

  bool get verifyStipendLoading => _verifyStipendLoading.value;

  set verifyStipendLoading(bool value) => _verifyStipendLoading.value = value;

  // Model
  //
  // final _createStipendOrderModel = CreateStipendOrderModel().obs;
  //
  // CreateStipendOrderModel get createStipendOrderModel => _createStipendOrderModel.value;
  //
  // set createStipendOrderModel(CreateStipendOrderModel value) =>
  //     _createStipendOrderModel.value = value;

  Future<void> verifyStipendPaymentOrder({
    required String orderId,
  }) async {
    try {
      verifyStipendLoading = true;
      statusCheckModel = await internshipPostProvider!.verifyStipendPaymentOrder(
        orderId: orderId,
      );
    } catch (err) {
      rethrow;
    } finally {
      verifyStipendLoading = false;
    }
  }


}
