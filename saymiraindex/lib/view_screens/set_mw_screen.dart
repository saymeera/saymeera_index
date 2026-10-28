import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class _Item {
  final String symbol;
  final String category;
  bool added;

  _Item({required this.symbol, required this.category, this.added = false});
}

class SetMWScreen extends StatefulWidget {
  const SetMWScreen({super.key});

  @override
  State<SetMWScreen> createState() => _SetMWScreenState();
}

class _SetMWScreenState extends State<SetMWScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  final List<_Item> _instruments = [
    _Item(symbol: 'Nifty 50',     category: 'Index',     added: true),
    _Item(symbol: 'BankNifty',    category: 'Index',     added: true),
    _Item(symbol: 'Sensex',       category: 'Index',     added: true),
    _Item(symbol: 'Nifty IT',     category: 'Index',     added: false),
    _Item(symbol: 'Nifty Auto',   category: 'Index',     added: false),
    _Item(symbol: 'Nifty FMCG',   category: 'Index',     added: false),
    _Item(symbol: 'Nifty Pharma', category: 'Index',     added: false),
    _Item(symbol: 'Nifty Metal',  category: 'Index',     added: false),
    _Item(symbol: 'Gold',         category: 'Commodity', added: true),
    _Item(symbol: 'Silver',       category: 'Commodity', added: true),
    _Item(symbol: 'Crude Oil',    category: 'Commodity', added: false),
    _Item(symbol: 'Natural Gas',  category: 'Commodity', added: false),
    _Item(symbol: 'Copper',       category: 'Commodity', added: false),
    _Item(symbol: 'Aluminium',    category: 'Commodity', added: false),
    _Item(symbol: 'USD / INR',    category: 'Currency',  added: true),
    _Item(symbol: 'EUR / INR',    category: 'Currency',  added: false),
    _Item(symbol: 'GBP / INR',    category: 'Currency',  added: false),
    _Item(symbol: 'JPY / INR',    category: 'Currency',  added: false),
  ];

  List<_Item> get _watching  => _instruments.where((i) => i.added).toList();
  List<_Item> get _available => _instruments.where((i) => !i.added &&
      (_query.isEmpty || i.symbol.toLowerCase().contains(_query.toLowerCase()))).toList();
  List<_Item> get _searched  => _query.isEmpty
      ? []
      : _instruments.where((i) =>
          i.symbol.toLowerCase().contains(_query.toLowerCase())).toList();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
        title: const Text('Set Market Watch',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        actions: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${_watching.length} added',
                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _searchBar(),
          Expanded(
            child: _query.isNotEmpty
                ? _searchResults()
                : _defaultList(),
          ),
        ],
      ),
      bottomNavigationBar: _saveBar(context),
    );
  }

  Widget _searchBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(12),
      child: TextField(
        controller: _searchController,
        onChanged: (v) => setState(() => _query = v),
        decoration: InputDecoration(
          hintText: 'Search instruments...',
          hintStyle: const TextStyle(color: AppColors.textHint, fontSize: 14),
          prefixIcon: const Icon(Icons.search, color: AppColors.textHint, size: 20),
          suffixIcon: _query.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close, size: 18, color: AppColors.textHint),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _query = '');
                  },
                )
              : null,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: AppColors.primaryRed),
          ),
        ),
      ),
    );
  }

  Widget _defaultList() {
    final categories = ['Index', 'Commodity', 'Currency'];
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        if (_watching.isNotEmpty) ...[
          _sectionLabel('In Your Watchlist', _watching.length, AppColors.primaryRed),
          const SizedBox(height: 8),
          ..._watching.map((i) => _tile(i)),
          const SizedBox(height: 16),
        ],
        ...categories.map((cat) {
          final items = _instruments.where((i) => i.category == cat && !i.added).toList();
          if (items.isEmpty) return const SizedBox.shrink();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionLabel(cat, items.length, AppColors.textSecondary),
              const SizedBox(height: 8),
              ...items.map((i) => _tile(i)),
              const SizedBox(height: 16),
            ],
          );
        }),
      ],
    );
  }

  Widget _searchResults() {
    final items = _searched;
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 48, color: AppColors.textHint),
            const SizedBox(height: 12),
            Text('No results for "$_query"',
                style: const TextStyle(color: AppColors.textSecondary)),
          ],
        ),
      );
    }
    return ListView(
      padding: const EdgeInsets.all(12),
      children: items.map((i) => _tile(i)).toList(),
    );
  }

  Widget _sectionLabel(String label, int count, Color color) {
    return Row(
      children: [
        Text(label,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: color)),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text('$count',
              style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }

  Widget _tile(_Item item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: item.added ? AppColors.primaryRed.withValues(alpha: 0.4) : AppColors.border,
        ),
      ),
      child: ListTile(
        dense: true,
        leading: CircleAvatar(
          radius: 18,
          backgroundColor: item.added
              ? AppColors.primaryRed.withValues(alpha: 0.1)
              : Colors.grey.shade100,
          child: Text(
            item.symbol.substring(0, item.symbol.length >= 2 ? 2 : 1),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: item.added ? AppColors.primaryRed : AppColors.textSecondary,
            ),
          ),
        ),
        title: Text(item.symbol,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        subtitle: Text(item.category,
            style: const TextStyle(fontSize: 11, color: AppColors.textHint)),
        trailing: GestureDetector(
          onTap: () => setState(() => item.added = !item.added),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: item.added
                  ? AppColors.primaryRed.withValues(alpha: 0.1)
                  : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: item.added ? AppColors.primaryRed : Colors.grey.shade300,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  item.added ? Icons.remove : Icons.add,
                  size: 14,
                  color: item.added ? AppColors.primaryRed : AppColors.textSecondary,
                ),
                const SizedBox(width: 4),
                Text(
                  item.added ? 'Remove' : 'Add',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: item.added ? AppColors.primaryRed : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _saveBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Watchlist saved — ${_watching.length} instruments'),
                duration: const Duration(seconds: 2),
                backgroundColor: AppColors.primaryRed,
              ),
            );
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryRed,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text(
            'Save Watchlist',
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
