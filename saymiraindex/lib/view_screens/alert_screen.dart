import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class _AlertItem {
  final String symbol;
  final String condition;
  final String level;
  final String setOn;
  final bool triggered;
  bool active;

  _AlertItem({
    required this.symbol,
    required this.condition,
    required this.level,
    required this.setOn,
    required this.triggered,
    this.active = true,
  });
}

class AlertScreen extends StatefulWidget {
  const AlertScreen({super.key});

  @override
  State<AlertScreen> createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen> {
  final List<_AlertItem> _alerts = [
    _AlertItem(symbol: 'Nifty 50',    condition: 'Breakout above', level: '22,500', setOn: '2 days ago',  triggered: false),
    _AlertItem(symbol: 'BankNifty',   condition: 'Watch level',    level: '48,000', setOn: '1 week ago',  triggered: false),
    _AlertItem(symbol: 'Gold',        condition: 'Break below',    level: '71,000', setOn: '3 days ago',  triggered: true,  active: false),
    _AlertItem(symbol: 'Silver',      condition: 'Near support',   level: '82,500', setOn: '5 days ago',  triggered: false),
    _AlertItem(symbol: 'Crude Oil',   condition: 'Watch level',    level: '6,200',  setOn: '1 day ago',   triggered: false),
    _AlertItem(symbol: 'USD / INR',   condition: 'Breakout above', level: '83.50',  setOn: '1 week ago',  triggered: true,  active: false),
  ];

  @override
  Widget build(BuildContext context) {
    final active    = _alerts.where((a) => !a.triggered).toList();
    final triggered = _alerts.where((a) =>  a.triggered).toList();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.primaryRed,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Alerts', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_alert_outlined, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _statsRow(),
          const SizedBox(height: 16),
          if (active.isNotEmpty) ...[
            _sectionLabel('Active Alerts', active.length),
            const SizedBox(height: 8),
            ...active.map((a) => _alertCard(a)),
            const SizedBox(height: 16),
          ],
          if (triggered.isNotEmpty) ...[
            _sectionLabel('Triggered', triggered.length),
            const SizedBox(height: 8),
            ...triggered.map((a) => _alertCard(a)),
          ],
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _statsRow() {
    return Row(
      children: [
        _statCard('Active', '4', Colors.green),
        const SizedBox(width: 12),
        _statCard('Triggered', '2', AppColors.primaryRed),
        const SizedBox(width: 12),
        _statCard('Total', '6', AppColors.textSecondary),
      ],
    );
  }

  Widget _statCard(String label, String count, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Text(count, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: color)),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String label, int count) {
    return Row(
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.primaryRed.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text('$count', style: TextStyle(fontSize: 12, color: AppColors.primaryRed, fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }

  Widget _alertCard(_AlertItem a) {
    final color = a.triggered ? Colors.grey.shade400 : AppColors.primaryRed;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: a.triggered ? Colors.grey.shade200 : AppColors.border),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: CircleAvatar(
          radius: 22,
          backgroundColor: color.withOpacity(0.1),
          child: Icon(
            a.triggered ? Icons.notifications_off_outlined : Icons.notifications_active_outlined,
            color: color,
            size: 20,
          ),
        ),
        title: Text(
          a.symbol,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 15,
            color: a.triggered ? Colors.grey : AppColors.textPrimary,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 2),
            Text('${a.condition}  ${a.level}',
                style: TextStyle(fontSize: 13, color: a.triggered ? Colors.grey : AppColors.textSecondary)),
            const SizedBox(height: 2),
            Text('Set ${a.setOn}', style: const TextStyle(fontSize: 11, color: AppColors.textHint)),
          ],
        ),
        trailing: a.triggered
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Text('Triggered',
                    style: TextStyle(fontSize: 11, color: Colors.orange.shade700, fontWeight: FontWeight.w600)),
              )
            : Switch(
                value: a.active,
                activeColor: AppColors.primaryRed,
                onChanged: (val) => setState(() => a.active = val),
              ),
      ),
    );
  }
}
