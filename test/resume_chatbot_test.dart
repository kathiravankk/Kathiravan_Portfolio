// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';

const String apiEndpoint = "https://dev.api.internsharks.ai/api/resumechatbot";

// Configurable Test Data Variables
String testFirstName = "Midhun";
String testLastName = "Raj";
String testRole = "Flutter Mobile Developer";
String testDefaultEmail = "midhunraj2113@gmail.com";
String testEmailConfirmation = "Yes";

void main() {
  final Dio dio = Dio(
    BaseOptions(
      headers: {"Content-Type": "application/json"},
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      validateStatus: (status) => true, // Don't throw on 4xx/5xx so we can print the response body
    ),
  );

  test('Resume Chatbot Step-by-Step Test with Interactive Terminal OTP', () async {
    print("\n🚀 STARTING CHATBOT INTERACTIVE TEST\n");

    // -------------------------------------------------------------------------
    // STEP 1: START CHAT
    // -------------------------------------------------------------------------
    print("==================================================");
    print("🔄 STEP 1: Sending action='start_chat'");
    final Response step1Res = await dio.post(
      apiEndpoint,
      data: {"action": "start_chat"},
    );

    print("Status: ${step1Res.statusCode}");
    print("📩 Response Body: ${step1Res.data}");

    expect(step1Res.statusCode, anyOf(200, 201),
        reason: "Server returned error: ${step1Res.data}");

    final Map<String, dynamic> step1Data = step1Res.data is Map<String, dynamic>
        ? step1Res.data
        : <String, dynamic>{};
    final String userId = step1Data["user_id"] ?? step1Data["userId"] ?? "";
    expect(userId, isNotEmpty);

    print("Status: ${step1Res.statusCode}");
    print("👤 user_id: $userId");
    print("🤖 Bot Message: ${step1Data["message"]}");
    print("📌 next_field: ${step1Data["next_field"]}");
    print("==================================================\n");

    // -------------------------------------------------------------------------
    // STEP 2: SEND NAME
    // -------------------------------------------------------------------------
    final Map<String, dynamic> step2Payload = {
      "action": "send_message",
      "user_id": userId,
      "message": testFirstName,
    };

    print("==================================================");
    print("🔄 STEP 2: Sending name '$testFirstName'");
    final Response step2Res = await dio.post(apiEndpoint, data: step2Payload);
    expect(step2Res.statusCode, anyOf(200, 201));

    final Map<String, dynamic> step2Data = step2Res.data;
    print("Status: ${step2Res.statusCode}");
    print("🤖 Bot Message: ${step2Data["message"]}");
    print("📌 next_field: ${step2Data["next_field"]}");
    print("📌 completed_section: ${step2Data["completed_section"]}");
    print("==================================================\n");

    // -------------------------------------------------------------------------
    // STEP 3: SEND SURNAME
    // -------------------------------------------------------------------------
    final Map<String, dynamic> step3Payload = {
      "action": "send_message",
      "user_id": userId,
      "message": testLastName,
    };

    print("==================================================");
    print("🔄 STEP 3: Sending surname '$testLastName'");
    final Response step3Res = await dio.post(apiEndpoint, data: step3Payload);
    expect(step3Res.statusCode, anyOf(200, 201));

    final Map<String, dynamic> step3Data = step3Res.data;
    print("Status: ${step3Res.statusCode}");
    print("🤖 Bot Message: ${step3Data["message"]}");
    print("📌 next_field: ${step3Data["next_field"]}");
    print("📌 completed_section: ${step3Data["completed_section"]}");
    print("==================================================\n");

    // -------------------------------------------------------------------------
    // STEP 4: SEND ROLE
    // -------------------------------------------------------------------------
    final Map<String, dynamic> step4Payload = {
      "action": "send_message",
      "user_id": userId,
      "message": testRole,
    };

    print("==================================================");
    print("🔄 STEP 4: Sending role '$testRole'");
    final Response step4Res = await dio.post(apiEndpoint, data: step4Payload);
    expect(step4Res.statusCode, anyOf(200, 201));

    final Map<String, dynamic> step4Data = step4Res.data;
    print("Status: ${step4Res.statusCode}");
    print("🤖 Bot Message: ${step4Data["message"]}");
    print("📌 next_field: ${step4Data["next_field"]}");
    print("📌 completed_section: ${step4Data["completed_section"]}");
    print("==================================================\n");

    // -------------------------------------------------------------------------
    // STEP 5: SEND EMAIL
    // -------------------------------------------------------------------------
    final Map<String, dynamic> step5Payload = {
      "action": "send_message",
      "user_id": userId,
      "message": testDefaultEmail,
    };

    print("==================================================");
    print("🔄 STEP 5: Sending email '$testDefaultEmail'");
    print("➡️ Request Payload: ${jsonEncode(step5Payload)}");

    final Response step5Res = await dio.post(apiEndpoint, data: step5Payload);
    expect(step5Res.statusCode, anyOf(200, 201));

    final Map<String, dynamic> step5Data = step5Res.data;
    print("Status: ${step5Res.statusCode}");
    print("🤖 Bot Message: ${step5Data["message"]}");
    print("📌 next_field: ${step5Data["next_field"]}");
    print("📌 completed_section: ${step5Data["completed_section"]}");
    print("==================================================\n");

    // -------------------------------------------------------------------------
    // STEP 6: CONFIRM EMAIL ADDRESS
    // -------------------------------------------------------------------------
    final Map<String, dynamic> step6Payload = {
      "action": "send_message",
      "user_id": userId,
      "message": testEmailConfirmation,
    };

    print("==================================================");
    print("🔄 STEP 6: Confirming email with '$testEmailConfirmation'");
    print("➡️ Request Payload: ${jsonEncode(step6Payload)}");

    final Response step6Res = await dio.post(apiEndpoint, data: step6Payload);
    expect(step6Res.statusCode, anyOf(200, 201));

    final Map<String, dynamic> step6Data = step6Res.data;
    print("Status: ${step6Res.statusCode}");
    print("🤖 Bot Message: ${step6Data["message"]}");
    print("📌 next_field: ${step6Data["next_field"]}");
    print("📌 completed_section: ${step6Data["completed_section"]}");
    print("==================================================\n");
  });
}
