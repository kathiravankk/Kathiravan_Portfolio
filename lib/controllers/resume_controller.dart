import 'package:get/get.dart';
import 'package:internsharks/app/data/models/account/extracted_data_model.dart';
import 'package:internsharks/app/data/models/account/resume_extract_model.dart';
import 'package:internsharks/provider/resume_provider.dart';


class ResumeController extends GetxController {
  final ResumeProvider? resumeProvider;
  ResumeData? extractedResumeData; // 🔥 AI data store

  ResumeController(this.resumeProvider);

  // Get response code

  int getResponseCode() => resumeProvider!.responseStatus;

  // Set model
  final _resumeUploadSuccess = false.obs;

  bool get resumeUploadSuccess => _resumeUploadSuccess.value;
  set resumeUploadSuccess(bool value) =>
      _resumeUploadSuccess.value = value;
  final _resumeAnalyzeModel = ResumeExtractModel().obs;

  ResumeExtractModel get resumeAnalyzeModel => _resumeAnalyzeModel.value;

  set resumeAnalyzeModel(ResumeExtractModel value) =>
      _resumeAnalyzeModel.value = value;

  //Set loading
  String? filePath;
  final _resumeUploadLoading = false.obs;

  bool get resumeUploadLoading => _resumeUploadLoading.value;

  set resumeUploadLoading(bool value) => _resumeUploadLoading.value = value;

  Future<void> uploadResume(String? filePath) async {
    resumeUploadLoading = true;
    try {
      resumeAnalyzeModel = await resumeProvider!.uploadResumePdf(filePath!);
      resumeUploadLoading = false;
    } catch (error) {
      resumeUploadLoading = false;
      rethrow;
    }
  }
  Future<bool> registerCompleteStudentData({
    required ResumeData resumeData,
    bool emailVerified = false,
    bool mobileVerified = false,
  }) async {
    resumeUploadLoading = true;
    try {
      final Map<String, dynamic> data = {};

      // Verification Status
      data['email_verified'] = emailVerified ? '1' : '0';
      data['mobile_verified'] = mobileVerified ? '1' : '0';

      // Personal Info
      final info = resumeData.personalInfo;
      data['name'] = info!.name ?? '';
      data['email'] = info!.email ?? '';
      data['mobile'] = info!.phone ?? ''; // Mapping phone to mobile
      data['dob'] = info!.location ?? ''; // No DOB in PersonalInfo, using location or empty? User used dob? PersonalInfo has no dob in model. checking...
      // PersonalInfo model has: name, email, phone, location.
      // User code used: resume.personalInfo.dob ?? '' -> this implies they might have added it or assumed it.
      // I will use empty string for dob if not found, or check extracted_data_model again.
      // ResumeData model has dob? NO. PersonalInfo has no dob.
      // API expects dob. I will send empty string for now.
      data['dob'] = ''; 
      
      data['profile_summary'] = resumeData.profileSummary;

      // Skills
      for (int i = 0; i < resumeData.skills!.length; i++) {
        data['skills[$i]'] = resumeData.skills![i];
      }

      // Languages
      for (int i = 0; i < resumeData.languages!.length; i++) {
        data['languages[$i]'] = resumeData.languages![i];
      }

      // Experience
      for (int i = 0; i < resumeData.experience!.length; i++) {
        data['experience[$i][company]'] = resumeData.experience![i].company;
        data['experience[$i][role]'] = resumeData.experience![i].role;
        data['experience[$i][duration]'] = resumeData.experience![i].duration;
      }

      // Projects
      for (int i = 0; i < resumeData.projects!.length; i++) {
        data['projects[$i][title]'] = resumeData.projects![i].title;
        data['projects[$i][description]'] = resumeData.projects![i].description;
      }

      // Colleges
      for (int i = 0; i < resumeData.colleges!.length; i++) {
        data['colleges[$i][name]'] = resumeData.colleges![i].institution;
        data['colleges[$i][location]'] = ''; // College model has no location
      }

      // Degrees
      for (int i = 0; i < resumeData.degree!.length; i++) {
        data['degree[$i][name]'] = resumeData.degree![i].degree;
        data['degree[$i][year]'] = ''; // Degree model has no year
      }

      final response = await resumeProvider!.registerStudent(data);
      
      resumeAnalyzeModel = response;
      resumeUploadSuccess = response.success == true;
      
      return resumeUploadSuccess;

    } catch (e) {
      print("Register Error: $e");
      resumeUploadSuccess = false;
      return false;
    } finally {
      resumeUploadLoading = false;
    }
  }

  // Future<void> saveResumeData(String filePath) async {
  //   resumeUploadLoading = true;
  //
  //   try {
  //     final response =
  //     await resumeProvider!.uploadResumePdf(filePath);
  //
  //     resumeAnalyzeModel = response;
  //
  //     resumeUploadSuccess =
  //         resumeAnalyzeModel.success == true &&
  //             resumeAnalyzeModel.filename != null;
  //
  //   } catch (e) {
  //     resumeUploadSuccess = false;
  //   } finally {
  //     resumeUploadLoading = false;
  //   }
  // }

}
