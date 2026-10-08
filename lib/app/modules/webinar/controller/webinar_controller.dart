import 'dart:async';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:internsharks/app/core/utils/app_functions.dart';
import 'package:internsharks/app/data/models/webinar/webinar_detail_model.dart';
import 'package:internsharks/app/data/models/webinar/webinar_model.dart';
import 'package:internsharks/app/data/providers/webinar_provider.dart';

class WebinarController extends GetxController {
  final WebinarProvider? webinarProvider;

  WebinarController(this.webinarProvider);

  int getResponseCode() => webinarProvider?.responseStatus ?? 0;

  // CAROUSEL ACTIVE INDEX
  final _carouselIndex = 0.obs;
  int get carouselIndex => _carouselIndex.value;
  set carouselIndex(int value) => _carouselIndex.value = value;

  // -------------------------------------------------------------
  // 1. UPCOMING WEBINARS (TOP ROW CAROUSEL)
  // -------------------------------------------------------------
  final _upcomingLoading = false.obs;
  bool get upcomingLoading => _upcomingLoading.value;
  set upcomingLoading(bool value) => _upcomingLoading.value = value;

  final _upcomingList = <WebinarData>[].obs;
  List<WebinarData> get upcomingWebinars => _upcomingList;

  Future<void> fetchUpcomingWebinars() async {
    try {
      upcomingLoading = true;
      final result = await webinarProvider!.fetchWebinars(
        page: 1,
        limit: 10,
        status: "upcoming",
      );

      final list = result.data ?? [];
      if (list.isNotEmpty) {
        _upcomingList.assignAll(list);
      } else {
        // Fallback: If no webinar is explicitly flagged as "upcoming",
        // fetch general webinars so the carousel displays content in dev/testing environments.
        final allResult = await webinarProvider!.fetchWebinars(
          page: 1,
          limit: 10,
        );
        _upcomingList.assignAll(allResult.data ?? []);
      }
      upcomingLoading = false;
    } catch (e) {
      upcomingLoading = false;
    }
  }

  // -------------------------------------------------------------
  // 2. BROWSE WEBINARS (SECOND PART / VERTICAL LIST)
  // Filter tabs:
  // 0: All Webinars
  // 1: Upcoming
  // 2: Free
  // 3: Paid
  // 4: Completed
  // -------------------------------------------------------------
  final List<String> filterTitles = const [
    "All Webinars",
    "Upcoming",
    "Free",
    "Paid",
    "Completed",
  ];

  final _selectedFilterIndex = 0.obs;
  int get selectedFilterIndex => _selectedFilterIndex.value;
  set selectedFilterIndex(int value) => _selectedFilterIndex.value = value;

  final _selectedSort = "Latest First".obs;
  String get selectedSort => _selectedSort.value;
  set selectedSort(String value) => _selectedSort.value = value;

  final _browseLoading = false.obs;
  bool get browseLoading => _browseLoading.value;
  set browseLoading(bool value) => _browseLoading.value = value;

  final _browseList = <WebinarData>[].obs;

  List<WebinarData> get browseList {
    final list = List<WebinarData>.from(_browseList);
    if (selectedSort == "Oldest First") {
      list.sort((a, b) {
        final aDate = DateTime.tryParse(a.webinarDate ?? a.createdAt ?? '') ?? DateTime(1970);
        final bDate = DateTime.tryParse(b.webinarDate ?? b.createdAt ?? '') ?? DateTime(1970);
        return aDate.compareTo(bDate);
      });
    } else if (selectedSort == "Latest First") {
      list.sort((a, b) {
        final aDate = DateTime.tryParse(a.webinarDate ?? a.createdAt ?? '') ?? DateTime(1970);
        final bDate = DateTime.tryParse(b.webinarDate ?? b.createdAt ?? '') ?? DateTime(1970);
        return bDate.compareTo(aDate);
      });
    } else if (selectedSort == "Price: Low to High") {
      list.sort((a, b) => (a.amount ?? 0).compareTo(b.amount ?? 0));
    } else if (selectedSort == "Price: High to Low") {
      list.sort((a, b) => (b.amount ?? 0).compareTo(a.amount ?? 0));
    }
    return list;
  }

