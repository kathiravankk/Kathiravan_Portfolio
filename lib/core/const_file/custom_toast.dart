import 'package:flutter/material.dart';

class CustomToast {
  static OverlayEntry? _currentToast;

  // ✅ SUCCESS TOAST
  static void showSuccess(
      BuildContext context, {
        required String title,
        required String message,
        Duration duration = const Duration(seconds: 3),
      }) {
    _showToast(
      context,
      title: title,
      message: message,
      duration: duration,
      color: Colors.green.shade600,
      icon: Icons.check_circle,
      bgColor: Colors.green.shade50,
    );
  }

  // ❌ ERROR TOAST
  static void showError(
      BuildContext context, {
        required String title,
        required String message,
        Duration duration = const Duration(seconds: 3),
      }) {
    _showToast(
      context,
      title: title,
      message: message,
      duration: duration,
      color: Colors.red.shade600,
      icon: Icons.error,
      bgColor: Colors.red.shade50,
    );
  }

  // ℹ️ INFO TOAST
  static void showInfo(
      BuildContext context, {
        required String title,
        required String message,
        Duration duration = const Duration(seconds: 3),
      }) {
    _showToast(
      context,
      title: title,
      message: message,
      duration: duration,
      color: Colors.blue.shade600,
      icon: Icons.info,
      bgColor: Colors.blue.shade50,
    );
  }

  // ⚠️ WARNING TOAST
  static void showWarning(
      BuildContext context, {
        required String title,
        required String message,
        Duration duration = const Duration(seconds: 3),
      }) {
    _showToast(
      context,
      title: title,
      message: message,
      duration: duration,
      color: Colors.orange.shade600,
      icon: Icons.warning,
      bgColor: Colors.orange.shade50,
    );
  }

  // 🎨 MAIN TOAST BUILDER
  static void _showToast(
      BuildContext context, {
        required String title,
        required String message,
        required Duration duration,
        required Color color,
        required IconData icon,
        required Color bgColor,
      }) {
    // Remove existing toast
    _currentToast?.remove();

    final overlay = Overlay.of(context);

    _currentToast = OverlayEntry(
      builder: (context) => _ToastWidget(
        title: title,
        message: message,
        color: color,
        icon: icon,
        bgColor: bgColor,
        onDismiss: () {
          _currentToast?.remove();
          _currentToast = null;
        },
      ),
    );

    overlay.insert(_currentToast!);

    // Auto remove after duration
    Future.delayed(duration, () {
      _currentToast?.remove();
      _currentToast = null;
    });
  }
}

// 🎨 TOAST WIDGET (Animated)
class _ToastWidget extends StatefulWidget {
  final String title;
  final String message;
  final Color color;
  final IconData icon;
  final Color bgColor;
  final VoidCallback onDismiss;

  const _ToastWidget({
    required this.title,
    required this.message,
    required this.color,
    required this.icon,
    required this.bgColor,
    required this.onDismiss,
  });

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 16,
      left: 16,
      right: 16,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Material(
            color: Colors.transparent,
            child: GestureDetector(
              onHorizontalDragEnd: (details) {
                if (details.primaryVelocity! > 500 ||
                    details.primaryVelocity! < -500) {
                  widget.onDismiss();
                }
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border(
                    left: BorderSide(
                      color: widget.color,
                      width: 5,
                    ),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: widget.color.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Icon Container
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: widget.bgColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        widget.icon,
                        color: widget.color,
                        size: 28,
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Text Content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.title,
                            style: TextStyle(
                              color: Colors.grey.shade900,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.message,
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Close Button
                    IconButton(
                      onPressed: widget.onDismiss,
                      icon: Icon(
                        Icons.close,
                        color: Colors.grey.shade600,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}