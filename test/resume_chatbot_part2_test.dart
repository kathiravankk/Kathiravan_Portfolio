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
import 'sample_data.dart';

const String apiEndpoint = "https://dev.api.internsharks.ai/api/resumechatbot";

// ---------------------------------------------------------------------------
// ✏️  Configurable Test Data Variables
// ---------------------------------------------------------------------------
String testOtp = "6790";
String testUserId = ""; // Leave empty to load from .chatbot_session.json
String testPhone = "9943155120"; //midhun
String testPhoneConfirmation = "Yes";
String testPhoneOtp = "1234";
String testRefcode = "No";
String testLocation = "Chennai";
String testLinkedIn = "https://www.linkedin.com/in/javid-akeel/";
String testGithub = "https://github.com/expectopatronam/";
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
String testCollegeDegree = "Add college degree";
String testCollegeDegreeDetails = "Bachelor of Science, Computer Science, Einstein College, 2019-2023, 65%";
String testTechnicalSkills = "Flutter, Dart, Firebase, REST API, Git, GetX";
String testInternships = "DTIT";
String testInternshipRole = "Flutter Developer Intern";
String testInternshipDates = "Jan 2023 - Jun 2023";
String testInternshipDescriptionChoice = "you generate";
String testProjects = "Yes";

// Projects & subsequent fields (from sampleData in test/sample_data.dart)
String testProjectName =
    (sampleData["projects"] as List)[0]["title"] ?? "No Network Game App";
String testProjectDescriptionChoice = "you generate";

// Paper Presentations
String testPaperPresentationsConfirm = "paper presentation";
String testPaperPresentationTitle =
    (sampleData["paper_presentations"] as List)[0]["title"] ?? "AI Chat App";
String testPaperPresentationEvent =
    (sampleData["paper_presentations"] as List)[0]["event"] ??
    "Einstein College";
String testPaperPresentationYear =
    (sampleData["paper_presentations"] as List)[0]["year"] ?? "August 2024";
String testPaperPresentationVenueAndDate =
    "$testPaperPresentationEvent, $testPaperPresentationYear";
String testPaperPresentationDescriptionChoice = "you generate";

// Certifications
String testCertificationsConfirm = "Yes";
String testCertificationName =
    (sampleData["certifications"] as List)[0]["name"] ??
    "Flutter Certification";
String testCertificationIssuer =
    (sampleData["certifications"] as List)[0]["issuer"] ?? "Udemy";
String testCertificationDate =
    (sampleData["certifications"] as List)[0]["date"] ?? "September 2024";

// Industrial Visits
String testIndustrialVisitsConfirm = "Yes";
String testIndustrialVisitCompany =
    (sampleData["industrial_visits"] as List)[0]["company"] ?? "Microsoft";
String testIndustrialVisitLocation =
    (sampleData["industrial_visits"] as List)[0]["location"] ?? "Chennai";
String testIndustrialVisitDate =
    (sampleData["industrial_visits"] as List)[0]["date"] ?? "October 2024";

// Workshops
String testWorkshopsConfirm = "Yes";
String testWorkshopName = (sampleData["workshops"] as List)[0] == "name"
    ? "Flutter Development Workshop"
    : (sampleData["workshops"] as List)[0];

// Publications
String testPublicationsConfirm = "Yes";
String testPublicationTitle = (sampleData["publications"] as List)[0] == "title"
    ? "Cross-Platform App Performance in Flutter"
    : (sampleData["publications"] as List)[0];
String testPublicationDate = "November 2024";

// Leadership
String testLeadershipConfirm = "Yes";
String testLeadershipRole = (sampleData["leadership"] as List)[0] == "role"
    ? "Team Lead"
    : (sampleData["leadership"] as List)[0];
String testLeadershipDescriptionChoice =
    "I lead a team of 5 ,mentoring juniors and ensuring deadlines";

// Volunteer Experience
String testVolunteerExperienceConfirm = "Yes";
String testVolunteerRole =
    (sampleData["volunteer_experience"] as List)[0] == "role"
    ? "NSS Volunteer"
    : (sampleData["volunteer_experience"] as List)[0];
String testVolunteerDescriptionChoice = "I helped clean the city";

// Languages, Areas of Interest, Hobbies
String testLanguagesData =
    ((sampleData["languages"] as List?) ?? ["Tamil", "English"]).join(", ");
String testAreasOfInterestData =
    ((sampleData["areas_of_interest"] as List?) ?? ["Mobile App Development"])
        .join(", ");
String testHobbiesData =
    ((sampleData["hobbies"] as List?) ?? ["Watching Cartoons"]).join(", ");

