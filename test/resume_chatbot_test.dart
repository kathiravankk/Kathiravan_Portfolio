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
import 'package:internsharks/app/data/providers/student_login_provider.dart';
import 'package:internsharks/app/data/models/account/create_new_resume_model.dart';
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

/// Helper function using StudentLoginProvider.makeNewChatResume
Future<CreateNewChatResumeModel> sendStep(
  StudentLoginProvider provider,
  String stepTag,
  String message, {
  GroupTracker? tracker,
}) async {
  if (tracker != null && tracker.failed) {
    markTestSkipped("Skipped because a previous step in this group failed.");
    return CreateNewChatResumeModel();
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
    final CreateNewChatResumeModel model = await provider.makeNewChatResume(
      chatRequestData: payload,
    );

    expect(
      provider.responseStatus,
      anyOf(200, 201),
      reason: "$stepTag Error: status=${provider.responseStatus}",
    );

    print("Status: ${provider.responseStatus}");
    print("🤖 Bot Message: ${model.message}");
    print("📌 next_field: ${model.nextField}");
    print("📌 completed_section: ${model.completedSection}");
    if (model.collectedData != null) {
      print(
        "📤 Collected Data: ${jsonEncode(model.collectedData!.toJson())}",
      );
    }
    print("==================================================\n");
    return model;
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

  final StudentLoginProvider provider = StudentLoginProvider(client: dio);

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
          final CreateNewChatResumeModel model = await provider
              .makeNewChatResume(chatRequestData: {"action": "start_chat"});

          expect(
            provider.responseStatus,
            anyOf(200, 201),
            reason: "Server returned error: status=${provider.responseStatus}",
          );

          final String userId = model.userId ?? "";
          expect(userId, isNotEmpty, reason: "user_id should not be empty");

          // Save session so all subsequent steps can reuse it
          final File sessionFile = File('.chatbot_session.json');
          sessionFile.writeAsStringSync(jsonEncode({"user_id": userId}));

          print("Status: ${provider.responseStatus}");
          print("👤 user_id: $userId");
          print("🤖 Bot Message: ${model.message}");
          print("📌 next_field: ${model.nextField}");
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
        await sendStep(provider, "STEP 2", testFirstName, tracker: tracker);
      });

      test('Step 3: Send Surname / Last Name', () async {
        await sendStep(provider, "STEP 3", testLastName, tracker: tracker);
      });

      test('Step 4: Send Role', () async {
        await sendStep(provider, "STEP 4", testRole, tracker: tracker);
      });
    });

    group('3. Email Setup & Confirmation', () {
      final tracker = GroupTracker();

      test('Step 5: Send Email Address', () async {
        await sendStep(
          provider,
          "STEP 5",
          testDefaultEmail,
          tracker: tracker,
        );
      });

      test('Step 6: Confirm Email Address', () async {
        final model = await sendStep(
          provider,
          "STEP 6",
          testEmailConfirmation,
          tracker: tracker,
        );
        if (model.message != null && model.message!.isNotEmpty) {
          print(
            "✅ Part 1 completed! OTP has been sent to $testDefaultEmail",
          );
          print("👉 Now proceed with Part 2 (Step 7 onwards).");
        }
      });
    });
  });
}
