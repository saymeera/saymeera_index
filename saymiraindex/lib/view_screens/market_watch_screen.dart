import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class _Instrument {
  final String symbol;
  final String category;
  final double ltp;
  final double change;
  final double changePct;

  const _Instrument({
    required this.symbol,
    required this.category,
    required this.ltp,
    required this.change,
    required this.changePct,
  });

  bool get isPositive => change >= 0;
}

class MarketWatchScreen extends StatefulWidget {
  const MarketWatchScreen({super.key});

  @override
  State<MarketWatchScreen> createState() => _MarketWatchScreenState();
}

class _MarketWatchScreenState extends State<MarketWatchScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  static const _all = [
    _Instrument(symbol: 'Nifty 50',    category: 'Index',     ltp: 22456.80, change: 128.45,  changePct: 0.57),
    _Instrument(symbol: 'BankNifty',   category: 'Index',     ltp: 47892.30, change: -234.60, changePct: -0.49),
    _Instrument(symbol: 'Sensex',      category: 'Index',     ltp: 74123.55, change: 342.20,  changePct: 0.46),
    _Instrument(symbol: 'Nifty IT',    category: 'Index',     ltp: 38654.00, change: 456.00,  changePct: 1.20),
    _Instrument(symbol: 'Nifty Auto',  category: 'Index',     ltp: 22145.00, change: -123.00, changePct: -0.55),
    _Instrument(symbol: 'Nifty FMCG',  category: 'Index',     ltp: 54320.00, change: 234.00,  changePct: 0.43),
    _Instrument(symbol: 'Gold',        category: 'Commodity', ltp: 71285.00, change: 215.00,  changePct: 0.30),
    _Instrument(symbol: 'Silver',      category: 'Commodity', ltp: 82450.00, change: -380.00, changePct: -0.46),
    _Instrument(symbol: 'Crude Oil',   category: 'Commodity', ltp: 6245.00,  change: 55.00,   changePct: 0.89),
    _Instrument(symbol: 'Natural Gas', category: 'Commodity', ltp: 198.50,   change: -4.20,   changePct: -0.21),
    _Instrument(symbol: 'USD / INR',   category: 'Currency',  ltp: 83.42,    change: 0.12,    changePct: 0.14),
    _Instrument(symbol: 'EUR / INR',   category: 'Currency',  ltp: 90.18,    change: -0.34,   changePct: -0.38),
  ];

  final _tabs = ['All', 'Index', 'Commodity', 'Currency'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<_Instrument> _filtered(String tab) =>
      tab == 'All' ? _all : _all.where((i) => i.category == tab).toList();

  String _fmt(double v) {
    if (v >= 10000) return v.toStringAsFixed(2);
    if (v >= 1000)  return v.toStringAsFixed(2);
    return v.toStringAsFixed(2);
  }

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
        title: const Text('Market Watch',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => setState(() {}),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          tabs: _tabs.map((t) => Tab(text: t)).toList(),
        ),
      ),
      body: Column(
        children: [
          _header(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _tabs.map((tab) {
                final items = _filtered(tab);
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  itemCount: items.length,
                  itemBuilder: (_, i) => _row(items[i]),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _header() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          const Icon(Icons.circle, size: 8, color: Colors.green),
          const SizedBox(width: 6),
          const Text('Live', style: TextStyle(fontSize: 12, color: Colors.green, fontWeight: FontWeight.w600)),
          const SizedBox(width: 12),
          const Text('Last updated: Just now',
              style: TextStyle(fontSize: 12, color: AppColors.textHint)),
          const Spacer(),
          Text('${_all.length} instruments',
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _row(_Instrument inst) {
    final color = inst.isPositive ? AppColors.bullish : AppColors.bearish;
    final sign  = inst.isPositive ? '+' : '';
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: color.withValues(alpha: 0.1),
              child: Text(
                inst.symbol.substring(0, inst.symbol.length >= 2 ? 2 : 1),
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: color),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(inst.symbol,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                  Text(inst.category,
                      style: const TextStyle(fontSize: 11, color: AppColors.textHint)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(_fmt(inst.ltp),
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '$sign${_fmt(inst.change)}  ($sign${inst.changePct.toStringAsFixed(2)}%)',
                    style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
