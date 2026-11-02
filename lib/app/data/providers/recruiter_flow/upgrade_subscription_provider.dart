import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:internsharks/app/core/utils/app_api_header.dart';
import 'package:internsharks/app/core/utils/app_api_urls.dart';
import 'package:internsharks/app/data/models/recruiter_flow/recruiter_subscription_plan_model.dart';
import 'package:internsharks/app/data/models/recruiter_flow/upgrade_subscription_model.dart';

class UpgradeSubscriptionProvider {
  final Dio client;

  UpgradeSubscriptionProvider({required this.client});

  int? _responseStatus;
  int get responseStatus => _responseStatus ?? 500;
  set responseStatus(int value) => _responseStatus = value;

  /// Fetch active recruiter subscription plans
  Future<RecruiterSubscriptionPlanModel> fetchSubscriptionPlans({
    String? recruiterId,
  }) async {
    final header = await AppApiHeader.recruiterHeader();
    try {
      client.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );

      final queryParams = <String, dynamic>{
        if (recruiterId != null && recruiterId.isNotEmpty)
          'recruiterId': recruiterId,
      };

      final response = await client
          .get(
            AppApiUrls.getRecruiterSubscriptionPlans,
            queryParameters: queryParams.isNotEmpty ? queryParams : null,
            options: Options(headers: header),
          )
          .timeout(const Duration(seconds: 60));

      responseStatus = response.statusCode ?? 200;
      return RecruiterSubscriptionPlanModel.fromJson(response.data);
    } on DioException catch (err) {
      responseStatus = err.response?.statusCode ?? 500;
      if (err.response?.data != null &&
          err.response!.data is Map<String, dynamic>) {
        return RecruiterSubscriptionPlanModel.fromJson(err.response!.data);
      }
      return RecruiterSubscriptionPlanModel(
        success: false,
        message: err.message ?? 'Failed to fetch subscription plans',
      );
    } catch (e) {
      debugPrint('[fetchSubscriptionPlans] Exception: $e');
      return RecruiterSubscriptionPlanModel(
        success: false,
        message: e.toString(),
      );
    }
  }

  /// Create upgrade subscription payment order
  /// POST /api/recruitersubscriptionplan/subscription/upgrade/order
  Future<UpgradeSubscriptionOrderModel> createUpgradeOrder({
    required String newPlanId,
    required String billingCycle,
  }) async {
    final header = await AppApiHeader.recruiterHeader();
    try {
      client.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );

      final body = {
        'newPlanId': newPlanId,
        'billingCycle': billingCycle,
      };

      debugPrint('★★★ Calling upgrade/order: $body ★★★');

      final response = await client
          .post(
            AppApiUrls.upgradeSubscriptionOrder,
            options: Options(headers: header),
            data: body,
          )
          .timeout(const Duration(seconds: 60));

      responseStatus = response.statusCode ?? 200;
      return UpgradeSubscriptionOrderModel.fromJson(response.data);
    } on DioException catch (err) {
      responseStatus = err.response?.statusCode ?? 500;
      if (err.response?.data != null &&
          err.response!.data is Map<String, dynamic>) {
        return UpgradeSubscriptionOrderModel.fromJson(err.response!.data);
      }
      return UpgradeSubscriptionOrderModel(
        success: false,
        message: err.message ?? 'Failed to create upgrade order',
      );
    } catch (e) {
      debugPrint('[createUpgradeOrder] Exception: $e');
      return UpgradeSubscriptionOrderModel(
        success: false,
        message: e.toString(),
      );
    }
  }

  /// Verify upgrade subscription payment
  /// POST /api/recruitersubscriptionplan/subscription/upgrade/verify
  Future<UpgradeSubscriptionVerifyModel> verifyUpgradePayment({
    required String orderId,
  }) async {
    final header = await AppApiHeader.recruiterHeader();
    try {
      client.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );

      final body = {
        'orderId': orderId,
      };

      debugPrint('★★★ Calling upgrade/verify: $body ★★★');

      final response = await client
          .post(
            AppApiUrls.upgradeSubscriptionVerify,
            options: Options(headers: header),
            data: body,
          )
          .timeout(const Duration(seconds: 60));

      responseStatus = response.statusCode ?? 200;
      return UpgradeSubscriptionVerifyModel.fromJson(response.data);
    } on DioException catch (err) {
      responseStatus = err.response?.statusCode ?? 500;
      if (err.response?.data != null &&
          err.response!.data is Map<String, dynamic>) {
        return UpgradeSubscriptionVerifyModel.fromJson(err.response!.data);
      }
      return UpgradeSubscriptionVerifyModel(
        success: false,
        message: err.message ?? 'Failed to verify subscription upgrade',
      );
    } catch (e) {
      debugPrint('[verifyUpgradePayment] Exception: $e');
      return UpgradeSubscriptionVerifyModel(
        success: false,
        message: e.toString(),
      );
    }
  }
}
