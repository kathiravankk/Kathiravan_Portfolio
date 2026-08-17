// ignore_for_file: avoid_print
// Run with: flutter test test/resume_chatbot_test_part2.dart --reporter=expanded
//
// PART 2: Step 7 onwards (OTP verification)
// Prerequisites:
//   1. Run Part 1 first: flutter test test/resume_chatbot_test.dart --reporter=expanded
//   2. Get OTP from your email
//   3. Set testOtp below, then run this file

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

void main() {
  final Dio dio = Dio(
    BaseOptions(
      headers: {"Content-Type": "application/json"},
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      validateStatus: (status) => true,
    ),
  );

  test('Part 2 – Steps 7 to 11: Verify Email OTP, Phone, Phone OTP, and Refcode', () async {
    String userId = testUserId.trim();

    if (userId.isEmpty) {
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
      userId = session["user_id"] ?? "";
    }

    expect(
      userId,
      isNotEmpty,
      reason: "user_id is empty. Provide testUserId or run Part 1.",
    );

    expect(
      testOtp,
      isNotEmpty,
      reason: "Set testOtp variable before running Part 2",
    );

    print("\n🚀 PART 2: STEP 7 to 11 – Chatbot Flow Verification\n");
    print("👤 Resuming session for user_id: $userId");

    // -------------------------------------------------------------------------
    // STEP 7: SEND EMAIL OTP
    // -------------------------------------------------------------------------
    final Map<String, dynamic> step7Payload = {
      "action": "send_message",
      "user_id": userId,
      "message": testOtp,
    };

    print("==================================================");
    print("🔄 STEP 7: Sending Email OTP '$testOtp'");
    print("➡️ Request Payload: ${jsonEncode(step7Payload)}");

    final Response step7Res = await dio.post(apiEndpoint, data: step7Payload);
    expect(step7Res.statusCode, anyOf(200, 201),
        reason: "Step 7 Error: ${step7Res.data}");

    final Map<String, dynamic> step7Data = step7Res.data is Map<String, dynamic>
        ? step7Res.data
        : <String, dynamic>{};
    print("Status: ${step7Res.statusCode}");
    print("🤖 Bot Message: ${step7Data["message"]}");
    print("📌 next_field: ${step7Data["next_field"]}");
    print("📌 completed_section: ${step7Data["completed_section"]}");
    print("==================================================\n");

    // -------------------------------------------------------------------------
    // STEP 8: SEND PHONE NUMBER
    // -------------------------------------------------------------------------
    final Map<String, dynamic> step8Payload = {
      "action": "send_message",
      "user_id": userId,
      "message": testPhone,
    };

    print("==================================================");
    print("🔄 STEP 8: Sending Phone Number '$testPhone'");
    print("➡️ Request Payload: ${jsonEncode(step8Payload)}");

    final Response step8Res = await dio.post(apiEndpoint, data: step8Payload);
    expect(step8Res.statusCode, anyOf(200, 201),
        reason: "Step 8 Error: ${step8Res.data}");

    final Map<String, dynamic> step8Data = step8Res.data is Map<String, dynamic>
        ? step8Res.data
        : <String, dynamic>{};
    print("Status: ${step8Res.statusCode}");
    print("🤖 Bot Message: ${step8Data["message"]}");
    print("📌 next_field: ${step8Data["next_field"]}");
    print("📌 completed_section: ${step8Data["completed_section"]}");
    print("==================================================\n");

    // -------------------------------------------------------------------------
    // STEP 9: CONFIRM PHONE NUMBER ('Yes')
    // -------------------------------------------------------------------------
    final Map<String, dynamic> step9Payload = {
      "action": "send_message",
      "user_id": userId,
      "message": testPhoneConfirmation,
    };

    print("==================================================");
    print("🔄 STEP 9: Confirming Phone with '$testPhoneConfirmation'");
    print("➡️ Request Payload: ${jsonEncode(step9Payload)}");

    final Response step9Res = await dio.post(apiEndpoint, data: step9Payload);
    expect(step9Res.statusCode, anyOf(200, 201),
        reason: "Step 9 Error: ${step9Res.data}");

    final Map<String, dynamic> step9Data = step9Res.data is Map<String, dynamic>
        ? step9Res.data
        : <String, dynamic>{};
    print("Status: ${step9Res.statusCode}");
    print("🤖 Bot Message: ${step9Data["message"]}");
    print("📌 next_field: ${step9Data["next_field"]}");
    print("📌 completed_section: ${step9Data["completed_section"]}");
    print("==================================================\n");

    // -------------------------------------------------------------------------
    // STEP 10: SEND PHONE OTP
    // -------------------------------------------------------------------------
    final Map<String, dynamic> step10Payload = {
      "action": "send_message",
      "user_id": userId,
      "message": testPhoneOtp,
    };

    print("==================================================");
    print("🔄 STEP 10: Sending Phone OTP '$testPhoneOtp'");
    print("➡️ Request Payload: ${jsonEncode(step10Payload)}");

    final Response step10Res = await dio.post(apiEndpoint, data: step10Payload);
    expect(step10Res.statusCode, anyOf(200, 201),
        reason: "Step 10 Error: ${step10Res.data}");

    final Map<String, dynamic> step10Data = step10Res.data is Map<String, dynamic>
        ? step10Res.data
        : <String, dynamic>{};
    print("Status: ${step10Res.statusCode}");
    print("🤖 Bot Message: ${step10Data["message"]}");
    print("📌 next_field: ${step10Data["next_field"]}");
    print("📌 completed_section: ${step10Data["completed_section"]}");
    print("==================================================\n");

    // -------------------------------------------------------------------------
    // STEP 11: SEND REFERRAL CODE ('No')
    // -------------------------------------------------------------------------
    final Map<String, dynamic> step11Payload = {
      "action": "send_message",
      "user_id": userId,
      "message": testRefcode,
    };

    print("==================================================");
    print("🔄 STEP 11: Sending Referral Code '$testRefcode'");
    print("➡️ Request Payload: ${jsonEncode(step11Payload)}");

    final Response step11Res = await dio.post(apiEndpoint, data: step11Payload);
    expect(step11Res.statusCode, anyOf(200, 201),
        reason: "Step 11 Error: ${step11Res.data}");

    print("Status: ${step11Res.statusCode}");
    print("📩 STEP 11 RESPONSE RECEIVED:");
    print(const JsonEncoder.withIndent('  ').convert(step11Res.data));
    print("==================================================\n");
    print("🛑 Stopped at Step 11 response. Ready for Step 12.");
  });
}