  Future<void> fetchBrowseWebinars({int? index}) async {
    final targetIndex = index ?? selectedFilterIndex;
    try {
      browseLoading = true;
      String? status;
      String? webinarType;

      switch (targetIndex) {
        case 1:
          status = "upcoming";
          break;
        case 2:
          webinarType = "free";
          break;
        case 3:
          webinarType = "paid";
          break;
        case 4:
          status = "completed";
          break;
        case 0:
        default:
          status = null;
          webinarType = null;
          break;
      }

      final result = await webinarProvider!.fetchWebinars(
        page: 1,
        limit: 10,
        status: status,
        webinarType: webinarType,
      );

      _browseList.assignAll(result.data ?? []);
      browseLoading = false;

      if (getResponseCode() != 200 && getResponseCode() != 201) {
        AppFunctions.apiErrorHandling(
          getResponseCode(),
          result.message ?? "Failed to fetch webinars",
        );
      }
    } catch (e) {
      browseLoading = false;
    }
  }

  Future<void> changeFilter(int index) async {
    if (selectedFilterIndex == index) return;
    selectedFilterIndex = index;
    await fetchBrowseWebinars(index: index);
  }

  void changeSort(String sort) {
    selectedSort = sort;
  }

  // -------------------------------------------------------------
  // REFRESH DATA (BOTH UPCOMING & BROWSE IN PARALLEL)
  // -------------------------------------------------------------
  Future<void> refreshData() async {
    await Future.wait([
      fetchUpcomingWebinars(),
      fetchBrowseWebinars(),
    ]);
  }

  // -------------------------------------------------------------
  // 3. WEBINAR DETAIL & COUNTDOWN TIMER
  // -------------------------------------------------------------
  final _detailLoading = false.obs;
  bool get detailLoading => _detailLoading.value;
  set detailLoading(bool value) => _detailLoading.value = value;

  final _webinarDetail = Rxn<WebinarDetailData>();
  WebinarDetailData? get webinarDetail => _webinarDetail.value;
  set webinarDetail(WebinarDetailData? value) => _webinarDetail.value = value;

  final _detailErrorMessage = ''.obs;
  String get detailErrorMessage => _detailErrorMessage.value;

  final _isBookmarked = false.obs;
  bool get isBookmarked => _isBookmarked.value;
  void toggleBookmark() {
    _isBookmarked.value = !_isBookmarked.value;
  }

  // Countdown timer reactive values
  final _days = "00".obs;
  String get days => _days.value;

  final _hours = "00".obs;
  String get hours => _hours.value;

  final _minutes = "00".obs;
  String get minutes => _minutes.value;

  final _seconds = "00".obs;
  String get seconds => _seconds.value;

  final _isTimerExpired = false.obs;
  bool get isTimerExpired => _isTimerExpired.value;

  Timer? _countdownTimer;

