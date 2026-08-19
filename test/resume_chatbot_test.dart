// ignore_for_file: avoid_print
// =============================================================================
// RUNNING INSTRUCTIONS:
// 1. Run All Steps Together:
//    flutter test test/resume_chatbot_test.dart --reporter=expanded
//
// 2. Run a Single Step (e.g. Step 1):
//    flutter test test/resume_chatbot_test.dart --plain-name="Step 1" --reporter=expanded
//
// 3. Run a Specific Group (e.g. Personal Information):
//    flutter test test/resume_chatbot_test.dart --name="Personal Information" --reporter=expanded
// =============================================================================

import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'sample_data.dart';

const String apiEndpoint = "https://dev.api.internsharks.ai/api/resumechatbot";

// ---------------------------------------------------------------------------
// ✏️  Configurable Test Data Variables (Part 1)
// ---------------------------------------------------------------------------
String testUserId = ""; // Leave empty to load from .chatbot_session.json
String testFirstName =
    (sampleData["personal_info"] as Map)["name"] ?? "Midhun";
String testLastName =
    (sampleData["personal_info"] as Map)["surname"] ?? "Raj";
String testRole =
    (sampleData["personal_info"] as Map)["role"] ?? "Flutter Developer";
String testDefaultEmail =
    (sampleData["personal_info"] as Map)["email"] ?? "midhunraj2113@gmail.com";
String testEmailConfirmation = "Yes";

String getActiveUserId() {
  final manualId = testUserId.trim();
  if (manualId.isNotEmpty) return manualId;

  final File sessionFile = File('.chatbot_session.json');
  expect(
    sessionFile.existsSync(),
    isTrue,
    reason:
        "No .chatbot_session.json found! Run Step 1 first or set testUserId.",
  );

  final session = jsonDecode(sessionFile.readAsStringSync());
  final sessionUserId =
      (session['user_id'] ?? session['userId'] ?? "").toString();
  expect(
    sessionUserId,
    isNotEmpty,
    reason: "user_id in .chatbot_session.json is empty!",
  );
  return sessionUserId;
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

  group('Resume Chatbot Part 1', () {
    group('1. Initial Session Setup', () {
      final tracker = GroupTracker();

      test('Step 1: Start Chat', () async {
        if (tracker.failed) {
          markTestSkipped("Skipped because a previous step failed.");
          return;
        }

        print("\n==================================================");
        print("🔄 STEP 1: Sending action='start_chat'");
        try {
          final Response step1Res = await dio.post(
            apiEndpoint,
            data: {"action": "start_chat"},
          );

          print("Status: ${step1Res.statusCode}");
          print("📩 Response Body: ${step1Res.data}");

          expect(
            step1Res.statusCode,
            anyOf(200, 201),
            reason: "Server returned error: ${step1Res.data}",
          );

          final Map<String, dynamic> step1Data =
              step1Res.data is Map<String, dynamic>
                  ? step1Res.data
                  : <String, dynamic>{};
          final String userId =
              step1Data["user_id"] ?? step1Data["userId"] ?? "";
          expect(userId, isNotEmpty, reason: "user_id should not be empty");

          // Save session so all subsequent steps can reuse it
          final File sessionFile = File('.chatbot_session.json');
          sessionFile.writeAsStringSync(jsonEncode({"user_id": userId}));

          print("👤 user_id: $userId");
          print("🤖 Bot Message: ${step1Data["message"]}");
          print("📌 next_field: ${step1Data["next_field"]}");
          print("💾 Saved user_id to .chatbot_session.json");
          print("==================================================\n");
        } catch (e) {
          tracker.failed = true;
          rethrow;
        }
      });
    });

    group('2. Personal Information', () {
      final tracker = GroupTracker();

      test('Step 2: Send First Name', () async {
        await sendStep(dio, "STEP 2", testFirstName, tracker: tracker);
      });

      test('Step 3: Send Surname / Last Name', () async {
        await sendStep(dio, "STEP 3", testLastName, tracker: tracker);
      });

      test('Step 4: Send Role', () async {
        await sendStep(dio, "STEP 4", testRole, tracker: tracker);
      });
    });

    group('3. Email Setup & Confirmation', () {
      final tracker = GroupTracker();

      test('Step 5: Send Email Address', () async {
        await sendStep(dio, "STEP 5", testDefaultEmail, tracker: tracker);
      });

      test('Step 6: Confirm Email Address', () async {
        final data = await sendStep(
          dio,
          "STEP 6",
          testEmailConfirmation,
          tracker: tracker,
        );
        if (data.isNotEmpty) {
          print(
            "✅ Part 1 completed! OTP has been sent to $testDefaultEmail",
          );
          print("👉 Now proceed with Part 2 (Step 7 onwards).");
        }
      });
    });
  });
}