// Achievements
String testAchievementsConfirm = "Yes";
String testAchievementDescription =
    (sampleData["achievements"] as List)[0] ??
    "Won the first prize at Quiz competition";

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
    reason:
        "user_id is empty in .chatbot_session.json. Set testUserId manually or rerun Part 1.",
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
      expect(
        testOtp,
        isNotEmpty,
        reason: "Set testOtp variable before running Step 7",
      );

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
      expect(
        response.statusCode,
        anyOf(200, 201),
        reason: "Step 7 Error: ${response.data}",
      );

      final data = response.data is Map<String, dynamic>
          ? response.data
          : <String, dynamic>{};
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
      expect(
        testPhone,
        isNotEmpty,
        reason: "Set testPhone variable before running Step 8",
      );

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
      expect(
        response.statusCode,
        anyOf(200, 201),
        reason: "Step 8 Error: ${response.data}",
      );

      final data = response.data is Map<String, dynamic>
          ? response.data
          : <String, dynamic>{};
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
      expect(
        response.statusCode,
        anyOf(200, 201),
        reason: "Step 9 Error: ${response.data}",
      );

      final data = response.data is Map<String, dynamic>
          ? response.data
          : <String, dynamic>{};
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
      expect(
        testPhoneOtp,
        isNotEmpty,
        reason: "Set testPhoneOtp variable before running Step 10",
      );

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
      expect(
        response.statusCode,
        anyOf(200, 201),
        reason: "Step 10 Error: ${response.data}",
      );

      final data = response.data is Map<String, dynamic>
          ? response.data
          : <String, dynamic>{};
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
      expect(
        response.statusCode,
        anyOf(200, 201),
        reason: "Step 11 Error: ${response.data}",
      );

      final data = response.data is Map<String, dynamic>
          ? response.data
          : <String, dynamic>{};
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
      expect(
        response.statusCode,
        anyOf(200, 201),
        reason: "Step 12 Error: ${response.data}",
      );

      final data = response.data is Map<String, dynamic>
          ? response.data
          : <String, dynamic>{};
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
      expect(
        response.statusCode,
        anyOf(200, 201),
        reason: "Step 13 Error: ${response.data}",
      );

      final data = response.data is Map<String, dynamic>
          ? response.data
          : <String, dynamic>{};
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
      expect(
        response.statusCode,
        anyOf(200, 201),
        reason: "Step 14 Error: ${response.data}",
      );

      final data = response.data is Map<String, dynamic>
          ? response.data
          : <String, dynamic>{};
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
      expect(
        response.statusCode,
        anyOf(200, 201),
        reason: "Step 15 Error: ${response.data}",
      );

      final data = response.data is Map<String, dynamic>
          ? response.data
          : <String, dynamic>{};
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
      print(
        "🔄 STEP 16: Sending Secondary (10th) School '$testSecondarySchool'",
      );
      final payload = {
        "action": "send_message",
        "user_id": userId,
        "message": testSecondarySchool,
      };
      print("➡️ Request Payload: ${jsonEncode(payload)}");

      final response = await dio.post(apiEndpoint, data: payload);
      expect(
        response.statusCode,
        anyOf(200, 201),
        reason: "Step 16 Error: ${response.data}",
      );

      final data = response.data is Map<String, dynamic>
          ? response.data
          : <String, dynamic>{};
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
      expect(
        response.statusCode,
        anyOf(200, 201),
        reason: "Step 17 Error: ${response.data}",
      );

      final data = response.data is Map<String, dynamic>
          ? response.data
          : <String, dynamic>{};
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
      print(
        "🔄 STEP 18: Sending Secondary (10th) Year of Passing '$testSecondaryYear'",
      );
      final payload = {
        "action": "send_message",
        "user_id": userId,
        "message": testSecondaryYear,
      };
      print("➡️ Request Payload: ${jsonEncode(payload)}");

      final response = await dio.post(apiEndpoint, data: payload);
      expect(
        response.statusCode,
        anyOf(200, 201),
        reason: "Step 18 Error: ${response.data}",
      );

      final data = response.data is Map<String, dynamic>
          ? response.data
          : <String, dynamic>{};
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
      print(
        "🔄 STEP 19: Sending Secondary (10th) Percentage '$testSecondaryPercentage'",
      );
      final payload = {
        "action": "send_message",
        "user_id": userId,
        "message": testSecondaryPercentage,
      };
      print("➡️ Request Payload: ${jsonEncode(payload)}");

      final response = await dio.post(apiEndpoint, data: payload);
      expect(
        response.statusCode,
        anyOf(200, 201),
        reason: "Step 19 Error: ${response.data}",
      );

      final data = response.data is Map<String, dynamic>
          ? response.data
          : <String, dynamic>{};
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
      print(
        "🔄 STEP 20: Confirming Higher Secondary '$testHigherSecondaryConfirm'",
      );
      final payload = {
        "action": "send_message",
        "user_id": userId,
        "message": testHigherSecondaryConfirm,
      };
      print("➡️ Request Payload: ${jsonEncode(payload)}");

      final response = await dio.post(apiEndpoint, data: payload);
      expect(
        response.statusCode,
        anyOf(200, 201),
        reason: "Step 20 Error: ${response.data}",
      );

      final data = response.data is Map<String, dynamic>
          ? response.data
          : <String, dynamic>{};
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
      print(
        "🔄 STEP 21: Sending Higher Secondary School '$testHigherSecondarySchool'",
      );
      final payload = {
        "action": "send_message",
        "user_id": userId,
        "message": testHigherSecondarySchool,
      };
      print("➡️ Request Payload: ${jsonEncode(payload)}");

      final response = await dio.post(apiEndpoint, data: payload);
      expect(
        response.statusCode,
        anyOf(200, 201),
        reason: "Step 21 Error: ${response.data}",
      );

      final data = response.data is Map<String, dynamic>
          ? response.data
          : <String, dynamic>{};
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
      print(
        "🔄 STEP 22: Sending Higher Secondary Board '$testHigherSecondaryBoard'",
      );
      final payload = {
        "action": "send_message",
        "user_id": userId,
        "message": testHigherSecondaryBoard,
      };
      print("➡️ Request Payload: ${jsonEncode(payload)}");

      final response = await dio.post(apiEndpoint, data: payload);
      expect(
        response.statusCode,
        anyOf(200, 201),
        reason: "Step 22 Error: ${response.data}",
      );

      final data = response.data is Map<String, dynamic>
          ? response.data
          : <String, dynamic>{};
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
      print(
        "🔄 STEP 23: Sending Higher Secondary Year of Passing '$testHigherSecondaryYear'",
      );
      final payload = {
        "action": "send_message",
        "user_id": userId,
        "message": testHigherSecondaryYear,
      };
      print("➡️ Request Payload: ${jsonEncode(payload)}");

      final response = await dio.post(apiEndpoint, data: payload);
      expect(
        response.statusCode,
        anyOf(200, 201),
        reason: "Step 23 Error: ${response.data}",
      );

      final data = response.data is Map<String, dynamic>
          ? response.data
          : <String, dynamic>{};
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
      print(
        "🔄 STEP 24: Sending Higher Secondary Percentage '$testHigherSecondaryPercentage'",
      );
      final payload = {
        "action": "send_message",
        "user_id": userId,
        "message": testHigherSecondaryPercentage,
      };
      print("➡️ Request Payload: ${jsonEncode(payload)}");

      final response = await dio.post(apiEndpoint, data: payload);
      expect(
        response.statusCode,
        anyOf(200, 201),
        reason: "Step 24 Error: ${response.data}",
      );

      final data = response.data is Map<String, dynamic>
          ? response.data
          : <String, dynamic>{};
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
      expect(
        response.statusCode,
        anyOf(200, 201),
        reason: "Step 25 Error: ${response.data}",
      );

      final data = response.data is Map<String, dynamic>
          ? response.data
          : <String, dynamic>{};
      print("Status: ${response.statusCode}");
      print("🤖 Bot Message: ${data["message"]}");
      print("📌 next_field: ${data["next_field"]}");
      print("📌 completed_section: ${data["completed_section"]}");
      print("==================================================\n");
    });

    // -------------------------------------------------------------------------
    // STEP 25b: SEND COLLEGE DEGREE DETAILS
    // -------------------------------------------------------------------------
    test('Step 25b: Send College Degree Details', () async {
      final userId = getActiveUserId();

      print("\n==================================================");
      print("👤 user_id: $userId");
      print(
        "🔄 STEP 25b: Sending College Degree Details '$testCollegeDegreeDetails'",
      );
      final payload = {
        "action": "send_message",
        "user_id": userId,
        "message": testCollegeDegreeDetails,
      };
      print("➡️ Request Payload: ${jsonEncode(payload)}");

      final response = await dio.post(apiEndpoint, data: payload);
      expect(
        response.statusCode,
        anyOf(200, 201),
        reason: "Step 25b Error: ${response.data}",
      );

      final data = response.data is Map<String, dynamic>
          ? response.data
          : <String, dynamic>{};
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
      expect(
        response.statusCode,
        anyOf(200, 201),
        reason: "Step 26 Error: ${response.data}",
      );

      final data = response.data is Map<String, dynamic>
          ? response.data
          : <String, dynamic>{};
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
      expect(
        response.statusCode,
        anyOf(200, 201),
        reason: "Step 27 Error: ${response.data}",
      );

      final data = response.data is Map<String, dynamic>
          ? response.data
          : <String, dynamic>{};
      print("Status: ${response.statusCode}");
      print("🤖 Bot Message: ${data["message"]}");
      print("📌 next_field: ${data["next_field"]}");
      print("📌 completed_section: ${data["completed_section"]}");
      print("==================================================\n");
    });

    // -------------------------------------------------------------------------
    // STEP 28: SEND INTERNSHIP ROLE
    // -------------------------------------------------------------------------
    test('Step 28: Send Internship Role', () async {
      final userId = getActiveUserId();

      print("\n==================================================");
      print("👤 user_id: $userId");
      print("🔄 STEP 28: Sending Internship Role '$testInternshipRole'");
      final payload = {
        "action": "send_message",
        "user_id": userId,
        "message": testInternshipRole,
      };
      print("➡️ Request Payload: ${jsonEncode(payload)}");

      final response = await dio.post(apiEndpoint, data: payload);
      expect(
        response.statusCode,
        anyOf(200, 201),
        reason: "Step 28 Error: ${response.data}",
      );

      final data = response.data is Map<String, dynamic>
          ? response.data
          : <String, dynamic>{};
      print("Status: ${response.statusCode}");
      print("🤖 Bot Message: ${data["message"]}");
      print("📌 next_field: ${data["next_field"]}");
      print("📌 completed_section: ${data["completed_section"]}");
      print("==================================================\n");
    });

    // -------------------------------------------------------------------------
    // STEP 29: SEND INTERNSHIP START AND END DATES
    // -------------------------------------------------------------------------
    test('Step 29: Send Internship Start and End Dates', () async {
      final userId = getActiveUserId();

      print("\n==================================================");
      print("👤 user_id: $userId");
      print(
        "🔄 STEP 29: Sending Internship Start & End Dates '$testInternshipDates'",
      );
      final payload = {
        "action": "send_message",
        "user_id": userId,
        "message": testInternshipDates,
      };
      print("➡️ Request Payload: ${jsonEncode(payload)}");

      final response = await dio.post(apiEndpoint, data: payload);
      expect(
        response.statusCode,
        anyOf(200, 201),
        reason: "Step 29 Error: ${response.data}",
      );

      final data = response.data is Map<String, dynamic>
          ? response.data
          : <String, dynamic>{};
      print("Status: ${response.statusCode}");
      print("🤖 Bot Message: ${data["message"]}");
      print("📌 next_field: ${data["next_field"]}");
      print("📌 completed_section: ${data["completed_section"]}");
      print("==================================================\n");
    });

    // -------------------------------------------------------------------------
    // STEP 30: SEND INTERNSHIP DESCRIPTION CHOICE ('you generate')
    // -------------------------------------------------------------------------
    test('Step 30: Send Internship Description Choice', () async {
      final userId = getActiveUserId();

      print("\n==================================================");
      print("👤 user_id: $userId");
      print(
        "🔄 STEP 30: Sending Internship Description Choice '$testInternshipDescriptionChoice'",
      );
      final payload = {
        "action": "send_message",
        "user_id": userId,
        "message": testInternshipDescriptionChoice,
      };
      print("➡️ Request Payload: ${jsonEncode(payload)}");

      final response = await dio.post(apiEndpoint, data: payload);
      expect(
        response.statusCode,
        anyOf(200, 201),
        reason: "Step 30 Error: ${response.data}",
      );

      final data = response.data is Map<String, dynamic>
          ? response.data
          : <String, dynamic>{};
      print("Status: ${response.statusCode}");
      print("🤖 Bot Message: ${data["message"]}");
      print("📌 next_field: ${data["next_field"]}");
      print("📌 completed_section: ${data["completed_section"]}");
      print("==================================================\n");
    });

    // -------------------------------------------------------------------------
    // STEP 31: SEND PROJECTS ('Yes')
    // -------------------------------------------------------------------------
    test('Step 31: Send Projects', () async {
      final userId = getActiveUserId();

      print("\n==================================================");
      print("👤 user_id: $userId");
      print("🔄 STEP 31: Sending Projects '$testProjects'");
      final payload = {
        "action": "send_message",
        "user_id": userId,
        "message": testProjects,
      };
      print("➡️ Request Payload: ${jsonEncode(payload)}");

      final response = await dio.post(apiEndpoint, data: payload);
      expect(
        response.statusCode,
        anyOf(200, 201),
        reason: "Step 31 Error: ${response.data}",
      );

      final data = response.data is Map<String, dynamic>
          ? response.data
          : <String, dynamic>{};
      print("Status: ${response.statusCode}");
      print("🤖 Bot Message: ${data["message"]}");
      print("📌 next_field: ${data["next_field"]}");
      print("📌 completed_section: ${data["completed_section"]}");
      print("==================================================\n");
    });

    // -------------------------------------------------------------------------
    // STEP 32: SEND PROJECT NAME
    // -------------------------------------------------------------------------
    test('Step 32: Send Project Name', () async {
      final userId = getActiveUserId();

      print("\n==================================================");
      print("👤 user_id: $userId");
      print("🔄 STEP 32: Sending Project Name '$testProjectName'");
      final payload = {
        "action": "send_message",
        "user_id": userId,
        "message": testProjectName,
      };
      print("➡️ Request Payload: ${jsonEncode(payload)}");

      final response = await dio.post(apiEndpoint, data: payload);
      expect(
        response.statusCode,
        anyOf(200, 201),
        reason: "Step 32 Error: ${response.data}",
      );

      final data = response.data is Map<String, dynamic>
          ? response.data
          : <String, dynamic>{};
      print("Status: ${response.statusCode}");
      print("🤖 Bot Message: ${data["message"]}");
      print("📌 next_field: ${data["next_field"]}");
      print("📌 completed_section: ${data["completed_section"]}");
      print("==================================================\n");
    });

    // -------------------------------------------------------------------------
    // STEP 33: SEND PROJECT DESCRIPTION CHOICE ('you generate')
    // -------------------------------------------------------------------------
    test('Step 33: Send Project Description Choice', () async {
      final userId = getActiveUserId();

      print("\n==================================================");
      print("👤 user_id: $userId");
      print(
        "🔄 STEP 33: Sending Project Description Choice '$testProjectDescriptionChoice'",
      );
      final payload = {
        "action": "send_message",
        "user_id": userId,
        "message": testProjectDescriptionChoice,
      };
      print("➡️ Request Payload: ${jsonEncode(payload)}");

      final response = await dio.post(apiEndpoint, data: payload);
      expect(
        response.statusCode,
        anyOf(200, 201),
        reason: "Step 33 Error: ${response.data}",
      );

      final data = response.data is Map<String, dynamic>
          ? response.data
          : <String, dynamic>{};
      print("Status: ${response.statusCode}");
      print("🤖 Bot Message: ${data["message"]}");
      print("📌 next_field: ${data["next_field"]}");
      print("📌 completed_section: ${data["completed_section"]}");
      print("==================================================\n");
    });

    // -------------------------------------------------------------------------
    // STEP 34: CONFIRM PAPER PRESENTATIONS ('Yes')
    // -------------------------------------------------------------------------
    test('Step 34: Confirm Paper Presentations', () async {
      final userId = getActiveUserId();

      print("\n==================================================");
      print("👤 user_id: $userId");
      print(
        "🔄 STEP 34: Confirming Paper Presentations '$testPaperPresentationsConfirm'",
      );
      final payload = {
        "action": "send_message",
        "user_id": userId,
        "message": testPaperPresentationsConfirm,
      };
      print("➡️ Request Payload: ${jsonEncode(payload)}");

      final response = await dio.post(apiEndpoint, data: payload);
      expect(
        response.statusCode,
        anyOf(200, 201),
        reason: "Step 34 Error: ${response.data}",
      );

      final data = response.data is Map<String, dynamic>
          ? response.data
          : <String, dynamic>{};
      print("Status: ${response.statusCode}");
      print("🤖 Bot Message: ${data["message"]}");
      print("📌 next_field: ${data["next_field"]}");
      print("📌 completed_section: ${data["completed_section"]}");
      print("==================================================\n");
    });

    // -------------------------------------------------------------------------
    // STEP 35: SEND PAPER PRESENTATION TITLE
    // -------------------------------------------------------------------------
    test('Step 35: Send Paper Presentation Title', () async {
      final userId = getActiveUserId();

      print("\n==================================================");
      print("👤 user_id: $userId");
      print(
        "🔄 STEP 35: Sending Paper Presentation Title '$testPaperPresentationTitle'",
      );
      final payload = {
        "action": "send_message",
        "user_id": userId,
        "message": testPaperPresentationTitle,
      };
      print("➡️ Request Payload: ${jsonEncode(payload)}");

      final response = await dio.post(apiEndpoint, data: payload);
      expect(
        response.statusCode,
        anyOf(200, 201),
        reason: "Step 35 Error: ${response.data}",
      );

      final data = response.data is Map<String, dynamic>
          ? response.data
          : <String, dynamic>{};
      print("Status: ${response.statusCode}");
      print("🤖 Bot Message: ${data["message"]}");
      print("📌 next_field: ${data["next_field"]}");
      print("📌 completed_section: ${data["completed_section"]}");
      print("==================================================\n");
    });

    // -------------------------------------------------------------------------
    // STEP 36: SEND PAPER PRESENTATION VENUE & DATE
    // -------------------------------------------------------------------------
    test('Step 36: Send Paper Presentation Venue and Date', () async {
      final userId = getActiveUserId();

      print("\n==================================================");
      print("👤 user_id: $userId");
      print(
        "🔄 STEP 36: Sending Paper Presentation Venue and Date '$testPaperPresentationVenueAndDate'",
      );
      final payload = {
        "action": "send_message",
        "user_id": userId,
        "message": testPaperPresentationVenueAndDate,
      };
      print("➡️ Request Payload: ${jsonEncode(payload)}");

      final response = await dio.post(apiEndpoint, data: payload);
      expect(
        response.statusCode,
        anyOf(200, 201),
        reason: "Step 36 Error: ${response.data}",
      );

      final data = response.data is Map<String, dynamic>
          ? response.data
          : <String, dynamic>{};
      print("Status: ${response.statusCode}");
      print("🤖 Bot Message: ${data["message"]}");
      print("📌 next_field: ${data["next_field"]}");
      print("📌 completed_section: ${data["completed_section"]}");
      print("==================================================\n");
    });

    // -------------------------------------------------------------------------
    // STEP 37: SEND PAPER PRESENTATION DESCRIPTION CHOICE ('you generate')
    // -------------------------------------------------------------------------
    test('Step 37: Send Paper Presentation Description Choice', () async {
      final userId = getActiveUserId();

      print("\n==================================================");
      print("👤 user_id: $userId");
      print(
        "🔄 STEP 37: Sending Paper Presentation Description Choice '$testPaperPresentationDescriptionChoice'",
      );
      final payload = {
        "action": "send_message",
        "user_id": userId,
        "message": testPaperPresentationDescriptionChoice,
      };
      print("➡️ Request Payload: ${jsonEncode(payload)}");

      final response = await dio.post(apiEndpoint, data: payload);
      expect(
        response.statusCode,
        anyOf(200, 201),
        reason: "Step 37 Error: ${response.data}",
      );

      final data = response.data is Map<String, dynamic>
          ? response.data
          : <String, dynamic>{};
      print("Status: ${response.statusCode}");
      print("🤖 Bot Message: ${data["message"]}");
      print("📌 next_field: ${data["next_field"]}");
      print("📌 completed_section: ${data["completed_section"]}");
      print("==================================================\n");
    });

    // -------------------------------------------------------------------------
    // STEP 39: CONFIRM CERTIFICATIONS ('Yes')
    // -------------------------------------------------------------------------
    test('Step 39: Confirm Certifications', () async {
      final userId = getActiveUserId();

      print("\n==================================================");
      print("👤 user_id: $userId");
      print(
        "🔄 STEP 39: Confirming Certifications '$testCertificationsConfirm'",
      );
      final payload = {
        "action": "send_message",
        "user_id": userId,
        "message": testCertificationsConfirm,
      };
      print("➡️ Request Payload: ${jsonEncode(payload)}");

      final response = await dio.post(apiEndpoint, data: payload);
      expect(
        response.statusCode,
        anyOf(200, 201),
        reason: "Step 39 Error: ${response.data}",
      );

      final data = response.data is Map<String, dynamic>
          ? response.data
          : <String, dynamic>{};
      print("Status: ${response.statusCode}");
      print("🤖 Bot Message: ${data["message"]}");
      print("📌 next_field: ${data["next_field"]}");
      print("📌 completed_section: ${data["completed_section"]}");
      print("==================================================\n");
    });

    // -------------------------------------------------------------------------
    // STEP 40: SEND CERTIFICATION NAME
    // -------------------------------------------------------------------------
    test('Step 40: Send Certification Name', () async {
      final userId = getActiveUserId();

      print("\n==================================================");
      print("👤 user_id: $userId");
      print("🔄 STEP 40: Sending Certification Name '$testCertificationName'");
      final payload = {
        "action": "send_message",
        "user_id": userId,
        "message": testCertificationName,
      };
      print("➡️ Request Payload: ${jsonEncode(payload)}");

      final response = await dio.post(apiEndpoint, data: payload);
      expect(
        response.statusCode,
        anyOf(200, 201),
        reason: "Step 40 Error: ${response.data}",
      );

      final data = response.data is Map<String, dynamic>
          ? response.data
          : <String, dynamic>{};
      print("Status: ${response.statusCode}");
      print("🤖 Bot Message: ${data["message"]}");
      print("📌 next_field: ${data["next_field"]}");
      print("📌 completed_section: ${data["completed_section"]}");
      print("==================================================\n");
    });

    // -------------------------------------------------------------------------
    // STEP 41: SEND CERTIFICATION ISSUER
    // -------------------------------------------------------------------------
    test('Step 41: Send Certification Issuer', () async {
      final userId = getActiveUserId();

      print("\n==================================================");
      print("👤 user_id: $userId");
      print(
        "🔄 STEP 41: Sending Certification Issuer '$testCertificationIssuer'",
      );
      final payload = {
        "action": "send_message",
        "user_id": userId,
        "message": testCertificationIssuer,
      };
      print("➡️ Request Payload: ${jsonEncode(payload)}");

      final response = await dio.post(apiEndpoint, data: payload);
      expect(
        response.statusCode,
        anyOf(200, 201),
        reason: "Step 41 Error: ${response.data}",
      );

      final data = response.data is Map<String, dynamic>
          ? response.data
          : <String, dynamic>{};
      print("Status: ${response.statusCode}");
      print("🤖 Bot Message: ${data["message"]}");
      print("📌 next_field: ${data["next_field"]}");
      print("📌 completed_section: ${data["completed_section"]}");
      print("==================================================\n");
    });

    // -------------------------------------------------------------------------
    // STEP 42: SEND CERTIFICATION DATE
    // -------------------------------------------------------------------------
    test('Step 42: Send Certification Date', () async {
      final userId = getActiveUserId();

      print("\n==================================================");
      print("👤 user_id: $userId");
      print("🔄 STEP 42: Sending Certification Date '$testCertificationDate'");
      final payload = {
        "action": "send_message",
        "user_id": userId,
        "message": testCertificationDate,
      };
      print("➡️ Request Payload: ${jsonEncode(payload)}");

      final response = await dio.post(apiEndpoint, data: payload);
      expect(
        response.statusCode,
        anyOf(200, 201),
        reason: "Step 42 Error: ${response.data}",
      );

      final data = response.data is Map<String, dynamic>
          ? response.data
          : <String, dynamic>{};
      print("Status: ${response.statusCode}");
      print("🤖 Bot Message: ${data["message"]}");
      print("📌 next_field: ${data["next_field"]}");
      print("📌 completed_section: ${data["completed_section"]}");
      print("==================================================\n");
    });

    // -------------------------------------------------------------------------
    // STEP 43: CONFIRM INDUSTRIAL VISITS ('Yes')
    // -------------------------------------------------------------------------
    test('Step 43: Confirm Industrial Visits', () async {
      final userId = getActiveUserId();

      print("\n==================================================");
      print("👤 user_id: $userId");
      print(
        "🔄 STEP 43: Confirming Industrial Visits '$testIndustrialVisitsConfirm'",
      );
      final payload = {
        "action": "send_message",
        "user_id": userId,
        "message": testIndustrialVisitsConfirm,
      };
      print("➡️ Request Payload: ${jsonEncode(payload)}");

      final response = await dio.post(apiEndpoint, data: payload);
      expect(
        response.statusCode,
        anyOf(200, 201),
        reason: "Step 43 Error: ${response.data}",
      );

      final data = response.data is Map<String, dynamic>
          ? response.data
          : <String, dynamic>{};
      print("Status: ${response.statusCode}");
      print("🤖 Bot Message: ${data["message"]}");
      print("📌 next_field: ${data["next_field"]}");
      print("📌 completed_section: ${data["completed_section"]}");
      print("==================================================\n");
    });

    // -------------------------------------------------------------------------
    // STEP 44: SEND INDUSTRIAL VISIT COMPANY
    // -------------------------------------------------------------------------
    test('Step 44: Send Industrial Visit Company', () async {
      final userId = getActiveUserId();

      print("\n==================================================");
      print("👤 user_id: $userId");
      print(
        "🔄 STEP 44: Sending Industrial Visit Company '$testIndustrialVisitCompany'",
      );
      final payload = {
        "action": "send_message",
        "user_id": userId,
        "message": testIndustrialVisitCompany,
      };
      print("➡️ Request Payload: ${jsonEncode(payload)}");

      final response = await dio.post(apiEndpoint, data: payload);
      expect(
        response.statusCode,
        anyOf(200, 201),
        reason: "Step 44 Error: ${response.data}",
      );

      final data = response.data is Map<String, dynamic>
          ? response.data
          : <String, dynamic>{};
      print("Status: ${response.statusCode}");
      print("🤖 Bot Message: ${data["message"]}");
      print("📌 next_field: ${data["next_field"]}");
      print("📌 completed_section: ${data["completed_section"]}");
      print("==================================================\n");
    });

    // -------------------------------------------------------------------------
    // STEP 45: SEND INDUSTRIAL VISIT LOCATION
    // -------------------------------------------------------------------------
    test('Step 45: Send Industrial Visit Location', () async {
      final userId = getActiveUserId();

      print("\n==================================================");
      print("👤 user_id: $userId");
      print(
        "🔄 STEP 45: Sending Industrial Visit Location '$testIndustrialVisitLocation'",
      );
      final payload = {
        "action": "send_message",
        "user_id": userId,
        "message": testIndustrialVisitLocation,
      };
      print("➡️ Request Payload: ${jsonEncode(payload)}");

      final response = await dio.post(apiEndpoint, data: payload);
      expect(
        response.statusCode,
        anyOf(200, 201),
        reason: "Step 45 Error: ${response.data}",
      );

      final data = response.data is Map<String, dynamic>
          ? response.data
          : <String, dynamic>{};
      print("Status: ${response.statusCode}");
      print("🤖 Bot Message: ${data["message"]}");
      print("📌 next_field: ${data["next_field"]}");
      print("📌 completed_section: ${data["completed_section"]}");
      print("==================================================\n");
    });

    // -------------------------------------------------------------------------
    // STEP 46: SEND INDUSTRIAL VISIT DATE
    // -------------------------------------------------------------------------
    test('Step 46: Send Industrial Visit Date', () async {
      final userId = getActiveUserId();

      print("\n==================================================");
      print("👤 user_id: $userId");
      print(
        "🔄 STEP 46: Sending Industrial Visit Date '$testIndustrialVisitDate'",
      );
      final payload = {
        "action": "send_message",
        "user_id": userId,
        "message": testIndustrialVisitDate,
      };
      print("➡️ Request Payload: ${jsonEncode(payload)}");

      final response = await dio.post(apiEndpoint, data: payload);
      expect(
        response.statusCode,
        anyOf(200, 201),
        reason: "Step 46 Error: ${response.data}",
      );

      final data = response.data is Map<String, dynamic>
          ? response.data
          : <String, dynamic>{};
      print("Status: ${response.statusCode}");
      print("🤖 Bot Message: ${data["message"]}");
      print("📌 next_field: ${data["next_field"]}");
      print("📌 completed_section: ${data["completed_section"]}");
      print("==================================================\n");
    });

    // -------------------------------------------------------------------------
    // STEP 47: SEND WORKSHOP NAME
    // -------------------------------------------------------------------------
    test('Step 47: Send Workshop Name', () async {
      final userId = getActiveUserId();

      print("\n==================================================");
      print("👤 user_id: $userId");
      print("🔄 STEP 47: Sending Workshop Name '$testWorkshopName'");
      final payload = {
        "action": "send_message",
        "user_id": userId,
        "message": testWorkshopName,
      };
      print("➡️ Request Payload: ${jsonEncode(payload)}");

      final response = await dio.post(apiEndpoint, data: payload);
      expect(
        response.statusCode,
        anyOf(200, 201),
        reason: "Step 47 Error: ${response.data}",
      );

      final data = response.data is Map<String, dynamic>
          ? response.data
          : <String, dynamic>{};
      print("Status: ${response.statusCode}");
      print("🤖 Bot Message: ${data["message"]}");
      print("📌 next_field: ${data["next_field"]}");
      print("📌 completed_section: ${data["completed_section"]}");
      print("==================================================\n");
    });

    // -------------------------------------------------------------------------
    // STEP 49: CONFIRM PUBLICATIONS ('Yes')
    // -------------------------------------------------------------------------
    test('Step 49: Confirm Publications', () async {
      final userId = getActiveUserId();

      print("\n==================================================");
      print("👤 user_id: $userId");
      print("🔄 STEP 49: Confirming Publications '$testPublicationsConfirm'");
      final payload = {
        "action": "send_message",
        "user_id": userId,
        "message": testPublicationsConfirm,
      };
      print("➡️ Request Payload: ${jsonEncode(payload)}");

      final response = await dio.post(apiEndpoint, data: payload);
      expect(
        response.statusCode,
        anyOf(200, 201),
        reason: "Step 49 Error: ${response.data}",
      );

      final data = response.data is Map<String, dynamic>
          ? response.data
          : <String, dynamic>{};
      print("Status: ${response.statusCode}");
      print("🤖 Bot Message: ${data["message"]}");
      print("📌 next_field: ${data["next_field"]}");
      print("📌 completed_section: ${data["completed_section"]}");
      print("==================================================\n");
    });

    // -------------------------------------------------------------------------
    // STEP 50: SEND PUBLICATION TITLE
    // -------------------------------------------------------------------------
    test('Step 50: Send Publication Title', () async {
      final userId = getActiveUserId();

      print("\n==================================================");
      print("👤 user_id: $userId");
      print("🔄 STEP 50: Sending Publication Title '$testPublicationTitle'");
      final payload = {
        "action": "send_message",
        "user_id": userId,
        "message": testPublicationTitle,
      };
      print("➡️ Request Payload: ${jsonEncode(payload)}");

      final response = await dio.post(apiEndpoint, data: payload);
      expect(
        response.statusCode,
        anyOf(200, 201),
        reason: "Step 50 Error: ${response.data}",
      );

      final data = response.data is Map<String, dynamic>
          ? response.data
          : <String, dynamic>{};
      print("Status: ${response.statusCode}");
      print("🤖 Bot Message: ${data["message"]}");
      print("📌 next_field: ${data["next_field"]}");
      print("📌 completed_section: ${data["completed_section"]}");
      print("==================================================\n");
    });

    // -------------------------------------------------------------------------
    // STEP 50b: SEND PUBLICATION DATE
    // -------------------------------------------------------------------------
    test('Step 50b: Send Publication Date', () async {
      final userId = getActiveUserId();

      print("\n==================================================");
      print("👤 user_id: $userId");
      print("🔄 STEP 50b: Sending Publication Date '$testPublicationDate'");
      final payload = {
        "action": "send_message",
        "user_id": userId,
        "message": testPublicationDate,
      };
      print("➡️ Request Payload: ${jsonEncode(payload)}");

      final response = await dio.post(apiEndpoint, data: payload);
      expect(
        response.statusCode,
        anyOf(200, 201),
        reason: "Step 50b Error: ${response.data}",
      );

      final data = response.data is Map<String, dynamic>
          ? response.data
          : <String, dynamic>{};
      print("Status: ${response.statusCode}");
      print("🤖 Bot Message: ${data["message"]}");
      print("📌 next_field: ${data["next_field"]}");
      print("📌 completed_section: ${data["completed_section"]}");
      print("==================================================\n");
    });

    // -------------------------------------------------------------------------
    // STEP 51: CONFIRM LEADERSHIP ('Yes')
    // -------------------------------------------------------------------------
    test('Step 51: Confirm Leadership', () async {
      final userId = getActiveUserId();

      print("\n==================================================");
      print("👤 user_id: $userId");
      print("🔄 STEP 51: Confirming Leadership '$testLeadershipConfirm'");
      final payload = {
        "action": "send_message",
        "user_id": userId,
        "message": testLeadershipConfirm,
      };
      print("➡️ Request Payload: ${jsonEncode(payload)}");

      final response = await dio.post(apiEndpoint, data: payload);
      expect(
        response.statusCode,
        anyOf(200, 201),
        reason: "Step 51 Error: ${response.data}",
      );

      final data = response.data is Map<String, dynamic>
          ? response.data
          : <String, dynamic>{};
      print("Status: ${response.statusCode}");
      print("🤖 Bot Message: ${data["message"]}");
      print("📌 next_field: ${data["next_field"]}");
      print("📌 completed_section: ${data["completed_section"]}");
      print("==================================================\n");
    });

    // -------------------------------------------------------------------------
    // STEP 52: SEND LEADERSHIP ROLE
    // -------------------------------------------------------------------------
    test('Step 52: Send Leadership Role', () async {
      final userId = getActiveUserId();

      print("\n==================================================");
      print("👤 user_id: $userId");
      print("🔄 STEP 52: Sending Leadership Role '$testLeadershipRole'");
      final payload = {
        "action": "send_message",
        "user_id": userId,
        "message": testLeadershipRole,
      };
      print("➡️ Request Payload: ${jsonEncode(payload)}");

      final response = await dio.post(apiEndpoint, data: payload);
      expect(
        response.statusCode,
        anyOf(200, 201),
        reason: "Step 52 Error: ${response.data}",
      );

      final data = response.data is Map<String, dynamic>
          ? response.data
          : <String, dynamic>{};
      print("Status: ${response.statusCode}");
      print("🤖 Bot Message: ${data["message"]}");
      print("📌 next_field: ${data["next_field"]}");
      print("📌 completed_section: ${data["completed_section"]}");
      print("==================================================\n");
    });

    // -------------------------------------------------------------------------
    // STEP 52b: SEND LEADERSHIP DESCRIPTION CHOICE ('you generate')
    // -------------------------------------------------------------------------
    test('Step 52b: Send Leadership Description Choice', () async {
      final userId = getActiveUserId();

      print("\n==================================================");
      print("👤 user_id: $userId");
      print(
        "🔄 STEP 52b: Sending Leadership Description Choice '$testLeadershipDescriptionChoice'",
      );
      final payload = {
        "action": "send_message",
        "user_id": userId,
        "message": testLeadershipDescriptionChoice,
      };
      print("➡️ Request Payload: ${jsonEncode(payload)}");

      final response = await dio.post(apiEndpoint, data: payload);
      expect(
        response.statusCode,
        anyOf(200, 201),
        reason: "Step 52b Error: ${response.data}",
      );

      final data = response.data is Map<String, dynamic>
          ? response.data
          : <String, dynamic>{};
      print("Status: ${response.statusCode}");
      print("🤖 Bot Message: ${data["message"]}");
      print("📌 next_field: ${data["next_field"]}");
      print("📌 completed_section: ${data["completed_section"]}");
      print("==================================================\n");
    });

    // -------------------------------------------------------------------------
    // STEP 53: CONFIRM VOLUNTEER EXPERIENCE ('Yes')
    // -------------------------------------------------------------------------
    test('Step 53: Confirm Volunteer Experience', () async {
      final userId = getActiveUserId();

      print("\n==================================================");
      print("👤 user_id: $userId");
      print(
        "🔄 STEP 53: Confirming Volunteer Experience '$testVolunteerExperienceConfirm'",
      );
      final payload = {
        "action": "send_message",
        "user_id": userId,
        "message": testVolunteerExperienceConfirm,
      };
      print("➡️ Request Payload: ${jsonEncode(payload)}");

      final response = await dio.post(apiEndpoint, data: payload);
      expect(
        response.statusCode,
        anyOf(200, 201),
        reason: "Step 53 Error: ${response.data}",
      );

      final data = response.data is Map<String, dynamic>
          ? response.data
          : <String, dynamic>{};
      print("Status: ${response.statusCode}");
      print("🤖 Bot Message: ${data["message"]}");
      print("📌 next_field: ${data["next_field"]}");
      print("📌 completed_section: ${data["completed_section"]}");
      print("==================================================\n");
    });

    // -------------------------------------------------------------------------
    // STEP 54: SEND VOLUNTEER EXPERIENCE ROLE
    // -------------------------------------------------------------------------
    test('Step 54: Send Volunteer Experience Role', () async {
      final userId = getActiveUserId();

      print("\n==================================================");
      print("👤 user_id: $userId");
      print(
        "🔄 STEP 54: Sending Volunteer Experience Role '$testVolunteerRole'",
      );
      final payload = {
        "action": "send_message",
        "user_id": userId,
        "message": testVolunteerRole,
      };
      print("➡️ Request Payload: ${jsonEncode(payload)}");

      final response = await dio.post(apiEndpoint, data: payload);
      expect(
        response.statusCode,
        anyOf(200, 201),
        reason: "Step 54 Error: ${response.data}",
      );

      final data = response.data is Map<String, dynamic>
          ? response.data
          : <String, dynamic>{};
      print("Status: ${response.statusCode}");
      print("🤖 Bot Message: ${data["message"]}");
      print("📌 next_field: ${data["next_field"]}");
      print("📌 completed_section: ${data["completed_section"]}");
      print("==================================================\n");
    });

    // -------------------------------------------------------------------------
    // STEP 54b: SEND VOLUNTEER EXPERIENCE DESCRIPTION CHOICE ('you generate')
    // -------------------------------------------------------------------------
    test('Step 54b: Send Volunteer Experience Description Choice', () async {
      final userId = getActiveUserId();

      print("\n==================================================");
      print("👤 user_id: $userId");
      print(
        "🔄 STEP 54b: Sending Volunteer Experience Description Choice '$testVolunteerDescriptionChoice'",
      );
      final payload = {
        "action": "send_message",
        "user_id": userId,
        "message": testVolunteerDescriptionChoice,
      };
      print("➡️ Request Payload: ${jsonEncode(payload)}");

      final response = await dio.post(apiEndpoint, data: payload);
      expect(
        response.statusCode,
        anyOf(200, 201),
        reason: "Step 54b Error: ${response.data}",
      );

      final data = response.data is Map<String, dynamic>
          ? response.data
          : <String, dynamic>{};
      print("Status: ${response.statusCode}");
      print("🤖 Bot Message: ${data["message"]}");
      print("📌 next_field: ${data["next_field"]}");
      print("📌 completed_section: ${data["completed_section"]}");
      print("==================================================\n");
    });

    // -------------------------------------------------------------------------
    // STEP 55: SEND LANGUAGES
    // -------------------------------------------------------------------------
    test('Step 55: Send Languages', () async {
      final userId = getActiveUserId();

      print("\n==================================================");
      print("👤 user_id: $userId");
      print("🔄 STEP 55: Sending Languages '$testLanguagesData'");
      final payload = {
        "action": "send_message",
        "user_id": userId,
        "message": testLanguagesData,
      };
      print("➡️ Request Payload: ${jsonEncode(payload)}");

      final response = await dio.post(apiEndpoint, data: payload);
      expect(
        response.statusCode,
        anyOf(200, 201),
        reason: "Step 55 Error: ${response.data}",
      );

      final data = response.data is Map<String, dynamic>
          ? response.data
          : <String, dynamic>{};
      print("Status: ${response.statusCode}");
      print("🤖 Bot Message: ${data["message"]}");
      print("📌 next_field: ${data["next_field"]}");
      print("📌 completed_section: ${data["completed_section"]}");
      print("==================================================\n");
    });

    // -------------------------------------------------------------------------
    // STEP 56: SEND AREAS OF INTEREST
    // -------------------------------------------------------------------------
    test('Step 56: Send Areas of Interest', () async {
      final userId = getActiveUserId();

      print("\n==================================================");
      print("👤 user_id: $userId");
      print("🔄 STEP 56: Sending Areas of Interest '$testAreasOfInterestData'");
      final payload = {
        "action": "send_message",
        "user_id": userId,
        "message": testAreasOfInterestData,
      };
      print("➡️ Request Payload: ${jsonEncode(payload)}");

      final response = await dio.post(apiEndpoint, data: payload);
      expect(
        response.statusCode,
        anyOf(200, 201),
        reason: "Step 56 Error: ${response.data}",
      );

      final data = response.data is Map<String, dynamic>
          ? response.data
          : <String, dynamic>{};
      print("Status: ${response.statusCode}");
      print("🤖 Bot Message: ${data["message"]}");
      print("📌 next_field: ${data["next_field"]}");
      print("📌 completed_section: ${data["completed_section"]}");
      print("==================================================\n");
    });

    // -------------------------------------------------------------------------
    // STEP 57: SEND HOBBIES
    // -------------------------------------------------------------------------
    test('Step 57: Send Hobbies', () async {
      final userId = getActiveUserId();

      print("\n==================================================");
      print("👤 user_id: $userId");
      print("🔄 STEP 57: Sending Hobbies '$testHobbiesData'");
      final payload = {
        "action": "send_message",
        "user_id": userId,
        "message": testHobbiesData,
      };
      print("➡️ Request Payload: ${jsonEncode(payload)}");

      final response = await dio.post(apiEndpoint, data: payload);
      expect(
        response.statusCode,
        anyOf(200, 201),
        reason: "Step 57 Error: ${response.data}",
      );

      final data = response.data is Map<String, dynamic>
          ? response.data
          : <String, dynamic>{};
      print("Status: ${response.statusCode}");
      print("🤖 Bot Message: ${data["message"]}");
      print("📌 next_field: ${data["next_field"]}");
      print("📌 completed_section: ${data["completed_section"]}");
      print("==================================================\n");
    });

    // -------------------------------------------------------------------------
    // STEP 58: CONFIRM ACHIEVEMENTS ('Yes')
    // -------------------------------------------------------------------------
    test('Step 58: Confirm Achievements', () async {
      final userId = getActiveUserId();

      print("\n==================================================");
      print("👤 user_id: $userId");
      print("🔄 STEP 58: Confirming Achievements '$testAchievementsConfirm'");
      final payload = {
        "action": "send_message",
        "user_id": userId,
        "message": testAchievementsConfirm,
      };
      print("➡️ Request Payload: ${jsonEncode(payload)}");

      final response = await dio.post(apiEndpoint, data: payload);
      expect(
        response.statusCode,
        anyOf(200, 201),
        reason: "Step 58 Error: ${response.data}",
      );

      final data = response.data is Map<String, dynamic>
          ? response.data
          : <String, dynamic>{};
      print("Status: ${response.statusCode}");
      print("🤖 Bot Message: ${data["message"]}");
      print("📌 next_field: ${data["next_field"]}");
      print("📌 completed_section: ${data["completed_section"]}");
      print("==================================================\n");
    });

    // -------------------------------------------------------------------------
    // STEP 59: SEND ACHIEVEMENT DESCRIPTION
    // -------------------------------------------------------------------------
    test('Step 59: Send Achievement Description', () async {
      final userId = getActiveUserId();

      print("\n==================================================");
      print("👤 user_id: $userId");
      print(
        "🔄 STEP 59: Sending Achievement Description '$testAchievementDescription'",
      );
      final payload = {
        "action": "send_message",
        "user_id": userId,
        "message": testAchievementDescription,
      };
      print("➡️ Request Payload: ${jsonEncode(payload)}");

      final response = await dio.post(apiEndpoint, data: payload);
      expect(
        response.statusCode,
        anyOf(200, 201),
        reason: "Step 59 Error: ${response.data}",
      );

      print("Status: ${response.statusCode}");
      print("📩 STEP 59 RESPONSE RECEIVED:");
      print(const JsonEncoder.withIndent('  ').convert(response.data));
      print("==================================================\n");
      print("🎉 Resume Chatbot Data Collection COMPLETE! (next_field: DONE)");
    });
  });
}
