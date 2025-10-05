import 'package:flutter/material.dart';
import 'package:web3_wallet/util/colors.dart';

class AppToast {
  static OverlayEntry? _overlayEntry;
  static bool _isShowing = false;

  static void showSuccess(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    if (_isShowing) return;

    _isShowing = true;

    _overlayEntry = _createOverlayEntry(
      context,
      message: message,
      icon: Icons.check_circle,
      backgroundColor: Colors.green,
      onPress: () {},
    );

    Overlay.of(context).insert(_overlayEntry!);

    Future.delayed(duration, () {
      _removeOverlay();
    });
  }

  static void showError(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onPress,
  }) {
    if (_isShowing) return;

    _isShowing = true;
    _overlayEntry = _createOverlayEntry(
      context,
      message: message,
      icon: Icons.error,
      backgroundColor: AppColors.backgroundDark,
      onPress: onPress ?? () {},
    );

    Overlay.of(context).insert(_overlayEntry!);

    if (duration == Duration.zero) {
      return;
    }

    Future.delayed(duration, () {
      _removeOverlay();
    });
  }

  static OverlayEntry _createOverlayEntry(
    BuildContext context, {
    required String message,
    required IconData icon,
    required Color backgroundColor,
    required VoidCallback onPress,
  }) {
    return OverlayEntry(
      builder: (context) => _ToastWidget(
        message: message,
        icon: icon,
        backgroundColor: backgroundColor,
        onPress: () {
          onPress();
          _removeOverlay();
        },
      ),
    );
  }

  static void _removeOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
      _isShowing = false;
    }
  }
}

class _ToastWidget extends StatefulWidget {
  final String message;
  final IconData icon;
  final Color backgroundColor;
  final VoidCallback onPress;

  const _ToastWidget({
    required this.message,
    required this.icon,
    required this.backgroundColor,
    required this.onPress,
  });

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(
          begin: const Offset(0, 1),
          end: const Offset(0, 0),
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutBack,
          ),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 40,
      left: 16,
      right: 16,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Center(
            child: Material(
              color: Colors.transparent,
              child: GestureDetector(
                onTap: widget.onPress,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: widget.backgroundColor,
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: Colors.white, width: 0.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 8,
                    children: [
                      Flexible(
                        child: Text(
                          widget.message,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const Icon(Icons.replay, size: 24, color: Colors.white),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
