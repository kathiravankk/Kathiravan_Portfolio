import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import 'package:flutter_cashfree_pg_sdk/api/cfsession/cfsession.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfwebcheckoutpayment.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentgateway/cfpaymentgatewayservice.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfenums.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfexceptions.dart';
import 'package:internsharks/app/core/utils/app_api_urls.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/utils/asset_images.dart';
import 'package:internsharks/app/data/models/webinar/webinar_detail_model.dart';
import 'package:internsharks/app/data/providers/profile_provider.dart';
import 'package:internsharks/app/data/providers/webinar_provider.dart';
import 'package:internsharks/app/data/repositories/local_storage_service.dart';
import 'package:internsharks/app/modules/profile/controller/profile_controller.dart';
import 'package:internsharks/app/modules/webinar/controller/webinar_controller.dart';
import 'package:internsharks/app/modules/webinar/widgets/webinar_common_widgets.dart';
import 'package:internsharks/app/modules/webinar/widgets/webinar_content_sections.dart';
import 'package:internsharks/app/modules/webinar/widgets/webinar_countdown_card.dart';
import 'package:internsharks/app/modules/webinar/widgets/webinar_dialogs.dart';
import 'package:internsharks/app/modules/webinar/widgets/webinar_registration_modal.dart';

class WebinarDetailScreen extends StatefulWidget {
  final String? webinarId;

  const WebinarDetailScreen({super.key, this.webinarId});

  @override
  State<WebinarDetailScreen> createState() => _WebinarDetailScreenState();
}

class _WebinarDetailScreenState extends State<WebinarDetailScreen> {
  late final WebinarController webinarController;
  String effectiveWebinarId = '';
  String? studentId;
  String? studentName;
  String? studentEmail;
  String? studentMobile;
  String? studentCollege;
  final Set<String> _verifiedWebinarIds = <String>{};
  String? _lastRegisteredMobile;
  Timer? _joinTickerTimer;

  // Cashfree payment gateway service
  final CFPaymentGatewayService _cfPaymentGatewayService =
      CFPaymentGatewayService();
  Map<String, dynamic>? _pendingPaidRegistrationPayload;
  String? _pendingPaidStudentName;
  String? _pendingPaidStudentEmail;
  WebinarDetailData? _pendingWebinarDetail;

