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

      print("Status: ${response.statusCode}");
      print("📩 STEP 13 RESPONSE RECEIVED:");
      print(const JsonEncoder.withIndent('  ').convert(response.data));
      print("==================================================\n");
      print("🛑 Stopped at Step 13 response. Ready for Step 14.");
    });
  });
}
