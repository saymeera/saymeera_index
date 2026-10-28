import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/constants/app_colors.dart';

class _Referred {
  final String name;
  final String joinedOn;
  final String status;

  const _Referred({required this.name, required this.joinedOn, required this.status});
}

class ReferralScreen extends StatelessWidget {
  const ReferralScreen({super.key});

  static const _code = 'SMI00142';

  static const List<_Referred> _referred = [
    _Referred(name: 'Amit Shah',      joinedOn: '2 days ago',   status: 'Active'),
    _Referred(name: 'Riya Patel',     joinedOn: '1 week ago',   status: 'Active'),
    _Referred(name: 'Suresh Kumar',   joinedOn: '2 weeks ago',  status: 'Active'),
    _Referred(name: 'Priya Mehta',    joinedOn: '3 weeks ago',  status: 'Active'),
    _Referred(name: 'Rahul Verma',    joinedOn: '1 month ago',  status: 'Active'),
    _Referred(name: 'Kiran Bose',     joinedOn: '1 month ago',  status: 'Pending'),
    _Referred(name: 'Neha Jain',      joinedOn: '6 weeks ago',  status: 'Active'),
    _Referred(name: 'Vikram Singh',   joinedOn: '2 months ago', status: 'Pending'),
  ];

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
        title: const Text('Referral', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _codeCard(context),
          const SizedBox(height: 14),
          _statsRow(),
          const SizedBox(height: 14),
          _howItWorks(),
          const SizedBox(height: 14),
          _referredList(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _codeCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryRed,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text('Your Referral Code',
              style: TextStyle(color: Colors.white70, fontSize: 13)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_code,
                  style: const TextStyle(
                      color: Colors.white, fontSize: 30, fontWeight: FontWeight.w800, letterSpacing: 4)),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () {
                  Clipboard.setData(const ClipboardData(text: _code));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Referral code copied!'), duration: Duration(seconds: 2)),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.copy_outlined, color: Colors.white, size: 18),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.share_outlined, size: 18),
              label: const Text('Share Code'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primaryRed,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statsRow() {
    return Row(
      children: [
        _stat('8', 'Total\nReferrals', AppColors.primaryRed),
        const SizedBox(width: 10),
        _stat('6', 'Active\nMembers', const Color(0xFF2E7D32)),
        const SizedBox(width: 10),
        _stat('₹400', 'Reward\nEarned', const Color(0xFF1565C0)),
      ],
    );
  }

  Widget _stat(String value, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: color)),
            const SizedBox(height: 4),
            Text(label, textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, height: 1.3)),
          ],
        ),
      ),
    );
  }

  Widget _howItWorks() {
    const steps = [
      ('Share your referral code with friends', Icons.share_outlined),
      ('Friend registers using your code', Icons.person_add_outlined),
      ('You earn ₹50 reward per active referral', Icons.redeem_outlined),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('How It Works',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          ...steps.map((s) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Icon(s.$2, size: 20, color: AppColors.primaryRed),
                    const SizedBox(width: 12),
                    Expanded(child: Text(s.$1,
                        style: const TextStyle(fontSize: 13, color: AppColors.textSecondary))),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _referredList() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: Text('Referred Members',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
          ),
          const Divider(height: 1),
          ..._referred.map((r) => _referredTile(r)),
        ],
      ),
    );
  }

  Widget _referredTile(_Referred r) {
    final initials = r.name.split(' ').map((w) => w[0]).take(2).join();
    final active = r.status == 'Active';
    return ListTile(
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: AppColors.primaryRed.withOpacity(0.1),
        child: Text(initials,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primaryRed)),
      ),
      title: Text(r.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
      subtitle: Text('Joined ${r.joinedOn}',
          style: const TextStyle(fontSize: 12, color: AppColors.textHint)),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: active ? const Color(0xFFE8F5E9) : Colors.orange.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(r.status,
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: active ? const Color(0xFF2E7D32) : Colors.orange.shade700)),
      ),
    );
  }
}