  @override
  void initState() {
    super.initState();
    _initCashFreeCallbacks();

    // 1. Resolve controller
    if (Get.isRegistered<WebinarController>()) {
      webinarController = Get.find<WebinarController>();
    } else {
      webinarController = Get.put(
        WebinarController(WebinarProvider(client: Dio())),
        permanent: true,
      );
    }

    // 2. Extract webinar ID from widget or Get.arguments
    if (widget.webinarId != null && widget.webinarId!.isNotEmpty) {
      effectiveWebinarId = widget.webinarId!;
    } else if (Get.arguments != null) {
      if (Get.arguments is String) {
        effectiveWebinarId = Get.arguments as String;
      } else if (Get.arguments is Map) {
        effectiveWebinarId =
            Get.arguments['webinarId'] ?? Get.arguments['id'] ?? '';
      }
    }

    // Default fallback to provided id if empty (e.g. testing)
    if (effectiveWebinarId.isEmpty) {
      effectiveWebinarId = "6abe2454646b8d0143a0a917";
    }

    // Ensure countdown starts immediately if detail is already cached
    if (webinarController.webinarDetail != null) {
      webinarController.initCountdownFromDetail(webinarController.webinarDetail!);
    }

    // Periodic ticker to automatically update join button status when the 10-minute threshold arrives
    _joinTickerTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (mounted) {
        setState(() {});
      }
    });

    // 3. Fetch webinar detail and profile on load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadWebinarData();
    });
  }

  @override
  void dispose() {
    _joinTickerTimer?.cancel();
    webinarController.stopCountdown();
    super.dispose();
  }

  /// Initialize Cashfree payment callbacks
  void _initCashFreeCallbacks() {
    _cfPaymentGatewayService.setCallback(
      // ── PAYMENT SUCCESS ──────────────────────────────────────────────────
      (orderId) async {
        debugPrint('[Cashfree Webinar] Payment success for orderId: $orderId');
        await _handleWebinarPaymentSuccess(orderId);
      },
      // ── PAYMENT FAILURE ──────────────────────────────────────────────────
      (orderId, error) {
        debugPrint(
          '[Cashfree Webinar] Payment failed for orderId: $orderId | error: $error',
        );
        _handleWebinarPaymentFailure(orderId.toString(), error);
      },
    );
  }

  /// Launch Cashfree Web Checkout sheet
  void _openCashFreeCheckout({
    required String orderId,
    required String paymentSessionId,
    String? environmentStr,
  }) {
    try {
      final CFEnvironment environment =
          (environmentStr?.toUpperCase() == "SANDBOX" ||
                  (environmentStr == null && AppApiUrls.baseUrl.contains("dev.")))
              ? CFEnvironment.SANDBOX
              : CFEnvironment.PRODUCTION;

      final session = CFSessionBuilder()
          .setEnvironment(environment)
          .setOrderId(orderId)
          .setPaymentSessionId(paymentSessionId)
          .build();

      final dropPayment = CFWebCheckoutPaymentBuilder()
          .setSession(session)
          .build();

      _cfPaymentGatewayService.doPayment(dropPayment);
    } on CFException catch (e) {
      Fluttertoast.showToast(
        msg: "Payment error: ${e.message}",
        backgroundColor: const Color(0xFFE11D48),
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error opening payment: $e",
        backgroundColor: const Color(0xFFE11D48),
      );
    }
  }

  /// Handle verified payment success and proceed to register webinar
  Future<void> _handleWebinarPaymentSuccess(String orderId) async {
    Fluttertoast.showToast(
      msg: "Payment successful. Verifying...",
      backgroundColor: const Color(0xFF10B981),
    );

    final verifyRes =
        await webinarController.verifyWebinarPayment(orderId: orderId);
    final bool isSuccess = verifyRes['success'] == true;

    if (isSuccess) {
      // If only payment is successful and verified, call registerWebinar API
      if (_pendingPaidRegistrationPayload != null) {
        final regRes = await webinarController
            .registerWebinar(_pendingPaidRegistrationPayload!);
        debugPrint('[WebinarDetail] registerWebinar response: $regRes');
      }

      // Refresh latest detail from server
      final effectiveId = _pendingWebinarDetail?.sId ?? effectiveWebinarId;
      await webinarController.fetchWebinarDetail(effectiveId);

      Fluttertoast.showToast(
        msg: "Registration completed successfully! 🎉",
        backgroundColor: const Color(0xFF10B981),
      );

      final savedDetail =
          _pendingWebinarDetail ?? webinarController.webinarDetail;
      final savedName = _pendingPaidStudentName ?? (studentName ?? '');
      final savedEmail = _pendingPaidStudentEmail ?? (studentEmail ?? '');

      // Reset pending state
      _pendingPaidRegistrationPayload = null;
      _pendingPaidStudentName = null;
      _pendingPaidStudentEmail = null;
      _pendingWebinarDetail = null;

      if (savedDetail != null && mounted) {
        _showRegistrationSuccessDialog(
          savedDetail,
          savedName,
          savedEmail,
        );
      }
    } else {
      Fluttertoast.showToast(
        msg: verifyRes['message'] ??
            "Payment verification failed. Please contact support with Order ID: $orderId",
        backgroundColor: const Color(0xFFE11D48),
      );
    }
  }

  /// Handle payment failure callback from Cashfree
  void _handleWebinarPaymentFailure(String orderId, String error) {
    Fluttertoast.showToast(
      msg: "Payment failed or cancelled: $error",
      backgroundColor: const Color(0xFFE11D48),
    );
  }

  Future<void> _loadUserProfile() async {
    try {
      studentId = await LocalStorageService.getStudentId();
      final stuMap = await LocalStorageService.getStudent();
      if (stuMap != null) {
        studentName ??=
            stuMap['studname'] ?? stuMap['name'] ?? stuMap['studentName'];
        studentMobile ??= stuMap['studmobileno'] ??
            stuMap['mobile'] ??
            stuMap['studentMobileNo'];
        studentEmail ??=
            stuMap['studemail'] ?? stuMap['email'] ?? stuMap['studEmail'];
      }

      if (studentId != null && studentId!.isNotEmpty) {
        final ProfileController profileCtrl =
            Get.isRegistered<ProfileController>()
                ? Get.find<ProfileController>()
                : Get.put(
                    ProfileController(ProfileProvider(client: Dio())),
                  );

        if (profileCtrl.profileDataModel.id == null ||
            profileCtrl.profileDataModel.id!.isEmpty) {
          await profileCtrl.getProfileData(studentId: studentId!);
        }

        final profile = profileCtrl.profileDataModel;
        if (profile.studentName != null && profile.studentName!.isNotEmpty) {
          studentName = profile.studentName;
        }
        if (profile.studEmail != null && profile.studEmail!.isNotEmpty) {
          studentEmail = profile.studEmail;
        }
        if (profile.studMobileNo != null && profile.studMobileNo!.isNotEmpty) {
          studentMobile = profile.studMobileNo;
        }
        if (profile.collegeName != null && profile.collegeName!.isNotEmpty) {
          studentCollege = profile.collegeName;
        }
      }
    } catch (e) {
      debugPrint("Error loading profile: $e");
    }
  }

  Future<void> _loadWebinarData() async {
    if (effectiveWebinarId.isNotEmpty) {
      await webinarController.fetchWebinarDetail(effectiveWebinarId);
    }
    await _loadUserProfile();
    webinarController.fetchColleges();
  }

  void _shareWebinar() {
    final detail = webinarController.webinarDetail;
    final title = detail?.title ?? "Webinar";
    final url =
        "https://dev.api.internsharks.ai/api/webinar/getwebinarbyid/$effectiveWebinarId";
    SharePlus.instance.share(
      ShareParams(
        text: "Join this exclusive webinar: '$title' on Internsharks!\n$url",
        subject: title,
      ),
    );
  }

  void _handleRegisterAction(WebinarDetailData detail) {
    if (detail.registration?.isRegistered == true) {
      _handleJoinWebinar(detail);
      return;
    }

    final bool isRegistrationClosed = webinarController.isTimerExpired ||
        (detail.allowRegistration == false &&
            !(detail.registration?.isRegistered ?? false));

    if (isRegistrationClosed) {
      Fluttertoast.showToast(
        msg: "Registration for this webinar has ended.",
        backgroundColor: const Color(0xFF1E2E40),
      );
      return;
    }

    final bool isPaid = (detail.webinarType ?? '').toLowerCase() == 'paid' ||
        (detail.amount != null && detail.amount! > 0);

    // Open modular registration modal bottom sheet
    showWebinarRegistrationModal(
      context: context,
      detail: detail,
      isPaid: isPaid,
      studentId: studentId,
      studentName: studentName,
      studentEmail: studentEmail,
      studentMobile: studentMobile,
      studentCollege: studentCollege,
      webinarController: webinarController,
      onRegisterFree: (payload, name, email) async {
        final res = await webinarController.registerWebinar(payload);
        if (res['success'] == true) {
          _lastRegisteredMobile = payload['mobile']?.toString();
          final effectiveId = detail.sId ?? effectiveWebinarId;
          await webinarController.fetchWebinarDetail(effectiveId);
          final updatedDetail = webinarController.webinarDetail ?? detail;
          if (mounted) {
            _showRegistrationSuccessDialog(updatedDetail, name, email);
          }
        }
      },
      onProceedToPay: (payload, name, email) async {
        _pendingPaidRegistrationPayload = payload;
        _pendingPaidStudentName = name;
        _pendingPaidStudentEmail = email;
        _pendingWebinarDetail = detail;

        final effectiveStudId = payload['studentId'] ?? (studentId ?? "");
        final effectiveWebId = detail.sId ?? effectiveWebinarId;

        final paymentOrderRes =
            await webinarController.createWebinarPayment(
          webinarId: effectiveWebId,
          studentId: effectiveStudId,
        );

        if (paymentOrderRes['success'] == true &&
            paymentOrderRes['orderId'] != null &&
            paymentOrderRes['paymentSessionId'] != null) {
          _openCashFreeCheckout(
            orderId: paymentOrderRes['orderId'],
            paymentSessionId: paymentOrderRes['paymentSessionId'],
          );
        } else {
          Fluttertoast.showToast(
            msg: paymentOrderRes['message'] ??
                "Failed to create payment order.",
            backgroundColor: const Color(0xFFE11D48),
          );
        }
      },
    );
  }

  void _showRegistrationSuccessDialog(
    WebinarDetailData detail,
    String name,
    String email,
  ) {
    final bool canJoinNow = WebinarDateUtils.canJoinWebinar(detail);
    final int joinMinutes = WebinarDateUtils.getJoinBeforeMinutes(detail);
    showWebinarRegistrationSuccessDialog(
      context: context,
      detail: detail,
      name: name,
      email: email,
      canJoinNow: canJoinNow,
      joinMinutes: joinMinutes,
      onJoinTap: () => _handleJoinWebinar(detail),
    );
  }

  Future<void> _handleJoinWebinar(WebinarDetailData detail) async {
    final String wId = detail.sId ?? effectiveWebinarId;

    if (!WebinarDateUtils.canJoinWebinar(detail)) {
      final int minutesBefore = WebinarDateUtils.getJoinBeforeMinutes(detail);
      Fluttertoast.showToast(
        msg:
            "Webinar hasn't started yet. You can join $minutesBefore minutes before the start time.",
        backgroundColor: const Color(0xFF1E2E40),
      );
      return;
    }

    final bool verificationRequired =
        detail.join?.mobileVerificationRequired ?? true;
    final bool isVerified =
        (detail.isMobileVerified == true) || _verifiedWebinarIds.contains(wId);

    if (verificationRequired && !isVerified) {
      await _startMobileVerificationFlow(detail);
    } else {
      await _fetchAndShowMeetingLink(detail);
    }
  }

  Future<void> _startMobileVerificationFlow(WebinarDetailData detail) async {
    final String wId = detail.sId ?? effectiveWebinarId;
    String mobile = _lastRegisteredMobile ?? studentMobile ?? "";

    if (mobile.isEmpty) {
      mobile = await promptWebinarMobileNumber(context) ?? "";
      if (mobile.isEmpty) return;
      _lastRegisteredMobile = mobile;
    }

    final sendRes = await webinarController.sendWebinarOtp(wId, mobile);

    if (sendRes['success'] == false &&
        sendRes['message'] != null &&
        sendRes['otp'] == null) {
      Fluttertoast.showToast(
        msg: sendRes['message'] ?? "Failed to send OTP",
        backgroundColor: const Color(0xFFE11D48),
      );
      return;
    }

    final String? receivedOtp = sendRes['otp']?.toString();

    Fluttertoast.showToast(
      msg: sendRes['message'] ?? "OTP sent successfully",
      backgroundColor: const Color(0xFF10B981),
    );

    if (!mounted) return;
    showWebinarOtpVerificationDialog(
      context: context,
      detail: detail,
      mobile: mobile,
      webinarController: webinarController,
      initialOtp: receivedOtp,
      onVerifiedSuccess: () {
        _verifiedWebinarIds.add(wId);
        _fetchAndShowMeetingLink(detail);
      },
    );
  }

  Future<void> _fetchAndShowMeetingLink(WebinarDetailData detail) async {
    final String wId = detail.sId ?? effectiveWebinarId;
    final res = await webinarController.getMeetingLink(wId);

    if (res['success'] == true && res['meetingLink'] != null) {
      final String link = res['meetingLink'];
      if (!mounted) return;
      showWebinarLiveMeetingDialog(
        context: context,
        detail: detail,
        meetingLink: link,
      );
    } else {
      Fluttertoast.showToast(
        msg: res['message'] ??
            "Webinar link will be active closer to start time.",
        backgroundColor: const Color(0xFF1E2E40),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AssetImages.appBackgroundImg),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: AppColors.transparentColor,
        appBar: _buildCustomAppBar(),
        body: SafeArea(
          child: Obx(() {
            if (webinarController.detailLoading) {
              return const WebinarLoadingState();
            }

            final detail = webinarController.webinarDetail;
            if (detail == null) {
              return WebinarErrorState(
                errorMessage: webinarController.detailErrorMessage,
                onRetry: _loadWebinarData,
              );
            }

            return RefreshIndicator(
              color: AppColors.primaryColor,
              backgroundColor: const Color(0xFF111D28),
              onRefresh: _loadWebinarData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. HERO BANNER
                    WebinarBannerCard(
                      detail: detail,
                      webinarController: webinarController,
                    ),

                    const SizedBox(height: 18),

                    // 2. TITLE WITH ACCENT STYLING
                    WebinarStylizedTitle(title: detail.title ?? 'Webinar'),

                    if (detail.shortDescription != null &&
                        detail.shortDescription!.trim().isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Text(
                        detail.shortDescription!.trim(),
                        style: AppStyles.customTextStyle(
                          size: 13.5,
                          color: const Color(0xFF94A3B8),
                          lineSpace: 1.45,
                        ),
                      ),
                    ],

                    const SizedBox(height: 18),

                    // 3. REGISTRATION & COUNTDOWN TIMER CARD WITH ACTION BUTTON
                    WebinarRegistrationCountdownCard(
                      detail: detail,
                      webinarController: webinarController,
                      canJoinWebinar: WebinarDateUtils.canJoinWebinar(detail),
                      joinBeforeMinutes:
                          WebinarDateUtils.getJoinBeforeMinutes(detail),
                      onRegisterTap: () => _handleRegisterAction(detail),
                      onJoinTap: () => _handleJoinWebinar(detail),
                    ),

                    const SizedBox(height: 18),

                    // 4. THREE INFO CHIPS (Category, Type, Language)
                    WebinarThreeInfoChips(detail: detail),

                    const SizedBox(height: 12),

                    // 5. REGISTRATION START & END DATES ROW
                    WebinarRegistrationDatesRow(detail: detail),

                    const SizedBox(height: 10),

                    // 6. WEBINAR DATE & TIME ROW
                    WebinarScheduleRow(detail: detail),

                    const SizedBox(height: 22),

                    // 7. ABOUT THIS WEBINAR SECTION
                    WebinarAboutSection(detail: detail),

                    const SizedBox(height: 22),

                    // 8. SPEAKER SECTION
                    if (detail.speaker != null) ...[
                      WebinarSpeakerSection(speaker: detail.speaker!),
                      const SizedBox(height: 22),
                    ],

                    // 9. RELATED WEBINARS SECTION
                    if (detail.similarWebinars != null &&
                        detail.similarWebinars!.isNotEmpty) ...[
                      WebinarRelatedWebinarsSection(
                        list: detail.similarWebinars!,
                      ),
                      const SizedBox(height: 20),
                    ],

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildCustomAppBar() {
    return AppBar(
      backgroundColor: AppColors.transparentColor,
      elevation: 0,
      centerTitle: true,
      leading: Padding(
        padding: const EdgeInsets.only(left: 14),
        child: Center(
          child: InkWell(
            onTap: () => Navigator.of(context).pop(),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF141F24),
                border: Border.all(
                  color: const Color(0xFF22313A),
                  width: 1,
                ),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.whiteColor,
                size: 17,
              ),
            ),
          ),
        ),
      ),
      title: Text(
        "Webinar Details",
        style: AppStyles.customTextStyle(
          size: 18,
          weight: FontWeight.w700,
          color: AppColors.whiteColor,
        ),
      ),
      actions: [
        Center(
          child: Obx(() {
            final isSaved = webinarController.isBookmarked;
            return InkWell(
              onTap: () {
                webinarController.toggleBookmark();
                Fluttertoast.showToast(
                  msg: isSaved
                      ? "Removed from saved webinars"
                      : "Webinar saved successfully",
                  backgroundColor: const Color(0xFF1E2E40),
                  textColor: AppColors.whiteColor,
                );
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF141F24),
                  border: Border.all(
                    color: const Color(0xFF22313A),
                    width: 1,
                  ),
                ),
                child: Icon(
                  isSaved
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_border_rounded,
                  color: isSaved
                      ? AppColors.secondaryColor
                      : AppColors.whiteColor,
                  size: 20,
                ),
              ),
            );
          }),
        ),
        const SizedBox(width: 8),
        Center(
          child: InkWell(
            onTap: _shareWebinar,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF141F24),
                border: Border.all(
                  color: const Color(0xFF22313A),
                  width: 1,
                ),
              ),
              child: const Icon(
                Icons.share_outlined,
                color: AppColors.whiteColor,
                size: 19,
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),
      ],
    );
  }
}
