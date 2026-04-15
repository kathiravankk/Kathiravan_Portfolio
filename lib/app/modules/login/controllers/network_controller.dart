import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _subscription;

  final RxBool isConnected = true.obs;
  bool _snackbarShowing = false;

  @override
  void onInit() {
    super.onInit();
    _checkInitialConnection();
    _subscription = _connectivity.onConnectivityChanged.listen(_updateStatus);
  }

  Future<void> _checkInitialConnection() async {
    final result = await _connectivity.checkConnectivity();
    _updateStatus(result);
  }

  void _updateStatus(List<ConnectivityResult> results) {
    final connected = results.any((r) => r != ConnectivityResult.none);

    if (!connected && isConnected.value) {
      isConnected.value = false;
      _showNoConnectionSnackbar();
    } else if (connected && !isConnected.value) {
      isConnected.value = true;
      _showBackOnlineSnackbar();
    }
  }

  void _showNoConnectionSnackbar() {
    if (_snackbarShowing) {
      Get.closeCurrentSnackbar();
    }

    _snackbarShowing = true;

    Get.rawSnackbar(
      messageText: const Text(
        'No network connection',
        style: TextStyle(color: Colors.white, fontSize: 14),
      ),
      backgroundColor: Colors.red.shade700,
      isDismissible: false,
      duration: null, // Stays forever until dismissed manually
      snackStyle: SnackStyle.GROUNDED,
      snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.zero,
      borderRadius: 0,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      icon: const Icon(Icons.wifi_off, color: Colors.white),
      mainButton: TextButton(
        onPressed: () async {
          final result = await _connectivity.checkConnectivity();
          _updateStatus(result);
        },
        child: const Text(
          'Retry',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _showBackOnlineSnackbar() {
    if (_snackbarShowing) {
      Get.closeCurrentSnackbar();
    }

    _snackbarShowing = false;

    Get.rawSnackbar(
      messageText: const Text(
        'Back online',
        style: TextStyle(color: Colors.white, fontSize: 14),
      ),
      backgroundColor: Colors.green.shade600,
      isDismissible: true,
      duration: const Duration(seconds: 3),
      snackStyle: SnackStyle.GROUNDED,
      snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.zero,
      borderRadius: 0,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      icon: const Icon(Icons.wifi, color: Colors.white),
    );
  }

  @override
  void onClose() {
    _subscription.cancel();
    super.onClose();
  }
}