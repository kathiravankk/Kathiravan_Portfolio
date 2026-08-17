// ignore_for_file: avoid_print
// =============================================================================
// RUNNING INSTRUCTIONS:
// 1. Run All Steps Together:
//    flutter test test/resume_chatbot_test_part2.dart --reporter=expanded
//
// 2. Run a Single Step (e.g. Step 11):
//    flutter test test/resume_chatbot_test_part2.dart --plain-name="Step 11" --reporter=expanded
//
// 3. Run a Subset of Steps (e.g. Steps 8 to 11):
//    flutter test test/resume_chatbot_test_part2.dart --name="Step (8|9|10|11)" --reporter=expanded
// =============================================================================

import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';

const String apiEndpoint = "https://dev.api.internsharks.ai/api/resumechatbot";

// ---------------------------------------------------------------------------
// ✏️  Configurable Test Data Variables
// ---------------------------------------------------------------------------
String testOtp = "4314";
String testUserId = ""; // Leave empty to load from .chatbot_session.json
String testPhone = "9943155120";
String testPhoneConfirmation = "Yes";
String testPhoneOtp = "1234";
String testRefcode = "No";
String testLocation = "No";
String testLinkedIn = "No";
String testGithub = "No";
String testSummaryChoice = "you generate";
String testSecondarySchool = "Velammal Matric";
String testSecondaryBoard = "CBSE";
String testSecondaryYear = "2015";
String testSecondaryPercentage = "75";
String testHigherSecondaryConfirm = "Yes";
String testHigherSecondarySchool = "Velammal Higher Secondary";
String testHigherSecondaryBoard = "CBSE";
String testHigherSecondaryYear = "2017";
String testHigherSecondaryPercentage = "80";
String testCollegeDegree = "No";
String testTechnicalSkills = "Flutter, Dart, Firebase, REST API, Git, GetX";
String testInternships = "No";
String testProjects = "No";
String testPaperPresentations = "No";
String testCertifications = "No";
String testIndustrialVisits = "No";
String testWorkshops = "No";
String testPublications = "No";
String testLeadership = "No";
String testVolunteerExperience = "No";
String testLanguages = "English, Tamil";
String testAreasOfInterest = "Mobile App Development, UI/UX Design";
String testHobbies = "Reading tech blogs, Chess";

String getActiveUserId() {
  final manualId = testUserId.trim();
  if (manualId.isNotEmpty) return manualId;

  final File sessionFile = File('.chatbot_session.json');
  expect(
    sessionFile.existsSync(),
    isTrue,
    reason:
        "Run Part 1 (resume_chatbot_test.dart) first to generate .chatbot_session.json, or set testUserId directly above.",
  );

  final Map<String, dynamic> session = jsonDecode(
    sessionFile.readAsStringSync(),
  );
  final String savedId = session["user_id"] ?? "";
  expect(
    savedId,
    isNotEmpty,
    reason: "user_id is empty in .chatbot_session.json. Set testUserId manually or rerun Part 1.",
  );
  return savedId;
}

