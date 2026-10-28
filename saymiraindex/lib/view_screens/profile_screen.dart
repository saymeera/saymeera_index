import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
        title: const Text('Profile', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _profileHeader(),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _sectionCard('Personal Info', [
                    _row(Icons.person_outline, 'Full Name', 'Tajender Bhardwaj'),
                    _divider(),
                    _row(Icons.phone_outlined, 'Mobile', '+91 88105 85059'),
                    _divider(),
                    _row(Icons.email_outlined, 'Email', 'tajender08@gmail.com'),
                    _divider(),
                    _row(Icons.cake_outlined, 'Date of Birth', '12 / 06 / 1992'),
                    _divider(),
                    _row(Icons.wc_outlined, 'Gender', 'Male'),
                  ]),
                  const SizedBox(height: 12),
                  _sectionCard('Location', [
                    _row(Icons.flag_outlined, 'Country', 'India'),
                    _divider(),
                    _row(Icons.map_outlined, 'State', 'Maharashtra'),
                    _divider(),
                    _row(Icons.location_city_outlined, 'District', 'Pune'),
                  ]),
                  const SizedBox(height: 12),
                  _sectionCard('Membership', [
                    _row(Icons.confirmation_number_outlined, 'Member ID', 'SMI-00142'),
                    _divider(),
                    _row(Icons.calendar_today_outlined, 'Member Since', 'January 2024'),
                    _divider(),
                    _row(Icons.workspace_premium_outlined, 'Subscription', 'Premium'),
                    _divider(),
                    _row(Icons.person_2_outlined, 'Account Type', 'Individual'),
                  ]),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileHeader() {
    return Container(
      width: double.infinity,
      color: AppColors.primaryRed,
      padding: const EdgeInsets.only(top: 8, bottom: 32),
      child: Column(
        children: [
          CircleAvatar(
            radius: 46,
            backgroundColor: Colors.white,
            child: Text(
              'TB',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryRed,
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Tajender Bhardwaj',
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Premium Member',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard(String title, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryRed,
                letterSpacing: 0.4,
              ),
            ),
          ),
          const Divider(height: 1),
          ...children,
        ],
      ),
    );
  }

  Widget _row(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primaryRed),
          const SizedBox(width: 14),
          Expanded(
            child: Text(label, style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
          ),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _divider() => const Divider(height: 1, indent: 48);
}
