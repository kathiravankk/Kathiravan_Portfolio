// ignore_for_file: avoid_print
// =============================================================================
// RUNNING INSTRUCTIONS:
// 1. Run All Steps Together:
//    flutter test test/resume_chatbot_part2_test.dart --reporter=expanded
//
// 2. Run a Single Step (e.g. Step 11):
//    flutter test test/resume_chatbot_part2_test.dart --plain-name="Step 11" --reporter=expanded
//
// 3. Run a Specific Section Group (e.g. Education):
//    flutter test test/resume_chatbot_part2_test.dart --name="Education" --reporter=expanded
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
String testOtp = "5564";
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
String testCollegeDegree = "B.Sc";
String testCollegeStartYear = "2019";
String testCollegeEndYear = "2024";
String testCollegePercentage = "80";
String testCollegeFeild = "Computer Science";
String testCollegeName = "Einstein";
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
String testWorkshopDate = (sampleData["workshops"] as List)[0] == "date"
    ? "November 2024"
    : (sampleData["workshops"] as List)[0];

// Publications
String testPublicationsConfirm = "Yes";
String testPublicationTitle = (sampleData["publications"] as List)[0] == "title"
    ? "Cross-Platform App Performance in Flutter"
    : (sampleData["publications"] as List)[0];
String testPublicationDate = "November 2024 , Einstein College";

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

/// Tracker class to monitor if any step in a group has failed.
class GroupTracker {
  bool failed = false;
}

