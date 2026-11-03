import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:internsharks/app/core/utils/app_api_header.dart';
import 'package:internsharks/app/core/utils/app_api_urls.dart';
import 'package:internsharks/app/data/models/recruiter_flow/recruiter_subscription_order_model.dart';
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

  /// Create subscription payment order (for buying again or changing billing cycle)
  /// POST /api/recruitersubscriptionplan/create-subscription-order
  Future<RecruiterSubscriptionOrderModel> createSubscriptionOrder({
    String? subscriptionId,
    String? planId,
    String? billingCycle,
  }) async {
    final header = await AppApiHeader.recruiterHeader();
    try {
      client.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );

      final body = <String, dynamic>{
        if (subscriptionId != null && subscriptionId.isNotEmpty)
          'subscriptionId': subscriptionId,
        if (planId != null && planId.isNotEmpty) 'planId': planId,
        if (billingCycle != null && billingCycle.isNotEmpty)
          'billingCycle': billingCycle,
      };

      debugPrint('★★★ Calling create-subscription-order: $body ★★★');

      final response = await client
          .post(
            AppApiUrls.createSubscriptionOrder,
            options: Options(headers: header),
            data: body,
          )
          .timeout(const Duration(seconds: 45));

      responseStatus = response.statusCode ?? 200;
      return RecruiterSubscriptionOrderModel.fromJson(response.data);
    } on DioException catch (err) {
      responseStatus = err.response?.statusCode ?? 500;
      if (err.response?.data != null &&
          err.response!.data is Map<String, dynamic>) {
        return RecruiterSubscriptionOrderModel.fromJson(err.response!.data);
      }
      return RecruiterSubscriptionOrderModel(
        success: false,
        message: err.message ?? 'Failed to create subscription order',
      );
    } catch (e) {
      debugPrint('[createSubscriptionOrder] Exception: $e');
      return RecruiterSubscriptionOrderModel(
        success: false,
        message: e.toString(),
      );
    }
  }

  /// Verify subscription payment
  /// POST /api/recruitersubscriptionplan/verify-subscription-payment
  Future<RecruiterSubscriptionVerifyModel> verifySubscriptionPayment({
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

      debugPrint('★★★ Calling verify-subscription-payment: $body ★★★');

      final response = await client
          .post(
            AppApiUrls.verifySubscriptionPayment,
            options: Options(headers: header),
            data: body,
          )
          .timeout(const Duration(seconds: 45));

      responseStatus = response.statusCode ?? 200;
      return RecruiterSubscriptionVerifyModel.fromJson(response.data);
    } on DioException catch (err) {
      responseStatus = err.response?.statusCode ?? 500;
      if (err.response?.data != null &&
          err.response!.data is Map<String, dynamic>) {
        return RecruiterSubscriptionVerifyModel.fromJson(err.response!.data);
      }
      return RecruiterSubscriptionVerifyModel(
        success: false,
        message: err.message ?? 'Failed to verify subscription payment',
      );
    } catch (e) {
      debugPrint('[verifySubscriptionPayment] Exception: $e');
      return RecruiterSubscriptionVerifyModel(
        success: false,
        message: e.toString(),
      );
    }
  }
}
