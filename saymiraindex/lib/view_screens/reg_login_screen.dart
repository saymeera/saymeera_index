import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../routes/app_routes.dart';

class RegLoginScreen extends StatelessWidget {
  const RegLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.primaryRed,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Account Access',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              _logo(),
              const SizedBox(height: 40),
              _card(
                context,
                icon: Icons.login_rounded,
                title: 'Login',
                subtitle: 'Already a member? Sign in to access\nyour dashboard and portfolio.',
                buttonText: 'Sign In',
                filled: true,
                onTap: () => Navigator.pushNamed(context, AppRoutes.login),
              ),
              const SizedBox(height: 16),
              _card(
                context,
                icon: Icons.person_add_alt_1_rounded,
                title: 'Register',
                subtitle: 'New to Say Mira? Create your account\nand start your learning journey.',
                buttonText: 'Create Account',
                filled: false,
                onTap: () => Navigator.pushNamed(context, AppRoutes.register),
              ),
              const Spacer(),
              _footer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _logo() {
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: AppColors.primaryRed,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Center(
            child: Text(
              'SM',
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Say Mira',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 6),
        const Text(
          'India\'s Trading Education Platform',
          style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _card(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String buttonText,
    required bool filled,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: filled ? AppColors.primaryRed.withValues(alpha: 0.3) : AppColors.border,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.primaryRed.withValues(alpha: filled ? 0.12 : 0.07),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: AppColors.primaryRed, size: 26),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(subtitle,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textSecondary, height: 1.4)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: filled ? AppColors.primaryRed : Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: filled ? AppColors.primaryRed : AppColors.border,
                ),
              ),
              child: Text(
                buttonText,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: filled ? Colors.white : AppColors.textSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _footer() {
    return const Text(
      'By continuing, you agree to Say Mira\'s Terms of Service\nand Privacy Policy.',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 11, color: AppColors.textHint, height: 1.5),
    );
  }
}
