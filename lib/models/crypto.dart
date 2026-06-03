class Crypto {
  final int rank;
  final String name;
  final String symbol;
  final double priceUsd;

  Crypto({
    required this.rank,
    required this.name,
    required this.symbol,
    required this.priceUsd,
  });

  factory Crypto.fromJson(Map<String, dynamic> json) {
    return Crypto(
      rank: int.tryParse(json['rank'].toString()) ?? 0,
      name: json['name'] ?? '',
      symbol: json['symbol'] ?? '',
      priceUsd: double.tryParse(json['price_usd'].toString()) ?? 0.0,
    );
  }
}