void main() {
  final Dio dio = Dio(
    BaseOptions(
      headers: {"Content-Type": "application/json"},
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      validateStatus: (status) => true,
    ),
  );

  group('Resume Chatbot Part 2', () {
    // -------------------------------------------------------------------------
    // STEP 7: SEND EMAIL OTP
    // -------------------------------------------------------------------------
    test('Step 7: Send Email OTP', () async {
      final userId = getActiveUserId();
      expect(testOtp, isNotEmpty, reason: "Set testOtp variable before running Step 7");

      print("\n==================================================");
      print("👤 user_id: $userId");
      print("🔄 STEP 7: Sending Email OTP '$testOtp'");
      final payload = {
        "action": "send_message",
        "user_id": userId,
        "message": testOtp,
      };
      print("➡️ Request Payload: ${jsonEncode(payload)}");

      final response = await dio.post(apiEndpoint, data: payload);
      expect(response.statusCode, anyOf(200, 201), reason: "Step 7 Error: ${response.data}");

      final data = response.data is Map<String, dynamic> ? response.data : <String, dynamic>{};
      print("Status: ${response.statusCode}");
      print("🤖 Bot Message: ${data["message"]}");
      print("📌 next_field: ${data["next_field"]}");
      print("📌 completed_section: ${data["completed_section"]}");
      print("==================================================\n");
    });

    // -------------------------------------------------------------------------
    // STEP 8: SEND PHONE NUMBER
    // -------------------------------------------------------------------------
    test('Step 8: Send Phone Number', () async {
      final userId = getActiveUserId();
      expect(testPhone, isNotEmpty, reason: "Set testPhone variable before running Step 8");

      print("\n==================================================");
      print("👤 user_id: $userId");
      print("🔄 STEP 8: Sending Phone Number '$testPhone'");
      final payload = {
        "action": "send_message",
        "user_id": userId,
        "message": testPhone,
      };
      print("➡️ Request Payload: ${jsonEncode(payload)}");

      final response = await dio.post(apiEndpoint, data: payload);
      expect(response.statusCode, anyOf(200, 201), reason: "Step 8 Error: ${response.data}");

      final data = response.data is Map<String, dynamic> ? response.data : <String, dynamic>{};
      print("Status: ${response.statusCode}");
      print("🤖 Bot Message: ${data["message"]}");
      print("📌 next_field: ${data["next_field"]}");
      print("📌 completed_section: ${data["completed_section"]}");
      print("==================================================\n");
    });

    // -------------------------------------------------------------------------
    // STEP 9: CONFIRM PHONE NUMBER
    // -------------------------------------------------------------------------
    test('Step 9: Confirm Phone Number (Yes)', () async {
      final userId = getActiveUserId();

      print("\n==================================================");
      print("👤 user_id: $userId");
      print("🔄 STEP 9: Confirming Phone with '$testPhoneConfirmation'");
      final payload = {
        "action": "send_message",
        "user_id": userId,
        "message": testPhoneConfirmation,
      };
      print("➡️ Request Payload: ${jsonEncode(payload)}");

      final response = await dio.post(apiEndpoint, data: payload);
      expect(response.statusCode, anyOf(200, 201), reason: "Step 9 Error: ${response.data}");

      final data = response.data is Map<String, dynamic> ? response.data : <String, dynamic>{};
      print("Status: ${response.statusCode}");
      print("🤖 Bot Message: ${data["message"]}");
      print("📌 next_field: ${data["next_field"]}");
      print("📌 completed_section: ${data["completed_section"]}");
      print("==================================================\n");
    });

    // -------------------------------------------------------------------------
    // STEP 10: SEND PHONE OTP
    // -------------------------------------------------------------------------
    test('Step 10: Send Phone OTP', () async {
      final userId = getActiveUserId();
      expect(testPhoneOtp, isNotEmpty, reason: "Set testPhoneOtp variable before running Step 10");

      print("\n==================================================");
      print("👤 user_id: $userId");
      print("🔄 STEP 10: Sending Phone OTP '$testPhoneOtp'");
      final payload = {
        "action": "send_message",
        "user_id": userId,
        "message": testPhoneOtp,
      };
      print("➡️ Request Payload: ${jsonEncode(payload)}");

      final response = await dio.post(apiEndpoint, data: payload);
      expect(response.statusCode, anyOf(200, 201), reason: "Step 10 Error: ${response.data}");

      final data = response.data is Map<String, dynamic> ? response.data : <String, dynamic>{};
      print("Status: ${response.statusCode}");
      print("🤖 Bot Message: ${data["message"]}");
      print("📌 next_field: ${data["next_field"]}");
      print("📌 completed_section: ${data["completed_section"]}");
      print("==================================================\n");
    });

    // -------------------------------------------------------------------------
    // STEP 11: SEND REFERRAL CODE
    // -------------------------------------------------------------------------
    test('Step 11: Send Referral Code', () async {
      final userId = getActiveUserId();

      print("\n==================================================");
      print("👤 user_id: $userId");
      print("🔄 STEP 11: Sending Referral Code '$testRefcode'");
      final payload = {
        "action": "send_message",
        "user_id": userId,
        "message": testRefcode,
      };
      print("➡️ Request Payload: ${jsonEncode(payload)}");

      final response = await dio.post(apiEndpoint, data: payload);
      expect(response.statusCode, anyOf(200, 201), reason: "Step 11 Error: ${response.data}");

      final data = response.data is Map<String, dynamic> ? response.data : <String, dynamic>{};
      print("Status: ${response.statusCode}");
      print("🤖 Bot Message: ${data["message"]}");
      print("📌 next_field: ${data["next_field"]}");
      print("📌 completed_section: ${data["completed_section"]}");
      print("==================================================\n");
    });

    // -------------------------------------------------------------------------
    // STEP 12: SEND LOCATION
    // -------------------------------------------------------------------------
    test('Step 12: Send Location', () async {
      final userId = getActiveUserId();

      print("\n==================================================");
      print("👤 user_id: $userId");
      print("🔄 STEP 12: Sending Location '$testLocation'");
      final payload = {
        "action": "send_message",
        "user_id": userId,
        "message": testLocation,
      };
      print("➡️ Request Payload: ${jsonEncode(payload)}");

      final response = await dio.post(apiEndpoint, data: payload);
      expect(response.statusCode, anyOf(200, 201), reason: "Step 12 Error: ${response.data}");

      final data = response.data is Map<String, dynamic> ? response.data : <String, dynamic>{};
      print("Status: ${response.statusCode}");
      print("🤖 Bot Message: ${data["message"]}");
      print("📌 next_field: ${data["next_field"]}");
      print("📌 completed_section: ${data["completed_section"]}");
      print("==================================================\n");
    });

    // -------------------------------------------------------------------------
    // STEP 13: SEND LINKEDIN
    // -------------------------------------------------------------------------
    test('Step 13: Send LinkedIn', () async {
      final userId = getActiveUserId();

      print("\n==================================================");
      print("👤 user_id: $userId");
      print("🔄 STEP 13: Sending LinkedIn '$testLinkedIn'");
      final payload = {
        "action": "send_message",
        "user_id": userId,
        "message": testLinkedIn,
      };
      print("➡️ Request Payload: ${jsonEncode(payload)}");

      final response = await dio.post(apiEndpoint, data: payload);
      expect(response.statusCode, anyOf(200, 201), reason: "Step 13 Error: ${response.data}");

      final data = response.data is Map<String, dynamic> ? response.data : <String, dynamic>{};
      print("Status: ${response.statusCode}");
      print("🤖 Bot Message: ${data["message"]}");
      print("📌 next_field: ${data["next_field"]}");
      print("📌 completed_section: ${data["completed_section"]}");
      print("==================================================\n");
    });

    // -------------------------------------------------------------------------
    // STEP 14: SEND GITHUB
    // -------------------------------------------------------------------------
    test('Step 14: Send GitHub', () async {
      final userId = getActiveUserId();

      print("\n==================================================");
      print("👤 user_id: $userId");
      print("🔄 STEP 14: Sending GitHub '$testGithub'");
      final payload = {
        "action": "send_message",
        "user_id": userId,
        "message": testGithub,
      };
      print("➡️ Request Payload: ${jsonEncode(payload)}");

      final response = await dio.post(apiEndpoint, data: payload);
      expect(response.statusCode, anyOf(200, 201), reason: "Step 14 Error: ${response.data}");

      final data = response.data is Map<String, dynamic> ? response.data : <String, dynamic>{};
      print("Status: ${response.statusCode}");
      print("🤖 Bot Message: ${data["message"]}");
      print("📌 next_field: ${data["next_field"]}");
      print("📌 completed_section: ${data["completed_section"]}");
      print("==================================================\n");
    });

    // -------------------------------------------------------------------------
    // STEP 15: SEND SUMMARY CHOICE
    // -------------------------------------------------------------------------
    test('Step 15: Send Summary Choice', () async {
      final userId = getActiveUserId();

      print("\n==================================================");
      print("👤 user_id: $userId");
      print("🔄 STEP 15: Sending Summary Choice '$testSummaryChoice'");
      final payload = {
        "action": "send_message",
        "user_id": userId,
        "message": testSummaryChoice,
      };
      print("➡️ Request Payload: ${jsonEncode(payload)}");

      final response = await dio.post(apiEndpoint, data: payload);
      expect(response.statusCode, anyOf(200, 201), reason: "Step 15 Error: ${response.data}");

      final data = response.data is Map<String, dynamic> ? response.data : <String, dynamic>{};
      print("Status: ${response.statusCode}");
      print("🤖 Bot Message: ${data["message"]}");
      print("📌 next_field: ${data["next_field"]}");
      print("📌 completed_section: ${data["completed_section"]}");
      print("==================================================\n");
    });

    // -------------------------------------------------------------------------
    // STEP 16: SEND SECONDARY (10th) SCHOOL
    // -------------------------------------------------------------------------
    test('Step 16: Send Secondary (10th) School', () async {
      final userId = getActiveUserId();

      print("\n==================================================");
      print("👤 user_id: $userId");
      print("🔄 STEP 16: Sending Secondary (10th) School '$testSecondarySchool'");
      final payload = {
        "action": "send_message",
        "user_id": userId,
        "message": testSecondarySchool,
      };
      print("➡️ Request Payload: ${jsonEncode(payload)}");

      final response = await dio.post(apiEndpoint, data: payload);
      expect(response.statusCode, anyOf(200, 201), reason: "Step 16 Error: ${response.data}");

      final data = response.data is Map<String, dynamic> ? response.data : <String, dynamic>{};
      print("Status: ${response.statusCode}");
      print("🤖 Bot Message: ${data["message"]}");
      print("📌 next_field: ${data["next_field"]}");
      print("📌 completed_section: ${data["completed_section"]}");
      print("==================================================\n");
    });

    // -------------------------------------------------------------------------
    // STEP 17: SEND SECONDARY (10th) BOARD
    // -------------------------------------------------------------------------
    test('Step 17: Send Secondary (10th) Board', () async {
      final userId = getActiveUserId();

      print("\n==================================================");
      print("👤 user_id: $userId");
      print("🔄 STEP 17: Sending Secondary (10th) Board '$testSecondaryBoard'");
      final payload = {
        "action": "send_message",
        "user_id": userId,
        "message": testSecondaryBoard,
      };
      print("➡️ Request Payload: ${jsonEncode(payload)}");

      final response = await dio.post(apiEndpoint, data: payload);
      expect(response.statusCode, anyOf(200, 201), reason: "Step 17 Error: ${response.data}");

      final data = response.data is Map<String, dynamic> ? response.data : <String, dynamic>{};
      print("Status: ${response.statusCode}");
      print("🤖 Bot Message: ${data["message"]}");
      print("📌 next_field: ${data["next_field"]}");
      print("📌 completed_section: ${data["completed_section"]}");
      print("==================================================\n");
    });

    // -------------------------------------------------------------------------
    // STEP 18: SEND SECONDARY (10th) YEAR OF PASSING
    // -------------------------------------------------------------------------
    test('Step 18: Send Secondary (10th) Year of Passing', () async {
      final userId = getActiveUserId();

      print("\n==================================================");
      print("👤 user_id: $userId");
      print("🔄 STEP 18: Sending Secondary (10th) Year of Passing '$testSecondaryYear'");
      final payload = {
        "action": "send_message",
        "user_id": userId,
        "message": testSecondaryYear,
      };
      print("➡️ Request Payload: ${jsonEncode(payload)}");

      final response = await dio.post(apiEndpoint, data: payload);
      expect(response.statusCode, anyOf(200, 201), reason: "Step 18 Error: ${response.data}");

      final data = response.data is Map<String, dynamic> ? response.data : <String, dynamic>{};
      print("Status: ${response.statusCode}");
      print("🤖 Bot Message: ${data["message"]}");
      print("📌 next_field: ${data["next_field"]}");
      print("📌 completed_section: ${data["completed_section"]}");
      print("==================================================\n");
    });

    // -------------------------------------------------------------------------
    // STEP 19: SEND SECONDARY (10th) PERCENTAGE
    // -------------------------------------------------------------------------
    test('Step 19: Send Secondary (10th) Percentage', () async {
      final userId = getActiveUserId();

      print("\n==================================================");
      print("👤 user_id: $userId");
      print("🔄 STEP 19: Sending Secondary (10th) Percentage '$testSecondaryPercentage'");
      final payload = {
        "action": "send_message",
        "user_id": userId,
        "message": testSecondaryPercentage,
      };
      print("➡️ Request Payload: ${jsonEncode(payload)}");

      final response = await dio.post(apiEndpoint, data: payload);
      expect(response.statusCode, anyOf(200, 201), reason: "Step 19 Error: ${response.data}");

      final data = response.data is Map<String, dynamic> ? response.data : <String, dynamic>{};
      print("Status: ${response.statusCode}");
      print("🤖 Bot Message: ${data["message"]}");
      print("📌 next_field: ${data["next_field"]}");
      print("📌 completed_section: ${data["completed_section"]}");
      print("==================================================\n");
    });

    // -------------------------------------------------------------------------
    // STEP 20: CONFIRM HIGHER SECONDARY (12th) SCHOOL
    // -------------------------------------------------------------------------
    test('Step 20: Confirm Higher Secondary (12th) School', () async {
      final userId = getActiveUserId();

      print("\n==================================================");
      print("👤 user_id: $userId");
      print("🔄 STEP 20: Confirming Higher Secondary '$testHigherSecondaryConfirm'");
      final payload = {
        "action": "send_message",
        "user_id": userId,
        "message": testHigherSecondaryConfirm,
      };
      print("➡️ Request Payload: ${jsonEncode(payload)}");

      final response = await dio.post(apiEndpoint, data: payload);
      expect(response.statusCode, anyOf(200, 201), reason: "Step 20 Error: ${response.data}");

      final data = response.data is Map<String, dynamic> ? response.data : <String, dynamic>{};
      print("Status: ${response.statusCode}");
      print("🤖 Bot Message: ${data["message"]}");
      print("📌 next_field: ${data["next_field"]}");
      print("📌 completed_section: ${data["completed_section"]}");
      print("==================================================\n");
    });

    // -------------------------------------------------------------------------
    // STEP 21: SEND HIGHER SECONDARY (12th) SCHOOL
    // -------------------------------------------------------------------------
    test('Step 21: Send Higher Secondary (12th) School', () async {
      final userId = getActiveUserId();

      print("\n==================================================");
      print("👤 user_id: $userId");
      print("🔄 STEP 21: Sending Higher Secondary School '$testHigherSecondarySchool'");
      final payload = {
        "action": "send_message",
        "user_id": userId,
        "message": testHigherSecondarySchool,
      };
      print("➡️ Request Payload: ${jsonEncode(payload)}");

      final response = await dio.post(apiEndpoint, data: payload);
      expect(response.statusCode, anyOf(200, 201), reason: "Step 21 Error: ${response.data}");

      final data = response.data is Map<String, dynamic> ? response.data : <String, dynamic>{};
      print("Status: ${response.statusCode}");
      print("🤖 Bot Message: ${data["message"]}");
      print("📌 next_field: ${data["next_field"]}");
      print("📌 completed_section: ${data["completed_section"]}");
      print("==================================================\n");
    });

    // -------------------------------------------------------------------------
    // STEP 22: SEND HIGHER SECONDARY (12th) BOARD
    // -------------------------------------------------------------------------
    test('Step 22: Send Higher Secondary (12th) Board', () async {
      final userId = getActiveUserId();

      print("\n==================================================");
      print("👤 user_id: $userId");
      print("🔄 STEP 22: Sending Higher Secondary Board '$testHigherSecondaryBoard'");
      final payload = {
        "action": "send_message",
        "user_id": userId,
        "message": testHigherSecondaryBoard,
      };
      print("➡️ Request Payload: ${jsonEncode(payload)}");

      final response = await dio.post(apiEndpoint, data: payload);
      expect(response.statusCode, anyOf(200, 201), reason: "Step 22 Error: ${response.data}");

      final data = response.data is Map<String, dynamic> ? response.data : <String, dynamic>{};
      print("Status: ${response.statusCode}");
      print("🤖 Bot Message: ${data["message"]}");
      print("📌 next_field: ${data["next_field"]}");
      print("📌 completed_section: ${data["completed_section"]}");
      print("==================================================\n");
    });

    // -------------------------------------------------------------------------
    // STEP 23: SEND HIGHER SECONDARY (12th) YEAR OF PASSING
    // -------------------------------------------------------------------------
    test('Step 23: Send Higher Secondary (12th) Year of Passing', () async {
      final userId = getActiveUserId();

      print("\n==================================================");
      print("👤 user_id: $userId");
      print("🔄 STEP 23: Sending Higher Secondary Year of Passing '$testHigherSecondaryYear'");
      final payload = {
        "action": "send_message",
        "user_id": userId,
        "message": testHigherSecondaryYear,
      };
      print("➡️ Request Payload: ${jsonEncode(payload)}");

      final response = await dio.post(apiEndpoint, data: payload);
      expect(response.statusCode, anyOf(200, 201), reason: "Step 23 Error: ${response.data}");

      final data = response.data is Map<String, dynamic> ? response.data : <String, dynamic>{};
      print("Status: ${response.statusCode}");
      print("🤖 Bot Message: ${data["message"]}");
      print("📌 next_field: ${data["next_field"]}");
      print("📌 completed_section: ${data["completed_section"]}");
      print("==================================================\n");
    });

    // -------------------------------------------------------------------------
    // STEP 24: SEND HIGHER SECONDARY (12th) PERCENTAGE
    // -------------------------------------------------------------------------
    test('Step 24: Send Higher Secondary (12th) Percentage', () async {
      final userId = getActiveUserId();

      print("\n==================================================");
      print("👤 user_id: $userId");
      print("🔄 STEP 24: Sending Higher Secondary Percentage '$testHigherSecondaryPercentage'");
      final payload = {
        "action": "send_message",
        "user_id": userId,
        "message": testHigherSecondaryPercentage,
      };
      print("➡️ Request Payload: ${jsonEncode(payload)}");

      final response = await dio.post(apiEndpoint, data: payload);
      expect(response.statusCode, anyOf(200, 201), reason: "Step 24 Error: ${response.data}");

      final data = response.data is Map<String, dynamic> ? response.data : <String, dynamic>{};
      print("Status: ${response.statusCode}");
      print("🤖 Bot Message: ${data["message"]}");
      print("📌 next_field: ${data["next_field"]}");
      print("📌 completed_section: ${data["completed_section"]}");
      print("==================================================\n");
    });

    // -------------------------------------------------------------------------
    // STEP 25: SEND COLLEGE DEGREE ('No')
    // -------------------------------------------------------------------------
    test('Step 25: Send College Degree', () async {
      final userId = getActiveUserId();

      print("\n==================================================");
      print("👤 user_id: $userId");
      print("🔄 STEP 25: Sending College Degree '$testCollegeDegree'");
      final payload = {
        "action": "send_message",
        "user_id": userId,
        "message": testCollegeDegree,
      };
      print("➡️ Request Payload: ${jsonEncode(payload)}");

      final response = await dio.post(apiEndpoint, data: payload);
      expect(response.statusCode, anyOf(200, 201), reason: "Step 25 Error: ${response.data}");

      final data = response.data is Map<String, dynamic> ? response.data : <String, dynamic>{};
      print("Status: ${response.statusCode}");
      print("🤖 Bot Message: ${data["message"]}");
      print("📌 next_field: ${data["next_field"]}");
      print("📌 completed_section: ${data["completed_section"]}");
      print("==================================================\n");
    });

    // -------------------------------------------------------------------------
    // STEP 26: SEND TECHNICAL SKILLS
    // -------------------------------------------------------------------------
    test('Step 26: Send Technical Skills', () async {
      final userId = getActiveUserId();

      print("\n==================================================");
      print("👤 user_id: $userId");
      print("🔄 STEP 26: Sending Technical Skills '$testTechnicalSkills'");
      final payload = {
        "action": "send_message",
        "user_id": userId,
        "message": testTechnicalSkills,
      };
      print("➡️ Request Payload: ${jsonEncode(payload)}");

      final response = await dio.post(apiEndpoint, data: payload);
      expect(response.statusCode, anyOf(200, 201), reason: "Step 26 Error: ${response.data}");

      final data = response.data is Map<String, dynamic> ? response.data : <String, dynamic>{};
      print("Status: ${response.statusCode}");
      print("🤖 Bot Message: ${data["message"]}");
      print("📌 next_field: ${data["next_field"]}");
      print("📌 completed_section: ${data["completed_section"]}");
      print("==================================================\n");
    });

    // -------------------------------------------------------------------------
    // STEP 27: SEND INTERNSHIPS ('No')
    // -------------------------------------------------------------------------
    test('Step 27: Send Internships', () async {
      final userId = getActiveUserId();

      print("\n==================================================");
      print("👤 user_id: $userId");
      print("🔄 STEP 27: Sending Internships '$testInternships'");
      final payload = {
        "action": "send_message",
        "user_id": userId,
        "message": testInternships,
      };
      print("➡️ Request Payload: ${jsonEncode(payload)}");

      final response = await dio.post(apiEndpoint, data: payload);
      expect(response.statusCode, anyOf(200, 201), reason: "Step 27 Error: ${response.data}");

      final data = response.data is Map<String, dynamic> ? response.data : <String, dynamic>{};
      print("Status: ${response.statusCode}");
      print("🤖 Bot Message: ${data["message"]}");
      print("📌 next_field: ${data["next_field"]}");
      print("📌 completed_section: ${data["completed_section"]}");
      print("==================================================\n");
    });

    // -------------------------------------------------------------------------
    // STEP 28: SEND PROJECTS ('No')
    // -------------------------------------------------------------------------
    test('Step 28: Send Projects', () async {
      final userId = getActiveUserId();

      print("\n==================================================");
      print("👤 user_id: $userId");
      print("🔄 STEP 28: Sending Projects '$testProjects'");
      final payload = {
        "action": "send_message",
        "user_id": userId,
        "message": testProjects,
      };
      print("➡️ Request Payload: ${jsonEncode(payload)}");

      final response = await dio.post(apiEndpoint, data: payload);
      expect(response.statusCode, anyOf(200, 201), reason: "Step 28 Error: ${response.data}");

      final data = response.data is Map<String, dynamic> ? response.data : <String, dynamic>{};
      print("Status: ${response.statusCode}");
      print("🤖 Bot Message: ${data["message"]}");
      print("📌 next_field: ${data["next_field"]}");
      print("📌 completed_section: ${data["completed_section"]}");
      print("==================================================\n");
    });

    // -------------------------------------------------------------------------
    // STEP 29: SEND PAPER PRESENTATIONS ('No')
    // -------------------------------------------------------------------------
    test('Step 29: Send Paper Presentations', () async {
      final userId = getActiveUserId();

      print("\n==================================================");
      print("👤 user_id: $userId");
      print("🔄 STEP 29: Sending Paper Presentations '$testPaperPresentations'");
      final payload = {
        "action": "send_message",
        "user_id": userId,
        "message": testPaperPresentations,
      };
      print("➡️ Request Payload: ${jsonEncode(payload)}");

      final response = await dio.post(apiEndpoint, data: payload);
      expect(response.statusCode, anyOf(200, 201), reason: "Step 29 Error: ${response.data}");

      final data = response.data is Map<String, dynamic> ? response.data : <String, dynamic>{};
      print("Status: ${response.statusCode}");
      print("🤖 Bot Message: ${data["message"]}");
      print("📌 next_field: ${data["next_field"]}");
      print("📌 completed_section: ${data["completed_section"]}");
      print("==================================================\n");
    });

    // -------------------------------------------------------------------------
    // STEP 30: SEND CERTIFICATIONS ('No')
    // -------------------------------------------------------------------------
    test('Step 30: Send Certifications', () async {
      final userId = getActiveUserId();

      print("\n==================================================");
      print("👤 user_id: $userId");
      print("🔄 STEP 30: Sending Certifications '$testCertifications'");
      final payload = {
        "action": "send_message",
        "user_id": userId,
        "message": testCertifications,
      };
      print("➡️ Request Payload: ${jsonEncode(payload)}");

      final response = await dio.post(apiEndpoint, data: payload);
      expect(response.statusCode, anyOf(200, 201), reason: "Step 30 Error: ${response.data}");

      final data = response.data is Map<String, dynamic> ? response.data : <String, dynamic>{};
      print("Status: ${response.statusCode}");
      print("🤖 Bot Message: ${data["message"]}");
      print("📌 next_field: ${data["next_field"]}");
      print("📌 completed_section: ${data["completed_section"]}");
      print("==================================================\n");
    });

    // -------------------------------------------------------------------------
    // STEP 31: SEND INDUSTRIAL VISITS ('No')
    // -------------------------------------------------------------------------
    test('Step 31: Send Industrial Visits', () async {
      final userId = getActiveUserId();

      print("\n==================================================");
      print("👤 user_id: $userId");
      print("🔄 STEP 31: Sending Industrial Visits '$testIndustrialVisits'");
      final payload = {
        "action": "send_message",
        "user_id": userId,
        "message": testIndustrialVisits,
      };
      print("➡️ Request Payload: ${jsonEncode(payload)}");

      final response = await dio.post(apiEndpoint, data: payload);
      expect(response.statusCode, anyOf(200, 201), reason: "Step 31 Error: ${response.data}");

      final data = response.data is Map<String, dynamic> ? response.data : <String, dynamic>{};
      print("Status: ${response.statusCode}");
      print("🤖 Bot Message: ${data["message"]}");
      print("📌 next_field: ${data["next_field"]}");
      print("📌 completed_section: ${data["completed_section"]}");
      print("==================================================\n");
    });

    // -------------------------------------------------------------------------
    // STEP 32: SEND WORKSHOPS ('No')
    // -------------------------------------------------------------------------
    test('Step 32: Send Workshops', () async {
      final userId = getActiveUserId();

      print("\n==================================================");
      print("👤 user_id: $userId");
      print("🔄 STEP 32: Sending Workshops '$testWorkshops'");
      final payload = {
        "action": "send_message",
        "user_id": userId,
        "message": testWorkshops,
      };
      print("➡️ Request Payload: ${jsonEncode(payload)}");

      final response = await dio.post(apiEndpoint, data: payload);
      expect(response.statusCode, anyOf(200, 201), reason: "Step 32 Error: ${response.data}");

      final data = response.data is Map<String, dynamic> ? response.data : <String, dynamic>{};
      print("Status: ${response.statusCode}");
      print("🤖 Bot Message: ${data["message"]}");
      print("📌 next_field: ${data["next_field"]}");
      print("📌 completed_section: ${data["completed_section"]}");
      print("==================================================\n");
    });

    // -------------------------------------------------------------------------
    // STEP 33: SEND PUBLICATIONS ('No')
    // -------------------------------------------------------------------------
    test('Step 33: Send Publications', () async {
      final userId = getActiveUserId();

      print("\n==================================================");
      print("👤 user_id: $userId");
      print("🔄 STEP 33: Sending Publications '$testPublications'");
      final payload = {
        "action": "send_message",
        "user_id": userId,
        "message": testPublications,
      };
      print("➡️ Request Payload: ${jsonEncode(payload)}");

      final response = await dio.post(apiEndpoint, data: payload);
      expect(response.statusCode, anyOf(200, 201), reason: "Step 33 Error: ${response.data}");

      final data = response.data is Map<String, dynamic> ? response.data : <String, dynamic>{};
      print("Status: ${response.statusCode}");
      print("🤖 Bot Message: ${data["message"]}");
      print("📌 next_field: ${data["next_field"]}");
      print("📌 completed_section: ${data["completed_section"]}");
      print("==================================================\n");
    });

    // -------------------------------------------------------------------------
    // STEP 34: SEND LEADERSHIP ('No')
    // -------------------------------------------------------------------------
    test('Step 34: Send Leadership', () async {
      final userId = getActiveUserId();

      print("\n==================================================");
      print("👤 user_id: $userId");
      print("🔄 STEP 34: Sending Leadership '$testLeadership'");
      final payload = {
        "action": "send_message",
        "user_id": userId,
        "message": testLeadership,
      };
      print("➡️ Request Payload: ${jsonEncode(payload)}");

      final response = await dio.post(apiEndpoint, data: payload);
      expect(response.statusCode, anyOf(200, 201), reason: "Step 34 Error: ${response.data}");

      final data = response.data is Map<String, dynamic> ? response.data : <String, dynamic>{};
      print("Status: ${response.statusCode}");
      print("🤖 Bot Message: ${data["message"]}");
      print("📌 next_field: ${data["next_field"]}");
      print("📌 completed_section: ${data["completed_section"]}");
      print("==================================================\n");
    });

    // -------------------------------------------------------------------------
    // STEP 35: SEND VOLUNTEER EXPERIENCE ('No')
    // -------------------------------------------------------------------------
    test('Step 35: Send Volunteer Experience', () async {
      final userId = getActiveUserId();

      print("\n==================================================");
      print("👤 user_id: $userId");
      print("🔄 STEP 35: Sending Volunteer Experience '$testVolunteerExperience'");
      final payload = {
        "action": "send_message",
        "user_id": userId,
        "message": testVolunteerExperience,
      };
      print("➡️ Request Payload: ${jsonEncode(payload)}");

      final response = await dio.post(apiEndpoint, data: payload);
      expect(response.statusCode, anyOf(200, 201), reason: "Step 35 Error: ${response.data}");

      final data = response.data is Map<String, dynamic> ? response.data : <String, dynamic>{};
      print("Status: ${response.statusCode}");
      print("🤖 Bot Message: ${data["message"]}");
      print("📌 next_field: ${data["next_field"]}");
      print("📌 completed_section: ${data["completed_section"]}");
      print("==================================================\n");
    });

    // -------------------------------------------------------------------------
    // STEP 36: SEND LANGUAGES
    // -------------------------------------------------------------------------
    test('Step 36: Send Languages', () async {
      final userId = getActiveUserId();

      print("\n==================================================");
      print("👤 user_id: $userId");
      print("🔄 STEP 36: Sending Languages '$testLanguages'");
      final payload = {
        "action": "send_message",
        "user_id": userId,
        "message": testLanguages,
      };
      print("➡️ Request Payload: ${jsonEncode(payload)}");

      final response = await dio.post(apiEndpoint, data: payload);
      expect(response.statusCode, anyOf(200, 201), reason: "Step 36 Error: ${response.data}");

      final data = response.data is Map<String, dynamic> ? response.data : <String, dynamic>{};
      print("Status: ${response.statusCode}");
      print("🤖 Bot Message: ${data["message"]}");
      print("📌 next_field: ${data["next_field"]}");
      print("📌 completed_section: ${data["completed_section"]}");
      print("==================================================\n");
    });

    // -------------------------------------------------------------------------
    // STEP 37: SEND AREAS OF INTEREST
    // -------------------------------------------------------------------------
    test('Step 37: Send Areas of Interest', () async {
      final userId = getActiveUserId();

      print("\n==================================================");
      print("👤 user_id: $userId");
      print("🔄 STEP 37: Sending Areas of Interest '$testAreasOfInterest'");
      final payload = {
        "action": "send_message",
        "user_id": userId,
        "message": testAreasOfInterest,
      };
      print("➡️ Request Payload: ${jsonEncode(payload)}");

      final response = await dio.post(apiEndpoint, data: payload);
      expect(response.statusCode, anyOf(200, 201), reason: "Step 37 Error: ${response.data}");

      final data = response.data is Map<String, dynamic> ? response.data : <String, dynamic>{};
      print("Status: ${response.statusCode}");
      print("🤖 Bot Message: ${data["message"]}");
      print("📌 next_field: ${data["next_field"]}");
      print("📌 completed_section: ${data["completed_section"]}");
      print("==================================================\n");
    });

    // -------------------------------------------------------------------------
    // STEP 38: SEND HOBBIES
    // -------------------------------------------------------------------------
    test('Step 38: Send Hobbies', () async {
      final userId = getActiveUserId();

      print("\n==================================================");
      print("👤 user_id: $userId");
      print("🔄 STEP 38: Sending Hobbies '$testHobbies'");
      final payload = {
        "action": "send_message",
        "user_id": userId,
        "message": testHobbies,
      };
      print("➡️ Request Payload: ${jsonEncode(payload)}");

      final response = await dio.post(apiEndpoint, data: payload);
      expect(response.statusCode, anyOf(200, 201), reason: "Step 38 Error: ${response.data}");

      print("Status: ${response.statusCode}");
      print("📩 STEP 38 RESPONSE RECEIVED:");
      print(const JsonEncoder.withIndent('  ').convert(response.data));
      print("==================================================\n");
      print("🛑 Stopped at Step 38 response. Ready for Step 39.");
    });
  });
}
