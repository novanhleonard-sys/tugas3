import 'package:flutter/material.dart';
import '../models/crypto.dart';
import '../services/api_service.dart';
import '../widgets/crypto_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();

  List<Crypto> _allCryptos = [];
  List<Crypto> _filtered = [];
  bool _isLoading = true;
  bool _hasError = false;
  String _lastUpdated = '';

  @override
  void initState() {
    super.initState();
    _loadData();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filtered = _allCryptos.where((c) {
        return c.name.toLowerCase().contains(query) ||
            c.symbol.toLowerCase().contains(query);
      }).toList();
    });
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final data = await _apiService.fetchCryptos();
      final now = TimeOfDay.now();
      setState(() {
        _allCryptos = data;
        _filtered = data;
        _isLoading = false;
        _lastUpdated = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildSearchBar(),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Crypto Market',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFF8FAFC),
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Realtime Cryptocurrency Prices',
                  style: TextStyle(
                    fontSize: 13,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),
          if (!_isLoading && !_hasError) ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${_allCryptos.length} coins',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF38BDF8),
                  ),
                ),
                Text(
                  'Updated $_lastUpdated',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(color: Color(0xFFF8FAFC), fontSize: 14),
        decoration: InputDecoration(
          hintText: 'Search cryptocurrency...',
          hintStyle: const TextStyle(color: Color(0xFF64748B), fontSize: 14),
          prefixIcon: const Icon(Icons.search, color: Color(0xFF64748B), size: 20),
          filled: true,
          fillColor: const Color(0xFF1E293B),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) return _buildLoading();
    if (_hasError) return _buildError();
    if (_filtered.isEmpty) return _buildEmpty();

    return RefreshIndicator(
      onRefresh: _loadData,
      color: const Color(0xFF38BDF8),
      backgroundColor: const Color(0xFF1E293B),
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 20),
        itemCount: _filtered.length,
        itemBuilder: (context, index) => CryptoTile(crypto: _filtered[index]),
      ),
    );
  }

  Widget _buildLoading() {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8),
      itemCount: 8,
      itemBuilder: (_, __) => _SkeletonTile(),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.wifi_off_rounded, size: 52, color: Color(0xFF475569)),
          const SizedBox(height: 16),
          const Text(
            'Gagal memuat data',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF94A3B8),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Periksa koneksi internet Anda',
            style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _loadData,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF38BDF8),
              foregroundColor: const Color(0xFF0F172A),
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Try Again', style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off_rounded, size: 48, color: Color(0xFF475569)),
          const SizedBox(height: 12),
          const Text(
            'No matching cryptocurrency found',
            style: TextStyle(fontSize: 14, color: Color(0xFF94A3B8)),
          ),
        ],
      ),
    );
  }
}

class _SkeletonTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _box(36, 40),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _box(60, 10),
                const SizedBox(height: 6),
                _box(80, 16),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _box(30, 10),
              const SizedBox(height: 6),
              _box(70, 14),
            ],
          ),
        ],
      ),
    );
  }

  Widget _box(double w, double h) => Container(
        width: w,
        height: h,
        decoration: BoxDecoration(
          color: const Color(0xFF334155),
          borderRadius: BorderRadius.circular(4),
        ),
      );
}
