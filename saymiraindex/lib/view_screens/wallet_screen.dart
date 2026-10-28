import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class _Txn {
  final String title;
  final String subtitle;
  final String date;
  final String amount;
  final bool credit;

  const _Txn({
    required this.title,
    required this.subtitle,
    required this.date,
    required this.amount,
    required this.credit,
  });
}

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  static const List<_Txn> _txns = [
    _Txn(title: 'Referral Bonus',      subtitle: 'Referral: Amit Shah',     date: '2 days ago',   amount: '+₹50',   credit: true),
    _Txn(title: 'Subscription Renewal', subtitle: 'Premium Plan — Annual',   date: '1 week ago',   amount: '−₹999',  credit: false),
    _Txn(title: 'Referral Bonus',      subtitle: 'Referral: Riya Patel',    date: '2 weeks ago',  amount: '+₹100',  credit: true),
    _Txn(title: 'Referral Bonus',      subtitle: 'Referral: Suresh Kumar',  date: '3 weeks ago',  amount: '+₹50',   credit: true),
    _Txn(title: 'Welcome Bonus',        subtitle: 'New member reward',       date: '1 month ago',  amount: '+₹200',  credit: true),
    _Txn(title: 'Plan Upgrade',         subtitle: 'Basic → Premium',         date: '1 month ago',  amount: '−₹499',  credit: false),
    _Txn(title: 'Referral Bonus',      subtitle: 'Referral: Priya Mehta',   date: '5 weeks ago',  amount: '+₹50',   credit: true),
    _Txn(title: 'Cashback',            subtitle: 'Promotional offer',       date: '2 months ago', amount: '+₹100',  credit: true),
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
        title: const Text('Wallet', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _balanceCard(),
          const SizedBox(height: 14),
          _actionRow(),
          const SizedBox(height: 14),
          _summaryRow(),
          const SizedBox(height: 14),
          _transactionList(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _balanceCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primaryRed,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text('Available Balance', style: TextStyle(color: Colors.white70, fontSize: 13)),
          const SizedBox(height: 8),
          const Text('₹ 1,250',
              style: TextStyle(color: Colors.white, fontSize: 38, fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          const Text('Member ID: SMI-00142', style: TextStyle(color: Colors.white54, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _actionRow() {
    return Row(
      children: [
        _actionBtn(Icons.add_circle_outline, 'Add Funds'),
        const SizedBox(width: 12),
        _actionBtn(Icons.arrow_circle_up_outlined, 'Withdraw'),
        const SizedBox(width: 12),
        _actionBtn(Icons.history_outlined, 'History'),
      ],
    );
  }

  Widget _actionBtn(IconData icon, String label) {
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
            Icon(icon, color: AppColors.primaryRed, size: 24),
            const SizedBox(height: 6),
            Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow() {
    return Row(
      children: [
        _summaryTile('₹550', 'Total Earned', const Color(0xFF2E7D32)),
        const SizedBox(width: 12),
        _summaryTile('₹1,498', 'Total Spent', AppColors.primaryRed),
      ],
    );
  }

  Widget _summaryTile(String value, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Icon(
              label.contains('Earned') ? Icons.trending_up : Icons.trending_down,
              color: color,
              size: 22,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: color)),
                Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _transactionList() {
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
            child: Text('Transactions', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
          ),
          const Divider(height: 1),
          ..._txns.map((t) => _txnTile(t)),
        ],
      ),
    );
  }

  Widget _txnTile(_Txn t) {
    final color = t.credit ? const Color(0xFF2E7D32) : AppColors.primaryRed;
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            radius: 20,
            backgroundColor: color.withOpacity(0.1),
            child: Icon(
              t.credit ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
              color: color,
              size: 18,
            ),
          ),
          title: Text(t.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          subtitle: Text(t.subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textHint)),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(t.amount,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: color)),
              Text(t.date, style: const TextStyle(fontSize: 11, color: AppColors.textHint)),
            ],
          ),
        ),
        const Divider(height: 1, indent: 56),
      ],
    );
  }
}
