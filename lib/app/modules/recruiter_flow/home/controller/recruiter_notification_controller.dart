import 'package:get/get.dart';
import 'package:internsharks/app/data/models/notification/recruiter_notification_model.dart';
import 'package:internsharks/app/data/providers/recruiter_flow/recruiter_notification_provider.dart';

class RecruiterNotificationController extends GetxController {
  final RecruiterNotificationProvider? notificationProvider;

  RecruiterNotificationController(this.notificationProvider);

  // Loading state
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  set isLoading(bool v) => _isLoading.value = v;

  // All notifications
  final RxList<RecruiterNotificationModel> allNotifications =
      <RecruiterNotificationModel>[].obs;

  // Filter: 'all' | 'unread'
  final RxString selectedFilter = 'all'.obs;

  List<RecruiterNotificationModel> get filteredNotifications {
    if (selectedFilter.value == 'unread') {
      return allNotifications.where((n) => n.isRead == false).toList();
    }
    return allNotifications;
  }

  int get unreadCount =>
      allNotifications.where((n) => n.isRead == false).length;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    try {
      isLoading = true;
      final result = await notificationProvider!.fetchNotifications();
      if (result.data != null) {
        allNotifications.assignAll(result.data!);
      }
    } catch (_) {
      // silently fail; keep existing list
    } finally {
      isLoading = false;
    }
  }

  Future<void> refreshNotifications() async {
    await fetchNotifications();
  }

  void setFilter(String filter) {
    selectedFilter.value = filter;
  }
}
