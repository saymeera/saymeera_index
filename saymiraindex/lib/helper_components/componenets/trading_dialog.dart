import 'package:flutter/material.dart';

enum TradingDialogType {
  buy,
  sell,
  warning,
  error,
  info,
  success,
}

class TradingDialog {
  static Future<void> show({
    required BuildContext context,
    required String title,
    required String message,
    TradingDialogType type = TradingDialogType.info,

    // 🔥 Boolean controls
    bool showPrimary = true,
    bool showSecondary = false,

    String primaryText = "OK",
    String secondaryText = "Cancel",

    VoidCallback? onPrimary,
    VoidCallback? onSecondary,

    bool barrierDismissible = false,
  }) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierLabel: "TradingDialog",
      barrierColor: Colors.black.withOpacity(0.6),
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (_, __, ___) {
        return Center(
          child: _TradingDialogCard(
            title: title,
            message: message,
            type: type,
            showPrimary: showPrimary,
            showSecondary: showSecondary,
            primaryText: primaryText,
            secondaryText: secondaryText,
            onPrimary: onPrimary,
            onSecondary: onSecondary,
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: anim,
            curve: Curves.easeOutBack,
          ),
          child: FadeTransition(opacity: anim, child: child),
        );
      },
    );
  }
}

class _TradingDialogCard extends StatelessWidget {
  final String title;
  final String message;
  final TradingDialogType type;

  final bool showPrimary;
  final bool showSecondary;

  final String primaryText;
  final String secondaryText;

  final VoidCallback? onPrimary;
  final VoidCallback? onSecondary;

  const _TradingDialogCard({
    required this.title,
    required this.message,
    required this.type,
    required this.showPrimary,
    required this.showSecondary,
    required this.primaryText,
    required this.secondaryText,
    this.onPrimary,
    this.onSecondary,
  });

  @override
  Widget build(BuildContext context) {
    final colors = _DialogTheme.getTheme(type);

    return Material(
      color: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        constraints: const BoxConstraints(maxWidth: 420),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 24,
              offset: Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Gradient Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: colors.gradient),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  _IconBadge(icon: colors.icon, bgColor: colors.badgeBg),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Body
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message,
                    style: TextStyle(
                      fontSize: 14.5,
                      height: 1.5,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  const SizedBox(height: 22),

                  // Buttons (boolean controlled)
                  Row(
                    children: [
                      if (showSecondary)
                        Expanded(
                          child: _SecondaryButton(
                            text: secondaryText,
                            onTap: () {
                              Navigator.pop(context);
                              if (onSecondary != null) onSecondary!();
                            },
                          ),
                        ),

                      if (showSecondary && showPrimary)
                        const SizedBox(width: 12),

                      if (showPrimary)
                        Expanded(
                          child: _PrimaryButton(
                            text: primaryText,
                            colors: colors,
                            onTap: () {
                              Navigator.pop(context);
                              if (onPrimary != null) onPrimary!();
                            },
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =====================
// UI Components
// =====================

class _IconBadge extends StatelessWidget {
  final IconData icon;
  final Color bgColor;

  const _IconBadge({
    required this.icon,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String text;
  final _DialogThemeData colors;
  final VoidCallback onTap;

  const _PrimaryButton({
    required this.text,
    required this.colors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        height: 46,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: colors.gradient),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: colors.gradient.last.withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 15,
            letterSpacing: 0.4,
          ),
        ),
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _SecondaryButton({
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        height: 46,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey.shade50,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

// =====================
// Theme Engine
// =====================

class _DialogThemeData {
  final List<Color> gradient;
  final IconData icon;
  final Color badgeBg;

  _DialogThemeData({
    required this.gradient,
    required this.icon,
    required this.badgeBg,
  });
}

class _DialogTheme {
  static _DialogThemeData getTheme(TradingDialogType type) {
    switch (type) {
      case TradingDialogType.buy:
        return _DialogThemeData(
          gradient: [const Color(0xFF00C853), const Color(0xFF64DD17)],
          icon: Icons.trending_up,
          badgeBg: const Color(0xFF00A843),
        );
      case TradingDialogType.sell:
        return _DialogThemeData(
          gradient: [const Color(0xFFD50000), const Color(0xFFFF5252)],
          icon: Icons.trending_down,
          badgeBg: const Color(0xFFB00020),
        );
      case TradingDialogType.warning:
        return _DialogThemeData(
          gradient: [const Color(0xFFFF8F00), const Color(0xFFFFC107)],
          icon: Icons.warning_amber_rounded,
          badgeBg: const Color(0xFFFF6F00),
        );
      case TradingDialogType.error:
        return _DialogThemeData(
          gradient: [const Color(0xFFB71C1C), const Color(0xFFD32F2F)],
          icon: Icons.error_outline,
          badgeBg: const Color(0xFF8E0000),
        );
      case TradingDialogType.success:
        return _DialogThemeData(
          gradient: [const Color(0xFF2E7D32), const Color(0xFF66BB6A)],
          icon: Icons.check_circle_outline,
          badgeBg: const Color(0xFF1B5E20),
        );
      case TradingDialogType.info:
      default:
        return _DialogThemeData(
          gradient: [const Color(0xFF1565C0), const Color(0xFF42A5F5)],
          icon: Icons.info_outline,
          badgeBg: const Color(0xFF0D47A1),
        );
    }
  }
}