  void startCountdown(DateTime targetDate) {
    _countdownTimer?.cancel();
    _updateTimerValues(targetDate);

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateTimerValues(targetDate);
    });
  }

  void _updateTimerValues(DateTime targetDate) {
    final now = DateTime.now();
    final difference = targetDate.difference(now);

    if (difference.isNegative || difference == Duration.zero) {
      _days.value = "00";
      _hours.value = "00";
      _minutes.value = "00";
      _seconds.value = "00";
      _isTimerExpired.value = true;
      _countdownTimer?.cancel();
    } else {
      _isTimerExpired.value = false;
      final d = difference.inDays;
      final h = difference.inHours % 24;
      final m = difference.inMinutes % 60;
      final s = difference.inSeconds % 60;

      _days.value = d.toString().padLeft(2, '0');
      _hours.value = h.toString().padLeft(2, '0');
      _minutes.value = m.toString().padLeft(2, '0');
      _seconds.value = s.toString().padLeft(2, '0');
    }
  }

  void stopCountdown() {
    _countdownTimer?.cancel();
    _countdownTimer = null;
  }

  /// Calculates the registration end DateTime (until 11:59:59 PM of the registration end date).
  /// If the registration end date is today, countdown runs from DateTime.now() until 11:59:59 PM today.
  DateTime? parseRegistrationEndDateTime({
    String? registrationEndDate,
    String? webinarDate,
    String? startTime,
  }) {
    DateTime? baseDate;

    if (registrationEndDate != null && registrationEndDate.trim().isNotEmpty) {
      baseDate = _parseFlexibleDate(registrationEndDate.trim());
      if (baseDate != null) {
        // Registration closes at the end of the registration end date (11:59:59 PM)
        return DateTime(
          baseDate.year,
          baseDate.month,
          baseDate.day,
          23,
          59,
          59,
        );
      }
    }

    if (webinarDate != null && webinarDate.trim().isNotEmpty) {
      baseDate = _parseFlexibleDate(webinarDate.trim());
      if (baseDate != null) {
        if (startTime != null && startTime.trim().isNotEmpty) {
          final timeParts = startTime.trim().split(':');
          if (timeParts.length >= 2) {
            final hour = int.tryParse(timeParts[0]);
            final minute = int.tryParse(timeParts[1]);
            if (hour != null && minute != null) {
              return DateTime(
                baseDate.year,
                baseDate.month,
                baseDate.day,
                hour,
                minute,
                0,
              );
            }
          }
        }
        return DateTime(
          baseDate.year,
          baseDate.month,
          baseDate.day,
          23,
          59,
          59,
        );
      }
    }

    return null;
  }

  DateTime? _parseFlexibleDate(String dateStr) {
    final isoParsed = DateTime.tryParse(dateStr);
    if (isoParsed != null) {
      return isoParsed.toLocal();
    }

    const formats = [
      'dd-MM-yyyy',
      'dd/MM/yyyy',
      'yyyy/MM/dd',
      'yyyy-MM-dd',
      'dd MMM yyyy',
      'd MMM yyyy',
    ];

    for (final f in formats) {
      try {
        final parsed = DateFormat(f).parseLoose(dateStr);
        return parsed;
      } catch (_) {}
    }

    return null;
  }

  /// Initializes and starts the countdown timer for the given webinar detail.
  void initCountdownFromDetail(WebinarDetailData detail) {
    final targetDate = parseRegistrationEndDateTime(
      registrationEndDate: detail.registrationEndDate,
      webinarDate: detail.webinarDate,
      startTime: detail.startTime,
    );

    if (targetDate != null) {
      startCountdown(targetDate);
    } else {
      _days.value = "00";
      _hours.value = "00";
      _minutes.value = "00";
      _seconds.value = "00";
      _isTimerExpired.value = true;
      stopCountdown();
    }
  }

  Future<void> fetchWebinarDetail(String webinarId) async {
    try {
      detailLoading = true;
      _detailErrorMessage.value = '';

      final result = await webinarProvider!.getWebinarById(webinarId);
      if (result.success == true && result.data != null) {
        webinarDetail = result.data;

        // Calculate registration end date ending at 11:59:59 PM
        initCountdownFromDetail(result.data!);
      } else {
        _detailErrorMessage.value =
            result.message ?? "Failed to fetch webinar details";
        if (getResponseCode() != 200 && getResponseCode() != 201) {
          AppFunctions.apiErrorHandling(
            getResponseCode(),
            result.message ?? "Failed to fetch webinar details",
          );
        }
      }
      detailLoading = false;
    } catch (e) {
      detailLoading = false;
      _detailErrorMessage.value = e.toString();
    }
  }

  // -------------------------------------------------------------
  // 5. COLLEGES & REGISTRATION & MEETING LINK
  // -------------------------------------------------------------
  final _colleges = <String>[].obs;
  List<String> get colleges => _colleges;
  final _collegesLoading = false.obs;
  bool get collegesLoading => _collegesLoading.value;

  Future<List<String>> fetchColleges() async {
    if (_colleges.isNotEmpty) return _colleges;
    try {
      _collegesLoading.value = true;
      final list = await webinarProvider!.fetchColleges();
      _colleges.assignAll(list);
      _collegesLoading.value = false;
      return list;
    } catch (e) {
      _collegesLoading.value = false;
      return [];
    }
  }

  final _registerLoading = false.obs;
  bool get registerLoading => _registerLoading.value;

  Future<Map<String, dynamic>> registerWebinar(Map<String, dynamic> payload) async {
    try {
      _registerLoading.value = true;
      final res = await webinarProvider!.registerWebinar(payload);
      _registerLoading.value = false;
      if (res['success'] == true) {
        if (webinarDetail != null && webinarDetail!.sId == payload['webinarId']) {
          final regData = res['data'] is Map<String, dynamic> ? res['data'] : null;
          webinarDetail!.registration = WebinarRegistrationInfo(
            isRegistered: true,
            status: regData != null ? regData['status'] : 'registered',
            registeredAt: regData != null ? regData['registeredAt'] : DateTime.now().toIso8601String(),
          );
          if (regData != null && regData['availableSeats'] != null) {
            webinarDetail!.availableSeats = (regData['availableSeats'] as num).toInt();
          }
          if (regData != null && regData['join'] != null && regData['join'] is Map<String, dynamic>) {
            webinarDetail!.join = WebinarJoinInfo.fromJson(regData['join']);
          }
          _webinarDetail.refresh();
        }
      }
      return res;
    } catch (e) {
      _registerLoading.value = false;
      return {'success': false, 'message': e.toString()};
    }
  }

  final _otpSending = false.obs;
  bool get otpSending => _otpSending.value;

  Future<Map<String, dynamic>> sendWebinarOtp(String webinarId, String mobile) async {
    try {
      _otpSending.value = true;
      final res = await webinarProvider!.sendWebinarOtp(
        webinarId: webinarId,
        mobile: mobile,
      );
      _otpSending.value = false;
      return res;
    } catch (e) {
      _otpSending.value = false;
      return {'success': false, 'message': e.toString()};
    }
  }

  final _otpVerifying = false.obs;
  bool get otpVerifying => _otpVerifying.value;

  Future<Map<String, dynamic>> verifyWebinarOtp(String webinarId, String otp) async {
    try {
      _otpVerifying.value = true;
      final res = await webinarProvider!.verifyWebinarOtp(
        webinarId: webinarId,
        otp: otp,
      );
      _otpVerifying.value = false;
      if (res['success'] == true) {
        if (webinarDetail != null && webinarDetail!.sId == webinarId) {
          webinarDetail!.isMobileVerified = true;
          _webinarDetail.refresh();
        }
      }
      return res;
    } catch (e) {
      _otpVerifying.value = false;
      return {'success': false, 'message': e.toString()};
    }
  }

  final _meetingLinkLoading = false.obs;
  bool get meetingLinkLoading => _meetingLinkLoading.value;

  Future<Map<String, dynamic>> getMeetingLink(String webinarId) async {
    try {
      _meetingLinkLoading.value = true;
      final res = await webinarProvider!.getWebinarMeetingLink(webinarId);
      _meetingLinkLoading.value = false;
      return res;
    } catch (e) {
      _meetingLinkLoading.value = false;
      return {'success': false, 'message': e.toString()};
    }
  }

  // -------------------------------------------------------------
  // 6. WEBINAR PAYMENT ORDER & VERIFICATION
  // -------------------------------------------------------------
  final _paymentCreating = false.obs;
  bool get paymentCreating => _paymentCreating.value;

  Future<Map<String, dynamic>> createWebinarPayment({
    required String webinarId,
    required String studentId,
  }) async {
    try {
      _paymentCreating.value = true;
      final res = await webinarProvider!.createWebinarPayment(
        webinarId: webinarId,
        studentId: studentId,
      );
      _paymentCreating.value = false;
      return res;
    } catch (e) {
      _paymentCreating.value = false;
      return {'success': false, 'message': e.toString()};
    }
  }

  final _paymentVerifying = false.obs;
  bool get paymentVerifying => _paymentVerifying.value;

  Future<Map<String, dynamic>> verifyWebinarPayment({
    required String orderId,
  }) async {
    try {
      _paymentVerifying.value = true;
      final res = await webinarProvider!.verifyWebinarPayment(
        orderId: orderId,
      );
      _paymentVerifying.value = false;
      return res;
    } catch (e) {
      _paymentVerifying.value = false;
      return {'success': false, 'message': e.toString()};
    }
  }

  @override
  void onInit() {
    super.onInit();
    refreshData();
  }

  @override
  void onClose() {
    stopCountdown();
    super.onClose();
  }
}