/// Helper function to execute a test step without repeating boilerplate.
/// If a prior step in the group failed, subsequent steps in the same group are skipped.
Future<Map<String, dynamic>> sendStep(
  Dio dio,
  String stepTag,
  String message, {
  GroupTracker? tracker,
}) async {
  if (tracker != null && tracker.failed) {
    markTestSkipped("Skipped because a previous step in this group failed.");
    return {};
  }

  final userId = getActiveUserId();

  print("\n==================================================");
  print("👤 user_id: $userId");
  print("🔄 $stepTag: Sending '$message'");
  final payload = {
    "action": "send_message",
    "user_id": userId,
    "message": message,
  };
  print("➡️ Request Payload: ${jsonEncode(payload)}");

  try {
    final response = await dio.post(apiEndpoint, data: payload);
    expect(
      response.statusCode,
      anyOf(200, 201),
      reason: "$stepTag Error: ${response.data}",
    );

    final data = response.data is Map<String, dynamic>
        ? response.data
        : <String, dynamic>{};
    print("Status: ${response.statusCode}");
    print("🤖 Bot Message: ${data["message"]}");
    print("📌 next_field: ${data["next_field"]}");
    print("📌 completed_section: ${data["completed_section"]}");
    if (data.containsKey("collected_data")) {
      print("📤 Collected Data: ${data["collected_data"]}");
    }
    print("==================================================\n");
    return data;
  } catch (e) {
    if (tracker != null) tracker.failed = true;
    rethrow;
  }
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
    group('1. Email OTP Verification', () {
      final tracker = GroupTracker();

      test('Step 7: Send Email OTP', () async {
        expect(
          testOtp,
          isNotEmpty,
          reason: "Set testOtp variable before running Step 7",
        );
        await sendStep(dio, "STEP 7", testOtp, tracker: tracker);
      });
    });

    group('2. Phone Number & OTP Verification', () {
      final tracker = GroupTracker();

      test('Step 8: Send Phone Number', () async {
        expect(
          testPhone,
          isNotEmpty,
          reason: "Set testPhone variable before running Step 8",
        );
        await sendStep(dio, "STEP 8", testPhone, tracker: tracker);
      });

      test('Step 9: Confirm Phone Number (Yes)', () async {
        await sendStep(dio, "STEP 9", testPhoneConfirmation, tracker: tracker);
      });

      test('Step 10: Send Phone OTP', () async {
        await sendStep(dio, "STEP 10", testPhoneOtp, tracker: tracker);
      });
    });

    group('3. Profile & Social Links', () {
      final tracker = GroupTracker();

      test('Step 11: Send Referral Code', () async {
        await sendStep(dio, "STEP 11", testRefcode, tracker: tracker);
      });

      test('Step 12: Send Location', () async {
        await sendStep(dio, "STEP 12", testLocation, tracker: tracker);
      });

      test('Step 13: Send LinkedIn', () async {
        await sendStep(dio, "STEP 13", testLinkedIn, tracker: tracker);
      });

      test('Step 14: Send GitHub', () async {
        await sendStep(dio, "STEP 14", testGithub, tracker: tracker);
      });

      test('Step 15: Send Summary Choice', () async {
        await sendStep(dio, "STEP 15", testSummaryChoice, tracker: tracker);
      });
    });

    group('4. Education (10th, 12th & College)', () {
      final tracker = GroupTracker();

      test('Step 16: Send Secondary (10th) School', () async {
        await sendStep(dio, "STEP 16", testSecondarySchool, tracker: tracker);
      });

      test('Step 17: Send Secondary (10th) Board', () async {
        await sendStep(dio, "STEP 17", testSecondaryBoard, tracker: tracker);
      });

      test('Step 18: Send Secondary (10th) Year of Passing', () async {
        await sendStep(dio, "STEP 18", testSecondaryYear, tracker: tracker);
      });

      test('Step 19: Send Secondary (10th) Percentage', () async {
        await sendStep(
          dio,
          "STEP 19",
          testSecondaryPercentage,
          tracker: tracker,
        );
      });

      test('Step 20: Confirm Higher Secondary (12th) School', () async {
        await sendStep(
          dio,
          "STEP 20",
          testHigherSecondaryConfirm,
          tracker: tracker,
        );
      });

      test('Step 21: Send Higher Secondary (12th) School', () async {
        await sendStep(
          dio,
          "STEP 21",
          testHigherSecondarySchool,
          tracker: tracker,
        );
      });

      test('Step 22: Send Higher Secondary (12th) Board', () async {
        await sendStep(
          dio,
          "STEP 22",
          testHigherSecondaryBoard,
          tracker: tracker,
        );
      });

      test('Step 23: Send Higher Secondary (12th) Year of Passing', () async {
        await sendStep(
          dio,
          "STEP 23",
          testHigherSecondaryYear,
          tracker: tracker,
        );
      });

      test('Step 24: Send Higher Secondary (12th) Percentage', () async {
        await sendStep(
          dio,
          "STEP 24",
          testHigherSecondaryPercentage,
          tracker: tracker,
        );
      });

      test('Step 25: Send College Degree', () async {
        await sendStep(dio, "STEP 25", testCollegeDegree, tracker: tracker);
      });

      test('Step 25b: Send College Field of Study', () async {
        await sendStep(dio, "STEP 25b", testCollegeFeild, tracker: tracker);
      });

      test('Step 25c: Send College Name', () async {
        await sendStep(dio, "STEP 25c", testCollegeName, tracker: tracker);
      });

      test('Step 25d: Send College Start Year', () async {
        await sendStep(dio, "STEP 25d", testCollegeStartYear, tracker: tracker);
      });

      test('Step 25e: Send College End Year', () async {
        await sendStep(dio, "STEP 25e", testCollegeEndYear, tracker: tracker);
      });

      test('Step 25f: Send College Percentage', () async {
        await sendStep(
          dio,
          "STEP 25f",
          testCollegePercentage,
          tracker: tracker,
        );
      });
    });

    group('5. Technical Skills & Internships', () {
      final tracker = GroupTracker();

      test('Step 26: Send Technical Skills', () async {
        await sendStep(dio, "STEP 26", testTechnicalSkills, tracker: tracker);
      });

      test('Step 27: Send Internships', () async {
        await sendStep(dio, "STEP 27", testInternships, tracker: tracker);
      });

      test('Step 28: Send Internship Role', () async {
        await sendStep(dio, "STEP 28", testInternshipRole, tracker: tracker);
      });

      test('Step 29: Send Internship Start and End Dates', () async {
        await sendStep(dio, "STEP 29", testInternshipDates, tracker: tracker);
      });

      test('Step 30: Send Internship Description Choice', () async {
        await sendStep(
          dio,
          "STEP 30",
          testInternshipDescriptionChoice,
          tracker: tracker,
        );
      });
    });

    group('6. Projects & Paper Presentations', () {
      final tracker = GroupTracker();

      test('Step 31: Send Projects', () async {
        await sendStep(dio, "STEP 31", testProjects, tracker: tracker);
      });

      test('Step 32: Send Project Name', () async {
        await sendStep(dio, "STEP 32", testProjectName, tracker: tracker);
      });

      test('Step 33: Send Project Description Choice', () async {
        await sendStep(
          dio,
          "STEP 33",
          testProjectDescriptionChoice,
          tracker: tracker,
        );
      });

      test('Step 34: Confirm Paper Presentations', () async {
        await sendStep(
          dio,
          "STEP 34",
          testPaperPresentationsConfirm,
          tracker: tracker,
        );
      });

      test('Step 35: Send Paper Presentation Title', () async {
        await sendStep(
          dio,
          "STEP 35",
          testPaperPresentationTitle,
          tracker: tracker,
        );
      });

      test('Step 36: Send Paper Presentation Venue and Date', () async {
        await sendStep(
          dio,
          "STEP 36",
          testPaperPresentationVenueAndDate,
          tracker: tracker,
        );
      });

      test('Step 37: Send Paper Presentation Description Choice', () async {
        await sendStep(
          dio,
          "STEP 37",
          testPaperPresentationDescriptionChoice,
          tracker: tracker,
        );
      });
    });

    group('7. Certifications & Industrial Visits', () {
      final tracker = GroupTracker();

      test('Step 39: Confirm Certifications', () async {
        await sendStep(
          dio,
          "STEP 39",
          testCertificationsConfirm,
          tracker: tracker,
        );
      });

      test('Step 40: Send Certification Name', () async {
        await sendStep(dio, "STEP 40", testCertificationName, tracker: tracker);
      });

      test('Step 41: Send Certification Issuer', () async {
        await sendStep(
          dio,
          "STEP 41",
          testCertificationIssuer,
          tracker: tracker,
        );
      });

      test('Step 42: Send Certification Date', () async {
        await sendStep(dio, "STEP 42", testCertificationDate, tracker: tracker);
      });

      test('Step 43: Confirm Industrial Visits', () async {
        await sendStep(
          dio,
          "STEP 43",
          testIndustrialVisitsConfirm,
          tracker: tracker,
        );
      });

      test('Step 44: Send Industrial Visit Company', () async {
        await sendStep(
          dio,
          "STEP 44",
          testIndustrialVisitCompany,
          tracker: tracker,
        );
      });

      test('Step 45: Send Industrial Visit Location', () async {
        await sendStep(
          dio,
          "STEP 45",
          testIndustrialVisitLocation,
          tracker: tracker,
        );
      });

      test('Step 46: Send Industrial Visit Date', () async {
        await sendStep(
          dio,
          "STEP 46",
          testIndustrialVisitDate,
          tracker: tracker,
        );
      });
    });

    group('8. Workshops & Publications', () {
      final tracker = GroupTracker();

      test('Step 47: Confirm Workshops', () async {
        await sendStep(dio, "STEP 47", testWorkshopsConfirm, tracker: tracker);
      });

      test('Step 47a: Send Workshop Name', () async {
        await sendStep(dio, "STEP 47a", testWorkshopName, tracker: tracker);
      });

      test('Step 49: Send Workshop Date', () async {
        await sendStep(dio, "STEP 49", testWorkshopDate, tracker: tracker);
      });

       test('Step 50: Confirm Publication', () async {
        await sendStep(dio, "STEP 50", testPublicationsConfirm, tracker: tracker);
      });

      test('Step 50a: Send Publication Title', () async {
        await sendStep(dio, "STEP 50a", testPublicationTitle, tracker: tracker);
      });

      test('Step 50b: Send Publication Date and Venue', () async {
        await sendStep(dio, "STEP 50b", testPublicationDate, tracker: tracker);
      });
    });

    group('9. Leadership & Volunteer Experience', () {
      final tracker = GroupTracker();

      test('Step 51: Confirm Leadership', () async {
        await sendStep(dio, "STEP 51", testLeadershipConfirm, tracker: tracker);
      });

      test('Step 52: Send Leadership Role', () async {
        await sendStep(dio, "STEP 52", testLeadershipRole, tracker: tracker);
      });

      test('Step 52b: Send Leadership Description Choice', () async {
        await sendStep(
          dio,
          "STEP 52b",
          testLeadershipDescriptionChoice,
          tracker: tracker,
        );
      });

      test('Step 53: Confirm Volunteer Experience', () async {
        await sendStep(
          dio,
          "STEP 53",
          testVolunteerExperienceConfirm,
          tracker: tracker,
        );
      });

      test('Step 54: Send Volunteer Experience Role', () async {
        await sendStep(dio, "STEP 54", testVolunteerRole, tracker: tracker);
      });

      test('Step 54b: Send Volunteer Experience Description Choice', () async {
        await sendStep(
          dio,
          "STEP 54b",
          testVolunteerDescriptionChoice,
          tracker: tracker,
        );
      });
    });

    group('10. Languages, Interests & Achievements', () {
      final tracker = GroupTracker();

      test('Step 55: Send Languages', () async {
        await sendStep(dio, "STEP 55", testLanguagesData, tracker: tracker);
      });

      test('Step 56: Send Areas of Interest', () async {
        await sendStep(
          dio,
          "STEP 56",
          testAreasOfInterestData,
          tracker: tracker,
        );
      });

      test('Step 57: Send Hobbies', () async {
        await sendStep(dio, "STEP 57", testHobbiesData, tracker: tracker);
      });

      test('Step 58: Confirm Achievements', () async {
        await sendStep(
          dio,
          "STEP 58",
          testAchievementsConfirm,
          tracker: tracker,
        );
      });

      test('Step 59: Send Achievement Description', () async {
        final data = await sendStep(
          dio,
          "STEP 59",
          testAchievementDescription,
          tracker: tracker,
        );
        print(const JsonEncoder.withIndent('  ').convert(data));
        print("🎉 Resume Chatbot Data Collection COMPLETE! (next_field: DONE)");
      });
    });
  });
}
