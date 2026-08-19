// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';

const String apiEndpoint = "https://dev.api.internsharks.ai/api/resumechatbot";

// ---------------------------------------------------------------------------
// ✏️  Configurable Test Data Variables (Part 1)
// ---------------------------------------------------------------------------
String testUserId = ""; // Leave empty to load from .chatbot_session.json
String testFirstName = "Midhun";
String testLastName = "Raj";
String testRole = "Flutter Mobile Developer";
String testDefaultEmail = "farrukjavid@gmail.com";
String testEmailConfirmation = "Yes";

String getActiveUserId() {
  final manualId = testUserId.trim();
  if (manualId.isNotEmpty) return manualId;

  final File sessionFile = File('.chatbot_session.json');
  expect(
    sessionFile.existsSync(),
    isTrue,
    reason: "No .chatbot_session.json found! Run Step 1 first or set testUserId.",
  );

  final session = jsonDecode(sessionFile.readAsStringSync());
  final sessionUserId = (session['user_id'] ?? session['userId'] ?? "").toString();
  expect(
    sessionUserId,
    isNotEmpty,
    reason: "user_id in .chatbot_session.json is empty!",
  );
  return sessionUserId;
}

void main() {
  final Dio dio = Dio(
    BaseOptions(
      headers: {"Content-Type": "application/json"},
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      validateStatus: (status) => true, // Don't throw on 4xx/5xx so we can print the response body
    ),
  );

  group('Resume Chatbot Part 1', () {
    // -------------------------------------------------------------------------
    // STEP 1: START CHAT
    // -------------------------------------------------------------------------
    test('Step 1: Start Chat', () async {
      print("\n==================================================");
      print("🔄 STEP 1: Sending action='start_chat'");
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

      final Map<String, dynamic> step1Data = step1Res.data is Map<String, dynamic>
          ? step1Res.data
          : <String, dynamic>{};
      final String userId = step1Data["user_id"] ?? step1Data["userId"] ?? "";
      expect(userId, isNotEmpty, reason: "user_id should not be empty");

      // Save session so all subsequent steps can reuse it
      final File sessionFile = File('.chatbot_session.json');
      sessionFile.writeAsStringSync(jsonEncode({"user_id": userId}));

      print("👤 user_id: $userId");
      print("🤖 Bot Message: ${step1Data["message"]}");
      print("📌 next_field: ${step1Data["next_field"]}");
      print("💾 Saved user_id to .chatbot_session.json");
      print("==================================================\n");
    });

    // -------------------------------------------------------------------------
    // STEP 2: SEND NAME
    // -------------------------------------------------------------------------
    test('Step 2: Send First Name', () async {
      final userId = getActiveUserId();

      print("\n==================================================");
      print("👤 user_id: $userId");
      print("🔄 STEP 2: Sending First Name '$testFirstName'");
      final payload = {
        "action": "send_message",
        "user_id": userId,
        "message": testFirstName,
      };
      print("➡️ Request Payload: ${jsonEncode(payload)}");

      final response = await dio.post(apiEndpoint, data: payload);
      expect(response.statusCode, anyOf(200, 201), reason: "Step 2 Error: ${response.data}");

      final data = response.data is Map<String, dynamic> ? response.data : <String, dynamic>{};
      print("Status: ${response.statusCode}");
      print("🤖 Bot Message: ${data["message"]}");
      print("📌 next_field: ${data["next_field"]}");
      print("📌 completed_section: ${data["completed_section"]}");
      print("==================================================\n");
    });

    // -------------------------------------------------------------------------
    // STEP 3: SEND SURNAME
    // -------------------------------------------------------------------------
    test('Step 3: Send Surname / Last Name', () async {
      final userId = getActiveUserId();

      print("\n==================================================");
      print("👤 user_id: $userId");
      print("🔄 STEP 3: Sending Surname '$testLastName'");
      final payload = {
        "action": "send_message",
        "user_id": userId,
        "message": testLastName,
      };
      print("➡️ Request Payload: ${jsonEncode(payload)}");

      final response = await dio.post(apiEndpoint, data: payload);
      expect(response.statusCode, anyOf(200, 201), reason: "Step 3 Error: ${response.data}");

      final data = response.data is Map<String, dynamic> ? response.data : <String, dynamic>{};
      print("Status: ${response.statusCode}");
      print("🤖 Bot Message: ${data["message"]}");
      print("📌 next_field: ${data["next_field"]}");
      print("📌 completed_section: ${data["completed_section"]}");
      print("==================================================\n");
    });

    // -------------------------------------------------------------------------
    // STEP 4: SEND ROLE
    // -------------------------------------------------------------------------
    test('Step 4: Send Role', () async {
      final userId = getActiveUserId();

      print("\n==================================================");
      print("👤 user_id: $userId");
      print("🔄 STEP 4: Sending Role '$testRole'");
      final payload = {
        "action": "send_message",
        "user_id": userId,
        "message": testRole,
      };
      print("➡️ Request Payload: ${jsonEncode(payload)}");

      final response = await dio.post(apiEndpoint, data: payload);
      expect(response.statusCode, anyOf(200, 201), reason: "Step 4 Error: ${response.data}");

      final data = response.data is Map<String, dynamic> ? response.data : <String, dynamic>{};
      print("Status: ${response.statusCode}");
      print("🤖 Bot Message: ${data["message"]}");
      print("📌 next_field: ${data["next_field"]}");
      print("📌 completed_section: ${data["completed_section"]}");
      print("==================================================\n");
    });

    // -------------------------------------------------------------------------
    // STEP 5: SEND EMAIL
    // -------------------------------------------------------------------------
    test('Step 5: Send Email Address', () async {
      final userId = getActiveUserId();

      print("\n==================================================");
      print("👤 user_id: $userId");
      print("🔄 STEP 5: Sending Email '$testDefaultEmail'");
      final payload = {
        "action": "send_message",
        "user_id": userId,
        "message": testDefaultEmail,
      };
      print("➡️ Request Payload: ${jsonEncode(payload)}");

      final response = await dio.post(apiEndpoint, data: payload);
      expect(response.statusCode, anyOf(200, 201), reason: "Step 5 Error: ${response.data}");

      final data = response.data is Map<String, dynamic> ? response.data : <String, dynamic>{};
      print("Status: ${response.statusCode}");
      print("🤖 Bot Message: ${data["message"]}");
      print("📌 next_field: ${data["next_field"]}");
      print("📌 completed_section: ${data["completed_section"]}");
      print("==================================================\n");
    });

    // -------------------------------------------------------------------------
    // STEP 6: CONFIRM EMAIL ADDRESS
    // -------------------------------------------------------------------------
    test('Step 6: Confirm Email Address', () async {
      final userId = getActiveUserId();

      print("\n==================================================");
      print("👤 user_id: $userId");
      print("🔄 STEP 6: Confirming Email '$testEmailConfirmation'");
      final payload = {
        "action": "send_message",
        "user_id": userId,
        "message": testEmailConfirmation,
      };
      print("➡️ Request Payload: ${jsonEncode(payload)}");

      final response = await dio.post(apiEndpoint, data: payload);
      expect(response.statusCode, anyOf(200, 201), reason: "Step 6 Error: ${response.data}");

      final data = response.data is Map<String, dynamic> ? response.data : <String, dynamic>{};
      print("Status: ${response.statusCode}");
      print("🤖 Bot Message: ${data["message"]}");
      print("📌 next_field: ${data["next_field"]}");
      print("📌 completed_section: ${data["completed_section"]}");
      print("==================================================\n");
      print("✅ Part 1 completed! OTP has been sent to $testDefaultEmail");
      print("👉 Now proceed with Part 2 (Step 7 onwards).");
    });
  });
}

