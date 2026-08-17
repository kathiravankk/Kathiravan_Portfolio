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
// ✏️  Set this after receiving OTP from email, then run this test
// ---------------------------------------------------------------------------
String testOtp = "3417";
String testUserId = ""; // Leave empty to load from .chatbot_session.json

void main() {
  final Dio dio = Dio(
    BaseOptions(
      headers: {"Content-Type": "application/json"},
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      validateStatus: (status) => true,
    ),
  );

  test('Part 2 – Step 7: Send OTP and verify email', () async {
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

    print("\n🚀 PART 2: STEP 7 – OTP Verification\n");
    print("👤 Resuming session for user_id: $userId");

    // -------------------------------------------------------------------------
    // STEP 7: SEND OTP
    // -------------------------------------------------------------------------
    final Map<String, dynamic> step7Payload = {
      "action": "send_message",
      "user_id": userId,
      "message": testOtp,
    };

    print("==================================================");
    print("🔄 STEP 7: Sending OTP '$testOtp'");
    print("➡️ Request Payload: ${jsonEncode(step7Payload)}");

    final Response step7Res = await dio.post(apiEndpoint, data: step7Payload);
    expect(step7Res.statusCode, anyOf(200, 201));

    print("Status: ${step7Res.statusCode}");
    print("📩 STEP 7 RESPONSE RECEIVED:");
    print(const JsonEncoder.withIndent('  ').convert(step7Res.data));
    print("==================================================\n");
    print("🛑 Stopped at Step 7 response. Ready for Step 8.");
  });
}
